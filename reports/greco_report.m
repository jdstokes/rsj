function greco_report(subject_type, measure)
% Output rsj report

%% Report index
% RS 
%   S D 
%   S D1 D2
% Mean Beta
%   S D 
%   S D1 D2

%% Configure
C = Study_greco;
% measure = 'MPS(pw)';
% subject_type = 'T > N subjs';

%stat mode
stat_mode = 'within';
%measure type
measure_func =1;

%ChangeSubject
 subjects= {'S1_A';'S2_B';'S3_A';'S4_A';'S5_A';'S6_A';'S7_A';'S8_B';
     'S9_A';'S10_B';'S11_B';'S12_B';'S13_B';'S14_B';'S15_B';'S16_A';
     'S21_B';'S22_B';'S23_B';'S24_A'};
switch subject_type 
    case 'all subjects'
        C.subjects.subjAll = subjects;
     
    case 'T > N subjs'
           C.subjects.subjAll = subject_filter(subjects,'t > n');
        
        
    case 'N > T subjs'
        C.subjects.subjAll = subject_filter(subjects,'n > t');

        
    case 'high perf subjs'
                C.subjects.subjAll = subject_filter(subjects,'high perf');

    case 'low perf subjs'
                C.subjects.subjAll = subject_filter(subjects,'low perf');

end
C.subjects.subj2inc =  ones(1,length(C.subjects.subjAll))==1;

%ChangeMeasure
switch measure
    case  'MPS(pw)'
        C.tt.score_type = 'rsz';
        C.tt.mode = 'rs_pair';
    case  'MPS(all)'
         C.tt.score_type = 'rsz';
         C.tt.mode ='rs_all';
    case  'mean Beta'
         C.tt.score_type = 'uni_m';
         C.tt.mode = 'uni';
    case  'MPS(pw runNorm)'
        C.tt.score_type = 'rsz_runNorm';
        C.tt.mode = 'rs_pair_runNorm';
end

            
%% Analysis 
CI_comp{1}.input{1}.var = {'tt_code'};
CI_comp{1}.input{1}.val = 0;
CI_comp{2}.input{1}.var = {'tt_code'};
CI_comp{2}.input{1}.val = 1;
CI_comp{3}.input{1}.var = {'tt_code'};
CI_comp{3}.input{1}.val = 2;
tts = Input2Str(CI_comp);
figure;
rsj_rsa_group(C,CI_comp,stat_mode,measure_func,tts);
title(['S D D1',' ',subject_type]);
clear CI_comp
%% Analysis 
CI_comp{1}.input{1}.var = {'tt_code'};
CI_comp{1}.input{1}.val = 0;
CI_comp{2}.input{1}.var = {'tt_code'};
CI_comp{2}.input{1}.val(1,1) = 1;
CI_comp{2}.input{1}.val(2,1) = 2;
tts = Input2Str(CI_comp);
figure;
rsj_rsa_group(C,CI_comp,stat_mode,measure_func,tts);
title(['S D1&2',' ',subject_type]);
clear CI_comp
%% Analysis 
CI_comp{1}.input{1}.var = {'tt_code'};
CI_comp{1}.input{1}.val = 0;
CI_comp{1}.input{2}.var = {'cityTargC'};
CI_comp{1}.input{2}.val = {'T'};

CI_comp{2}.input{1}.var = {'tt_code'};
CI_comp{2}.input{1}.val = 0;
CI_comp{2}.input{2}.var = {'cityTargC'};
CI_comp{2}.input{2}.val = {'M'};

CI_comp{3}.input{1}.var = {'tt_code'};
CI_comp{3}.input{1}.val = 0;
CI_comp{3}.input{2}.var = {'cityTargC'};
CI_comp{3}.input{2}.val = {'N'};

tts = Input2Str(CI_comp);
figure;
rsj_rsa_group(C,CI_comp,stat_mode,measure_func,tts);
title(['ST SM SN',' ',subject_type]);

clear CI_comp

%% Analysis 3
CI_comp{1}.input{1}.var = {'tt_code'};
CI_comp{1}.input{1}.val = 1;
CI_comp{1}.input{2}.var = {'cityTargC'};
CI_comp{1}.input{2}.val = {'T'};

CI_comp{2}.input{1}.var = {'tt_code'};
CI_comp{2}.input{1}.val = 1;
CI_comp{2}.input{2}.var = {'cityTargC'};
CI_comp{2}.input{2}.val = {'M'};

CI_comp{3}.input{1}.var = {'tt_code'};
CI_comp{3}.input{1}.val = 1;
CI_comp{3}.input{2}.var = {'cityTargC'};
CI_comp{3}.input{2}.val = {'N'};

tts = Input2Str(CI_comp);
figure;
rsj_rsa_group(C,CI_comp,stat_mode,measure_func,tts);
title(['D1T D1M D1N',' ',subject_type]);

