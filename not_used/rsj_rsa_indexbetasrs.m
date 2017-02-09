function data = rsj_rsa_indexbetasrs(scores,index,ols)

mask_exists_ind = find(~cellfun('isempty',scores.scores))';
for i = mask_exists_ind
     
    [scores_msk, ~] = rsj_rsa_outlier_removal(scores.scores{i}.rsz(index),ols);
    data(1:length(scores_msk),i)= scores_msk; %#ok<*AGROW>
     clear scores_msk
end

            
            
            
           