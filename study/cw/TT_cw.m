function tt_all = TT_cw(subj,C,varargin)


format = '.txt';
fileName = fullfile(C.dir.dir_behavioral,subj,[subj,format]);
tt = tdfread(fileName);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%   TT. Build tt
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
tt.event = (1:sum(C.tt.tt_trials))';
trial_dur_study = 6.8;
trial_dur_ret = 4.75;


NumTrials = sum(C.tt.tt_trials);
for i=1:NumTrials;
    
    tri = tt.col_trial_num(i);
    run = tt.Run(i); 
  
    if tt.trial_type(i) == 1
        dur = trial_dur_study;
    elseif tt.trial_type(i) == 2
 
        dur = trial_dur_ret; 
    end
    onset = tt.Onset(i);

    ttspm(run).EVENTNUM{tri} = tt.event(i);
     
  
    if tt.trial_type(i) == 1
    ttspm(run).TT_MAIN{tri} = 'enc';
    elseif tt.trial_type(i) == 2
        ttspm(run).TT_MAIN{tri} = 'ret';
    end
    
%     if tri ==1
%         cnt1=0;
%         cnt2=0;
%        
%     for j = 1:2
%     ttspm(run).ONSET{j} =[];
%     ttspm(run).DUR{j} =[];
%     ttspm(run).PMOD_ERROR(j).param=[];
%     ttspm(run).PMOD_ERROR(j).poly{1} = 1;
%     ttspm(run).PMOD_ERROR(j).name{1} = 'angEr';
%     end
%     end
        ttspm(run).DUR{tri}= dur;
        ttspm(run).ONSET{tri} = onset;
%      if  data.trial_type(i) == 1 
        
        
%         ttspm(run).PMOD_ERROR(1).param{1}(cnt1) = data.test_angEr(i);
%         
%    elseif  data.trial_type(i) == 2 
     
       
%      end
%         ttspm(run).ONSET{2}(cnt2) = onset;
%         ttspm(run).DUR{2}(cnt2) = dur;
%         ttspm(run).PMOD_ERROR(2).param{1}(cnt2) = data.test_angEr(i);
        

%     end

end


%% RS_all
pairs = nchoosek(1:NumTrials,2);

for i = 1:size(pairs,1)
    x = pairs(i,1);
    y = pairs(i,2);
    
    ttrs.rs_withinrun(i,1)  = tt.Run(x) == tt.Run(y);
    ttrs.rs_tt_1(i,1)  = tt.trial_type(x) ==1 & tt.trial_type(y) ==1;
    ttrs.rs_tt_2(i,1)  = tt.trial_type(x) ==2 & tt.trial_type(y) ==2;
    ttrs.rs_tt_wordID(i,1)  = tt.word_ID(x) == tt.word_ID(y);
    ttrs.rs_tt_hit(i,1) = tt.accuracy(x) ==1 & tt.accuracy(y) == 1;
    ttrs.rs_tt_buffer(i,1) = tt.accuracy(x) ==0 & tt.accuracy(y) == 0;
    ttrs.rs_tt_miss(i,1) = tt.accuracy(x) ==2 & tt.accuracy(y) == 2;
    ttrs.test_angEr(i,1) = tt.test_angEr(x);                                %% only useful for RS analysis (ret word to enc word comparisons)
end



%% tt_all
tt_all.rs_pair = tt;
tt_all.rs_all = ttrs;
tt_all.spm = ttspm;


% vars = fieldnames(data);
% for i = 1:length(vars)
%     if ischar(data.(vars{i}))
%         data.(vars{i}) = cellstr(data.(vars{i}));
%     end
% end

% data.NumTrials = NumTrials;
% 
% %Configure output
% if nargin == 3 
%     if strcmp(varargin{1},'spm')
%         tt = ttspm;
%     else
%         error('bad argument');
%     end
% elseif nargin == 2
%     tt = data;
% else
%     error('too many inputs');
% end
