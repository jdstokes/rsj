function [ind] = GetDprime(C,conditions) 

subjects = C.subjects.subj2inc;

prc = nan(length(subjects),2);
[score1,tt_size_1] = GetGrecoBehav(C,conditions{1});
[score2,tt_size_2] = GetGrecoBehav(C,conditions{2});

prc(1:length(subjects),1) = score1;
prc(1:length(subjects),2) = score2;

scores_dp = nan(length(subjects),1);
for curSubj = 1:length(subjects)        
        %adjust for 0 or 1 values; this is just a quick fix; go back and modify
        if prc(curSubj,1) == 0
           prc(curSubj,1) = .1;
        elseif  prc(curSubj,1) ==1
            prc(curSubj,1) = .99;
        end
        
         if prc(curSubj,2) == 0
           prc(curSubj,2) = .1;
        elseif  prc(curSubj,2) ==1
            prc(curSubj,2) = .99;
        end
%         [dp, ~, ~] = dprime(prc(curSubj,1),prc(curSubj,2),10,10);
        dp = dprime(prc(curSubj,1),prc(curSubj,2),tt_size_1(2),tt_size_2(2));
        scores_dp(curSubj,1) = dp;
        clear dp
end

% group = nanmean(scores_dp);
ind =scores_dp;
