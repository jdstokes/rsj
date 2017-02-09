function SL_reg_greco(C,beta_row)

slrad = 4;
slDir = fullfile(C.dir.analysis,'searchLight',beta_row.beta_ID,['radius_',num2str(slrad)]);

antsDir = '/Users/jdstokes/repos/antsbin/';
maskType = 'v3';
maskDir = fullfile(C.dir.dat_mask,maskType);

repSubj = 'S16_A';                         %Pick rep subj
subj2run = C.subjects.subj2run;            %Subject List
regFold = ['SL_reg_', repSubj];           %Registration Folder


%Arguments
makeMM = 0; %Make megamask, change makeMM to 1
regSpec = 0;
warpSL = 1;
    %Ok we're going to get slightly more sophisticated this time, instead
    %of setting each mask to a constant value across the entire mask, we're
    %going to create a normal distribution within the mask centered around
    %it's centroid, this will hopefully allow us to weight the local
    %topography of the mask and give ANTS better guidance when doing it's
    %thing
    %This section hasn't been debugged yet - C 6/4/13
%     for sub = substart:subend

if makeMM
for subInd=length(subj2run):-1:1
    
    
    
    
    
    subj= subj2run{subInd};
    h = waitbar(subInd/length(subj2run),['Building super mask:' num2str(subInd) ' / ' num2str(length(subj2run))]);
   
%         cd([maskDir subj,'/'])%Mask directory
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %% Do Left CA1 - 50
        %Load mask
        hdr1 = spm_vol(fullfile(maskDir,subj,['rL_CA1.nii']));
        LCA1 = spm_read_vols(hdr1);
        %Get indices
        inds = find(LCA1>0);
        %Reset to 1 (unnecessary)
        LCA1(inds)=1;
        %Get subscripts for rough size aproximation
        [I1,J1,K1] = ind2sub(size(LCA1),inds);
        mins= min([I1,J1,K1]);
        maxs = max([I1,J1,K1]);
        %largest spread of X,Y,Z becomes basis for distrubution
        maxdim = max(maxs-mins);
        %Get Centroid
        stats = regionprops(LCA1,'centroid');
        %Create and normalize distribution (distribution span set to 5)
        x = [0:100];
        normdist = normpdf(x,0,round(maxdim/7));
        normdist = 5*normdist/max(normdist);
        %Go through inds set value of mask to
        %normdist(radius_from_centroid)+(constant to distinguish mask set)
        for i = 1:length(inds)
            [I,J,K] = ind2sub(size(LCA1),inds(i));
            dist = round(pdist([[stats.Centroid([2 1 3])];[I,J,K]],'euclidean'));
            LCA1(inds(i))=normdist(dist+1)+50;
        end

        clearvars inds I1 J1 K1 I J K mins maxs maxdim stats dist
        %%%%%%%%%%%%%%%%%%%%
        %% Do Right CA1
        
       
        hdr2 =  spm_vol(fullfile(maskDir,subj,['rR_CA1.nii']));
        RCA1 = spm_read_vols(hdr2);
        inds = find(RCA1>0);
        RCA1(inds)=1;
        [I1,J1,K1] = ind2sub(size(RCA1),inds);
        mins= min([I1,J1,K1]);
        maxs = max([I1,J1,K1]);
        maxdim = max(maxs-mins);
        
        stats = regionprops(RCA1,'centroid');
        x = [0:100];
        normdist = normpdf(x,0,round(maxdim/7));
        normdist = 5*normdist/max(normdist);
        for i = 1:length(inds)
            [I,J,K] = ind2sub(size(RCA1),inds(i));
            dist = round(pdist([[stats.Centroid([2 1 3])];[I,J,K]],'euclidean'));
            RCA1(inds(i))=normdist(dist+1)+50;
        end
        clearvars inds I1 J1 K1 I J K mins maxs maxdim stats dist
        %%%%%%%%%%%%%%%%%%%%
        %% Do Left CA3 - 100
         hdr1 =spm_vol(fullfile(maskDir,subj,['rL_CA3.nii']));
