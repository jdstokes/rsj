classdef rsj_tt_unpack
    properties
        names
        menu
        vals
    end
methods
    function tt_unpack = rsj_tt_unpack(C,mode)
        % mode: 'rs_pair', 'rs_all', 'behav', ' behav_scores'
        
        
        tt_struct = rsj_trial_type(C.subjects.subjAll{1},C,mode).Get_tt;
        tt_unpack.names = fieldnames(tt_struct);
        
        % only get variables with categorical responses. Set at at 
        % threshold of 10 which is super liberatl
        cnt = 0;
        for i1 = 1:length(tt_unpack.names)
            tt_unpack.vals.(tt_unpack.names{i1}) = unique(tt_struct.(tt_unpack.names{i1}));
            if length(unique(tt_struct.(tt_unpack.names{i1}))) <10
                cnt = cnt+1;
                tt_unpack.menu{cnt,1} = tt_unpack.names{i1};
            end
        end
        tt_unpack.menu = [{'null'};tt_unpack.menu];
    end
end
end