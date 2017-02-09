classdef BehavData
    properties
        id
        ss 
        mode
    end

 methods
     function B = BehavData(id,ss,mode)
            B.id = id;
            B.ss  = ss;
            B.mode = mode;
        end
        
        function I = GetIndices(B)
              I= SelectType(B,SelectStudy(B));
        end
        
        function I_all = SelectStudy(B)
             switch B.ss.name
                case 'greco'
                    I_all = TT_greco(B.id,B.ss);
                case 'cw'
                    I_all = TT_cw(B.id,B.ss);
                case 'ce'
                    I_all = TT_ce(B.id,B.ss);   
             end
        end
        
        function I = SelectType(B,tt_all)
            switch B.mode
                case 'rs_pair'
                    I = tt_all.rs_pair;
                case 'rs_pair_runNorm'
                    I = tt_all.rs_pair;
                case 'uni'
                    I = tt_all.rs_pair;
                case 'rs_all'
                    I = tt_all.rs_all;
                case 'spm'
                    I = tt_all.spm;
                case 'behav'
                    I = tt_all.behav;
                case 'behav_scores';
                    I = tt_all.behav_xtra_scores;
            end
        end
        
 end
end