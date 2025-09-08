# !/bin/bash
# outcount and motion censor for functional bold runs

# set data directories
dataDir=/media/yuhui/LCT
cd ${dataDir}

for patDir in subj_folder; do 
{
	cd ${dataDir}/${patDir}
	for runDir in bold.sft; do
	{	
		cd ${dataDir}/${patDir}/${runDir}

		run_dsets=($(ls -f rbold*.nii.gz))
		run_num=${#run_dsets[@]}

		for run in `seq 1 ${run_num}`; do
		{
			if [ -f rbold${run}.nii.gz ]; then
				3dToutcount -mask brain_mask.nii.gz -fraction -polort 4 -legendre \
							rbold${run}.nii.gz > outcount.bold.r$run.1D

				# chai use 0.02 as threshold
				1deval -a outcount.bold.r$run.1D -expr "1-step(a-0.02)" > rm.out.cen.bold.r$run.1D

			fi
		}&
		done
		wait
		# catenate outlier censor files into a single time series
		cat rm.out.cen.bold.r*.1D > outcount_bold_censor.1D
		rm rm.out.cen*

		cat outcount.bold.r*.1D > outcount_bold.1D

		cat rp_bold*.txt > dfile_rall.bold.1D

		run_dsets=($(ls -f rbold*.nii.gz))
		goodrun_num=${#run_dsets[@]}
		run_length=`3dinfo -nv rbold*.nii.gz`
		# compute de-meaned motion parameters (for use in regression)
		1d_tool.py -overwrite -infile dfile_rall.bold.1D -set_run_lengths ${run_length} \
				-demean -write motion_demean.bold.1D

		# compute motion parameter derivatives (for use in regression)
		1d_tool.py -overwrite -infile dfile_rall.bold.1D -set_run_lengths ${run_length} \
				-derivative -demean -write motion_deriv.bold.1D

		# create censor file motion_${subj}_censor.1D, for censoring motion 
		1d_tool.py -overwrite -infile dfile_rall.bold.1D -set_run_lengths ${run_length} \
			-show_censor_count \
			-censor_motion 0.4 motion_bold

		# combine motion and outlier censor files
		1deval -overwrite -a motion_bold_censor.1D -b outcount_bold_censor.1D \
			-expr "a*b*c" > censor_combined.1D

		1deval -overwrite -a motion_bold_censor.1D \
			-expr "a" > censor_motion.1D

		1dplot -jpg motion_censor -censor censor_combined.1D motion_*_enorm.1D

			
	}&
	done
	wait

}&
done
wait

