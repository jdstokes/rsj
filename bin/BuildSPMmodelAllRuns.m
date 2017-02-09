function BuildSPMmodelAllRuns(subj,C,modelID)
    
  
    switch C.spm.model_type
        %For running your basic/standard SPM model and Rissman style Single
        %Trial
        case {'Basic','STris'}
            
            ipDir = fullfile(C.dir.analysis,'specs', C.spm.modelName,subj);
            opDir = fullfile(C.dir.ana_models,modelID,subj);
            if ~exist(opDir,'dir')
                mkdir(opDir);
            else
                 return
                
            end
            
            RunModelEstimation(subj,C,ipDir,opDir);

        %Estimates a seperate model for each event
        case 'STmum'

                tt_all =  TT_greco(subj,C);
                tt = tt_all.spm;
                clear tt_all

                allTrials = [];

                for runNum = 1:length(tt)
                    allTrials = [allTrials,cell2mat(tt(runNum).EVENTNUM)];
                end
                clear tt

                for curEvent = allTrials
                   ipDir = fullfile(C.dir.analysis,'specs', C.spm.modelName,subj,['event_',num2str(curEvent)]);
                   opDir = fullfile(C.dir.ana_models,modelID,subj,['event_',num2str(curEvent)]);
                   if ~exist(opDir,'dir')
                       mkdir(opDir);
                   else
                       continue
                       
                   end
                   
                   
                   RunModelEstimation(subj,C,ipDir,opDir)
                end
        otherwise
            error('Incorrect model type');
                 
    end
end

function RunModelEstimation(subj,C,ipDir,opDir)
            matlabbatch = SetupModelEstimation(subj,C,ipDir,opDir);
            spm_jobman('initcfg')
            spm('defaults', 'FMRI');
            spm_jobman('serial', matlabbatch);
end
function [matlabbatch]=SetupModelEstimation(subj,C,ipDir,opDir)

%%% Setup input variables
dir_mask =C.dir.dat_mask;
maskType = C.masks.maskType;
tt_all =  TT_greco(subj,C);
numRuns = length(tt_all.numTrialsByRun);

dir_mri = C.dir.dat_mri;
spm_funcFold = C.spm.funcFold;
spm_funcFile = C.spm.funcFile;
spm_smooth = C.spm.smooth;
spm_motionFile = C.spm.motionFile;
spm_structFile = C.spm.structFile;

spm_hpf = C.spm.hpf;
spm_fir_length = C.spm.fir_length;
spm_fir_order = C.spm.fir_order;

spm_mask = C.spm.mask;
super_mask = C.spm.roi_mask_name;
spm_response_function = C.spm.response_function;
spm_movement_reg = C.spm.movement_reg;
spm_struct_reg = C.spm.struct_reg;
global_scaling = C.spm.global_scaling;


clear C

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
    


%%% Load function images
for curRun = 1:numRuns
matlabbatch{curRun}.spm.util.exp_frames.files = {fullfile(dir_mri,subj,[spm_funcFold,num2str(curRun)],[spm_smooth,spm_funcFile])};
matlabbatch{curRun}.spm.util.exp_frames.frames = Inf;  
end

%%% New SPM module
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
    matlabbatch{specNum}.spm.stats.fmri_spec.sess(curRun).multi = {fullfile(ipDir,[subj,'_','Run',...
                                                                    num2str(curRun), '.mat'])};    
    matlabbatch{specNum}.spm.stats.fmri_spec.sess(curRun).regress = struct('name', {}, 'val', {});
    
    
    
    
%% Nuisance covariates
    if spm_movement_reg && spm_struct_reg
        covariates = {
            fullfile(dir_mri,subj,[spm_funcFold,num2str(curRun)],spm_motionFile)
            fullfile(dir_mri,subj,[spm_funcFold,num2str(curRun)],spm_structFile)
        };
    elseif spm_movement_reg
        covariates = {fullfile(dir_mri,subj,[spm_funcFold,num2str(curRun)],spm_motionFile)};
    elseif spm_struct_reg
        covariates = {fullfile(dir_mri,subj,[spm_funcFold,num2str(curRun)],spm_structFile)};
    else
        covariates = {};
     end

    matlabbatch{specNum}.spm.stats.fmri_spec.sess(curRun).multi_reg = covariates;
    
    
%% High pass filter
    matlabbatch{specNum}.spm.stats.fmri_spec.sess(curRun).hpf = spm_hpf;  
end



%% Not sure what this does
matlabbatch{specNum}.spm.stats.fmri_spec.fact = struct('name', {}, 'levels', {});



%% Response function
switch spm_response_function
    case 'hrf'
        matlabbatch{specNum}.spm.stats.fmri_spec.bases.hrf.derivs = [0 0];
    case 'none'
        matlabbatch{specNum}.spm.stats.fmri_spec.bases.none = true;
    case 'fir'
        matlabbatch{specNum}.spm.stats.fmri_spec.bases.fir.length = spm_fir_length;
        matlabbatch{specNum}.spm.stats.fmri_spec.bases.fir.order = spm_fir_order;
    otherwise
        error('Incorrect response function');
end

matlabbatch{specNum}.spm.stats.fmri_spec.volt = 1;


%% Global scaling
matlabbatch{specNum}.spm.stats.fmri_spec.global = 'None';



%% SPM mask threshold
matlabbatch{specNum}.spm.stats.fmri_spec.mthresh = mask.thresh;


%% Apply structural mask to limit voxel inclusion
switch super_mask
    case 'super_mask_ash'
        matlabbatch{specNum}.spm.stats.fmri_spec.mask = {fullfile(dir_mask,maskType,subj,'super_mask_ash.nii')};
    case 'super_mask'
        matlabbatch{specNum}.spm.stats.fmri_spec.mask = {fullfile(dir_mask,maskType,subj,'super_mask.nii')};
    case 'none'
        matlabbatch{specNum}.spm.stats.fmri_spec.mask = {''};
    otherwise
        error('Incorrect super mask');
end


matlabbatch{specNum}.spm.stats.fmri_spec.cvi = 'AR(1)';

%Global scaling

if ~global_scaling
matlabbatch{specNum}.spm.stats.fmri_spec.global = 'None';
elseif global_scaling
 matlabbatch{specNum}.spm.stats.fmri_spec.global = 'Scaling';
end
    


%% 
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





                                            




