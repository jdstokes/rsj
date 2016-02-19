function index = rsj_rsa_get_index(ts,behav,C)

vars.F = fieldnames(behav);%Get fields
vars.I = fieldnames(ts);%Get fields


switch C.tt.mode
    case 'rs_pair'
        inds = BuildIndex(NumTrials(C));
        id = nchoosek(1:NumTrials(C),2);
        ind_pair = abs(id(:,1) - id(:,2)) ==1;
        index = logical(inds(id(:,2)).*ind_pair);
    case 'rs_all'
        numPairs = nchoosek(NumTrials(C),2);
        inds = BuildIndex(numPairs);
        id = nchoosek(1:NumTrials(C),2);
        ind_non_pair = abs(id(:,1) - id(:,2)) ~=1;
        index = logical(inds.*ind_non_pair);
    case 'uni'
        inds = BuildIndex(NumTrials(C));
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
                        behav
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
