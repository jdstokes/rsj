close all;
%tt_code 0 : Same trials
%tt_code 1: Diff 1 trials
%tt_code 2: Diff 2 trial
%T: trained city
%M: morph city
%N : novel city
%Acc 1: correct trials


%% All subjects; RS
subject_type = 'all subjects';
measure = 'MPS(pw)';
greco_report(subject_type, measure);

%% Subjects showing greater T > N perf; RS
subject_type = 'T > N subjs';
measure = 'MPS(pw)';
greco_report(subject_type, measure);

%% Subjects showing greater N > T perf; RS
subject_type = 'N > T subjs';
measure = 'MPS(pw)';
greco_report(subject_type, measure);

%% Subjects with high d'; RS
subject_type = 'high perf subjs';
measure = 'MPS(pw)';
greco_report(subject_type, measure);

%% Subjects with low d'; RS
subject_type = 'low perf subjs';
measure = 'MPS(pw)';
greco_report(subject_type, measure);


%% All subjects; mean Beta
subject_type = 'all subjects';
measure = 'mean Beta';
greco_report(subject_type, measure);

%% Subjects showing greater T > N perf; mean Beta
subject_type = 'T > N subjs';
measure = 'mean Beta';
greco_report(subject_type, measure);

%% Subjects showing greater N > T perf; mean Beta
subject_type = 'N > T subjs';
measure = 'mean Beta';
greco_report(subject_type, measure);

%% Subjects with high d'; mean Beta
subject_type = 'high perf subjs';
measure = 'mean Beta';
greco_report(subject_type, measure);

%% Subjects with low d'; mean Beta
subject_type = 'low perf subjs';
measure = 'mean Beta';
greco_report(subject_type, measure);