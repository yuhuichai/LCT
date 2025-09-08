# # !/bin/bash

top_dir=/media/yuhui/LCT
cd $top_dir

for patDir in subj_folder; do
{
	cd ${top_dir}/${patDir}
	for runDir in mt.sft; do 
	{	
		cd ${top_dir}/${patDir}/${runDir}

		run_dsets=($(ls -f bold*.nii.gz))
		run_num=${#run_dsets[@]}

		for subj in rbold rdant; do # 
		{	
			3dTcat -prefix all_runs.${subj}.nii.gz ${subj}*nii.gz -overwrite
			3dTstat -overwrite -mean -prefix mean.${subj}.nii.gz all_runs.$subj.nii.gz
			rm all_runs.$subj.nii.gz
		}&
		done
		wait

		# background noise suppression
		3dcalc -a mean.rbold.nii.gz -b mean.rdant.nii.gz \
			-expr "(a-b)/(b+100)" -prefix mean.sub_d_dant.beta100.nii.gz -overwrite

		3dcalc -a mean.sub_d_dant.beta100.nii.gz -b ../brain_mask_comb.nii.gz -expr "a*step(b)" \
			-prefix mean.sub_d_dant.beta100.masked.nii.gz -overwrite

		DenoiseImage -d 3 -n Gaussian -i mean.sub_d_dant.beta100.masked.nii.gz -o mean.sub_d_dant.beta100.masked.denoised.nii.gz

		DenoiseImage -d 3 -n Gaussian -i mean.sub_d_dant.beta100.nii.gz -o mean.sub_d_dant.beta100.denoised.nii.gz

	}&
	done
	wait
}
done
wait
