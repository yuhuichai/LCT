# !/bin/bash

# set data directories
top_dir=/media/yuhui/LCT 
cd $top_dir

for patDir in subj_folder; do 
{
	cd ${top_dir}/${patDir}
	for runDir in bold.sft; do
	{	
		cd ${top_dir}/${patDir}/${runDir}

		run_dsets=($(ls -f rbold*.nii.gz))
		run_num=${#run_dsets[@]}

		for subj in rbold; do 
		{				
			# ================================= normalize ==================================
			# scale each voxel time series to have a mean of 100
			# (be sure no negatives creep in)
			for run in `seq 1 ${run_num}`; do
			{    
				if [ -f ${subj}${run}.nii.gz ] && [ ! -f norm.${subj}${run}.nii.gz ]; then

					3dTstat -overwrite -prefix rm.mean.${subj}${run}.nii.gz ${subj}${run}.nii.gz
					3dcalc -a ${subj}${run}.nii.gz -b rm.mean.${subj}${run}.nii.gz \
							-c brain_mask.nii.gz -expr 'step(c)*(a/b*100)'         \
							-prefix norm.${subj}${run}.nii.gz -overwrite -float

					rm rm.mean.${subj}${run}.nii.gz
				fi
			}&
			done
			wait

			# ------------------------------
			# run the regression analysis in afni    
			echo "++++++++++++++ input `ls norm.${subj}*nii.gz` for glm .........."

			3dDeconvolve -input norm.${subj}*nii.gz                   \
				-mask brain_mask.nii.gz                          \
				-polort A -float -local_times                              \
				-censor censor_combined.1D \
				-num_stimts 15                                                       \
				-stim_times 1 ../Stim/ProbHH_valueH_dis2tr.txt 'GAM'                    \
				-stim_label 1 ProbHH_valueH                                              \
				-stim_times 2 ../Stim/ProbHH_valueL_dis2tr.txt 'GAM'                    \
				-stim_label 2 ProbHH_valueL                                              \
				-stim_times 3 ../Stim/ProbLL_valueH_dis2tr.txt 'GAM'                    \
				-stim_label 3 ProbLL_valueH                                              \
				-stim_times 4 ../Stim/ProbLL_valueL_dis2tr.txt 'GAM'                    \
				-stim_label 4 ProbLL_valueL                                              \
				-stim_times 5 ../Stim/ProbMM_valueH_dis2tr.txt 'GAM'                    \
				-stim_label 5 ProbMM_valueH                                              \
				-stim_times 6 ../Stim/ProbMM_valueL_dis2tr.txt 'GAM'                    \
				-stim_label 6 ProbMM_valueL                                              \
				-stim_times 7 ../Stim/ProbMM_valueSH_dis2tr.txt 'GAM'                    \
				-stim_label 7 ProbMM_valueSH                                              \
				-stim_times 8 ../Stim/A_GAIN_norm_dis2tr.txt 'GAM'                    \
				-stim_label 8 A_GAIN_norm                                              \
				-stim_times 9 ../Stim/A_GAIN_sh_dis2tr.txt 'GAM'                    \
				-stim_label 9 A_GAIN_sh                                             \
				-stim_times 10 ../Stim/A_LOSS_norm_dis2tr.txt 'GAM'                    \
				-stim_label 10 A_LOSS_norm                                              \
				-stim_times 11 ../Stim/A_LOSS_sh_dis2tr.txt 'GAM'                    \
				-stim_label 11 A_LOSS_sh                                              \
				-stim_times 12 ../Stim/R_GAIN_norm_dis2tr.txt 'GAM'                    \
				-stim_label 12 R_GAIN_norm                                              \
				-stim_times 13 ../Stim/R_GAIN_sh_dis2tr.txt 'GAM'                    \
				-stim_label 13 R_GAIN_sh                                              \
				-stim_times 14 ../Stim/R_LOSS_norm_dis2tr.txt 'GAM'                    \
				-stim_label 14 R_LOSS_norm                                              \
				-stim_times 15 ../Stim/R_LOSS_sh_dis2tr.txt 'GAM'                    \
				-stim_label 15 R_LOSS_sh                                              \
				-jobs 4                                                             \
				-fout -tout -x1D X.xmat.1D -xjpeg X.jpg                             \
				-bucket stats.${subj}.nii.gz 												\
				-overwrite

			3dDeconvolve -input norm.${subj}*nii.gz                   \
				-mask brain_mask.nii.gz                          \
				-censor censor_combined.1D \
				-polort A -float -local_times                              \
				-num_stimts 6                                                       \
				-stim_times 1 ../Stim/ProbLH_valueLH_dis2tr.txt 'GAM'                    \
				-stim_label 1 ProbLH_valueLH                                              \
				-stim_times 2 ../Stim/ProbMM_valueLH_dis2tr.txt 'GAM'                    \
				-stim_label 2 ProbMM_valueLH                                              \
				-stim_times 3 ../Stim/ProbMM_valueSH_Fast_dis2tr.txt 'GAM'                    \
				-stim_label 3 ProbMM_valueSH_Fast                                              \
				-stim_times 4 ../Stim/ProbMM_valueSH_Slow_dis2tr.txt 'GAM'                    \
				-stim_label 4 ProbMM_valueSH_Slow                                              \
				-stim_times 5 ../Stim/AR_GAINLOSS_norm_dis2tr.txt 'GAM'                    \
				-stim_label 5 AR_GAINLOSS_norm                                              \
				-stim_times 6 ../Stim/AR_GAINLOSS_sh_dis2tr.txt 'GAM'                    \
				-stim_label 6 AR_GAINLOSS_sh                                              \
				-jobs 4                                                             \
				-fout -tout -x1D X_rt.xmat.1D -xjpeg X_rt.jpg                             \
				-bucket stats_rt.${subj}.nii.gz 												\
				-overwrite 

			3dDeconvolve -input norm.${subj}*nii.gz                   \
				-mask brain_mask.nii.gz                          \
				-censor censor_combined.1D \
				-polort A -float -local_times                             \
				-num_stimts 9                                                       \
				-stim_times 1 ../Stim/ProbLH_valueLH_dis2tr.txt 'GAM'                    \
				-stim_label 1 ProbLH_valueLH                                              \
				-stim_times 2 ../Stim/ProbMM_valueLH_dis2tr.txt 'GAM'                    \
				-stim_label 2 ProbMM_valueLH                                              \
				-stim_times 3 ../Stim/ProbMM_valueSH_dis2tr.txt 'GAM'                    \
				-stim_label 3 ProbMM_valueSH                                              \
				-stim_times 4 ../Stim/A_GAIN_norm_dis2tr.txt 'GAM'                    \
				-stim_label 4 A_GAIN_norm                                              \
				-stim_times 5 ../Stim/A_GAIN_sh_dis2tr.txt 'GAM'                    \
				-stim_label 5 A_GAIN_sh                                             \
				-stim_times 6 ../Stim/A_LOSS_norm_dis2tr.txt 'GAM'                    \
				-stim_label 6 A_LOSS_norm                                              \
				-stim_times 7 ../Stim/A_LOSS_sh_dis2tr.txt 'GAM'                    \
				-stim_label 7 A_LOSS_sh                                              \
				-stim_times 8 ../Stim/R_GAINLOSS_norm_dis2tr.txt 'GAM'                    \
				-stim_label 8 R_GAINLOSS_norm                                              \
				-stim_times 9 ../Stim/R_GAINLOSSdummy_sh_dis2tr.txt 'GAM'                    \
				-stim_label 9 R_GAINLOSSdummy_sh                                              \
				-num_glt 4                                                               \
				-gltsym 'SYM: ProbMM_valueSH -ProbMM_valueLH'                                             \
				-glt_label 1 ProbMM_valueSH-ProbMM_valueLH                                     \
				-gltsym 'SYM: ProbMM_valueSH -0.5*ProbMM_valueLH -0.5*ProbLH_valueLH'           \
				-glt_label 2 ProbMM_valueSH-ProbLMH_valueLH                                     \
				-gltsym 'SYM: A_GAIN_sh -A_LOSS_sh'                                             \
				-glt_label 3 A_GAIN_sh-A_LOSS_sh                                     \
				-gltsym 'SYM: A_GAIN_norm -A_LOSS_norm'                                             \
				-glt_label 4 A_GAIN_norm-A_LOSS_norm                                    \
				-jobs 4                                                             \
				-fout -tout -x1D X1.xmat.1D -xjpeg X1.jpg                             \
				-bucket stats3.${subj}.nii.gz 												\
				-overwrite
	
			rm fitts.${subj}* norm.${subj}* errts.${subj}

		}&
		done
		wait
	}&
	done
	wait
}&
done
wait
