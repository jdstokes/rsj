classdef rsj_get_space
    
    
    properties
        struct
        combs_all
        combs_curr
        opts
        
    end
    
    methods
        function space = rsj_get_space(C)
            space.struct={'spm_modelName','spm_hpf','spm_mask','spm_smooth','maskType','betas','rs_feature_mask','scores','ol_v_method','ol_v'};
            space.combs_all = cell(size(space.struct));
            
            path2 = genpath(C.dir.dir_model);
            
            path2 = strrep(path2,[C.dir.dir_model],'');
            path_all = strsplit(path2,':');
            path_all = path_all(~cellfun('isempty',path_all));
            cnt =0;
            for i = 1: length(path_all)
                if size(strsplit(path_all{i},'/'),2) ==length(space.struct)
                    cnt = cnt+1;
                    space.combs_all(cnt,1:length(space.struct)) = strsplit(path_all{i},'/');
                end
            end
            
            space.combs_curr = space.combs_all;
            space.opts = GetAll(space);
            
        end
        function opts = GetAll(space)
            
             cnt = 0;
            for i = 1: length(space.struct)
                 if strcmp(space.struct{i},'scores')||strcmp(space.struct{i},'betas')
                    continue
                 end
                 cnt = cnt+1;
                  opts{cnt} = unique(space.combs_all(:,i));
            end
        end
        
        function [opts,newCombs]  = VarFilter(rspace,curCombs,C,var)
            
            
            val = GetValue(C,var);
            
            if isnumeric(val) || islogical(val)
                val = num2str(val);
            end
            varInd = ~cellfun('isempty',strfind(rspace.struct,var));
            space_ind = ~cellfun('isempty',strfind(curCombs(:,varInd),val));
            
            newCombs = curCombs(space_ind,:);
            cnt = 0;
            for i = 1: length(rspace.struct)
                if strcmp(rspace.struct{i},'scores')||strcmp(space.struct{i},'betas')
                    continue
                end
                cnt = cnt+1;
                opts{cnt} = unique(newCombs(:,i));
            end
        end
        
        function [opts,newCombs] = VarReset(rspace,curCombs,C,var)
            allCombs = C.space.combs_all;
            all_ind = ones(size(C.space.combs_all));
            cnt = 0;
            for i1 = 1: length(rspace.struct)
                if ~cellfun('isempty',strfind({'score'},rspace.struct{i1}))
                    continue
                elseif ~cellfun('isempty',strfind({var},rspace.struct{i1}))
                    cnt = cnt +1;
                    continue
                end
                var_opts = unique(curCombs(:,i1));
                var_ind = ones(size(allCombs,1),1);
                for i2 = 1: length(var_opts)
                    ind = ~cellfun('isempty',strfind(allCombs(:,i1),var_opts{i2}));
                    var_ind = var_ind.*ind;        
                end
                cnt = cnt +1;
                space_ind(:,cnt) = var_ind;
            end
           
                 cnt = 0;
            for i = 1: length(rspace.struct)
                if strcmp(rspace.struct{i},'scores')
                    continue
                end
                cnt = cnt+1;
                opts{cnt} = unique(newCombs(:,i));
            end
          
        end
            
            
            
            
    end

end



