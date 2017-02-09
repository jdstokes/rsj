function BuildSPMspecs(subj,C)
%Create model specs

modelName = C.spm.modelName;

tt_all =  TT_greco(subj,C);
tt = tt_all.spm;
clear tt_all


    switch modelName
        case{'STris_20'}
            for curRun = 1:length(tt)
                for tri = 1:length(tt(curRun).EVENTNUM)
                    S.names{tri} = ['Event_Run',num2str(curRun),'_Tri',num2str(tri)];
                end
                S.onsets = tt(curRun).ONSET;
                S.durations = tt(curRun).DUR;
                S.option = 'basic';
                S.curRun = curRun;
                
                SaveSpecs(C,subj,modelName,S);
                clear S
            end
        case{'STris_0'}
            for curRun = 1:length(tt)
                numTrials = length(tt(curRun).EVENTNUM);
                durations = num2cell(zeros(1,numTrials));
                for tri = 1:numTrials
                    S.names{tri} = ['Event_Run',num2str(curRun),'_Tri',num2str(tri)];
                end
                S.onsets = tt(curRun).ONSET;
                S.durations = durations;
                S.option = 'basic';
                S.curRun = curRun;
                
                SaveSpecs(C,subj,modelName,S);
                clear S durations numTrials
            end

          %%ST mum 
        case{'Basic_allv1_20'}
            for curRun = 1:length(tt)
                
                S.curRun = curRun;
                S.names = cell(1,1);
                S.names{1} = 'Cond_all';
                S.durations = cell(1,1);
                S.onsets = cell(1,1);
                S.onsets{1} = cell2mat(tt(curRun).ONSET);
                S.durations{1} = cell2mat(tt(curRun).DUR);
                S.option = 'basic';
                
                SaveSpecs(C,subj,modelName,S);
                clear S
            end
        case{'Basic_allv1_0'}
          for curRun = 1:length(tt)
                numTrials = length(tt(curRun).EVENTNUM);
                durations = zeros(1,numTrials);
                
                S.curRun = curRun;
                S.names = cell(1,1);
                S.names{1} = 'cond_all';
                S.durations = cell(1,1);
                S.onsets = cell(1,1);
                
                S.onsets{1} = cell2mat(tt(curRun).ONSET);
                S.durations{1} = durations;
                S.option = 'basic';
                
                SaveSpecs(C,subj,modelName,S);
                clear S
          end
          
           case{'Basic_allv2_20'}
            for curRun = 1:length(tt)
                numEvents = length(tt(curRun).EVENTNUM);
                onsets_all = [];
                onsets_null = [];
                dur_all = [];
                dur_null = [];
                
                for curEvent = 1:numEvents
                    
                    switch tt(curRun).TT_CODE{curEvent}; %Trial's condition code
                        case 99
                            onsets_null = [onsets_null tt(curRun).ONSET{curEvent}];
                            dur_null = [dur_null tt(curRun).DUR{curEvent}];
                        case {0,1,2}
                            onsets_all = [onsets_all tt(curRun).ONSET{curEvent}];
                            dur_all = [dur_all tt(curRun).DUR{curEvent}];
                        otherwise 
                            error('non specified condition');
                    end
                end
                

                S.names = {'Cond_all','Cond_null'};
                S.durations = {dur_all, dur_null};
                S.onsets = {onsets_all, onsets_null};
                S.curRun = curRun;
                S.option ='basic';
                
                SaveSpecs(C,subj,modelName,S);
                clear S
            end
           case{'Basic_allv2_0'}
            for curRun = 1:length(tt)
                numEvents = length(tt(curRun).EVENTNUM);
                onsets_all = [];
                onsets_null = [];
                dur_all = [];
                dur_null = [];
                
                for curEvent = 1:numEvents
                    
                    switch tt(curRun).TT_CODE{curEvent}; %Trial's condition code
                        case 99
                            onsets_null = [onsets_null tt(curRun).ONSET{curEvent}];
                            dur_null = [0 tt(curRun).DUR{curEvent}];
                        case {0,1,2}
                            onsets_all = [onsets_all tt(curRun).ONSET{curEvent}];
                            dur_all = [0 tt(curRun).DUR{curEvent}];
                        otherwise 
                            error('non specified condition');
                    end
                end
                

                S.names = {'Cond_all','Cond_null'};
                S.durations = {dur_all, dur_null};
                S.onsets = {onsets_all, onsets_null};
                S.curRun = curRun;
                S.option ='basic';
                
                SaveSpecs(C,subj,modelName,S);
                clear S
            end            
            
        case{'STmum_20'}
           allTrials = [];
           for curRun = 1:length(tt)
               allTrials = [allTrials,cell2mat(tt(curRun).EVENTNUM)];
           end
           clear curRun
           %%Output model for each trial
           for curEvent = allTrials
                              
               for curRun = 1:length(tt)
               
                  S.option = 'events';
                  S.names = {'Event_other'};
                  S.durations = {};
                  S.onsets = {};
                  S.curEvent = curEvent;
                  S.curRun = curRun;
                  
           
                   cnt = 0;
                   for curTrial = 1:length(tt(curRun).EVENTNUM)
                       if tt(curRun).EVENTNUM{curTrial} == curEvent
                            S.names{2} = ['Event_',num2str(curEvent)];
                            S.onsets{2} = tt(curRun).ONSET{curTrial};
                            S.durations{2} = tt(curRun).DUR{curTrial};
                       else
                            cnt = cnt + 1;
                            S.onsets{1}(cnt) = tt(curRun).ONSET{curTrial};
                            S.durations{1}(cnt) = tt(curRun).DUR{curTrial};
                       end
                   end
                   
                   SaveSpecs(C,subj,modelName,S);
                   clear S
               end
               
           end
        case{'STmum_0'}
           allTrials = [];
           for curRun = 1:length(tt)
               allTrials = [allTrials,cell2mat(tt(curRun).EVENTNUM)];
           end
           clear curRun
           %%Output model for each trial
           for curEvent = allTrials
                              
               for curRun = 1:length(tt)
               
                  S.option = 'events';
                  S.names = {'Event_other'};
                  S.durations = {};
                  S.onsets = {};
                  S.curEvent = curEvent;
                  S.curRun = curRun;
                  
           
                   cnt = 0;
                   for curTrial = 1:length(tt(curRun).EVENTNUM)
                       if tt(curRun).EVENTNUM{curTrial} == curEvent
                            S.names{2} = ['Event_',num2str(curEvent)];
                            S.onsets{2} = tt(curRun).ONSET{curTrial};
                            S.durations{2} = 0;
                       else
                            cnt = cnt + 1;
                            S.onsets{1}(cnt) = tt(curRun).ONSET{curTrial};
                            S.durations{1}(cnt) = 0;
                       end
                   end
                   
                   SaveSpecs(C,subj,modelName,S);
                   clear S
               end
               
           end
        case{'Basic_SD1D2_20'}
            for curRun = 1:length(tt) 
                numEvents = length(tt(curRun).EVENTNUM);
                
                onsets_same = [];
                onsets_diff1 = [];
                onsets_diff2 = [];
                onsets_null = [];
                dur_same = [];
                dur_diff1 = [];
                dur_diff2 = [];
                dur_null = [];
                
                
                
                for curEvent = 1:numEvents
                
                    switch tt(curRun).TT_CODE{curEvent}
                        case 0
                            onsets_same = [onsets_same tt(curRun).ONSET{curEvent}];
                            dur_same = [dur_same tt(curRun).DUR{curEvent}];
                        case 1
                            onsets_diff1 = [onsets_diff1 tt(curRun).ONSET{curEvent}];
                            dur_diff1 = [dur_diff1 tt(curRun).DUR{curEvent}];
                        case 2
                            onsets_diff2 = [onsets_diff2 tt(curRun).ONSET{curEvent}];
                            dur_diff2 = [dur_diff2 tt(curRun).DUR{curEvent}];
                        case 99
                            onsets_null = [onsets_null tt(curRun).ONSET{curEvent}];
                            dur_null = [dur_null tt(curRun).DUR{curEvent}];  
                    end

                end
                S.names = {'Cond_same','Cond_diff1','Cond_diff2','Cond_null'};
                S.durations = {dur_same, dur_diff1, dur_diff2, dur_null};
                S.onsets = {onsets_same,onsets_diff1,onsets_diff2, onsets_null};
                S.curRun = curRun;
                S.option = 'basic';
                
                SaveSpecs(C,subj,modelName,S);
                clear S 
            end
        case{'Basic_SD1D2_0'}
            for curRun = 1:length(tt) 
                numEvents = length(tt(curRun).EVENTNUM);
                
                onsets_same = [];
                onsets_diff1 = [];
                onsets_diff2 = [];
                onsets_null = [];
                dur_same = [];
                dur_diff1 = [];
                dur_diff2 = [];
                dur_null = [];
                
                for curEvent = 1:numEvents
                
                    switch tt(curRun).TT_CODE{curEvent}
                        case 0
                            onsets_same = [onsets_same tt(curRun).ONSET{curEvent}];
                            dur_same = [dur_same 0];
                        case 1
                            onsets_diff1 = [onsets_diff1 tt(curRun).ONSET{curEvent}];
                            dur_diff1 = [dur_diff1 0];
                        case 2
                            onsets_diff2 = [onsets_diff2 tt(curRun).ONSET{curEvent}];
                            dur_diff2 = [dur_diff2 0];
                        case 99
                            onsets_null = [onsets_null tt(curRun).ONSET{curEvent}];
                            dur_null = [dur_null 0];  
                    end

                end
                
                S.names = {'Cond_same','Cond_diff1','Cond_diff2','Cond_null'};
                S.durations = {dur_same, dur_diff1, dur_diff2, dur_null};
                S.onsets = {onsets_same,onsets_diff1,onsets_diff2, onsets_null};
                S.curRun = curRun;
                S.option = 'basic';
                
                SaveSpecs(C,subj,modelName,S);
                clear S
            end
      case{'Basic_TMN_20'}
            for curRun = 1:length(tt) 
                numEvents = length(tt(curRun).EVENTNUM);
                
                onsets_T = [];
                onsets_M = [];
                onsets_N = [];
                onsets_null = [];
                dur_T = [];
                dur_M = [];
                dur_N = [];
                dur_null = [];
                
                
                
                for curEvent = 1:numEvents
                
                    if tt(curRun).TT_CODE{curEvent} ==99
                         onsets_null = [onsets_null tt(curRun).ONSET{curEvent}];
                         dur_null = [dur_null tt(curRun).DUR{curEvent}];
                    else
                        switch tt(curRun).TT_CURTARGCITY{curEvent}{1}
                            case 'T'
                                onsets_T = [onsets_T tt(curRun).ONSET{curEvent}];
                                dur_T = [dur_T tt(curRun).DUR{curEvent}];
                            case 'M'
                                onsets_M = [onsets_M tt(curRun).ONSET{curEvent}];
                                dur_M = [dur_M tt(curRun).DUR{curEvent}];
                            case 'N'
                                onsets_N = [onsets_N tt(curRun).ONSET{curEvent}];
                                dur_N = [dur_N tt(curRun).DUR{curEvent}];
                            
                               
                        end
                    end

                end
                S.names = {'Cond_T','Cond_M','Cond_N','Cond_null'};
                S.durations = {dur_T, dur_M, dur_N, dur_null};
                S.onsets = {onsets_T,onsets_M,onsets_N, onsets_null};
                S.curRun = curRun;
                S.option = 'basic';
                
                SaveSpecs(C,subj,modelName,S);
                clear S 
            end
      case{'Basic_TMN_0'}
            for curRun = 1:length(tt)
                numEvents = length(tt(curRun).EVENTNUM);
                
                onsets_T = [];
                onsets_M = [];
                onsets_N = [];
                onsets_null = [];
                dur_T = [];
                dur_M = [];
                dur_N = [];
                dur_null = [];
                
                
                
                for curEvent = 1:numEvents
                    
                    if tt(curRun).TT_CODE{curEvent} ==99
                        onsets_null = [onsets_null tt(curRun).ONSET{curEvent}];
                        dur_null = [dur_null 0];
                    else
                        switch tt(curRun).TT_CURTARGCITY{curEvent}{1}
                            case 'T'
                                onsets_T = [onsets_T tt(curRun).ONSET{curEvent}];
                                dur_T = [dur_T 0];
                            case 'M'
                                onsets_M = [onsets_M tt(curRun).ONSET{curEvent}];
                                dur_M = [dur_M 0];
                            case 'N'
                                onsets_N = [onsets_N tt(curRun).ONSET{curEvent}];
                                dur_N = [dur_N 0];
                                
                                
                        end
                    end
                    
                end
                S.names = {'Cond_T','Cond_M','Cond_N','Cond_null'};
                S.durations = {dur_T, dur_M, dur_N, dur_null};
                S.onsets = {onsets_T,onsets_M,onsets_N, onsets_null};
                S.curRun = curRun;
                S.option = 'basic';
                
                SaveSpecs(C,subj,modelName,S);
                clear S
            end
        otherwise
            error([modelName,' does not exist']);
    end

end   
 
function SaveSpecs(C,subj,modelName,S)

    names = S.names;
    onsets = S.onsets;
    durations = S.durations;
    option = S.option;
    
    switch option
        case 'basic'
            curRun = S.curRun;
           if ~exist(fullfile(C.dir.analysis,'specs',modelName,subj),'dir')
                mkdir(fullfile(C.dir.analysis,'specs',modelName,subj));
            end
            save(fullfile(C.dir.analysis,'specs',modelName,subj,...
                [subj,'_Run',sprintf('%i',curRun)]),'names', 'onsets', 'durations')
            
        case 'events'
            curRun = S.curRun;
            curEvent = S.curEvent;
            
            if ~exist(fullfile(C.dir.analysis,'specs',modelName,subj,['event_',num2str(curEvent)]),'dir')
                mkdir(fullfile(C.dir.analysis,'specs',modelName,subj,['event_',num2str(curEvent)]));
            end
            save(fullfile(C.dir.analysis,'specs',modelName,subj,['event_',num2str(curEvent)],...
                [subj,'_Run',sprintf('%i',curRun)]),'names', 'onsets', 'durations');
    end
            
end
        
        
        

   

    

        
 
    
    



