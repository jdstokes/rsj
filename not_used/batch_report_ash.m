% function batch_report_ash(C,rs_feature_mask)
%tt_code 0 : Same trials
%tt_code 1: Diff 1 trials
%tt_code 2: Diff 2 trial
%T: trained city
%M: morph city
%N : novel city
%Acc 1: correct trials

%% Voxel selection mask type
C.rs.rs_feature_mask = 'none';
disp(C.rs.rs_feature_mask);
 
%% All subjects; RS
subject_type = 'all subjects';
measure = 'MPS(pw)';
greco_report_ash(C,subject_type, measure);

%% Subjects showing greater T > N perf; RS
subject_type = 'T > N subjs';
measure = 'MPS(pw)';
greco_report_ash(C,subject_type, measure);

%% Subjects showing greater N > T perf; RS
subject_type = 'N > T subjs';
measure = 'MPS(pw)';
greco_report_ash(C,subject_type, measure);

%% Subjects with high d'; RS
subject_type = 'high perf subjs';
measure = 'MPS(pw)';
greco_report_ash(C,subject_type, measure);

%% Subjects with low d'; RS
subject_type = 'low perf subjs';
measure = 'MPS(pw)';
greco_report_ash(C,subject_type, measure);


% %% All subjects; mean Beta
% subject_type = 'all subjects';
% measure = 'mean Beta';
% greco_report_ash(C,subject_type, measure);
% 
% %% Subjects showing greater T > N perf; mean Beta
% subject_type = 'T > N subjs';
% measure = 'mean Beta';
% greco_report_ash(C,subject_type, measure);
% 
% %% Subjects showing greater N > T perf; mean Beta
% subject_type = 'N > T subjs';
% measure = 'mean Beta';
% greco_report_ash(C,subject_type, measure);
% 
% %% Subjects with high d'; mean Beta
% subject_type = 'high perf subjs';
% measure = 'mean Beta';
% greco_report_ash(C,subject_type, measure);
% 
% %% Subjects with low d'; mean Beta
% subject_type = 'low perf subjs';
% measure = 'mean Beta';
% greco_report_ash(C,subject_type, measure);