function rsj_spm_smooth(subj,C)


    matlabbatch = Batch_smooth(subj,C);
    
    spm_jobman('initcfg')
    spm('defaults', 'FMRI');
    spm_jobman('serial', matlabbatch);
end



function [matlabbatch]=Batch_smooth(subj,C)

numRuns = C.NumRuns;
dir_mri = GetValue(C,'dir_mri');
spm_funcFold = GetValue(C,'spm_funcFold');
spm_funcFile = ['ra', GetValue(C,'spm_funcFile')];
spm_smooth = GetValue(C,'spm_smooth');

switch spm_smooth
    case 's3ra'
        smooth_width = [3,3,3];
        smooth_prefix = 's3';
    case 's2ra'
        smooth_width = [2,2,2];
        smooth_prefix = 's2';
    case 's1ra'
        smooth_width = [1,1,1];
        smooth_prefix = 's1';
    otherwise
        error('bad spm_smooth')
end
for curRun = 1:numRuns
matlabbatch{curRun}.spm.util.exp_frames.files = {fullfile(dir_mri,subj,[spm_funcFold,num2str(curRun)],spm_funcFile)};
matlabbatch{curRun}.spm.util.exp_frames.frames = Inf;
end
for curRun = 1:numRuns
matlabbatch{numRuns+1 }.spm.spatial.smooth.data(curRun) = cfg_dep('Expand image frames: Expanded filename list.', substruct('.','val', '{}',{curRun}, '.','val', '{}',{1}, '.','val', '{}',{1}), substruct('.','files'));
end

matlabbatch{numRuns+1}.spm.spatial.smooth.fwhm = smooth_width;
matlabbatch{numRuns+1}.spm.spatial.smooth.dtype = 0;
matlabbatch{numRuns+1}.spm.spatial.smooth.im = 0;
matlabbatch{numRuns+1}.spm.spatial.smooth.prefix = smooth_prefix;
end