%         hdr1 = spm_vol(['rL_CA3.nii']);
        LCA3 = spm_read_vols(hdr1);
        inds = find(LCA3>0);
        LCA3(inds)=1;
        [I1,J1,K1] = ind2sub(size(LCA3),inds);
        mins= min([I1,J1,K1]);
        maxs = max([I1,J1,K1]);
        maxdim = max(maxs-mins);
        
        stats = regionprops(LCA3,'centroid');
        x = [0:100];
        normdist = normpdf(x,0,round(maxdim/7));
        normdist = 5*normdist/max(normdist);
        for i = 1:length(inds)
            [I,J,K] = ind2sub(size(LCA3),inds(i));
            dist = round(pdist([[stats.Centroid([2 1 3])];[I,J,K]],'euclidean'));
            LCA3(inds(i))=normdist(dist+1)+100;
        end
        clearvars inds I1 J1 K1 I J K mins maxs maxdim stats dist
        
        %%%%%%%%%%%%%%%%%%%%
        %% Do Right CA3
%         hdr2 = spm_vol(['rR_CA3.nii']);
        hdr2 = spm_vol(fullfile(maskDir,subj,['rR_CA3.nii']));
        
        RCA3 = spm_read_vols(hdr2);
        inds = find(RCA3>0);
        RCA3(inds)=1;
        [I1,J1,K1] = ind2sub(size(RCA3),inds);
        mins= min([I1,J1,K1]);
        maxs = max([I1,J1,K1]);
        maxdim = max(maxs-mins);
        
        stats = regionprops(RCA3,'centroid');
        x = [0:100];
        normdist = normpdf(x,0,round(maxdim/7));
        normdist = 5*normdist/max(normdist);
        for i = 1:length(inds)
            [I,J,K] = ind2sub(size(RCA3),inds(i));
            dist = round(pdist([[stats.Centroid([2 1 3])];[I,J,K]],'euclidean'));
            RCA3(inds(i))=normdist(dist+1)+100;
        end
        clearvars inds I1 J1 K1 I J K mins maxs maxdim stats dist
        %%%%%%%%%%%%%%%%%%%%
        %% Do Left PHC - 150
%         hdr1 = spm_vol(['rL_PHC.nii']);
        hdr1 = spm_vol(fullfile(maskDir,subj,['rL_PHC.nii']));
        LPHC = spm_read_vols(hdr1);
        inds = find(LPHC>0);
        LPHC(inds)=1;
        [I1,J1,K1] = ind2sub(size(LPHC),inds);
        mins= min([I1,J1,K1]);
        maxs = max([I1,J1,K1]);
        maxdim = max(maxs-mins);
        
        stats = regionprops(LPHC,'centroid');
        x = [0:100];
        normdist = normpdf(x,0,round(maxdim/7));
        normdist = 5*normdist/max(normdist);
        locations1(subInd,1:3) = stats.Centroid([2 1 3]);
        for i = 1:length(inds)
            [I,J,K] = ind2sub(size(LPHC),inds(i));
            dist = round(pdist([[stats.Centroid([2 1 3])];[I,J,K]],'euclidean'));
            LPHC(inds(i))=normdist(dist+1)+150;
        end
        clearvars inds I1 J1 K1 I J K mins maxs maxdim stats dist
        %%%%%%%%%%%%%%%%%%%%
        %% Do Right PHC
%         hdr1 = spm_vol(['rR_PHC.nii']);
        hdr1 = spm_vol(fullfile(maskDir,subj,['rR_PHC.nii']));
        RPHC = spm_read_vols(hdr1);
        inds = find(RPHC>0);
        RPHC(inds)=1;
        [I1,J1,K1] = ind2sub(size(RPHC),inds);
        mins= min([I1,J1,K1]);
        maxs = max([I1,J1,K1]);
        maxdim = max(maxs-mins);
        
        stats = regionprops(RPHC,'centroid');
        x = [0:100];
        normdist = normpdf(x,0,round(maxdim/7));
        normdist = 5*normdist/max(normdist);
        locations1(subInd,4:6) = stats.Centroid([2 1 3]);
        for i = 1:length(inds)
            [I,J,K] = ind2sub(size(RPHC),inds(i));
            dist = round(pdist([[stats.Centroid([2 1 3])];[I,J,K]],'euclidean'));
            RPHC(inds(i))=normdist(dist+1)+150;
        end
        clearvars inds I1 J1 K1 I J K mins maxs maxdim stats dist
        %% Do Left SUB - 75
