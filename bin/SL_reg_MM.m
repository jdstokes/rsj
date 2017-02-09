function SL_reg_MM(C,maskType)

antsDir = '/Users/jdstokes/repos/antsbin/'; %Location of Ants files
maskDir = fullfile(C.dir.dat_mask,maskType); %Location of Masks/ROIs
subj2run = C.subjects.subj2run;%Subject List
mmFold = ['SL_mm'];%Registration Folder


switch maskType
    
    case 'ash_lfseg_corr_usegray'
        for subInd=1:length(subj2run)
            
            
            
            
            subj= subj2run{subInd};
            h = waitbar(subInd/length(subj2run),['Building super mask:' num2str(subInd) ' / ' num2str(length(subj2run))]);
            
            
            
            %         cd([maskDir subj,'/'])%Mask directory
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            %% Do Left CA1 - 50
            %Load mask
            hdr1 = spm_vol(fullfile(maskDir,subj,['rash_left_CA1.nii']));
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
            
            
            hdr2 =  spm_vol(fullfile(maskDir,subj,['rash_right_CA1.nii']));
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
            hdr1 =spm_vol(fullfile(maskDir,subj,['rash_left_DG.nii']));
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
            hdr2 = spm_vol(fullfile(maskDir,subj,['rash_right_DG.nii']));
            
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
            hdr1 = spm_vol(fullfile(maskDir,subj,['rash_left_ERC.nii']));
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
            hdr1 = spm_vol(fullfile(maskDir,subj,['rash_right_ERC.nii']));
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
            hdr1 = spm_vol(fullfile(maskDir,subj,['rash_left_subiculum.nii']));
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
            hdr1 = spm_vol(fullfile(maskDir,subj,['rash_right_subiculum.nii']));
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
            
            
            
            
            dir_mri = C.dir.dat_mri;
            hiresFold = C.spm.hiresFold;
            hiresFile = ['r',C.spm.hiresFile];
            hrF_cS = fullfile(dir_mri,subj,hiresFold,hiresFile);
            hrHdr = spm_vol(hrF_cS);
            hrHdr = rmfield(hrHdr,'pinfo');
            hrHdr.descrip = 'SL mm';
            mkdir(fullfile(maskDir,mmFold,subj));
            
            hrHdr.fname = fullfile(maskDir,mmFold,subj,'SL_ROI_reg.nii');
            spm_write_vol(hrHdr,COMB);
            clear COMB dist I J K
            delete(h);
        end
        
    case'v3'
        for subInd=1:length(subj2run)
            
            
            
            
            
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
            
            
            
            dir_mri = C.dir.dat_mri;
            hiresFold = C.spm.hiresFold;
            hiresFile = ['r',C.spm.hiresFile];
            hrF_cS = fullfile(dir_mri,subj,hiresFold,hiresFile);
            hrHdr = spm_vol(hrF_cS);
            
            mkdir(fullfile(maskDir,mmFold,subj));
            
            hrHdr.fname = fullfile(maskDir,mmFold,subj,'SL_ROI_reg.nii');
            spm_write_vol(hrHdr,COMB);
            
            delete(h);
            clear COMB dist I J K
            delete(h);
        end
        
end