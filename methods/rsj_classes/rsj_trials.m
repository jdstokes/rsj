classdef rsj_trials
    properties
        names
        names_rs
        menu
        menu_rs
        vals
    end
methods
    function tt = rsj_trials(C)
        behav= C.tt.tt_func{1}(C.subjects.subjAll{1},C);
        behav_rs = C.tt.tt_func{2}(C.subjects.subjAll{1},C);
        tt.names = fieldnames(behav);
        tt.names_rs = fieldnames(behav_rs);
        cnt = 0;
        for i1 = 1:length(tt.names)
            tt.vals.(tt.names{i1}) = unique(behav.(tt.names{i1}));
            if length(unique(behav.(tt.names{i1}))) <10
                cnt = cnt+1;
                tt.menu{cnt,1} = tt.names{i1};
            end
        end
        cnt = 0;
        for i1 = 1:length(tt.names_rs)
            tt.vals.(tt.names_rs{i1}) = unique(behav_rs.(tt.names_rs{i1}));
            if length(unique(behav_rs.(tt.names_rs{i1}))) <10
                cnt = cnt +1;
                tt.menu_rs{cnt,1} = tt.names_rs{cnt};
            end
        end
        
        tt.menu = [{'null'};tt.menu];
        tt.menu_rs = [{'null'};tt.menu_rs];
        
    end
end
end