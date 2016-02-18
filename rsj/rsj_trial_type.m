classdef rsj_trial_type
    properties
        id
        ss 
        mode
    end

 methods
        function T = rsj_trial_type(id,ss,mode)
            T.id = id;
            T.ss  = ss;
            T.mode = mode;
        end
        
        function tt = Get_tt(T)
              tt= SelectType(T,SelectStudy(T));
        end
        
        function tt_all = SelectStudy(T)
             switch T.ss.name
                case 'greco'
                    tt_all = TT_greco(T.id,T.ss);
                case 'cw'
                    tt_all = TT_cw(T.id,T.ss);
                case 'ce'
                    tt_all = TT_ce(T.id,T.ss);   
             end
        end
        
        function tt = SelectType(T,tt_all)
            switch T.mode
                case 'rs_pair'
                    tt = tt_all.rs_pair;
                case 'uni'
                    tt = tt_all.rs_pair;
                case 'rs_all'
                    tt = tt_all.rs_all;
                case 'spm'
                    tt = tt_all.spm;
                case 'behav'
                    tt = tt_all.behav;
            end
        end
        
 end
end