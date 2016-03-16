function [score,tt_size] = CalcScoresCorr(score_name,code)
 score_type = strsplit(score_name,'_');
    
    %Overall trial cnt
    base_cnt = ones(length(code.all),1);
    for sco = 1:length(score_type)
        base_cnt = base_cnt .* code.(score_type{sco});
    end
    %Correct trial cnt
    crt_cnt = base_cnt .* code.corr;
   
    score = sum(crt_cnt)/sum(base_cnt);
    tt_size = [sum(crt_cnt),sum(base_cnt)];
    
    