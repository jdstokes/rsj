classdef rsj_study < handle
    % rsj_study class
    %  Properties
%         name : string
%         dir : struct
%         spm : struct
%         tt : struct
%         rs : struct
%         ol : struct
%         masks : struct
%         subjects : struct
%         space : struct
    properties
        name
        dir
        spm
        tt
        rs
        ol
        masks
        subjects
        space

    end
    methods 
        function obj = rsj_study
           
        
        end
    end
    
    
    %Study specific methods
    methods
      %subjects
      function x = GetSubj(obj)
           x = obj.subjects.subjAll(obj.subjects.subj2inc);
      end
       
       function x = GetSubjsInd(obj) 
           x = find(obj.subjects.subj2inc);
       end
       
       function x = NumSubjs(obj)
           x = length(find(obj.subjects.subj2inc));
       end
       
       function x = NumSubjsAll(obj)
           x = length(obj.subjects.subjAll);
       end
      
       
       %masks
       function x = GetMasks(obj) 
           x = obj.masks.maskAll(obj.masks.mask2inc);
       end
        
        function x = GetMasksInd(obj) 
           x = find(obj.masks.mask2inc);
        end
        
        function x = NumMasks(obj)
            
            x = length(find(obj.masks.mask2inc));

        end
        function x = NumMasksAll(obj)
            
            x = length(obj.masks.maskAll);

        end
       
        
       function x = GetTrialsInd(obj) 
           x = 1:sum(obj.tt.tt_trials);
       end
       
       function x = NumRuns(obj) 
           x = size(obj.tt.tt_trials,2);
       end
        
       function ChangeTT(obj,val)
            obj.tt.tt_val = val;
       end
       function x = GetVarNames(obj)
           x = ['null';fieldnames(obj.tt.tt_func{obj.tt.tt_val}...
               (obj.subjects.subjAll{1},obj))];
   
       end
       function ChangeVar(obj,varName,value)
           propAll = fieldnames(obj);
           
           for i1 = 1:length(propAll)
               if isstruct(obj.(propAll{i1}))
                   varAll = fieldnames(obj.(propAll{i1}));
                   for i2 = 1:length(varAll)
                       if strcmp(varName,varAll{i2})
                           obj.(propAll{i1}).(varAll{i2}) = value;
                           return
                       end
                   end
               end
           end
           
           
            error(['valued not changed: ',varName,value]);
           
       end
       
       function value = GetValue(obj,varName)
           propAll = fieldnames(obj);
           
           for i1 = 1:length(propAll)
               if isstruct(obj.(propAll{i1}))
                   varAll = fieldnames(obj.(propAll{i1}));
                   for i2 = 1:length(varAll)
                       if any(strcmp(varName,varAll))
                           value = obj.(propAll{i1}).(varAll{strcmp(varName,varAll)});
                           return
                       end
                   end
               end
           end
       end
       
%        function MakeOver(obj,value,varName)
%            
%            if strcmp(varName,'spm_hpf')
%                value = []
%            
%            end
%        end
       

        
    end%methods
end%classdef