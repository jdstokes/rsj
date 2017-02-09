function SL_cluster2(C,beta_row,slrad,maskType,repSubj,conds)

disp([beta_row.beta_ID,' radsize: ',num2str(slrad),' ', maskType, ' ', repSubj,' ',conds{1},' vs ',conds{2}]);
warpedfold = ['warped_',maskType,'_',repSubj];
maskAll= GetMasks(maskType);
maskInds = LoadRepMaskInds(C,repSubj,maskType,maskAll);

anaDir = fullfile(C.dir.analysis,'searchLight',beta_row.beta_ID,...
    'sl_analysis',['radius_',num2str(slrad)],warpedfold,['T_',conds{1},'_',conds{2}]);

disp('Loading P_1min');
[P,hdr] =   LoadImg(anaDir,'P_1min.nii');
disp('Loading T');
[T,~]   =   LoadImg(anaDir,'T.nii');
disp('Loading H');
[H,~]   =   LoadImg(anaDir,'H.nii');

% P = P/1000;
P(T<0) = 0;
P(H==0) = 0;
func_dim = [120 120 36];
thresh = .05;
thresh = 1 -thresh;
maxClustSize = 5;

disp('Running maxcluster');

[ClusterInds, MaxSize, MaxCount ] = maxclustersize(P,thresh);

for clust = 1:size(ClusterInds,2)
    
    if length(ClusterInds{clust}) >= maxClustSize

        IntersectPercentage(ClusterInds{clust},maskInds,maskAll);

        
        containsROI = CheckMasks(ClusterInds{clust},maskInds,maskAll);
        
        if containsROI %If cluster contains voxels within an ROI, save the cluster
        clusterImg = zeros(func_dim);
        clusterImg(ClusterInds{clust}) =1;
        clusterDir = fullfile(anaDir,['clusters',num2str(thresh)]);
        mkdir(clusterDir);
        hdr.fname = fullfile(clusterDir,['cluster_',num2str(clust),'.nii']);
        spm_write_vol(hdr,clusterImg);
        clear clusterImg 
        end
    end
    
end


end




function P = IntersectPercentage(clustI,maskInds,maskAll)

        for i = 1:length(maskInds)
            
            
           if ~isempty(intersect(clustI,maskInds{i}))
           disp(['total voxels: ',...
               num2str(length(clustI)), ' ',maskAll{i},...
               ' num voxels: ',num2str(length(intersect(clustI,maskInds{i})))])
           end
        end
end

function containsROI = CheckMasks(clustI,maskInds,maskAll)
        containsROI = 0;
        for i = 1:length(maskInds)
            
            
           if ~isempty(intersect(clustI,maskInds{i}))
               containsROI = true;
%            disp(['total voxels: ',...
%                num2str(length(clustI)), ' ',maskAll{i},...
%                ' num voxels: ',num2str(length(intersect(clustI,maskInds{i})))])
           end
        end
end



function maskInds = LoadRepMaskInds(C,repSubj,maskType,maskAll)


maskDir = fullfile(C.dir.dat_mask,maskType); %Mask directory


   %Cycle through each ROI
        for i=1:size(maskAll)
           m = LoadImg(fullfile(maskDir,repSubj),['r',maskAll{i}]);
           maskInds{i} = find(m~=0);
        end


end


function maskAll= GetMasks(maskType)

switch maskType
    case 'ash_lfseg_corr_usegray'
        maskAll = {
            %                     'ash_left_35.nii'
            %                     'ash_left_36.nii'
            'ash_left_CA1.nii'
            'ash_left_CA2.nii'
            'ash_left_CA3.nii'
            %                     'ash_left_CS.nii'
            'ash_left_DG.nii'
            %                     'ash_left_ERC.nii'
            %                     'ash_left_MISC.nii'
            %                     'ash_left_head.nii'
            'ash_left_subiculum.nii'
            %                     'ash_left_tail.nii'
            %                     'ash_right_35.nii'
            %                     'ash_right_36.nii'
            'ash_right_CA1.nii'
            'ash_right_CA2.nii'
            'ash_right_CA3.nii'
            %                     'ash_right_CS.nii'
            'ash_right_DG.nii'
            %                     'ash_right_ERC.nii'
            %                     'ash_right_MISC.nii'
            %                     'ash_right_head.nii'
            'ash_right_subiculum.nii'
            %                     'ash_right_tail.nii'
            
            };
    case 'v3'
        maskAll = {
            
        'L_CA1.nii'
        'L_CA3.nii'
        'L_SUB.nii'
        'L_PHC.nii'
        
        
        'R_CA1.nii'
        'R_CA3.nii'
        'R_SUB.nii'
        'R_PHC.nii'
        };
end


end








     
        
   
               
                
            
                
       
        
        
      