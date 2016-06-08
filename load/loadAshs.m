 

clear all
ash_file = '/Volumes/jdstokes/Studies/Data/dGR/rois/ash_stuff/S1_A/final/S1_A_left_lfseg_corr_nogray.nii.gz';
if ~exist(ash_file,'file')
   error([ash_file,' does not exist.']) 
end
gunzip(ash_file);
ash_file = strrep(ash_file,'.gz','');
% img=fmris_read_nifti(ash_file);

img = spm_read_vols(spm_vol(ash_file));
    