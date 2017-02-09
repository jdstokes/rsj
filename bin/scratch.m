
C = Study_greco2;
load(fullfile(C.dir.tables,'RSPairTables'))
load(fullfile(C.dir.tables,'greco_tables'))



% behav.Properties.VariableNames


right_CA1 = RSPairTables.rs_pair_ash_right_CA1;
left_CA1 = RSPairTables.rs_pair_ash_left_CA1;
right_DG = RSPairTables.rs_pair_ash_right_DG;

RSVarNames =RSPairTables.rs_pair_ash_right_CA1.Properties.VariableNames';


filter = behav.dprime_all>.2;

%% MPS T - N Same ratio
rs_TNratioS = (right_CA1.same_T-right_CA1.same_N)./((right_CA1.same_T+right_CA1.same_N)./2);

%% MPS T - N Same ratio X run
rs_TNratioS_r1 = (right_CA1.same_T_r1-right_CA1.same_N_r1)./((right_CA1.same_T_r1+right_CA1.same_N_r1)./2);
rs_TNratioS_r2 = (right_CA1.same_T_r2-right_CA1.same_N_r2)./((right_CA1.same_T_r2+right_CA1.same_N_r2)./2);
rs_TNratioS_r3 = (right_CA1.same_T_r3-right_CA1.same_N_r3)./((right_CA1.same_T_r3+right_CA1.same_N_r3)./2);
rs_TNratioS_r4 = (right_CA1.same_T_r4-right_CA1.same_N_r4)./((right_CA1.same_T_r4+right_CA1.same_N_r4)./2);

%%  MPS T - N Same 

rs_TNdiffS = (right_CA1.same_T-right_CA1.same_N);
rs_TNdiffS_r1 = (right_CA1.same_T_r1-right_CA1.same_N_r1);
rs_TNdiffS_r2 = (right_CA1.same_T_r2-right_CA1.same_N_r2);
rs_TNdiffS_r3 = (right_CA1.same_T_r3-right_CA1.same_N_r3);
rs_TNdiffS_r4 = (right_CA1.same_T_r4-right_CA1.same_N_r4);


%% Behav.
b_TNratioS= (behav.same_T-behav.same_N)./((behav.same_T+behav.same_N)./2);
b_TNdiffS= (behav.same_T-behav.same_N);



b_TNratioS_r1= (behav.same_T_r1-behav.same_N_r1)./((behav.same_T_r1+behav.same_N_r1)./2);
b_TNratioS_r2= (behav.same_T_r2-behav.same_N_r2)./((behav.same_T_r2+behav.same_N_r2)./2);
b_TNratioS_r3= (behav.same_T_r3-behav.same_N_r3)./((behav.same_T_r3+behav.same_N_r3)./2);
b_TNratioS_r4= (behav.same_T_r4-behav.same_N_r4)./((behav.same_T_r4+behav.same_N_r4)./2);

b_TNratioDP= (behav.dprime_d1_T-behav.dprime_d1_N)./((behav.dprime_d1_T+behav.dprime_d1_N)./2);
b_TNdiffDP = behav.dprime_d1_T-behav.dprime_d1_N;
b_TNratioDP_r1= (behav.dprime_d1_T_r1-behav.dprime_d1_N_r1)./((behav.dprime_d1_T_r1+behav.dprime_d1_N_r1)./2);
b_TNratioDP_r2= (behav.dprime_d1_T_r2-behav.dprime_d1_N_r2)./((behav.dprime_d1_T_r2+behav.dprime_d1_N_r2)./2);
b_TNratioDP_r3= (behav.dprime_d1_T_r3-behav.dprime_d1_N_r3)./((behav.dprime_d1_T_r3+behav.dprime_d1_N_r3)./2);
b_TNratioDP_r4= (behav.dprime_d1_T_r4-behav.dprime_d1_N_r4)./((behav.dprime_d1_T_r4+behav.dprime_d1_N_r4)./2);

b_TNdiffDP_r1= (behav.dprime_d1_T_r1-behav.dprime_d1_N_r1);
b_TNdiffDP_r2= (behav.dprime_d1_T_r2-behav.dprime_d1_N_r2);
b_TNdiffDP_r3= (behav.dprime_d1_T_r3-behav.dprime_d1_N_r3);
b_TNdiffDP_r4= (behav.dprime_d1_T_r4-behav.dprime_d1_N_r4);



%%
index = (b_TNratioDP > mean(b_TNratioDP)-2*std(b_TNratioDP)) & (b_TNratioDP < mean(b_TNratioDP)+2*std(b_TNratioDP));


[RHO,PVAL] = corr(b_TNratioDP(index), rs_TNratioS(index))
[RHO,PVAL] = corr(b_TNratioS(index),  rs_TNratioS(index))
[RHO,PVAL] = corr(b_TNdiffDP(index),  rs_TNratioS(index))




[RHO,PVAL] = corr(b_TNratioDP(index), rs_TNdiffS(index))
[RHO,PVAL] = corr(b_TNratioS(index),  rs_TNdiffS(index))
[RHO,PVAL] = corr(b_TNdiffDP(index),  rs_TNdiffS(index))



%% Same RS compared to Same perf


rs_score =right_CA1.same_T -right_CA1.same_M;
behav_score=behav.dprime_d1;
scatter(rs_score(filter),behav_score(filter))
[r,p ]=corr(rs_score(filter),behav_score(filter))
lsline


rs_score =right_CA1.same;
behav_score=behav.same;
scatter(rs_score(filter),behav_score(filter))
[r,p ]=corr(rs_score(filter),behav_score(filter))
lsline



filter = behav.dprime_all>.2;
rs_score = rs_TNratioS_r2
behav_score=b_TNratioS_r2
hist(behav_score,6)
filter = logical(~isnan(behav_score).*filter);
scatter(rs_score(filter),behav_score(filter))
[r,p ]=corr(rs_score(filter),behav_score(filter))
lsline








% TOI = behav(:,2:end);
% TOI.SOI = SOI;
% 
% VarNames = TOI.Properties.VariableNames;
% 
% [RHO,PVAL] = corr(table2array(TOI));
% 
% 
% indices = find(PVAL<.2);
% 
% 
% 
% for i =1: length(indices)
% 
%     
%     [X,Y] =ind2sub(size(PVAL),indices(i));
%     if strcmp(VarNames{X},'SOI') || strcmp(VarNames{Y},'SOI')
%     disp([VarNames{X},' - ',VarNames{Y}]);
%     end
%  
% end
% 
% 
% 

