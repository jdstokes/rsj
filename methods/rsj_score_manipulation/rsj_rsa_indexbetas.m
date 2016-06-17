function [data] = rsj_rsa_indexbetas(scores,index,C)

%%Find number of voxels
for i = 1:length(scores.scores) 
    if ~isempty(scores.scores{i})
        numVoxels = length(scores.scores{i}.(C.tt.score_type)(index));
        break
    end
end


%%Numboer of ROIs
numROIs = length(scores.scores);

%%Get data
data = nan(numVoxels,numROIs);


%% Remove outliers (if selected), get data
for i = 1:numROIs
    if ~isempty(scores.scores{i})
        [scores_msk, ~] = rsj_rsa_outlier_removal(scores.scores{i}.(C.tt.score_type)(index),C.ol.ol_rs);
        data(1:numVoxels,i) = scores_msk;
    else
        data(1:numVoxels,i) = NaN;
    end
end
