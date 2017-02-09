classdef Study_greco2 < Study 
    %%Study_greco2
    % Study name: 'greco'
    %   Properties:

    %   Load the following Info classes:
    %       InfoDir_greco
    %       InfoSubjects_greco
    %       InfoSPM_greco
    %       InfoMasks_greco
    
    
    properties

        spm %SPM fMRI analysis software specs
        outlier %Outlier removal specs
        masks %Mask information
        scores
    end
   
    methods 
        function s = Study_greco2
            
%%Study
            
            % Name of Study
            s.name = 'greco';  
            
            % WD

           if exist('/Volumes/jdstokes/Studies','dir')
                dir_wd = '/Volumes/jdstokes/Studies';
            elseif exist('/Users/jdstokes/Studies','dir')
                dir_wd = '/Users/jdstokes/Studies';
           elseif exist('/Volumes/Jared/Studies/')
                dir_wd = '/Volumes/Jared/Studies';

            else 
                error('no directory set');
            end
            %assign data, analysis, doc & report directories
            s.dir = InfoDir_greco(dir_wd,s.name);
            % subjects
            s.subjects = InfoSubjects_greco;
        

            %% Study_greco
            % SPM
            s.spm = InfoSPM_greco;
            % masks
            s.masks = InfoMasks_greco;
            
        end
    end
end
    
    



    
    
    
    
    
    
    
