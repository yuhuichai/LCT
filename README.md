# Resolving Mesoscale Midbrain–Prefrontal–Striatal Pathways Underlying Decision Making Using Submillimeter-Resolution fMRI at 7T

This repository contains code used in the article:  
**“Resolving mesoscale midbrain–prefrontal–striatal pathways underlying decision making using submillimeter-resolution functional MRI at 7T.”**

The analyses rely on publicly available neuroimaging software packages, including **AFNI**, **SPM12**, **ANTs**, **FreeSurfer**, and **LAYNII**.

---

## Correspondence

**Yuhui Chai**  
Beckman Institute for Advanced Science and Technology, University of Illinois at Urbana–Champaign  
405 N. Mathews Avenue, Urbana, IL 61801, USA  
Email: [yuhui@illinois.edu](mailto:yuhui@illinois.edu)  

**Joshua Goh**  
Graduate Institute of Brain and Mind Sciences, National Taiwan University College of Medicine  
No. 1, Sec. 4, Roosevelt Rd., Taipei 106319, Taiwan  
Email: [joshuagoh@ntu.edu.tw](mailto:joshuagoh@ntu.edu.tw)  

---

## Repository contents

- **Task design code and files:** `LCT_task/`  
- **Scan protocol:** `LCT_protocol_share.pdf`  

---

## Preprocessing scripts

- **Splitting and masking — `split_ctrl_dant.sh`**  
  - Discards the first 2 volumes in functional runs  
  - Splits the original time series into even (CTRL) and odd (MT-prepared) images in anatomical runs  
  - Creates a motion–correction mask  

- **Motion correction — `mc_run.m`**  
  - Reads all functional and anatomical runs  
  - Replaces inputs in `mc_job.m` with the corresponding NIfTI filenames  
  - Executes motion correction in MATLAB (requires **SPM12** and the **REST toolbox**)  

- **Motion censoring — `motion_censor.sh`**  
  - Censors time points if:  
    - The Euclidean norm of motion derivatives > 0.4 mm, **or**  
    - ≥20% of voxels are identified as outliers from the trend  

- **MT-weighted anatomy averaging — `mtepi.sh`**  
  - Computes mean MT-weighted anatomical images  

- **Cortical surface reconstruction — `reconall_mtepi.sh`**  
  - Runs FreeSurfer’s `recon-all` for brain segmentation and cortical surface reconstruction  

- **Cortical layering — `layer_MT.sh`**  
  - Generates cortical layers based on LAYNII  

---

## Analysis and figure generation

- **Behavioral analysis — `behavior_AR_RT.ipynb`**  
  Produces **Fig. S1**  

- **Stake effect analysis — `stake_fig1.ipynb`**  
  Produces **Fig. 2**  

- **Stake difference analysis — `stakedif_figS3.ipynb`**  
  Produces **Fig. S3**  

- **Reaction time (RT) analysis — `RT_fig3.ipynb`**  
  Produces **Fig. 3**  

- **Outcome-related effects — `gainloss_fig4.ipynb`**  
  Produces **Fig. 4**  

- **Laminar effects — `layerProfile_fig5.ipynb`**  
  Produces **Fig. 5**  

- **Control analysis — `roiProfile_control_v1.ipynb`**  
  Produces **Fig. S4**  
