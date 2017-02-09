function Build_rs_report
% Output rsj report
% close all

C = Study_greco2;
T = load(fullfile(C.dir.tables,'greco_tables.mat'));


% Settings
C.subjects.subj2run= {'S9_A','S16_A'};
C.scores.measure = 'MPS(pw)';
C.scores.rs_ID = 'r00000001';
C.scores.OL_type = 'none';
C.scores.score_type = 'uni_m';
C.scores.mode = 'uni';




foldpath = C.dir.dat_behav;

%stat mode
stat_mode = 'none';
%measure type
measure_func =1;

%regions
masks ={

    'ash_left_CA1.nii'
    'ash_left_CA3.nii'
    'ash_left_DG.nii'
    'ash_right_CA1.nii'
    'ash_right_CA3.nii'
    'ash_right_DG.nii'

    };
 
C.masks.mask2inc = zeros(1,length(C.masks.maskAll));
    for j = 1: length(masks)
        C.masks.mask2inc(strcmp(masks{j},C.masks.maskAll)) = 1;
    end
C.masks.mask2inc = logical(C.masks.mask2inc);


%% Analysis 


end

function ST_SD1D2
CI_comp{1}.input{1}.var = {'tt_code'};
CI_comp{1}.input{1}.val = 0;
CI_comp{2}.input{1}.var = {'tt_code'};
CI_comp{2}.input{1}.val = 1;
CI_comp{3}.input{1}.var = {'tt_code'};
CI_comp{3}.input{1}.val = 2;
tts = Input2Str(CI_comp);
figure('position',[333   261   961   622]);
GroupBarPlot(C,CI_comp,stat_mode,measure_func,tts,C.scores.rs_ID);
title(['S D1 D2']);
clear CI_comp

end

function BasicAll(C)
C.subjects.subj2run= {'S9_A','S16_A'};
C.scores.measure = 'MPS(pw)';
C.scores.rs_ID = 'r00000001';
C.scores.OL_type = 'none';
figure('position',[333   261   961   622]);
GroupBarPlot_BasicAll(C,,C.scores.rs_ID);
title(['']);
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