function Batch_rename
%% load C
C = Study_cw;


%% options
options.spm_smooth = {'s3ra'};
options.spm_mask = {'m8','m3','m1','m0'};
options.spm_hpf ={50,128};
 options.ol_v_method = {'mask'};
%   options.ol_v_method = {'none'};
%  options.ol_v = {'NO'};
 options.ol_v = {'IQRm', '2SDm', '3SDm'};
options.maskType = {'v1','v2'};
options.spm_modelName = {'standard_ST_mr'};

%%
    if exist('options','var')
    combs = allcombJ(options);
        for i = 1:size(combs,1)
            RunGroup(C,fieldnames(options),combs(i,:))
        end
        
    else
        RS_batch(C)
    end

end


%% Group analysis batch
function RunGroup(C,varNames,mode)

 for i = 1:length(varNames)
   ChangeVar(C,varNames{i},mode{i});
 end
 
 try
 MoveRsbetas(C);
 end

end

 






    

    











