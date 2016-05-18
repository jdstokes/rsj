%% Batch publish results
clear all
close all

C = Study_greco;

main_output_dir = '/Users/jdstokes/Dropbox/dGR_reports/analyses';

% VST = {'none', 'Voxel_selection_anova1_effect','Voxel_selection_anova1_noeffect',...
%     'Voxel_selection_anova2_effect','Voxel_selection_anova2_noeffect'};

VST = {'Voxel_selection_anova2_noeffect'};


for i = 1:length(VST)

rs_feature_mask = VST{i};
pubopt = struct('format','pdf','showCode',false);
opDir = fullfile(main_output_dir,'fMRI','rsa_meanbeta',rs_feature_mask);
if ~exist(opDir,'dir'),mkdir(opDir);end
pubopt.outputDir = opDir;
pubopt.codeToEvaluate = 'batch_report(C,rs_feature_mask)';
publish('batch_report.m',pubopt);




end