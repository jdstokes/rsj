function rsj_spm_model_byRunSPM12(subj,C)





spm_mask_val = GetValue(C,'spm_mask');
switch spm_mask_val
    case 'm8'
        mask.thresh = 0.8;
    case 'm3'
        mask.thresh = 0.3;
    case 'm1' 
        mask.thresh = .1;
    case 'm0' 
        mask.thresh = -Inf;
end
save('/Users/jdstokes/Documents/MATLAB/my_spm.mat','mask');
spm_my_defaults;


tt_all =  TT_greco(subj,C);
numRuns = length(tt_all.numTrialsByRun);



for runNum = 1:numRuns
matlabbatch = Batch_model_trialest(subj,C,runNum);
spm_jobman('initcfg')
spm('defaults', 'FMRI');
spm_jobman('serial', matlabbatch);
end

end


function [matlabbatch]=Batch_model_trialest(subj,C,runNum)


dir_mri = GetValue(C,'dir_mri');
dir_analysis = GetValue(C,'dir_analysis');
spm_funcFold = GetValue(C,'spm_funcFold');
spm_funcFile = GetValue(C,'spm_funcFile');
spm_modelName = GetValue(C,'spm_modelName');
spm_smooth = GetValue(C,'spm_smooth');
spm_motionFile = GetValue(C,'spm_motionFile');
spm_hpf = GetValue(C,'spm_hpf');
spm_mask = GetValue(C,'spm_mask');

opDir = fullfile(dir_analysis, spm_modelName,subj,spm_smooth,['hpf',num2str(spm_hpf)],spm_mask,['run',num2str(runNum)]);

% if ~exist(opDir,'dir')
%     mkdir(opDir);
% else
%     if exist(fullfile(opDir,'SPM.mat'),'file') >0
%         disp([fullfile(opDir,'SPM.mat'),' already exists']);
%         return
%     end
% end


matlabbatch{1}.spm.util.exp_frames.files = {fullfile(dir_mri,subj,[spm_funcFold,num2str(runNum)],[spm_smooth,spm_funcFile])};
matlabbatch{1}.spm.util.exp_frames.frames = Inf;  



    matlabbatch{2}.spm.stats.fmri_spec.dir = {opDir};
    matlabbatch{2}.spm.stats.fmri_spec.timing.units = 'secs';
    matlabbatch{2}.spm.stats.fmri_spec.timing.RT = 3;
    matlabbatch{2}.spm.stats.fmri_spec.timing.fmri_t = 16;
    matlabbatch{2}.spm.stats.fmri_spec.timing.fmri_t0 = 1;
    matlabbatch{2}.spm.stats.fmri_spec.sess(1).scans(1) = cfg_dep;
    matlabbatch{2}.spm.stats.fmri_spec.sess(1).scans(1).tname = 'Scans';
    matlabbatch{2}.spm.stats.fmri_spec.sess(1).scans(1).tgt_spec{1}(1).name = 'filter';
    matlabbatch{2}.spm.stats.fmri_spec.sess(1).scans(1).tgt_spec{1}(1).value = 'image';
    matlabbatch{2}.spm.stats.fmri_spec.sess(1).scans(1).tgt_spec{1}(2).name = 'strtype';
    matlabbatch{2}.spm.stats.fmri_spec.sess(1).scans(1).tgt_spec{1}(2).value = 'e';
    matlabbatch{2}.spm.stats.fmri_spec.sess(1).scans(1).sname = 'Expand image frames: Expanded filename list.';
    matlabbatch{2}.spm.stats.fmri_spec.sess(1).scans(1).src_exbranch = substruct('.','val', '{}',{1}, '.','val', '{}',{1}, '.','val', '{}',{1});
    matlabbatch{2}.spm.stats.fmri_spec.sess(1).scans(1).src_output = substruct('.','files');
    matlabbatch{2}.spm.stats.fmri_spec.sess(1).cond = struct('name', {}, 'onset', {}, 'duration', {}, 'tmod', {}, 'pmod', {});
    matlabbatch{2}.spm.stats.fmri_spec.sess(1).multi = {fullfile(dir_analysis ,spm_modelName,subj,[subj,'_Run',...
                                                                    num2str(runNum), '.mat'])};    
    matlabbatch{2}.spm.stats.fmri_spec.sess(1).regress = struct('name', {}, 'val', {});
    matlabbatch{2}.spm.stats.fmri_spec.sess(1).multi_reg = {fullfile(dir_mri,subj,[spm_funcFold,num2str(runNum)],spm_motionFile)};
    matlabbatch{2}.spm.stats.fmri_spec.sess(1).hpf = spm_hpf;  



matlabbatch{2}.spm.stats.fmri_spec.fact = struct('name', {}, 'levels', {});
matlabbatch{2}.spm.stats.fmri_spec.bases.hrf.derivs = [0 0];
matlabbatch{2}.spm.stats.fmri_spec.volt = 1;
matlabbatch{2}.spm.stats.fmri_spec.global = 'None';
matlabbatch{2}.spm.stats.fmri_spec.mask = {''};
matlabbatch{2}.spm.stats.fmri_spec.cvi = 'AR(1)';


matlabbatch{3}.spm.stats.fmri_est.spmmat(1) = cfg_dep;
matlabbatch{3}.spm.stats.fmri_est.spmmat(1).tname = 'Select SPM.mat';
matlabbatch{3}.spm.stats.fmri_est.spmmat(1).tgt_spec{1}(1).name = 'filter';
matlabbatch{3}.spm.stats.fmri_est.spmmat(1).tgt_spec{1}(1).value = 'mat';
matlabbatch{3}.spm.stats.fmri_est.spmmat(1).tgt_spec{1}(2).name = 'strtype';
matlabbatch{3}.spm.stats.fmri_est.spmmat(1).tgt_spec{1}(2).value = 'e';
matlabbatch{3}.spm.stats.fmri_est.spmmat(1).sname = 'fMRI model specification: SPM.mat File';
matlabbatch{3}.spm.stats.fmri_est.spmmat(1).src_exbranch = substruct('.','val', '{}',{2}, '.','val', '{}',{1}, '.','val', '{}',{1});
matlabbatch{3}.spm.stats.fmri_est.spmmat(1).src_output = substruct('.','spmmat');
matlabbatch{3}.spm.stats.fmri_est.method.Classical = 1;
end

