function SL_reg_specs(C,maskType,repSubj)

antsDir = '/Users/jdstokes/repos/antsbin/';
maskDir = fullfile(C.dir.dat_mask,maskType);
subj2run = C.subjects.subj2run;            %Subject List
regFold = ['SL_reg_',maskType,'_',repSubj];           %Registration Folder



%% Warp
% warpedfold = ['/reg_',maskType,'_',repSubj,'/'];

for subInd = 1: length(subj2run)
    subj= subj2run{subInd};
    dir_mri = C.dir.dat_mri;
    hiresFold = C.spm.hiresFold;
    hiresFile = ['r',C.spm.hiresFile];
    
    
    rDir_rS = fullfile(maskDir,regFold,repSubj);
    rDir_cS = fullfile(maskDir,regFold,subj);
    mkdir(rDir_rS);
    mkdir(rDir_cS);
    
    mDir_rS = fullfile(maskDir,repSubj);
    mDir_cS = fullfile(maskDir,subj);
    
    
    mmF_rS = fullfile(maskDir,'SL_mm',repSubj,'SL_ROI_reg.nii');
    mmF_cS = fullfile(maskDir,'SL_mm',subj,'SL_ROI_reg.nii');
    
    hrF_rS = fullfile(dir_mri,repSubj,hiresFold,hiresFile);
    hrF_cS = fullfile(dir_mri,subj,hiresFold,hiresFile);
    
    %%make warped mask d
    %Whats going in here:
    %   1. Warp mean functional -> template (or representative subject) -
    %       happens once per subject.
    %   2. masks follow mean functional -> template
    %       happens once per subject
    %   3. stats images follow mean functional -> template
    %     for sub = substart:subend
    % 1. Check
    
    
    %% Output reg specs and morph ROIs; Only need to do once

%         mkdir(fullfile(maskDir,subj,warpedfold));
        eval(['!',antsDir,'bin/ANTS 3 -m MSQ[',mmF_rS,',',mmF_cS,',.6,0] -m CC[',hrF_rS,',',hrF_cS,',.4,5] -i 20x20x10 -o ',rDir_cS,'/ab.nii -t SyN[0.15] -r Gauss[3,0] '])
        %eval(['!/Users/colintkyle/Documents/ANTs/bin/bin/ANTS 3 -m CC[',mask_dir,'smeanTSliceBLOCK1.nii,',func_dir,subjects{sub},'BLOCK1/meanTSliceBLOCK1.nii,1,5] -i 20x20x10 -o ',func_dir,subjects{sub},'BLOCK1/ab.nii -t SyN[0.25] -r Gauss[3,0] '])%-x ',mask_dir,subjects2(7).name,'/megamask.nii'])
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Moving %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Output %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Fixed %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Warper %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Warper %%%%%%%%%%%%%%%%%%
         eval(['!',antsDir,'bin/WarpImageMultiTransform 3 ',hrF_cS,' ',rDir_cS,'/bwarp.nii -R ',mmF_rS,' -use-NN ',rDir_cS,'/abWarp.nii ',rDir_cS,'/abAffine.txt'])
%                 eval(['!',antsDir,'bin/WarpImageMultiTransform 3 ',rDir_cS,'/r',subj, '_hires.nii ',rDir_cS,'/bwarp.nii -R ',rDir_cS,'/SL_ROI_reg2.nii ',rDir_cS,'/abWarp.nii ',rDir_cS,'/abAffine.txt'])


   
end



