function index = GetCondIndex(ts,behav,C)

vars.F = fieldnames(behav);%Get fields
vars.I = fieldnames(ts);%Get fields
numTrials = length(behav.(vars.F{1}));

switch C.scores.mode
    case 'rs_pair'
        inds = BuildIndex(numTrials);
        id = nchoosek(1:numTrials,2);
        ind_pair = abs(id(:,1) - id(:,2)) ==1;
        index = logical(inds(id(:,2)).*ind_pair);
    case 'rs_all'
        inds = BuildIndex(numTrials);
% %         id = nchoosek(1:numTrials,2);
%         ind_non_pair = abs(id(:,1) - id(:,2)) ~=1;
        index = logical(inds.*behav.ind_non_pair);
    case 'uni'
        inds = BuildIndex(numTrials);
        index = logical(inds);
    case 'rs_pair_runNorm'
        inds = BuildIndex(numTrials);
        index = logical(inds);
    otherwise
        error('incorrect mode');
        
end



    function indsF = BuildIndex(indlen)
        inds_all{1} = ones(indlen,1);
        for i = 1:length(vars.I)
            for ii = 1:length(ts.(vars.I{i}))
                if ~isempty(ts.(vars.I{i}))
                    if iscell(behav.(vars.I{i}))
                      
                        inds_all{i}(1:indlen,ii)= strcmp(ts.(vars.I{i})(ii),behav.(vars.I{i}));
                    end
                    if isnumeric(behav.(vars.I{i})) || islogical(behav.(vars.I{i}))
                        inds_all{i}(1:indlen,ii)= ts.(vars.I{i})(ii)==behav.(vars.I{i});
                    end
                end
            end
            inds_all{i} = any(inds_all{i},2);
        end
        clear i ii
        
        indsF = ones(indlen,1);
        for i = 1:length(inds_all)
            if ~isempty(inds_all{i})
                indsF = indsF .* inds_all{i};
            end
        end
        
        clear i inds_all
    end

end