%         hdr1 = spm_vol(['rL_SUB.nii']);
        hdr1 = spm_vol(fullfile(maskDir,subj,['rL_SUB.nii']));
        LSUB = spm_read_vols(hdr1);
        inds = find(LSUB>0);
        LSUB(inds)=1;
        [I1,J1,K1] = ind2sub(size(LSUB),inds);
        mins= min([I1,J1,K1]);
        maxs = max([I1,J1,K1]);
        maxdim = max(maxs-mins);
        
        stats = regionprops(LSUB,'centroid');
        x = [0:100];
        normdist = normpdf(x,0,round(maxdim/7));
        normdist = 5*normdist/max(normdist);
        locations1(subInd,1:3) = stats.Centroid([2 1 3]);
        for i = 1:length(inds)
            [I,J,K] = ind2sub(size(LSUB),inds(i));
            dist = round(pdist([[stats.Centroid([2 1 3])];[I,J,K]],'euclidean'));
            LSUB(inds(i))=normdist(dist+1)+75;
        end
        clearvars inds I1 J1 K1 I J K mins maxs maxdim stats dist
        %%%%%%%%%%%%%%%%%%%%
        %% Do Right subInd
%         hdr1 = spm_vol(['rR_SUB.nii']);
        hdr1 = spm_vol(fullfile(maskDir,subj,['rR_SUB.nii']));
        RSUB = spm_read_vols(hdr1);
        inds = find(RSUB>0);
        RSUB(inds)=1;
        [I1,J1,K1] = ind2sub(size(RSUB),inds);
        mins= min([I1,J1,K1]);
        maxs = max([I1,J1,K1]);
        maxdim = max(maxs-mins);
        
        stats = regionprops(RSUB,'centroid');
        x = [0:100];
        normdist = normpdf(x,0,round(maxdim/7));
        normdist = 5*normdist/max(normdist);
        locations1(subInd,4:6) = stats.Centroid([2 1 3]);
        for i = 1:length(inds)
            [I,J,K] = ind2sub(size(RSUB),inds(i));
            dist = round(pdist([[stats.Centroid([2 1 3])];[I,J,K]],'euclidean'));
            RSUB(inds(i))=normdist(dist+1)+75;
        end
        clearvars inds I1 J1 K1 I J K mins maxs maxdim stats dist
        %% Combine masks
        COMB = zeros(size(LSUB));
%         COMB(find(LCAant>0)) = LCAant(find(LCAant>0));%%LCAant+RCAant+LCA3+RCA3+LPHC+RPHC+LCA1+RCA1+LSUB+RSUB;
%         COMB(find(RCAant>0)) = RCAant(find(RCAant>0));
        COMB(find(LCA1>0)) = LCA1(find(LCA1>0));
        COMB(find(RCA1>0)) = RCA1(find(RCA1>0));
        COMB(find(LCA3>0)) = LCA3(find(LCA3>0));
        COMB(find(RCA3>0)) = RCA3(find(RCA3>0));
        COMB(find(LPHC>0)) = LPHC(find(LPHC>0));
        COMB(find(RPHC>0)) = RPHC(find(RPHC>0));
        COMB(find(LSUB>0)) = LSUB(find(LSUB>0));
        COMB(find(RSUB>0)) = RSUB(find(RSUB>0));
        
        inds = find(COMB==0);
        COMB1= zeros(size(COMB));
        COMB1(find(COMB>0)) = 1;
        [I1,J1,K1] = ind2sub(size(COMB),inds);
        mins= min([I1,J1,K1]);
        maxs = max([I1,J1,K1]);
        maxdim = max(maxs-mins);
        stats = regionprops(COMB1,'centroid');
        x = [0:100];
        normdist = normpdf(x,0,30);
        normdist = 5*normdist/max(normdist);

        for i = 1:length(inds)
            [I,J,K] = ind2sub(size(RSUB),inds(i));
            dist = round(pdist([[stats.Centroid([2 1 3])];[I,J,K]],'euclidean'));
            COMB(inds(i))=normdist(dist+1)+5;
        end
        
        
        
        
        
        mkdir(fullfile(maskDir,regFold,subj));
%         cd([maskDir, subj,'/',regFold]);
        
        hdr1.fname = fullfile(maskDir,regFold,subj,'SL_ROI_reg2.nii');
        spm_write_vol(hdr1,COMB);
        
delete(h);
end
end

%% Warp
warpedfold = ['/reg_',repSubj,'/'];