clear CI_comp

%% Analysis 
CI_comp{1}.input{1}.var = {'tt_code'};
CI_comp{1}.input{1}.val = 0;
CI_comp{1}.input{2}.var = {'acc'};
CI_comp{1}.input{2}.val = 1;
CI_comp{2}.input{1}.var = {'tt_code'};
CI_comp{2}.input{1}.val = 1;
CI_comp{2}.input{2}.var = {'acc'};
CI_comp{2}.input{2}.val = 1;
CI_comp{3}.input{1}.var = {'tt_code'};
CI_comp{3}.input{1}.val = 2;
CI_comp{3}.input{2}.var = {'acc'};
CI_comp{3}.input{2}.val = 1;
tts = Input2Str(CI_comp);
figure;
rsj_rsa_group(C,CI_comp,stat_mode,measure_func,tts);
title(['S D D1',' correct only ',subject_type]);
clear CI_comp

%% Analysis 
CI_comp{1}.input{1}.var = {'tt_code'};
CI_comp{1}.input{1}.val = 0;
CI_comp{1}.input{2}.var = {'acc'};
CI_comp{1}.input{2}.val = 1;
CI_comp{2}.input{1}.var = {'tt_code'};
CI_comp{2}.input{1}.val(1,1) = 1;
CI_comp{2}.input{1}.val(2,1) = 2;
CI_comp{2}.input{2}.var = {'acc'};
CI_comp{2}.input{2}.val = 1;

tts = Input2Str(CI_comp);
figure;
rsj_rsa_group(C,CI_comp,stat_mode,measure_func,tts);
title(['S D12',' correct only ',subject_type]);
clear CI_comp

%% Analysis 
CI_comp{1}.input{1}.var = {'tt_code'};
CI_comp{1}.input{1}.val = 0;
CI_comp{1}.input{2}.var = {'cityTargC'};
CI_comp{1}.input{2}.val = {'T'};
CI_comp{1}.input{3}.var = {'acc'};
CI_comp{1}.input{3}.val = 1;

CI_comp{2}.input{1}.var = {'tt_code'};
CI_comp{2}.input{1}.val = 0;
CI_comp{2}.input{2}.var = {'cityTargC'};
CI_comp{2}.input{2}.val = {'M'};
CI_comp{2}.input{3}.var = {'acc'};
CI_comp{2}.input{3}.val = 1;

CI_comp{3}.input{1}.var = {'tt_code'};
CI_comp{3}.input{1}.val = 0;
CI_comp{3}.input{2}.var = {'cityTargC'};
CI_comp{3}.input{2}.val = {'N'};
CI_comp{3}.input{3}.var = {'acc'};
CI_comp{3}.input{3}.val = 1;

tts = Input2Str(CI_comp);
figure;
rsj_rsa_group(C,CI_comp,stat_mode,measure_func,tts);
title(['ST SM SN',' correct only ',subject_type]);
clear CI_comp

%% Analysis 3
CI_comp{1}.input{1}.var = {'tt_code'};
CI_comp{1}.input{1}.val = 1;
CI_comp{1}.input{2}.var = {'cityTargC'};
CI_comp{1}.input{2}.val = {'T'};
CI_comp{1}.input{3}.var = {'acc'};
CI_comp{1}.input{3}.val = 1;

CI_comp{2}.input{1}.var = {'tt_code'};
CI_comp{2}.input{1}.val = 1;
CI_comp{2}.input{2}.var = {'cityTargC'};
CI_comp{2}.input{2}.val = {'M'};
CI_comp{2}.input{3}.var = {'acc'};
CI_comp{2}.input{3}.val = 1;

CI_comp{3}.input{1}.var = {'tt_code'};
CI_comp{3}.input{1}.val = 1;
CI_comp{3}.input{2}.var = {'cityTargC'};
CI_comp{3}.input{2}.val = {'N'};
CI_comp{3}.input{3}.var = {'acc'};
CI_comp{3}.input{3}.val = 1;

tts = Input2Str(CI_comp);
figure;
rsj_rsa_group(C,CI_comp,stat_mode,measure_func,tts);
title(['D1T D1M D1N;',' correct only; ',subject_type]);

clear CI_comp
end



%% Local functions
function tts = Input2Str(comp)


for i = 1:length(comp)
    s = '';
    input=comp{i}.input;
for j = 1: length(input)
    if ~isempty(input{j})
        s = [s,input{j}.var{1}];
        if isnumeric(input{j}.val) || islogical(input{j}.val)
            s = [s,'_',num2str(input{j}.val)','_'];
        elseif iscell(input{j}.val)
            s = [s,'_', input{j}.val{:},'_'];
        end
    end
end
tts{i} = s(1:end-1);
end
end