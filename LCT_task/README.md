# Lottery Choice Task - Salience (LCT-sal) event-related design
These are the instructions on how to run the LCT-sal event-related design files contained in this directory. These stimuli presentation files require [Psychopy](https://www.psychopy.org/) to be installed on your local system.

The task builds on previous studies (see references below). Our version introduces superhigh-stake (SH) trials, randomly interspersed among regular stake trials. These SH trials feature balanced win/lose probabilities and shortened response windows, designed to increase stimulus salience.

## References
  - Goh, J. O. S., Su, Y.-S., Tang, Y.-J., McCarrey, A. C., Tereshchenko, A., Elkins, W., & Resnick, S. M. (2016). Frontal, Striatal, and Medial Temporal Sensitivity to Value Distinguishes Risk-Taking from Risk-Aversive Older Adults during Decision Making. The Journal of Neuroscience, 36(49), 12498–12509. https://doi.org/10.1523/JNEUROSCI.1386-16.2016
  - Su, Y.-S., Chen, J.-T., Tang, Y.-J., Yuan, S.-Y., McCarrey, A. C., & Goh, J. O. S. (2018). Age-related differences in striatal, medial temporal, and frontal involvement during value-based decision processing. Neurobiology of Aging, 69, 185–198. https://doi.org/10.1016/j.neurobiolaging.2018.05.019
  - Chuang, Y.-S., Su, Y.-S., & Goh, J. O. S. (2020). Neural responses reveal associations between personal values and value-based decisions. Social Cognitive and Affective Neuroscience, 15(12), 1299–1309. https://doi.org/10.1093/scan/nsaa150
  - Chen, H.-Y., Dix, A., Goh, J. O. S., Smolka, M. N., Thurm, F., & Li, S.-C. (2021). Effects and mechanisms of information saliency in enhancing value-based decision-making in younger and older adults. Neurobiology of Aging, 99, 86–98. https://doi.org/10.1016/j.neurobiolaging.2020.11.018
  - Lee, C.-Y., Chen, C.-C., Mair, R. W., Gutchess, A., & Goh, J. O. S. (2021). Culture-related differences in the neural processing of probability during mixed lottery value-based decision-making. Biological Psychology, 166, 108209. https://doi.org/10.1016/j.biopsycho.2021.108209
  - Chen, P., Hung, H.-Y., & Goh, J. O. S. (2023). Age-related differences in ERP correlates of value-based decision making. Neurobiology of Aging, 123, 10–22. https://doi.org/10.1016/j.neurobiolaging.2022.11.008
  - Lee, C.-Y., Goh, J. O. S., & Gau, S. S.-F. (2023). Differential neural processing of value during decision-making in adults with attention-deficit/hyperactivity disorder and healthy controls. Journal of Psychiatry & Neuroscience, 48(2), E115–E124. https://doi.org/10.1503/jpn.220123

## Current setting is as follows:
  - Choice phase 3.0 s for non-salient trials, 1.5 s for salient (super-high, SH, magnitude) trials.
  - ITI1 jittered over 3 x 1s, 3 x 2s, 1 x 3s, 1 x 5s (see lct_sal_stim_generator).
  - Feedback phase 1.5 s
  - ITI2 jittered over 3 x 1s, 1 x 2s, 1 x 3s, 1 x 4s, 1 x 8s (see lct_sal_stim_generator).
  - 20 s fixation beginning
  - 20 s fixation end
  - Total time is per run 572 s; total run time for 6 runs is 57.2 min
  - 56 trials per run
  - 6 runs
  - Conditions:
    - ProbHH_valueH (8 trials per run; 48 trials total)
    - ProbHH_valueL (8 trials per run; 48 trials total)
    - ProbLL_valueH (8 trials per run; 48 trials total)
    - ProbLL_valueL (8 trials per run; 48 trials total)
    - ProbMM_valueH (8 trials per run; 48 trials total)
    - ProbMM_valueL (8 trials per run; 48 trials total)
    - ProbMM_valueSH (8 trials per run; 48 trials total)

## New stimuli sets can be generated using:
lct_sal_stim_generator.xlsx (see file contents for usage)

## There are six experimental runs and one practice run in this protocol associated with the following files:

- ADMT_r1.psyexp
- ADMT_r2.psyexp
- ADMT_r3.psyexp
- ADMT_r4.psyexp
- ADMT_r5.psyexp
- ADMT_r6.psyexp

## These .psyexp files call table values from the following corresponding spreadsheets:

- BML_r1.xlsx
- BML_r2.xlsx
- BML_r3.xlsx
- BML_r4.xlsx
- BML_r5.xlsx
- BML_r6.xlsx

**The other files are scripts and log files generated when the stimuli presentation code in the psyexp files is run.**

## To run
1. Open Psychopy.
2. Open the psyexp file you wish to run.
3. Click the play button (right pointing triangle).
4. The session info screen will appear for which you must enter the following:
  - **Participant ID code**. 9999 is an example for pilot participants.
  - **Session ID**. Leave default as 001 for first instance of the run. If run is repeated, you can enter 002 as necessary to avoid overwrite.
  - **Start points**. This is the total accumulated points that the participant has at the beginning of the run. If this is the first time running any run, then the start points are 0. If the participant has completed prior runs, you can note the last accumulated score from the latest run and enter it in this field. If the latest score is forgotten, you can open /data/*_ADMT_*.csv, scroll right and bottom to the 'totalsum' column to get the latest score.
