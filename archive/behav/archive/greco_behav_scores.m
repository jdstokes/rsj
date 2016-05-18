function [score_all,tt_size_all] = greco_behav_scores(subjects,score_name)

%Location of Greco enc behavdata
foldpath = '/Volumes/Jared/Data/dGR/behav/behav_scan/';

for curSubj = 1:length(subjects)
    
    %Because shape code is included in name, e.g. 'S1_A'. 'S1' is the
    %subject identifier. 'A' is the code for pretraining on shape 1 and 'B'
    %is the code for pretraining on shape 3
     S=strsplit(subjects{curSubj},'_');
     
    %Load behavioral data
    [DATA,HDRS] = LoadBehav([foldpath,subjects{curSubj},'/',subjects{curSubj},'.txt']); 
    
    %Specific variables importing for parsing trials
    col.col_run =  find(~cellfun(@isempty,strfind(HDRS,'run_num')));
    col.col_acc =  find(~cellfun(@isempty,strfind(HDRS,'acc')));
    col.col_tt = find(~cellfun(@isempty,strfind(HDRS,'trial_type')));
    col.col_currCity = find(~cellfun(@isempty,strfind(HDRS,'currCity')));
    col.col_priorCity = find(~cellfun(@isempty,strfind(HDRS,'priorCity')));
%   trTimeColumn = find(~cellfun(@isempty,strfind(HDRS,'trial_time')));  

    %Build codes
    code = BuildCodes(DATA,col,S);
  
    %Calculate scores
    [score,tt_size] = CalcScores(score_name,code,DATA); 
    score_all(curSubj,1) = score;
    tt_size_all(curSubj,1:2) = tt_size;
    clear score tt_size
    
    
end

function [DATA,HDRS]=LoadBehav(fileName)
fid=fopen(fileName);
HDRS_hand = textscan(fid,repmat('%s ',1,12),1, 'delimiter','\t');
DATA=textscan(fid,repmat('%s ',1,12), 'delimiter','\t');
for curtr = 1:length(HDRS_hand)
    HDRS(curtr) = HDRS_hand{curtr};
end
fclose(fid);

function [code]=BuildCodes(DATA,col,S)
tts = {'all','corr','incorr','s','d','d1','d2','d3','d2or3','d1or2',...
    'c1','c2','c3','c2or3','t','m','n','c1or2','r1','r2','r3','r4',...
    'r2or3or4','r3or4','r1or2'};

code = struct;
for curtt = 1: length(tts)
    code.(tts{curtt}) = zeros(length(DATA{1}),1);
end
for curtr = 1: length(DATA{1})
    
    %Different score
    cityDiff = abs(str2double(DATA{col.col_currCity}{curtr})...
        - str2double(DATA{col.col_priorCity}{curtr}));
    %all resp trias
    if(~strcmp(DATA{col.col_tt}(curtr),'null')), code.all(curtr)     = 1;end
    %correct trials
    if(strcmp(DATA{col.col_acc}(curtr),'1')),     code.corr(curtr)    = 1;end
    %correct trials
    if(strcmp(DATA{col.col_acc}(curtr),'0')),     code.incorr(curtr)    = 1;end
    %same trials
    if(strcmp(DATA{col.col_tt}(curtr),'s')),      code.s(curtr)       = 1;end
    %diff trials
    if(strcmp(DATA{col.col_tt}(curtr),'d')),      code.d(curtr)       = 1;end
    %d_1 trials
    if(strcmp(DATA{col.col_tt}(curtr),'d')...
            &&cityDiff==1),                 code.d1(curtr)     = 1;end
    %d_2 trials
    if(strcmp(DATA{col.col_tt}(curtr),'d')...
            &&cityDiff==2),                 code.d2(curtr)     = 1;end
    %d_3 trials
    if(strcmp(DATA{col.col_tt}(curtr),'d')...
            &&cityDiff==3),                         code.d3(curtr)     = 1;end
    %d_2 & d_3 trials
    if(strcmp(DATA{col.col_tt}(curtr),'d')...
            && (cityDiff==2 ||cityDiff==3)),        code.d2or3(curtr)   = 1;end
    %d_1 & d_2 trials
    if(strcmp(DATA{col.col_tt}(curtr),'d')...
            && (cityDiff==1 ||cityDiff==2)),              code.d1or2(curtr)   = 1;end
    %c1
    if(strcmp(DATA{col.col_currCity}(curtr),'1')),      code.c1(curtr) = 1;end
    if(strcmp(DATA{col.col_currCity}(curtr),'1') && strcmp(S(2),'A')), code.t(curtr) = 1;end
    if(strcmp(DATA{col.col_currCity}(curtr),'1') && strcmp(S(2),'B')), code.n(curtr) = 1;end
    %c2
    if(strcmp(DATA{col.col_currCity}(curtr),'2')),      code.c2(curtr) = 1;code.m(curtr) = 1; end
    %c3
    if(strcmp(DATA{col.col_currCity}(curtr),'3')),      code.c3(curtr) = 1;end
    if(strcmp(DATA{col.col_currCity}(curtr),'3') && strcmp(S(2),'A')), code.n(curtr) = 1;end
    if(strcmp(DATA{col.col_currCity}(curtr),'3') && strcmp(S(2),'B')), code.t(curtr) = 1;end
    %r1
    if(strcmp(DATA{col.col_run}(curtr),'0')),      code.r1(curtr) = 1;end
    %r2
    if(strcmp(DATA{col.col_run}(curtr),'1')),      code.r2(curtr) = 1;end
    %r3
    if(strcmp(DATA{col.col_run}(curtr),'2')),      code.r3(curtr) = 1;end
    %r4
    if(strcmp(DATA{col.col_run}(curtr),'3')),      code.r4(curtr) = 1;end
    %r2,r3,r4
    if(strcmp(DATA{col.col_run}(curtr),'2')||strcmp(DATA{col.col_run}(curtr),'3')||strcmp(DATA{col.col_run}(curtr),'4')),      code.r2or3or4(curtr) = 1;end
    if(strcmp(DATA{col.col_run}(curtr),'3')||strcmp(DATA{col.col_run}(curtr),'4')),      code.r3or4(curtr) = 1;end
    if(strcmp(DATA{col.col_run}(curtr),'1')||strcmp(DATA{col.col_run}(curtr),'2')),      code.r1or2(curtr) = 1;end

end


function [score,tt_size]=CalcScores(score_name,code,DATA)
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
    
  


