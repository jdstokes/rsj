function[]=RS_SL_groupREGbetas(RS)

%First, for each subject go in and combine CA1,CA3 on left and right,
%CA1 == 5, CA3 == 1; JS added PFC and SUB

    
        cd([RS.mask_dir RS.subj,'/'])%Mask directory
        
        %% Read in masks and output that SUPAMASK!
        hdr1 = spm_vol(['r',RS.subj,'_L_CA1.nii']);
        LCA1 = spm_read_vols(hdr1);
        hdr2 = spm_vol(['r',RS.subj,'_R_CA1.nii']);
        RCA1 = spm_read_vols(hdr2);
        
        hdr1 = spm_vol(['r',RS.subj,'_L_CA3.nii']);
        LCA3 = spm_read_vols(hdr1);
        hdr2 = spm_vol(['r',RS.subj,'_R_CA3.nii']);
        RCA3 = spm_read_vols(hdr2);
        
    
        hdr1 = spm_vol(['r',RS.subj,'_L_SUB.nii']);
        LSUB = spm_read_vols(hdr1);
        hdr2 = spm_vol(['r',RS.subj,'_R_SUB.nii']);
        RSUB = spm_read_vols(hdr2);
        
        hdr1 = spm_vol(['r',RS.subj,'_L_PHC.nii']);
        LPHC = spm_read_vols(hdr1);
        hdr2 = spm_vol(['r',RS.subj,'_R_PHC.nii']);
        RPHC = spm_read_vols(hdr2);
        
        
        LCA1(LCA1>0) = 10;
        RCA1(RCA1>0) = 10;
        LSUB(LSUB>0) = 20;
        RSUB(RSUB>0) = 20; 
        LPHC(LPHC>0) = 30;
        RPHC(RPHC>0) = 30;
        
        
        %%Build SUPAMASK!
        COMB = LCA1+RCA1+LCA3+RCA3+LPHC+RPHC+LSUB+RSUB;
        hdr1.fname = 'SL_ROI.nii';
        spm_write_vol(hdr1,COMB)
        
        
        

    %Whats going in here:
    %   1. Warp mean functional -> template (or representative subject) -
    %       happens once per subject.
    %   2. masks follow mean functional -> template
    %       happens once per subject
    %   3. stats images follow mean functional -> template
  
        %1. Get warp paramaters
            % 1. Check
        cd([RS.mask_dir RS.subj,'/'])%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Fixed %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Moving %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Output %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        eval(['!/Users/colintkyle/Documents/ANTs/bin/bin/ANTS 3 -m CC[',RS.mask_dir, 'ce105','/SL_ROI.nii,',RS.mask_dir, RS.subj,'/SL_ROI.nii,1,5] -i 20x20x10 -o ',RS.mask_dir, RS.subj,'/ab.nii -t SyN[0.25] -r Gauss[3,0] '])
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Moving %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Output %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Fixed %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Warper %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Warper %%%%%%%%%%%%%%%%%%
        eval(['!/Users/colintkyle/Documents/ANTs/bin/bin/WarpImageMultiTransform 3 ',RS.mask_dir, RS.subj,'/r', RS.subj,'_hr.nii ',RS.mask_dir, RS.subj,'/bwarp.nii -R ',RS.mask_dir, RS.subj,'/SL_ROI.nii ',RS.mask_dir, RS.subj,'/abWarp.nii ',RS.mask_dir, RS.subj,'/abAffine.txt'])
%         2. Check
        mkdir([RS.mask_dir RS.subj,'/warpedtotemplate/'])
        for mas = 1:length(RS.maskList)
           
                eval(['!/Users/colintkyle/Documents/ANTs/bin/bin/WarpImageMultiTransform 3 ',RS.mask_dir, RS.subj,'/r' RS.subj,'_',RS.maskList{mas},'.nii ',RS.mask_dir, RS.subj,'/warpedtotemplate/',RS.maskList{mas},'.nii -R ',RS.mask_dir, 'ce105','/SL_ROI.nii --use-NN ',RS.mask_dir, RS.subj,'/abWarp.nii ',RS.mask_dir, RS.subj,'/abAffine.txt'])
        end
        
        
        %warp Masks
        Masks = dir(fullfile([RS.mask_dir,RS.subj,'/','r*.nii']));
        
        %warp betas   
        Betas = dir(fullfile([RS.analysis_dir,RS.subj,'/*.img']));
      
        %make warped mask folder
        mkdir([RS.mask_dir_warp,RS.subj ]);
        %make warped beta folder
        mkdir([RS.analysis_dir_warp,RS.subj]);
      
        for i = 1:length(Masks)
            eval(['!/Users/colintkyle/Documents/ANTs/bin/bin/WarpImageMultiTransform 3 ',RS.mask_dir,RS.subj,'/' Masks(i).name,' ',RS.mask_dir_warp,RS.subj,'/',Masks(i).name,' -R ',RS.mask_dir,'ce105','/SL_ROI.nii ',RS.mask_dir, RS.subj,'/abWarp.nii ',RS.mask_dir, RS.subj,'/abAffine.txt'])
        end
        
        for i = 1:length(Betas)
            eval(['!/Users/colintkyle/Documents/ANTs/bin/bin/WarpImageMultiTransform 3 ',RS.analysis_dir,RS.subj,'/',Betas(i).name,' ',RS.analysis_dir_warp,RS.subj,'/',Betas(i).name,' -R ',RS.mask_dir,'ce105','/SL_ROI.nii ',RS.mask_dir, RS.subj,'/abWarp.nii ',RS.mask_dir, RS.subj,'/abAffine.txt'])
        end
        
  
    
    cd(RS.script_dir)