function [score,tt_size]=calc_scores_greco(score_name,code)
 score_type = strsplit(score_name,' ');
    
    %Overall trial cnt
    base_cnt = ones(length(DATA{1}),1);
    for sco = 2:length(score_type)
        base_cnt = base_cnt .* code.(score_type{sco});
    end
    %Correct trial cnt
    crt_cnt = base_cnt .* code.corr;
    incrt_cnt = base_cnt .* code.incorr;
    %score
    score =[];
    if strcmp(score_type{1},'corr')
        score = sum(crt_cnt)/sum(base_cnt);
        tt_size = [sum(crt_cnt),sum(base_cnt)];
    elseif strcmp(score_type{1},'incorr')
        score = sum(incrt_cnt)/sum(base_cnt);
        tt_size = [sum(incrt_cnt),sum(base_cnt)];
    else
        error('improper condition name!')
    end
    
  

