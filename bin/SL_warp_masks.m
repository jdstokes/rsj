function SL_warp_masks(C,beta_row,slrad,maskType,repSubj)


slDir = fullfile(C.dir.analysis,'searchLight',beta_row.beta_ID,['radius_',num2str(slrad)]);
antsDir = '/Users/jdstokes/repos/antsbin/';
maskDir = fullfile(C.dir.dat_mask,maskType);
subj2run = C.subjects.subj2run;            %Subject List
regFold = ['SL_reg_',maskType,'_',repSubj];      %Registration Folder
warpedfold = ['warped_',maskType,'_',repSubj];



    %Ok we're going to get slightly more sophisticated this time, instead
    %of setting each mask to a constant value across the entire mask, we're
    %going to create a normal distribution within the mask centered around
    %it's centroid, this will hopefully allow us to weight the local
    %topography of the mask and give ANTS better guidance when doing it's
    %thing
    %This section hasn't been debugged yet - C 6/4/13
%     for sub = substart:subend


for subInd = 1: length(subj2run)
    subj= subj2run{subInd};
    
    if exist(fullfile(slDir,subj,warpedfold),'dir')
        rmdir(fullfile(slDir,subj,warpedfold),'s');
    end
    mkdir(fullfile(slDir,subj,warpedfold));
    
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
    
    
%% Warp masks


 subj_masks= dir(fullfile(maskDir,subj,'/','r*.nii'));
        for mas = 1:length(subj_masks)
            eval(['!',antsDir,'/bin/WarpImageMultiTransform 3 ',mDir_cS,'/',subj_masks(mas).name,' ',rDir_cS,'/w_',subj_masks(mas).name,' -R ',mmF_cS,' --use-NN ',rDir_cS,'/abWarp.nii ',rDir_cS,'/abAffine.txt'])
        end
        
 %% Warp megamasks     
        
    eval(['!',antsDir,'/bin/WarpImageMultiTransform 3 ',mmF_cS,' ',rDir_cS,'/w_SL_ROI_reg.nii',' -R ',mmF_cS,' --use-NN ',rDir_cS,'/abWarp.nii ',rDir_cS,'/abAffine.txt'])
   

end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

