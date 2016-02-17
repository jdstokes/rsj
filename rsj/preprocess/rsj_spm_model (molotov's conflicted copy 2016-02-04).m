function rsj_spm_model(subj,C)

spm_mask = GetValue(C,'spm_mask');

switch spm_mask
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
matlabbatch = Batch_model_trialest(subj,C);
if isempty(matlabbatch)
    return
end
spm_jobman('initcfg')
spm('defaults', 'FMRI');
spm_jobman('serial', matlabbatch);

end


function [matlabbatch]=Batch_model_trialest(subj,C)

numRuns = C.NumRuns;
dir_mri = GetValue(C,'dir_mri');
dir_analysis = GetValue(C,'dir_analysis');
spm_funcFold = GetValue(C,'spm_funcFold');
spm_funcFile = GetValue(C,'spm_funcFile');
spm_modelName = GetValue(C,'spm_modelName');
spm_smooth = GetValue(C,'spm_smooth');
spm_motionFile = GetValue(C,'spm_motionFile');
spm_hpf = GetValue(C,'spm_hpf');
spm_mask = GetValue(C,'spm_mask');
opDir = fullfile(dir_analysis, spm_modelName,subj,spm_smooth,['hpf',num2str(spm_hpf)],spm_mask);
if ~exist(opDir,'dir')
    mkdir(opDir);
else
    if exist(fullfile(opDir,'SPM.mat'),'file') >0
        disp([fullfile(opDir,'SPM.mat'),' already exists']);
        matlabbatch=[];
        return
    end
end
for curRun = 1:numRuns
matlabbatch{curRun}.spm.util.exp_frames.files = {fullfile(dir_mri,subj,[spm_funcFold,num2str(curRun)],[spm_smooth,spm_funcFile])};
matlabbatch{curRun}.spm.util.exp_frames.frames = Inf;  
end

%%%New SPM module
specNum=numRuns+1;
for curRun=1:numRuns
    matlabbatch{specNum}.spm.stats.fmri_spec.dir = {opDir};
    matlabbatch{specNum}.spm.stats.fmri_spec.timing.units = 'secs';
    matlabbatch{specNum}.spm.stats.fmri_spec.timing.RT = 3;
    matlabbatch{specNum}.spm.stats.fmri_spec.timing.fmri_t = 16;
    matlabbatch{specNum}.spm.stats.fmri_spec.timing.fmri_t0 = 1;
    matlabbatch{specNum}.spm.stats.fmri_spec.sess(curRun).scans(1) = cfg_dep;
    matlabbatch{specNum}.spm.stats.fmri_spec.sess(curRun).scans(1).tname = 'Scans';
    matlabbatch{specNum}.spm.stats.fmri_spec.sess(curRun).scans(1).tgt_spec{1}(1).name = 'filter';
    matlabbatch{specNum}.spm.stats.fmri_spec.sess(curRun).scans(1).tgt_spec{1}(1).value = 'image';
    matlabbatch{specNum}.spm.stats.fmri_spec.sess(curRun).scans(1).tgt_spec{1}(2).name = 'strtype';
    matlabbatch{specNum}.spm.stats.fmri_spec.sess(curRun).scans(1).tgt_spec{1}(2).value = 'e';
    matlabbatch{specNum}.spm.stats.fmri_spec.sess(curRun).scans(1).sname = 'Expand image frames: Expanded filename list.';
    matlabbatch{specNum}.spm.stats.fmri_spec.sess(curRun).scans(1).src_exbranch = substruct('.','val', '{}',{curRun}, '.','val', '{}',{1}, '.','val', '{}',{1});
    matlabbatch{specNum}.spm.stats.fmri_spec.sess(curRun).scans(1).src_output = substruct('.','files');
    matlabbatch{specNum}.spm.stats.fmri_spec.sess(curRun).cond = struct('name', {}, 'onset', {}, 'duration', {}, 'tmod', {}, 'pmod', {});
    matlabbatch{specNum}.spm.stats.fmri_spec.sess(curRun).multi = {fullfile(dir_analysis ,spm_modelName,subj,[subj,'_Run',...
                                                                    num2str(curRun), '.mat'])};    
    matlabbatch{specNum}.spm.stats.fmri_spec.sess(curRun).regress = struct('name', {}, 'val', {});
    matlabbatch{specNum}.spm.stats.fmri_spec.sess(curRun).multi_reg = {fullfile(dir_mri,subj,[spm_funcFold,num2str(curRun)],spm_motionFile)};
    matlabbatch{specNum}.spm.stats.fmri_spec.sess(curRun).hpf = spm_hpf;  
end


matlabbatch{specNum}.spm.stats.fmri_spec.fact = struct('name', {}, 'levels', {});
matlabbatch{specNum}.spm.stats.fmri_spec.bases.hrf.derivs = [0 0];
matlabbatch{specNum}.spm.stats.fmri_spec.volt = 1;
matlabbatch{specNum}.spm.stats.fmri_spec.global = 'None';
matlabbatch{specNum}.spm.stats.fmri_spec.mask = {''};
matlabbatch{specNum}.spm.stats.fmri_spec.cvi = 'AR(1)';

estNum=specNum+1;

matlabbatch{estNum}.spm.stats.fmri_est.spmmat(1) = cfg_dep;
matlabbatch{estNum}.spm.stats.fmri_est.spmmat(1).tname = 'Select SPM.mat';
matlabbatch{estNum}.spm.stats.fmri_est.spmmat(1).tgt_spec{1}(1).name = 'filter';
matlabbatch{estNum}.spm.stats.fmri_est.spmmat(1).tgt_spec{1}(1).value = 'mat';
matlabbatch{estNum}.spm.stats.fmri_est.spmmat(1).tgt_spec{1}(2).name = 'strtype';
matlabbatch{estNum}.spm.stats.fmri_est.spmmat(1).tgt_spec{1}(2).value = 'e';
matlabbatch{estNum}.spm.stats.fmri_est.spmmat(1).sname = 'fMRI model specification: SPM.mat File';
matlabbatch{estNum}.spm.stats.fmri_est.spmmat(1).src_exbranch = substruct('.','val', '{}',{numRuns+1}, '.','val', '{}',{1}, '.','val', '{}',{1});
matlabbatch{estNum}.spm.stats.fmri_est.spmmat(1).src_output = substruct('.','spmmat');
matlabbatch{estNum}.spm.stats.fmri_est.method.Classical = 1;
end

