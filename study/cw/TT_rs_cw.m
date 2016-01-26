function ttrs = TT_rs_cw(subj,C)


tt = TT_cw(subj,C);

numTrials = C.NumTrials;
pairs = nchoosek(1:numTrials,2);

for i = 1:size(pairs,1)
    x = pairs(i,1);
    y = pairs(i,2);
    
    ttrs.rs_withinrun(i,1)  = tt.Run(x) == tt.Run(y);
    ttrs.rs_tt_1(i,1)  = tt.trial_type(x) ==1 & tt.trial_type(y) ==1;
    ttrs.rs_tt_2(i,1)  = tt.trial_type(x) ==2 & tt.trial_type(y) ==2;
    ttrs.rs_tt_wordID(i,1)  = tt.word_ID(x) == tt.word_ID(y);
    ttrs.rs_tt_hit(i,1) = tt.accuracy(x) ==1 & tt.accuracy(y) == 1;
    ttrs.rs_tt_buffer(i,1) = tt.accuracy(x) ==0 & tt.accuracy(y) == 0;
    ttrs.rs_tt_miss(i,1) = tt.accuracy(x) ==2 & tt.accuracy(y) == 2;
    ttrs.test_angEr(i,1) = tt.test_angEr(x);                                %% only useful for RS analysis (ret word to enc word comparisons)
end



