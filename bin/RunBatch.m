function RunBatch(varargin)

%Batch script for the following modules:
modules_all  = {
    'Preprocess'% *** %
    'SmoothNII',% *** %
    'ConvertASHSmasks2NII',% *** %
    'CoregisterAndFixAffineMasks',% *** %
    
    'SegmentHires' % *** %
    'CreateStructNuis' % *** %
    
    
    'BuildSuperMask_ash'  % *** %
    'BuildSPMspecs' % *** %
    'BuildSPMmodelAllRuns' % *** %
    'Check_residual' % *** %
    
    
    
    'Maskbetas',
    'Calcrs',
    
    'CombineMasks'
    
    

    };


C = Study_greco2;% Load C
% C.subjects.subj2run= {'S16_A','S9_A'}; %Override subj2run
C.subjects.subj2run= C.subjects.subj2inc; %Override subj2run



%      s.modelName_all ={
%                 'Basic_allv1_0'
%                 'Basic_allv1_20'
%                 'Basic_allv2_0'
%                 'Basic_allv2_20'
%                 'Basic_SD1D2_0'
%                 'Basic_SD1D2_20'
%                 'STris_0'
%                 'STris_20'
%                 'STmum_0'
%                 'STmum_20'};
           
C.spm.modelName ='Basic_TMN_0'; 


modules = {'CombineMasks'}; 

batch_subjs(C,modules); % Run batch
end



 
function batch_subjs(C,modules)

if ~isempty(C.subjects.subj2run) && iscell(C.subjects.subj2run)
    for i = 1:length(C.subjects.subj2run)
        disp(C.subjects.subj2run{i});
        batch_multiple_modules(C.subjects.subj2run{i},C,modules)
    end
else
    
    error('subj2run not right dude');
end
end


function batch_multiple_modules(subj,C,modules)
    for i = 1:length(modules)
        disp(modules{i});
        mod_func = str2func(modules{i});
        mod_func(subj,C)

    end
end



