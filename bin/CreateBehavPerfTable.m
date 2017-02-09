function T = CreateBehavPerfTable
C = Study_greco2;
AllScores.subjects =  C.subjects.subj2inc';

scores ={
    'dprime_all'
    'dprime_d1'
    'dprime_d2'
    
    'dprime_all_T'
    'dprime_d1_T'
    'dprime_d2_T'
    
    'dprime_all_N'
    'dprime_d1_N'
    'dprime_d2_N'
    
    'same'
    'diff_all'
    'diff1'
    'diff2'
    
    'same_T'
    'diff_all_T'
    'diff1_T'
    'diff2_T'
    
    'same_N'
    'diff_all_N'
    'diff1_N'
    'diff2_N'
    
    'same_M'
    'diff1_M'
    'diff1_M_preT'
    'diff1_M_preN'
    
    'T_T'
    'T_M'
    'T_N'
    'M_M'
    'M_T'
    'M_N'
    'N_N'
    'N_M'
    'N_T'
    
    
    'C1_C1'
    'C1_C2'
    'C1_C3'
    'C2_C2'
    'C2_C1'
    'C2_C3'
    'C3_C3'
    'C3_C2'
    'C3_C1'
    
    
    'dprime_all_r1'
    'dprime_all_r2'
    'dprime_all_r3'
    'dprime_all_r4'
     
    'dprime_d1_r1'
    'dprime_d1_r2'
    'dprime_d1_r3'
    'dprime_d1_r4'
    
    
    'same_r1'
    'same_r2'
    'same_r3'
    'same_r4'
    
    'diff1_r1'
    'diff1_r2'
    'diff1_r3'
    'diff1_r4'
    
    'dprime_d1_T_r1'
    'dprime_d1_T_r2'
    'dprime_d1_T_r3'
    'dprime_d1_T_r4'
    
    'dprime_d1_M_r1'
    'dprime_d1_M_r2'
    'dprime_d1_M_r3'
    'dprime_d1_M_r4'
    
    'dprime_d1_N_r1'
    'dprime_d1_N_r2'
    'dprime_d1_N_r3'
    'dprime_d1_N_r4'
    
    'same_T_r1'
    'same_T_r2'
    'same_T_r3'
    'same_T_r4'
    
    'same_M_r1'
    'same_M_r2'
    'same_M_r3'
    'same_M_r4'
    
    'same_N_r1'
    'same_N_r2'
    'same_N_r3'
    'same_N_r4'
    
    'diff1_T_r1'
    'diff1_T_r2'
    'diff1_T_r3'
    'diff1_T_r4'
    
    'diff1_M_r1'
    'diff1_M_r2'
    'diff1_M_r3'
    'diff1_M_r4'
    
    'diff1_N_r1'
    'diff1_N_r2'
    'diff1_N_r3'
    'diff1_N_r4'
    

    };

