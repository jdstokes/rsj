function [score_all,tt_size_all] = behav_scores_greco(score_name,C)


for i = 1:12
    
    DATA = TT_greco(C.subjects.subjAll{i},C);
    
    code = BuildCodes(DATA,C);
  
    [score,tt_size] = CalcScores(score_name,code,C); 
    score_all(i,1) = score;
    tt_size_all(i,1:2) = tt_size;
    clear score tt_size
    
    
end


function [code]=BuildCodes(DATA,C) 
tts = {'all','corr','incorr','s','d','d1','d2','d3','d2or3','d1or2',...
    'c1','c2','c3','c2or3','t','m','n','c1or2','r1','r2','r3','r4',...
    'r2or3or4','r3or4','r1or2'};

code = struct;
for curtt = 1: length(tts)
    code.(tts{curtt}) = zeros(NumTrials(C),1);
end
for curtr = 1:NumTrials(C)
    

    %all resp trias
    if(~strcmp(DATA.trial_type(curtr),'null')), code.all(curtr)     = 1;end
    %correct trials
    if(DATA.acc(curtr)==1),     code.corr(curtr)    = 1;end
    %correct trials
    if(DATA.acc(curtr)==0),     code.incorr(curtr)    = 1;end
    %same trials
    if(strcmp(DATA.trial_type(curtr),'s')),      code.s(curtr)       = 1;end
    %diff trials
    if(strcmp(DATA.trial_type(curtr),'d')),      code.d(curtr)       = 1;end
    %d_1 trials
    if(DATA.tt_code(curtr) ==1),                 code.d1(curtr)     = 1;end
    %d_2 trials
    if(DATA.tt_code(curtr) ==2),                code.d2(curtr)     = 1;end
                    
    %d_1 & d_2 trials
    if(DATA.tt_code(curtr) ==1 ||DATA.tt_code(curtr)==2),     code.d1or2(curtr)   = 1;end
    %c1
    if(DATA.currCity(curtr)==1),      code.c1(curtr) = 1;end
    if(strcmp(DATA.cityTargC(curtr),'T')),            code.t(curtr) = 1;end
    if(strcmp(DATA.cityTargC(curtr),'N')),            code.n(curtr) = 1;end
    %c2
    if(DATA.currCity(curtr)==2),      code.c2(curtr) = 1;code.m(curtr) = 1; end
    %c3
    if(DATA.currCity(curtr)==3),      code.c3(curtr) = 1;end
    %r1
    if(DATA.run_num(curtr)==0),      code.r1(curtr) = 1;end
    %r2
    if(DATA.run_num(curtr)==1),      code.r2(curtr) = 1;end
    %r3
    if(DATA.run_num(curtr)==2),      code.r3(curtr) = 1;end
    %r4
    if(DATA.run_num(curtr)==3),      code.r4(curtr) = 1;end
    %r2,r3,r4
    if(DATA.run_num(curtr) == 1 || DATA.run_num(curtr) == 2 || DATA.run_num(curtr) ==3),      code.r2or3or4(curtr) = 1;end
    if(DATA.run_num(curtr) == 3 || DATA.run_num(curtr) == 3),      code.r3or4(curtr) = 1;end
    if(DATA.run_num(curtr) == 0 || DATA.run_num(curtr) == 1),      code.r1or2(curtr) = 1;end

end


function [score,tt_size]=CalcScores(score_name,code,C)
 score_type = strsplit(score_name,' ');
    
    %Overall trial cnt
    base_cnt = ones(length(NumTrials(C)),1);
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
    
  


