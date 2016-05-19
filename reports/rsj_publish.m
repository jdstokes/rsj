function rsj_publish(C)


main_output_dir = C.dir.dir_reports;
% Setup C variables
spm_modelName = GetValue(C,'spm_modelName');
spm_smooth = GetValue(C,'spm_smooth');
maskType = GetValue(C,'maskType');
ol_v_method = GetValue(C,'ol_v_method');
ol_v = GetValue(C,'ol_v');
spm_mask = GetValue(C,'spm_mask');
spm_hpf = GetValue(C,'spm_hpf');
feature_mask = GetValue(C,'rs_feature_mask');



pubopt = struct('format','pdf','showCode',false);
opDir = fullfile(main_output_dir,'fMRI',spm_modelName,['hpf',num2str(spm_hpf)],spm_mask...
    ,spm_smooth,maskType,'betas',feature_mask,'scores',...
    ['OLSv_method_',ol_v_method],['OLSv_',ol_v]);

if ~exist(opDir,'dir'),mkdir(opDir);end

pubopt.outputDir = opDir;
pubopt.codeToEvaluate = 'batch_report(C,feature_mask)';
publish('batch_report.m',pubopt);



