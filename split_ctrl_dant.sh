# !/bin/bash

# set data directories
dataDir=/media/yuhui/LCT 
cd ${dataDir}

for patDir in subj_folder; do 
{
	top_dir=${dataDir}/${patDir}
	
	# task run
	for filePre in bold; do
	{
		cd $top_dir/Func
		sl_dsets=($(ls -f ${filePre}*.nii*))
		run_num=${#sl_dsets[@]}
		
		echo "*************** extract bold images, skip first 2 time points ***************"
		run=0
		for img in ${sl_dsets[@]}; do
			let "run+=1"
			3dTcat -overwrite -prefix ${filePre}_bold${run}.nii ${img}'[2..$]'
		done

		cd $top_dir
		[ ! -d ${filePre}.sft ] && mkdir ${filePre}.sft
		for run in `seq 1 ${run_num}`; do
		{
			mv $top_dir/Func/${filePre}_bold${run}.nii ${filePre}.sft/bold${run}.nii
		}&
		done
		wait 

		# *****************************************************************************************************
		cd $top_dir/${filePre}.sft
		# *****************************************************************************************************

		echo "************** create mask ******************"
		for img in bold*nii; do
		{
		    3drefit -duporigin bold1.nii ${img}
		    3dAutomask -prefix rm.mask_${img} ${img}
		}
		done
		wait
		# create union of inputs, output type is byte
		3dmask_tool -inputs rm.mask_* -union -prefix brain_mask.nii -overwrite
		rm rm.mask*

	}
	done
	wait

	# anatomical run
	for filePre in mt; do  
	{
		cd $top_dir/Func
		sl_dsets=($(ls -f ${filePre}_*.nii.gz*))
		run_num=${#sl_dsets[@]}

		echo "*************** extract bold and dant images, skip first 1 time points ***************"
		run=0
		for img in ${sl_dsets[@]}; do
			let "run+=1"
			3dTcat -overwrite -prefix ${filePre}_bold${run}.nii ${img}'[2..$]'
			3dTcat -overwrite -prefix ${filePre}_dant${run}.nii ${img}'[1..$]'
		done

		cd $top_dir
		[ ! -d ${filePre}.sft ] && mkdir ${filePre}.sft
		for run in `seq 1 ${run_num}`; do
		{
			mv $top_dir/Func/${filePre}_bold${run}.nii ${filePre}.sft/bold${run}.nii
			mv $top_dir/Func/${filePre}_dant${run}.nii ${filePre}.sft/dant${run}.nii
		}&
		done
		wait 

		# *****************************************************************************************************
		cd $top_dir/${filePre}.sft
		# *****************************************************************************************************

		echo "************** create mask ******************"
		for img in bold*nii dant*nii; do
		{
		    3drefit -duporigin bold1.nii ${img}
		    3dAutomask -prefix rm.mask_${img} ${img}
		}
		done
		wait
		# create union of inputs, output type is byte
		3dmask_tool -inputs rm.mask_* -union -prefix brain_mask.nii -overwrite
		rm rm.mask*

	}&
	done
	wait

	cd $top_dir

	echo "************** create combined mask for motion correction ******************"
	3dmask_tool -inputs *sft/brain_mask.nii -union -prefix brain_mask_comb.nii -overwrite
	echo "******************** do motion correction in spm ******************"

}&
done
wait

