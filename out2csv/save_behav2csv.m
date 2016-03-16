function save_behav2csv
C = Study_greco;
clear data T scores_subj
subjects = {
                 'S1_A' 
                 'S2_B' 
                 'S3_A'        
                'S4_A'
                'S5_A' 
                'S6_A'
                'S7_A'
                'S8_B'
                'S9_A'
                'S10_B'
                'S11_B'
                'S12_B'
                'S13_B'
                'S14_B'
                'S15_B'
                'S16_A' 
                'S21_B'
                'S22_B'
                'S23_B' % 99 trials
                'S24_A'
%                 'S25_A'
                 'S26_B'
%                  'S27_A'
                };


for i = 1:length(subjects)
    scores_subj=build_extra_scores_greco(subjects{i});
    clear tt_all
    data.subject{i,1} = subjects{i};
    S=strsplit(subjects{i},'_');
    data.group{i,1} = S{2};
    clear S
   score_names =fieldnames(scores_subj);
    for j = 1:length(score_names)
        
        data.(score_names{j})(i,1) = scores_subj.(score_names{j});
        
    end 
end

T = struct2table(data);

writetable(T,'scores_table_wide.csv');

end


  