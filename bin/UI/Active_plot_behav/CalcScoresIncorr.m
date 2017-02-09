function [score,tt_size] = CalcScoresIncorr(score_name,code)
 score_type = strsplit(score_name,'_');
    
    %Overall trial cnt
    base_cnt = ones(length(code.all),1);
    for sco = 2:length(score_type)
        base_cnt = base_cnt .* code.(score_type{sco});
    end
    %Correct trial cnt
    incrt_cnt = base_cnt .* code.incorr;
    %score
    score = sum(incrt_cnt)/sum(base_cnt);
    tt_size = [sum(incrt_cnt),sum(base_cnt)];
    