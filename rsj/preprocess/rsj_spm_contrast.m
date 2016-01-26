function SPM_contrast(subj,C)


matlabbatch = Batch_contrast_param(subj,C);
spm_jobman('initcfg')
spm('defaults', 'FMRI');
spm_jobman('serial', matlabbatch);


end
function [matlabbatch]= Batch_contrast(subj,C)

dir_analysis = GetValue(C,'dir_analysis');
spm_modelName = GetValue(C,'spm_modelName');
spm_smooth = GetValue(C,'spm_smooth');
spm_hpf = GetValue(C,'spm_hpf');
spm_mask = GetValue(C,'spm_mask');
matDir = fullfile(dir_analysis, spm_modelName,subj,spm_smooth,['hpf',num2str(spm_hpf)],spm_mask);


%%load mat specs


matlabbatch{1}.spm.stats.con.spmmat = {fullfile(matDir,'SPM.mat')};
matlabbatch{1}.spm.stats.con.consess{1}.tcon.name = 'Cond1';
matlabbatch{1}.spm.stats.con.consess{1}.tcon.weights = 1;
matlabbatch{1}.spm.stats.con.consess{1}.tcon.sessrep = 'repl';
matlabbatch{1}.spm.stats.con.consess{2}.tcon.name = 'Cond2';
matlabbatch{1}.spm.stats.con.consess{2}.tcon.weights = [0 1];
matlabbatch{1}.spm.stats.con.consess{2}.tcon.sessrep = 'repl';
matlabbatch{1}.spm.stats.con.consess{3}.tcon.name = 'Cond3';
matlabbatch{1}.spm.stats.con.consess{3}.tcon.weights = [0 0 1];
matlabbatch{1}.spm.stats.con.consess{3}.tcon.sessrep = 'repl';
matlabbatch{1}.spm.stats.con.consess{4}.tcon.name = 'Cond4';
matlabbatch{1}.spm.stats.con.consess{4}.tcon.weights = [0 0 0 1];
matlabbatch{1}.spm.stats.con.consess{4}.tcon.sessrep = 'repl';
matlabbatch{1}.spm.stats.con.delete = 0;

end

function [matlabbatch]= Batch_contrast_param(subj,C)

dir_analysis = GetValue(C,'dir_analysis');
spm_modelName = GetValue(C,'spm_modelName');
spm_smooth = GetValue(C,'spm_smooth');
spm_hpf = GetValue(C,'spm_hpf');
spm_mask = GetValue(C,'spm_mask');


matDir = fullfile(dir_analysis, spm_modelName,subj,spm_smooth,['hpf',num2str(spm_hpf)],spm_mask);
if ~exist(matDir,'dir'),mkdir(matDir);end

matlabbatch{1}.spm.stats.con.spmmat = {fullfile(matDir,'SPM.mat')};
matlabbatch{1}.spm.stats.con.consess{1}.tcon.name = 'Cond1';
matlabbatch{1}.spm.stats.con.consess{1}.tcon.weights = 1;
matlabbatch{1}.spm.stats.con.consess{1}.tcon.sessrep = 'repl';
matlabbatch{1}.spm.stats.con.consess{2}.tcon.name = 'Cond1p';
matlabbatch{1}.spm.stats.con.consess{2}.tcon.weights = [0 1];
matlabbatch{1}.spm.stats.con.consess{2}.tcon.sessrep = 'repl';
matlabbatch{1}.spm.stats.con.consess{3}.tcon.name = 'Cond2';
matlabbatch{1}.spm.stats.con.consess{3}.tcon.weights = [0 0 1];
matlabbatch{1}.spm.stats.con.consess{3}.tcon.sessrep = 'repl';
matlabbatch{1}.spm.stats.con.consess{4}.tcon.name = 'Cond2p';
matlabbatch{1}.spm.stats.con.consess{4}.tcon.weights = [0 0 0 1];
matlabbatch{1}.spm.stats.con.consess{4}.tcon.sessrep = 'repl';
matlabbatch{1}.spm.stats.con.consess{5}.tcon.name = 'Cond3';
matlabbatch{1}.spm.stats.con.consess{5}.tcon.weights = [0 0 0 0 1];
matlabbatch{1}.spm.stats.con.consess{5}.tcon.sessrep = 'repl';
matlabbatch{1}.spm.stats.con.consess{6}.tcon.name = 'Cond3p';
matlabbatch{1}.spm.stats.con.consess{6}.tcon.weights = [0 0 0 0 0 1];
matlabbatch{1}.spm.stats.con.consess{6}.tcon.sessrep = 'repl';
matlabbatch{1}.spm.stats.con.consess{7}.tcon.name = 'Cond4';
matlabbatch{1}.spm.stats.con.consess{7}.tcon.weights = [0 0 0 0 0 0 1];
matlabbatch{1}.spm.stats.con.consess{7}.tcon.sessrep = 'repl';
matlabbatch{1}.spm.stats.con.consess{8}.tcon.name = 'Cond4p';
matlabbatch{1}.spm.stats.con.consess{8}.tcon.weights = [0 0 0 0 0 0 0 1];
matlabbatch{1}.spm.stats.con.consess{8}.tcon.sessrep = 'repl';
matlabbatch{1}.spm.stats.con.delete = 0;

end