for curS = 1:length(scores)
    
    switch scores{curS}
        
        case 'dprime_all'
            conds = {'corr all s','incorr all d'};
            AllScores.(scores{curS}) = GetDprime(C,conds);
        case 'dprime_d1'
            conds = {'corr all s','incorr all d1'};
            AllScores.(scores{curS}) = GetDprime(C,conds);
        case 'dprime_d2'
            conds = {'corr all s','incorr all d2'};
            AllScores.(scores{curS}) = GetDprime(C,conds);
            
        case 'dprime_all_T'
            conds = {'corr all s t_prepost','incorr all d t'};
            AllScores.(scores{curS}) = GetDprime(C,conds);
        case 'dprime_d1_T'
            conds = {'corr all s t','incorr all d1 t'};
            AllScores.(scores{curS}) = GetDprime(C,conds);
        case 'dprime_d2_T'
            conds = {'corr all s t','incorr all d2 t'};
            AllScores.(scores{curS}) = GetDprime(C,conds);
            
        case 'dprime_all_N'
            conds = {'corr all s n','incorr all d n'};
            AllScores.(scores{curS}) = GetDprime(C,conds);
        case 'dprime_d1_N'
            conds = {'corr all s n','incorr all d1 n'};
            AllScores.(scores{curS}) = GetDprime(C,conds);
        case 'dprime_d2_N'
            conds = {'corr all s n','incorr all d2 n'};
            AllScores.(scores{curS}) = GetDprime(C,conds);
            
        case 'same'
            score_name = 'corr all s';
            AllScores.(scores{curS}) = GetGrecoBehav(C,score_name);
        case 'diff_all'
            score_name = 'corr all d';
            AllScores.(scores{curS}) = GetGrecoBehav(C,score_name);
        case 'diff1'
            score_name = 'corr all d1';
            AllScores.(scores{curS}) = GetGrecoBehav(C,score_name);
        case 'diff2'
            score_name = 'corr all d2';
            AllScores.(scores{curS}) = GetGrecoBehav(C,score_name);
            
        case 'same_T'
            score_name = 'corr all s t';
            AllScores.(scores{curS}) = GetGrecoBehav(C,score_name);
        case 'diff_all_T'
            score_name = 'corr all d t';
            AllScores.(scores{curS}) = GetGrecoBehav(C,score_name);
        case 'diff1_T'
            score_name = 'corr all d1 t';
            AllScores.(scores{curS}) = GetGrecoBehav(C,score_name);
        case 'diff2_T'
            score_name = 'corr all d2 t';
            AllScores.(scores{curS}) = GetGrecoBehav(C,score_name);
            
        case 'same_N'
            score_name = 'corr all s n';
            AllScores.(scores{curS}) = GetGrecoBehav(C,score_name);
        case 'diff_all_N'
            score_name = 'corr all d n';
            AllScores.(scores{curS}) = GetGrecoBehav(C,score_name);
        case 'diff1_N'
            score_name = 'corr all d1 n';
            AllScores.(scores{curS}) = GetGrecoBehav(C,score_name);
        case 'diff2_N'
            score_name = 'corr all d2 n';
            AllScores.(scores{curS}) = GetGrecoBehav(C,score_name);
            
        case 'same_M'
            score_name = 'corr all s m';
            AllScores.(scores{curS}) = GetGrecoBehav(C,score_name);
            
        case 'diff1_M'
            score_name = 'corr all d1 m';
            AllScores.(scores{curS}) = GetGrecoBehav(C,score_name);
                       
        case 'diff1_M_preT'
            score_name = 'corr all d1 m tpre';
            AllScores.(scores{curS}) = GetGrecoBehav(C,score_name);
            
        case 'diff1_M_preN'
            score_name = 'corr all d1 m npre';
            AllScores.(scores{curS}) = GetGrecoBehav(C,score_name);
            
        case 'T_T'
            score_name = 'corr all s t';
            AllScores.(scores{curS}) = GetGrecoBehav(C,score_name);
        case 'T_M'
            score_name = 'corr all d1 tpre';
            AllScores.(scores{curS}) = GetGrecoBehav(C,score_name);
        case 'T_N'
            score_name = 'corr all d2 tpre';
            AllScores.(scores{curS}) = GetGrecoBehav(C,score_name);
        case 'M_M'
            score_name = 'corr all s m';
            AllScores.(scores{curS}) = GetGrecoBehav(C,score_name);
        case 'M_T'
            score_name = 'corr all d1 t';
            AllScores.(scores{curS}) = GetGrecoBehav(C,score_name);
        case 'M_N'
            score_name = 'corr all d1 n';
            AllScores.(scores{curS}) = GetGrecoBehav(C,score_name);
        case 'N_N'
            score_name = 'corr all s n';
            AllScores.(scores{curS}) = GetGrecoBehav(C,score_name);
        case 'N_M'
            score_name = 'corr all d1 npre';
            AllScores.(scores{curS}) = GetGrecoBehav(C,score_name);
        case 'N_T'
            score_name = 'corr all d2 npre';
            AllScores.(scores{curS}) = GetGrecoBehav(C,score_name);
            
        case 'C1_C1'
            score_name = 'corr all s c1';
            AllScores.(scores{curS}) = GetGrecoBehav(C,score_name);
        case 'C1_C2'
            score_name = 'corr all d1 c1pre';
            AllScores.(scores{curS}) = GetGrecoBehav(C,score_name);
        case 'C1_C3'
            score_name = 'corr all d2 c1pre';
            AllScores.(scores{curS}) = GetGrecoBehav(C,score_name);
        case 'C2_C2'
            score_name = 'corr all s c2';
            AllScores.(scores{curS}) = GetGrecoBehav(C,score_name);
        case 'C2_C1'
            score_name = 'corr all d1 c1';
            AllScores.(scores{curS}) = GetGrecoBehav(C,score_name);
        case 'C2_C3'
            score_name = 'corr all d1 c3';
            AllScores.(scores{curS}) = GetGrecoBehav(C,score_name);
        case 'C3_C3'
            score_name = 'corr all s c3';
            AllScores.(scores{curS}) = GetGrecoBehav(C,score_name);
        case 'C3_C2'
            score_name = 'corr all d1 c3pre';
            AllScores.(scores{curS}) = GetGrecoBehav(C,score_name);
        case 'C3_C1'
            score_name = 'corr all d2 c3pre';
            AllScores.(scores{curS}) = GetGrecoBehav(C,score_name);
            
        case 'dprime_all_r1'
            conds = {'corr all s','incorr all d r1'};
            AllScores.(scores{curS}) = GetDprime(C,conds);
        case 'dprime_all_r2'
            conds = {'corr all s','incorr all d r2'};
            AllScores.(scores{curS}) = GetDprime(C,conds);
        case 'dprime_all_r3'
            conds = {'corr all s','incorr all d r3'};
            AllScores.(scores{curS}) = GetDprime(C,conds);
        case 'dprime_all_r4'
            conds = {'corr all s','incorr all d r4'};
            AllScores.(scores{curS}) = GetDprime(C,conds);
        case 'dprime_d1_r1'
            conds = {'corr all s','incorr all d1 r1'};
            AllScores.(scores{curS}) = GetDprime(C,conds);
        case 'dprime_d1_r2'
            conds = {'corr all s','incorr all d1 r2'};
            AllScores.(scores{curS}) = GetDprime(C,conds);
        case 'dprime_d1_r3'
            conds = {'corr all s','incorr all d1 r3'};
            AllScores.(scores{curS}) = GetDprime(C,conds);
        case 'dprime_d1_r4'
            conds = {'corr all s','incorr all d1 r4'};
            AllScores.(scores{curS}) = GetDprime(C,conds);
        %%%   
        case 'dprime_d1_T_r1'
            conds = {'corr all s','incorr all d1 r1 t'};
            AllScores.(scores{curS}) = GetDprime(C,conds);
        case 'dprime_d1_T_r2'
            conds = {'corr all s','incorr all d1 r2 t'};
            AllScores.(scores{curS}) = GetDprime(C,conds);
        case 'dprime_d1_T_r3'
            conds = {'corr all s','incorr all d1 r3 t'};
            AllScores.(scores{curS}) = GetDprime(C,conds);
        case 'dprime_d1_T_r4'
            conds = {'corr all s','incorr all d1 r4 t'};
            AllScores.(scores{curS}) = GetDprime(C,conds);
            
        case 'dprime_d1_M_r1'
            conds = {'corr all s','incorr all d1 r1 m'};
            AllScores.(scores{curS}) = GetDprime(C,conds);
        case 'dprime_d1_M_r2'
            conds = {'corr all s','incorr all d1 r2 m'};
            AllScores.(scores{curS}) = GetDprime(C,conds);
        case 'dprime_d1_M_r3'
            conds = {'corr all s','incorr all d1 r3 m'};
            AllScores.(scores{curS}) = GetDprime(C,conds);
        case 'dprime_d1_M_r4'
            conds = {'corr all s','incorr all d1 r4 m'};
            AllScores.(scores{curS}) = GetDprime(C,conds);
            
        case 'dprime_d1_N_r1'
            conds = {'corr all s','incorr all d1 r1 n'};
            AllScores.(scores{curS}) = GetDprime(C,conds);
        case 'dprime_d1_N_r2'
            conds = {'corr all s','incorr all d1 r2 n'};
            AllScores.(scores{curS}) = GetDprime(C,conds);
        case 'dprime_d1_N_r3'
            conds = {'corr all s','incorr all d1 r3 n'};
            AllScores.(scores{curS}) = GetDprime(C,conds);
        case 'dprime_d1_N_r4'
            conds = {'corr all s','incorr all d1 r4 n'};
            AllScores.(scores{curS}) = GetDprime(C,conds);
           
            
        case 'same_r1'
            score_name = 'corr all s r1';
            AllScores.(scores{curS}) = GetGrecoBehav(C,score_name);
        case 'same_r2'
            score_name = 'corr all s r2';
            AllScores.(scores{curS}) = GetGrecoBehav(C,score_name);
        case 'same_r3'
            score_name = 'corr all s r3';
            AllScores.(scores{curS}) = GetGrecoBehav(C,score_name);
        case 'same_r4'
            score_name = 'corr all s r4';
            AllScores.(scores{curS}) = GetGrecoBehav(C,score_name);
               
        case 'diff1_r1'
            score_name = 'corr all d1 r1';
            AllScores.(scores{curS}) = GetGrecoBehav(C,score_name);
        case 'diff1_r2'
            score_name = 'corr all d1 r2';
            AllScores.(scores{curS}) = GetGrecoBehav(C,score_name);
        case 'diff1_r3'
            score_name = 'corr all d1 r3';
            AllScores.(scores{curS}) = GetGrecoBehav(C,score_name);
        case 'diff1_r4'
            score_name = 'corr all d1 r4';
            AllScores.(scores{curS}) = GetGrecoBehav(C,score_name);
               
                
            
        case 'same_T_r1'
            score_name = 'corr all s t r1';
            AllScores.(scores{curS}) = GetGrecoBehav(C,score_name);
        case 'same_T_r2'
            score_name = 'corr all s t r2';
            AllScores.(scores{curS}) = GetGrecoBehav(C,score_name);
        case 'same_T_r3'
            score_name = 'corr all s t r3';
            AllScores.(scores{curS}) = GetGrecoBehav(C,score_name);
        case 'same_T_r4'
            score_name = 'corr all s t r4';
            AllScores.(scores{curS}) = GetGrecoBehav(C,score_name);
            
            
        case 'same_M_r1'
            score_name = 'corr all s m r1';
            AllScores.(scores{curS}) = GetGrecoBehav(C,score_name);
        case 'same_M_r2'
            score_name = 'corr all s m r2';
            AllScores.(scores{curS}) = GetGrecoBehav(C,score_name);
        case 'same_M_r3'
            score_name = 'corr all s m r3';
            AllScores.(scores{curS}) = GetGrecoBehav(C,score_name);
        case 'same_M_r4'
            score_name = 'corr all s m r4';
            AllScores.(scores{curS}) = GetGrecoBehav(C,score_name);
            
        case 'same_N_r1'
            score_name = 'corr all s n r1';
            AllScores.(scores{curS}) = GetGrecoBehav(C,score_name);
        case 'same_N_r2'
            score_name = 'corr all s n r2';
            AllScores.(scores{curS}) = GetGrecoBehav(C,score_name);
        case 'same_N_r3'
            score_name = 'corr all s n r3';
            AllScores.(scores{curS}) = GetGrecoBehav(C,score_name);
        case 'same_N_r4'
            score_name = 'corr all s n r4';
            AllScores.(scores{curS}) = GetGrecoBehav(C,score_name);
            

        case 'diff1_T_r1'
             score_name = 'corr all d1 t r1';
            AllScores.(scores{curS}) = GetGrecoBehav(C,score_name);
        case 'diff1_T_r2'
            score_name = 'corr all d1 t r2';
            AllScores.(scores{curS}) = GetGrecoBehav(C,score_name);            
        case 'diff1_T_r3'
            score_name = 'corr all d1 t r3';
            AllScores.(scores{curS}) = GetGrecoBehav(C,score_name);    
        case 'diff1_T_r4'
            score_name = 'corr all d1 t r4';
            AllScores.(scores{curS}) = GetGrecoBehav(C,score_name);
            
        case 'diff1_M_r1'
            score_name = 'corr all d1 m r1';
            AllScores.(scores{curS}) = GetGrecoBehav(C,score_name);
        case 'diff1_M_r2'
            score_name = 'corr all d1 m r2';
            AllScores.(scores{curS}) = GetGrecoBehav(C,score_name);
        case 'diff1_M_r3'
            score_name = 'corr all d1 m r3';
            AllScores.(scores{curS}) = GetGrecoBehav(C,score_name);
        case 'diff1_M_r4'
            score_name = 'corr all d1 m r4';
            AllScores.(scores{curS}) = GetGrecoBehav(C,score_name);
    
        case 'diff1_N_r1'
            score_name = 'corr all d1 n r1';
            AllScores.(scores{curS}) = GetGrecoBehav(C,score_name);
        case 'diff1_N_r2'
            score_name = 'corr all d1 n r2';
            AllScores.(scores{curS}) = GetGrecoBehav(C,score_name);
        case 'diff1_N_r3'
            score_name = 'corr all d1 n r3';
            AllScores.(scores{curS}) = GetGrecoBehav(C,score_name);
        case 'diff1_N_r4'
            score_name = 'corr all d1 n r4';
            AllScores.(scores{curS}) = GetGrecoBehav(C,score_name);
            
            
        otherwise
            error([scores{curS},' category not specified']);
    end
    
end


T = struct2table(AllScores);


end