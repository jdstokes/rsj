function PlotSearchLight_pie
close all
%Study properties
C = Study_greco2;


%Load tables
tableDir = C.dir.tables;
T = load(fullfile(tableDir,'greco_tables.mat'));

%Subject list
C.subjects.subj2run= C.subjects.subj2inc; %Override subj2run
subj2run = C.subjects.subj2run;

%Beta row ID
cur_model_ID = 'm00000089';
modelI = strcmp(cur_model_ID,cellstr(T.model.model_ID));
betaI = strcmp(cur_model_ID,cellstr(T.betas.model_ID));
rsI = strcmp(T.betas.beta_ID(betaI,:),cellstr(T.rs.beta_ID));
model_row = T.model(modelI,:);
beta_row = T.betas(betaI,:);
rs_row = T.rs(rsI,:);
%Registration type
repSubj = 'S16_A';
regType = 'reg_S16_A';
%img dim
imgDim = [120,120,36];

%categories of interest
cats = {'same','diff2'};

% cluster threshold
thresh = .95;

%load rep subjects mask




repSubj = 'S16_A';  
regType = ['reg_',repSubj];
maskType = C.masks.maskType;
maskAll = {
                    'ash_left_35.nii'
                    'ash_left_36.nii'
                    'ash_left_CA1.nii'
                    'ash_left_CA2.nii'
                    'ash_left_CA3.nii'
                    'ash_left_CS.nii'
                    'ash_left_DG.nii'
                    'ash_left_ERC.nii'
                    'ash_left_MISC.nii'
                    'ash_left_head.nii'
                    'ash_left_subiculum.nii'
                    'ash_left_tail.nii'
                    'ash_right_35.nii'
                    'ash_right_36.nii'
                    'ash_right_CA1.nii'
                    'ash_right_CA2.nii'
                    'ash_right_CA3.nii'
                    'ash_right_CS.nii'
                    'ash_right_DG.nii'
                    'ash_right_ERC.nii'
                    'ash_right_MISC.nii'
                    'ash_right_head.nii'
                    'ash_right_subiculum.nii'
                    'ash_right_tail.nii'

};


maskInds = LoadRepMaskInds(C,repSubj,maskType,maskAll);



% Get clusters
anaSLcomp = fullfile(C.dir.analysis,'searchLight',beta_row.beta_ID,...
    'sl_analysis',regType,['T_',cats{1},'_',cats{2}]);
clusterDir = fullfile(anaSLcomp,['clusters',num2str(thresh)]);
clusterNames = dir([clusterDir,'/*.nii']);


for clust = 1:length(clusterNames)
    clusterImg = LoadImg(clusterDir,clusterNames(clust).name);
    [voxelCount, maskNames]= GetPieChartInput(find(clusterImg),maskInds,maskAll);
    if voxelCount
    figure;
    p = pie(voxelCount,maskNames);
    title([FixStrings({clusterNames(clust).name},{'_','.nii'},{' ',''}), ' size: ',num2str(sum(voxelCount)),' voxels']);
    end
    
end




end




function [voxelCount, maskNames]= GetPieChartInput(clustI,maskInds,maskAll)
cnt =0;
voxelCount =[];
maskNames ={};

        for i = 1:length(maskInds)
            
            
           if ~isempty(intersect(clustI,maskInds{i}))
           disp(['total voxels: ',...
               num2str(length(clustI)), ' ',maskAll{i},...
               ' num voxels: ',num2str(length(intersect(clustI,maskInds{i})))])
           cnt = cnt +1;
           voxelCount(cnt) = length(intersect(clustI,maskInds{i}));
           maskNames{cnt} = maskAll{i};
           end
        end
        
        if ~isempty(voxelCount)
        voxelCount(end +1) = length(clustI) -sum(voxelCount);
        maskNames{end +1} = 'other';
        maskNames = FixStrings(maskNames,{'_','.nii','ash'},{' ','',''});
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