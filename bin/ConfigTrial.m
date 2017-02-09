function T = ConfigTrial(behav,input)


vars = fieldnames(behav);

for i = 1:length(input)
    
    if ~ any(strcmp(input{i}.var,vars))
        error('bad var name');
    else
        all_values = unique(behav.(input{i}.var{1}));
        if iscell(behav.(input{i}.var{1}))
            for ii = 1:length(input{i}.val)
                if ~any(strcmp(input{i}.val(ii),all_values))
                    error('bad val name');
                end
            end
            
            T.(input{i}.var{1}) =  input{i}.val;
            
        elseif isnumeric(behav.(input{i}.var{1})) || islogical(behav.(input{i}.var{1}))
            for ii = 1:length(input{i}.val)
                if ~any(input{i}.val(ii) == all_values)
                    error('bad val name');
                end
            end
            if exist('T','var') && isfield(T,input{i}.var{1})
            T.(input{i}.var{1})(end+1) =  input{i}.val;
            else
            T.(input{i}.var{1}) =  input{i}.val;
            end
            
        else
            error('cannot process variable (neither cell or double)');
        end
    end
end
