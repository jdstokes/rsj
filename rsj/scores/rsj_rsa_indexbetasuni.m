function [data] = rsj_rsa_indexbetasuni(scores,index,ols)

for i = 1:length(scores.scores) 
    [scores_msk, ~] = rsj_rsa_outlier_removal(scores.scores{i}.uni_m(index),ols);
    data(1:length(scores_msk),i)= scores_msk; %#ok<*AGROW>
 
end