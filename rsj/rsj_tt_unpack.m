classdef rsj_tt_unpack
    properties
        names
        names_rs
        menu
        menu_rs
        vals
    end
methods
    function tt_unpack = rsj_tt_unpack(C)
        
        behav = rsj_trial_type(C.subjects.subjAll{1},C,'rs_pair').Get_tt;
        behav_rs = rsj_trial_type(C.subjects.subjAll{1},C,'rs_all').Get_tt;
        
        tt_unpack.names = fieldnames(behav);
        tt_unpack.names_rs = fieldnames(behav_rs);
        
        cnt = 0;
        for i1 = 1:length(tt_unpack.names)
            tt_unpack.vals.(tt_unpack.names{i1}) = unique(behav.(tt_unpack.names{i1}));
            if length(unique(behav.(tt_unpack.names{i1}))) <10
                cnt = cnt+1;
                tt_unpack.menu{cnt,1} = tt_unpack.names{i1};
            end
        end
        
        cnt = 0;
        for i1 = 1:length(tt_unpack.names_rs)
            tt_unpack.vals.(tt_unpack.names_rs{i1}) = unique(behav_rs.(tt_unpack.names_rs{i1}));
            if length(unique(behav_rs.(tt_unpack.names_rs{i1}))) <10
                cnt = cnt +1;
                tt_unpack.menu_rs{cnt,1} = tt_unpack.names_rs{cnt};
            end
        end
        
        tt_unpack.menu = [{'null'};tt_unpack.menu];
        tt_unpack.menu_rs = [{'null'};tt_unpack.menu_rs];
        
    end
end
end