for subInd = 1: length(subj2run)
    subj= subj2run{subInd};
    
    if exist(fullfile(slDir,subj,warpedfold),'dir')
        rmdir(fullfile(slDir,subj,warpedfold),'s');
    end
    mkdir(fullfile(slDir,subj,warpedfold));
    
    
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
    if regSpec
        mkdir(fullfile(maskDir,subj,warpedfold));
        cd(fullfile(maskDir,subj));%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Fixed %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Moving %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Output %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        eval(['!',antsDir,'bin/ANTS 3 -m MSQ[',fullfile(maskDir,regFold,repSubj),'/SL_ROI_reg2.nii,',fullfile(maskDir,regFold,subj),'/SL_ROI_reg2.nii,.6,0] -m CC[',fullfile(maskDir,repSubj),['/r',repSubj,'_hires.nii,'],fullfile(maskDir,subj),['/r',subj, '_hires.nii,.4,5] -i 20x20x10 -o '],fullfile(maskDir,regFold,subj),'/ab.nii -t SyN[0.15] -r Gauss[3,0] '])
        %eval(['!/Users/colintkyle/Documents/ANTs/bin/bin/ANTS 3 -m CC[',mask_dir,'smeanTSliceBLOCK1.nii,',func_dir,subjects{sub},'BLOCK1/meanTSliceBLOCK1.nii,1,5] -i 20x20x10 -o ',func_dir,subjects{sub},'BLOCK1/ab.nii -t SyN[0.25] -r Gauss[3,0] '])%-x ',mask_dir,subjects2(7).name,'/megamask.nii'])
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Moving %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Output %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Fixed %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Warper %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Warper %%%%%%%%%%%%%%%%%%
         eval(['!',antsDir,'bin/WarpImageMultiTransform 3 ',fullfile(maskDir,subj),'/r',subj, '_hires.nii ',fullfile(maskDir,regFold,subj),'/bwarp.nii -R ',fullfile(maskDir,regFold,subj),'/SL_ROI_reg2.nii -use-NN ',fullfile(maskDir,regFold,subj),'/abWarp.nii ',fullfile(maskDir,regFold,subj),'/abAffine.txt'])
%                 eval(['!',antsDir,'bin/WarpImageMultiTransform 3 ',fullfile(maskDir,regFold,subj),'/r',subj, '_hires.nii ',fullfile(maskDir,regFold,subj),'/bwarp.nii -R ',fullfile(maskDir,regFold,subj),'/SL_ROI_reg2.nii ',fullfile(maskDir,regFold,subj),'/abWarp.nii ',fullfile(maskDir,regFold,subj),'/abAffine.txt'])

        %2. Check
        subj_masks= dir(fullfile(maskDir,subj,'/','r*.nii'));
        for mas = 1:length(subj_masks)
            eval(['!',antsDir,'/bin/WarpImageMultiTransform 3 ',fullfile(maskDir,subj),'/',subj_masks(mas).name,' ',fullfile(maskDir,subj),'/',warpedfold,'/w_',subj_masks(mas).name,' -R ',fullfile(maskDir,regFold,subj),'/SL_ROI_reg2.nii --use-NN ',fullfile(maskDir,regFold,subj),'/abWarp.nii ',fullfile(maskDir,regFold,subj),'/abAffine.txt'])
        end
    end
   
   
    %% Morph stat images
    
    if warpSL
    statimages=dir(fullfile(slDir,subj,'*.nii'));
    for i = 1:length(statimages)
        eval(['!',antsDir,'/bin/WarpImageMultiTransform 3 ',fullfile(slDir,subj,statimages(i).name),' ',fullfile(slDir,subj,warpedfold),'/w_',statimages(i).name ' -R ',fullfile(maskDir,regFold,repSubj),'/SL_ROI_reg2.nii --use-NN ',fullfile(maskDir,regFold,subj),'/abWarp.nii ',fullfile(maskDir,regFold,subj),'/abAffine.txt'])
    end
    
    end
    
    
    
    
    
    
    
    %     blockfolders = dir(fullfile([beta_dir,subjects{sub},'*.mat']));
%     for i = 1:n
%         betaimages = dir(fullfile([beta_dir,subjects{sub},blockfolders(i).name,'/AllEvents/*.img']));
%         mkdir([beta_dir,subjects{sub},blockfolders(i).name,'/AllEvents/warpedtotemplate/'])
%         for j = 1:length(betaimages)
%             eval(['!',antsDir,'/bin/WarpImageMultiTransform 3 ',beta_dir,subjects{sub},blockfolders(i).name,'/AllEvents/',betaimages(j).name,' ',beta_dir,subjects{sub},blockfolders(i).name,'/AllEvents/warpedtotemplate/group',betaimages(j).name,' -R ',mask_dir,subjects2(9).name,'/TempComb.nii --use-NN ',func_dir,subjects{sub},'BLOCK1/abWarp.nii ',func_dir,subjects{sub},'BLOCK1/abAffine.txt'])
%         end
%     end
end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

