% List of open inputs
nrun = X; % enter the number of runs here
jobfile = {'/Users/jdstokes/repos/projects/rsj/methods/preprocess/rsj_spm_segment_job.m'};
jobs = repmat(jobfile, 1, nrun);
inputs = cell(0, nrun);
for crun = 1:nrun
end
spm('defaults', 'FMRI');
spm_jobman('run', jobs, inputs{:});
