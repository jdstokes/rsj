function ttrs = TT_rs_ce(subj,C)


tt = TT_ce(subj,C);

numTrials = C.NumTrials;
pairs = nchoosek(1:numTrials,2);

for i = 1:size(pairs,1)
    x = pairs(i,1);
    y = pairs(i,2);
    
    ttrs.rs_withinrun(i,1)  = tt.run_num(x) == tt.run_num(y);
    ttrs.rs_pair_code(i,1)  = abs(tt.currCity(x) - tt.currCity(y));
    
    ttrs.rs_tt_same(i,1) = tt.tt_code(x) ==0 &   tt.tt_code(y) ==0;
    ttrs.rs_tt_diff1(i,1) = tt.tt_code(x) ==1 &  tt.tt_code(y) ==1;
    ttrs.rs_tt_diff2(i,1) = tt.tt_code(x) ==2 &  tt.tt_code(y) ==2;
    ttrs.rs_tt_diff12(i,1) =  any([ttrs.rs_tt_diff1(i),ttrs.rs_tt_diff2(i)]);
    ttrs.rs_TargC(i,1) = tt.cityTargC{x} == 'T'| tt.cityTargC{y} == 'T';
    ttrs.rs_MorphC(i,1) = tt.cityTargC{x} == 'M'| tt.cityTargC{y} == 'M';
    ttrs.rs_NovC(i,1) = tt.cityTargC{x} == 'N'| tt.cityTargC{y} == 'N';
    
end



