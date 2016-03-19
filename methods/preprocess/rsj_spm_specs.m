    function rsj_spm_specs(subj,C)
%Create model specs



modelNames = {'standard_ST_super_mask'}; %standard_CW_perf standard_ST_mr standard_ST_mr_byRun


tt_all =  TT_greco(subj,C);
tt = tt_all.spm;



for curModel=1:length(modelNames)
    
    switch modelNames{curModel}
        case{'standard_ST_mr','standard_ST_mr_super_mask','standard_ST_super_mask'}
            
            
            for run = 1:length(tt)
                for tri = 1:length(tt(run).EVENTNUM)
                    names{tri} = ['Run',num2str(run),'_Tri',num2str(tri)];
                end
                
                
                onsets = tt(run).ONSET;
                durations = tt(run).DUR;
                
                if ~exist(fullfile(C.dir.dir_analysis,modelNames{curModel},subj),'dir')
                    mkdir(fullfile(C.dir.dir_analysis,modelNames{curModel},subj));
                end
                save(fullfile(C.dir.dir_analysis,modelNames{curModel},subj,[subj,'_Run',sprintf('%i',run)]),'names', 'onsets', 'durations')

            end
            
               
      
            
%         case{'standard_ST_mr_super_mask'}
%   
%             for run = 1:length(tt)
%                 for tri = 1:length(tt(run).EVENTNUM)
%                     names{tri} = ['Run',num2str(run),'_Tri',num2str(tri)];
%                 end
%                 
%                 
%                 onsets = tt(run).ONSET;
%                 durations = tt(run).DUR;
%                 
%                 if ~exist(fullfile(C.dir.dir_analysis,modelNames{curModel},subj),'dir')
%                     mkdir(fullfile(C.dir.dir_analysis,modelNames{curModel},subj));
%                 end
%                 save(fullfile(C.dir.dir_analysis,modelNames{curModel},subj,[subj,'_Run',sprintf('%i',run)]),'names', 'onsets', 'durations')
%                 
%             end
            
          case{'standard_ST_mr_byRun_fir'}
  
              names = {'fir_trial'};

              for run = 1:length(tt)
%                   for tri = 1:length(tt(run).EVENTNUM)
%                   end
                  
                  
                  onsets = {cell2mat(tt(run).ONSET)};
                  durations = {zeros(size(tt(run).ONSET))};
                  
                  if ~exist(fullfile(C.dir.dir_analysis,'standard_ST_mr_byRun_fir',subj),'dir')
                      mkdir(fullfile(C.dir.dir_analysis,'standard_ST_mr_byRun_fir',subj));
                  end
                  save(fullfile(C.dir.dir_analysis,'standard_ST_mr_byRun_fir',subj,[subj,'_Run',sprintf('%i',run)]),'names', 'onsets', 'durations')
                  
              end
            
        case{'standard_CW_perf'}
            
            
            for run = 1:length(tt)
                
                check_ind=~cellfun('isempty',tt(run).ONSET);
                if any(check_ind ~= [1 1 1 1])
                    disp(['missing: ',subj,' ',num2str(run)])
                end
                names = tt(run).TT_MAIN_PERF(check_ind);
                onsets = tt(run).ONSET(check_ind);
                durations = tt(run).DUR(check_ind);
                
                if ~exist(fullfile(C.dir.dir_analysis,'specs',modelNames{curModel},subj),'dir')
                    mkdir(fullfile(C.dir.dir_analysis,'specs',modelNames{curModel},subj));
                end
                save(fullfile(C.dir.dir_analysis,'specs',modelNames{curModel},subj,[subj,'_Run',sprintf('%i',run)]),'names', 'onsets', 'durations')

            end
       case{'standard_CW_perf_param'}
            
            
            for run = 1:length(tt)
                
               
                check_ind=~cellfun('isempty',tt(run).ONSET);
                names = tt(run).TT_MAIN(check_ind);
                onsets = tt(run).ONSET(check_ind);
                durations = tt(run).DUR(check_ind);
                pmod = tt(run).PMOD_ERROR(check_ind);
                
                if ~exist(fullfile(C.dir.dir_analysis,'specs',modelNames{curModel},subj),'dir')
                    mkdir(fullfile(C.dir.dir_analysis,'specs',modelNames{curModel},subj));
                end
                save(fullfile(C.dir.dir_analysis,'specs',modelNames{curModel},subj,[subj,'_Run',sprintf('%i',run)]),'names', 'onsets', 'durations','pmod')
                    clear check_ind names onsets durations pmod
            end
    end
end
end

   

    

        
 
    
    



