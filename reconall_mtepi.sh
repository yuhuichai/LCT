#!/bin/sh
# recon-all for anatomical mt run

dataDIR=/media/yuhui/LCT # replace with your own data directory
batchDir=/media/yuhui/LCT/Batch # where the reconall.expert100 is located

cd ${dataDIR}

for patID in subj_folder/mt.sft; do
{	
	echo "***************************** start with ${patID} *********************"
	patDIR=${dataDIR}/${patID}
	cd ${patDIR}

	beta=100

	thr=0.5
	3dAutomask -overwrite -clfrac $thr -prefix brain_mask_aftmc.nii.gz mean.rbold.nii.gz
	epiMask=${patDIR}/brain_mask_aftmc.nii.gz

	3dcalc -a mean.sub_d_dant.beta${beta}.nii.gz -b ${epiMask} \
		-expr 'step(b)*a' \
		-prefix mean.sub_d_dant.beta${beta}.masked.nii.gz \
		-overwrite

	template=mean.sub_d_dant.beta${beta}.masked.nii.gz

	DenoiseImage -d 3 -n Gaussian -i ${template} -o denoise.${template}

	3dUnifize -GM -input denoise.${template} -prefix uni.denoise.${template} -overwrite

	3dUnifize -GM -input brain2epi.nii.gz -prefix uni.brain2epi.nii.gz -overwrite

	echo "++ add empty slices on each direction, make sure it matchs with align_anat2func"
	3dZeropad -I 40 -S 60 -A 40 -P 40 -L 40 -R 40 -prefix pad0.uni.denoise.${template} uni.denoise.${template} -overwrite

	# use mean.sub_d_dant_mc.nii.gz to determine the bottom and top slices of the brain mask
	3dZeropad -I 40 -S 60 -A 40 -P 40 -L 40 -R 40 -prefix pad0.mean.sub_d_dant.nii.gz mean.sub_d_dant_mc.nii.gz -overwrite

	########################################################################
	3dcalc -a pad0.uni.denoise.${template} -b uni.brain2epi.nii.gz -c pad0.mean.sub_d_dant.nii.gz -expr "a*step(abs(c)-0.0001)+b*step(0.0001-abs(c))" \
		-prefix recon.${template} -overwrite

	rm uni.brain2epi.nii.gz uni.brain2epi.nii.gz denoise.${template} uni.denoise.${template} pad0.uni.denoise.${template}

	export SUBJECTS_DIR=${patDIR}

	# A: If your skull-stripped volume does not have the cerebellum, then no. If it does, then yes, however you will have to run the data a bit differently.

	# First you must run only -autorecon1 like this: 
	# recon-all -autorecon1 -noskullstrip -s <subjid>
	recon-all -i recon.${template} -subjid Surf_uni -autorecon1 -noskullstrip -hires

	echo "++ check alignment betw input and MNI"
	# tkregister2 --mgz --s Surf_uni --fstal

	#@# Nu Intensity Correction Sat Oct 26 12:25:45 EDT 2019
	cd ${patDIR}/Surf_uni/mri
	mri_nu_correct.mni --i orig.mgz --o nu.mgz --uchar transforms/talairach.xfm --cm --n 2
	mri_add_xform_to_header -c ${patDIR}/Surf_uni/mri/transforms/talairach.xfm nu.mgz nu.mgz
	#@# Intensity Normalization Sat Oct 26 12:30:07 EDT 2019
	mri_normalize -g 1 -mprage -noconform nu.mgz T1.mgz


	cd ${patDIR}
	cp Surf_uni/mri/T1.mgz Surf_uni/mri/brainmask.auto.mgz
	cp Surf_uni/mri/T1.mgz Surf_uni/mri/brainmask.mgz

	cd ${patDIR}
	export SUBJECTS_DIR=${patDIR}

	# Then you will have to make a symbolic link or copy T1.mgz to brainmask.auto.mgz and a link from brainmask.auto.mgz to brainmask.mgz. 
	# Finally, open this brainmask.mgz file and check that it looks okay 
	# (there is no skull, cerebellum is intact; use the sample subject bert that comes with your FreeSurf_unier 
	# installation to make sure it looks comparable). From there you can run the final stages of recon-all: 
	# recon-all -autrecon2 -autorecon3 -s <subjid>
	recon-all -s Surf_uni -autorecon2 -careg -hires -parallel -openmp 2 -expert ${batchDir}/reconall.expert100 -xopts-overwrite -no-isrunning 
	recon-all -s Surf_uni -autorecon3 -hires -parallel -openmp 2 -expert ${batchDir}/reconall.expert100 -xopts-overwrite -no-isrunning 

	@SUMA_Make_Spec_FS -fspath Surf_uni/surf -sid SUMA -NIFTI

	mv Surf_uni/surf/SUMA ./

}&
done
wait

