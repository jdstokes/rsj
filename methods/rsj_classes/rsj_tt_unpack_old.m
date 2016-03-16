classdef rsj_tt_unpack_old
    properties
        names
        names_rs
        names_behav
        names_behav_scores
        menu
        menu_rs
        menu_behav
        vals
    end
methods
    function tt_unpack = rsj_tt_unpack(C)
        %Based off of first ssubject
        rs_pair = rsj_trial_type(C.subjects.subjAll{1},C,'rs_pair').Get_tt;
        rs_all = rsj_trial_type(C.subjects.subjAll{1},C,'rs_all').Get_tt;
        behav = rsj_trial_type(C.subjects.subjAll{1},C,'behav').Get_tt;
%         behav_scores = rsj_trial_type(C.subjects.subjAll{1},C,'behav_scores').Get_tt;
        
        tt_unpack.names = fieldnames(rs_pair);
        tt_unpack.names_rs = fieldnames(rs_all);
        tt_unpack.names_behav = fieldnames(behav);
%         tt_unpack.names_behav_scores = fieldnames(behav_scores);
        
        cnt = 0;
        for i1 = 1:length(tt_unpack.names)
            tt_unpack.vals.(tt_unpack.names{i1}) = unique(rs_pair.(tt_unpack.names{i1}));
            if length(unique(rs_pair.(tt_unpack.names{i1}))) <10
                cnt = cnt+1;
                tt_unpack.menu{cnt,1} = tt_unpack.names{i1};
            end
        end
        
        cnt = 0;
        for i1 = 1:length(tt_unpack.names_rs)
            tt_unpack.vals.(tt_unpack.names_rs{i1}) = unique(rs_all.(tt_unpack.names_rs{i1}));
            if length(unique(rs_all.(tt_unpack.names_rs{i1}))) <10
                cnt = cnt +1;
                tt_unpack.menu_rs{cnt,1} = tt_unpack.names_rs{i1};
            end
        end
        
        cnt = 0;
        for i1 = 4:length(tt_unpack.names_behav)
            tt_unpack.vals.(tt_unpack.names_behav{i1}) = unique(behav.(tt_unpack.names_behav{i1}));
            if length(unique(behav.(tt_unpack.names_behav{i1}))) <10
                cnt = cnt +1;
                tt_unpack.menu_behav{cnt,1} = tt_unpack.names_behav{i1};
            end
        end
        
        
        
        tt_unpack.menu = [{'null'};tt_unpack.menu];
        tt_unpack.menu_rs = [{'null'};tt_unpack.menu_rs];
        tt_unpack.menu_behav = [tt_unpack.menu_behav];
        
    end
end
end