function [data] = rsj_rsa_indexbetas(scores,index,C)

for i = 1:length(scores.scores) 
    [scores_msk, ~] = rsj_rsa_outlier_removal(scores.scores{i}.(C.tt.score_type)(index),C.ol.ol_rs);
    data(1:length(scores_msk),i)= scores_msk; %#ok<*AGROW>
end