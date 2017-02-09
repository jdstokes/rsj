classdef InfoSubjects_greco < InfoSubjects
    properties
    end
    
    methods
        function s = InfoSubjects_greco
                    

              s.subjAll = {'S1_A','S2_B','S3_A','S4_A','S5_A','S6_A',...
                  'S7_A','S8_B','S9_A','S10_B','S11_B','S12_B','S13_B',...
                  'S14_B','S15_B','S16_A','S21_B','S22_B','S23_B',...
                  'S24_A','S25_A','S26_B','S27_A'};
              s.subj2omitt = {'S25_A','S26_B','S27_A'};
              
              
              %Calc subj2inc
              s.subj2inc  = s.subjAll;
              removeIndex = cellfun(@(x,y) find(strcmp(x,y)),s.subj2omitt,...
                  repmat({s.subjAll},1,3),'UniformOutput',false);
              removeIndex = cell2mat(removeIndex);
              s.subj2inc(removeIndex) = [];
              
        end
        
        
    end
    
    
end