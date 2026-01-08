#!/bin/sh
dataDIR=/media/yuhui/LCT

cd ${dataDIR}
for patID in subj*; do
{		
	patDir=${dataDIR}/${patID}
	anatDIR=${dataDIR}/${patID}/mt.sft
	funcDIR=${dataDIR}/${patID}/bold.sft
	sumaDir=${dataDIR}/${patID}/mt.sft/SUMA

	cd ${dataDIR}
	for hemi in lh rh; do
	{
		cd ${dataDIR}
		SUBJECTS_DIR=${dataDIR}
		
		## PALS_B12_Brodmann.annot ######################################
		echo "++ PALS_B12_Brodmann.annot applied to ${hemi} of ${patID} ..."
		# inverse, from Yeo_JNeurophysiol11_FreeSurfer to individual
		cd ${dataDIR}
		mri_surf2surf --srcsubject Yeo_JNeurophysiol11_FreeSurfer/fsaverage \
			--trgsubject ${patID}/mt.sft/Surf_uni \
			--sval-annot Yeo_JNeurophysiol11_FreeSurfer/fsaverage/label/${hemi}.PALS_B12_Brodmann.annot \
			--tval ${patID}/mt.sft/Surf_uni/label/${hemi}.PALS_B12_Brodmann.annot \
			--hemi ${hemi}

		mri_surf2surf --srcsubject Yeo_JNeurophysiol11_FreeSurfer/fsaverage \
			--trgsubject ${patID}/mt.sft/Surf_uni \
			--sval-annot Yeo_JNeurophysiol11_FreeSurfer/fsaverage/label/${hemi}.Yeo2011_7Networks_N1000.annot \
			--tval ${patID}/mt.sft/Surf_uni/label/${hemi}.Yeo2011_7Networks_N1000.annot \
			--hemi ${hemi}

		SUBJECTS_DIR=${anatDIR}
		cd ${anatDIR}
		mri_label2vol \
			--annot Surf_uni/label/${hemi}.PALS_B12_Brodmann.annot \
			--subject Surf_uni --identity --temp Surf_uni/mri/T1.mgz \
			--hemi ${hemi} --proj frac -0.1 1.1 0.01 \
			--o ${sumaDir}/PALS_B12_Brodmann.${hemi}.nii.gz

		mri_label2vol \
			--annot Surf_uni/label/${hemi}.Yeo2011_7Networks_N1000.annot \
			--subject Surf_uni --identity --temp Surf_uni/mri/T1.mgz \
			--hemi ${hemi} --proj frac -0.1 1.1 0.01 \
			--o ${sumaDir}/Yeo2011_7Networks_N1000.${hemi}.nii.gz

	}&
	done
	wait

	cd ${sumaDir}
	3dcalc -a Yeo2011_7Networks_N1000.lh.nii.gz -b Yeo2011_7Networks_N1000.rh.nii.gz \
		-expr "a+b*iszero(a)" -prefix Yeo2011_7Networks_N1000.nii.gz -overwrite

	3dROIMaker -overwrite \
		-nifti \
		-inflate 2 \
		-refset Yeo2011_7Networks_N1000.nii.gz \
		-inset  Yeo2011_7Networks_N1000.nii.gz \
		-prefix Yeo2011_7Networks_N1000.d2

	rm Yeo2011_7Networks_N1000.d2_GM.* Yeo2011_7Networks_N1000.d2_GMI.niml.lt

	3dcalc -a Yeo2011_7Networks_N1000.d2_GMI.nii.gz -expr "step(amongst(a,7))" \
		-prefix default_network.nii.gz -overwrite

	3dcalc -a Yeo2011_7Networks_N1000.d2_GMI.nii.gz -expr "step(amongst(a,6))" \
		-prefix frontoparietal_network.nii.gz -overwrite

	3dcalc -a Yeo2011_7Networks_N1000.d2_GMI.nii.gz -expr "step(amongst(a,5))" \
		-prefix limbic_network.nii.gz -overwrite

	3dcalc -a Yeo2011_7Networks_N1000.d2_GMI.nii.gz -expr "step(amongst(a,4))" \
		-prefix ventralatten_network.nii.gz -overwrite

	for atlas in PALS_B12_Brodmann.lh PALS_B12_Brodmann.rh; do
	{
		3dROIMaker -overwrite \
			-nifti \
			-inflate 2 \
			-refset ${atlas}.nii.gz \
			-inset  ${atlas}.nii.gz \
			-prefix ${atlas}.d2

		rm ${atlas}.d2_GM.* ${atlas}.d2_GMI.niml.lt
	}&
	done
	wait

	cd ${sumaDir}
	# The dorsolateral prefrontal cortex is composed of the BA8, BA9, BA10, and BA46
	3dcalc -a PALS_B12_Brodmann.lh.d2_GMI.nii.gz -b PALS_B12_Brodmann.rh.d2_GMI.nii.gz \
		-expr "step(amongst(a,2,5,43,46)+amongst(b,3,6,44,47))" \
		-prefix PALS_dlpfc.nii.gz -overwrite

	# The ventrolateral prefrontal cortex is composed of areas BA45, BA47, and BA44
	3dcalc -a PALS_B12_Brodmann.lh.d2_GMI.nii.gz -b PALS_B12_Brodmann.rh.d2_GMI.nii.gz \
		-expr "step(amongst(a,16,26,15)+amongst(b,17,27,16))" \
		-prefix PALS_vlpfc.nii.gz -overwrite

	# The medial prefrontal cortex (mPFC) is composed of BA12, BA25, 
	# and anterior cingulate cortex: BA32, BA33, BA24
	3dcalc -a PALS_B12_Brodmann.lh.d2_GMI.nii.gz -b PALS_B12_Brodmann.rh.d2_GMI.nii.gz \
		-expr "step(amongst(a,44,41,42)+amongst(b,45,42,43))" \
		-prefix PALS_mpfc.nii.gz -overwrite

	# The ventral prefrontal cortex is composed of areas BA11, BA13, and BA14.[1] 
	# (Also see the definition of the orbitofrontal cortex.)
	3dcalc -a PALS_B12_Brodmann.lh.d2_GMI.nii.gz -b PALS_B12_Brodmann.rh.d2_GMI.nii.gz \
		-expr "step(amongst(a,45)+amongst(b,46))" \
		-prefix PALS_vpfc.nii.gz -overwrite
}&
done
wait