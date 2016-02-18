function [tag_codes]=build_codes_greco(tt_all)

numTrials = tt_all.numTrials;
tt = tt_all.rs_pair;
clear tt_all

condition_tags = {'all','corr','incorr',...
    's','d','d1','d2',...
    'c1','c2','c3',...
    'postT','postM','postN','preT','preM','preN',...
    'r1','r2','r3','r4'};
for i = 1: length(condition_tags)
    tag_codes.(condition_tags{i}) = zeros(numTrials,1);
end
clear i


for i = 1:numTrials
    
   
    if(tt.tt_code(i)~=99),                             tag_codes.all(i)     = 1; end
    %correct trials
    if(tt.acc(i) == 1),                                tag_codes.corr(i)    = 1; end
    %correct trials
    if(tt.acc(i) == 0),                                tag_codes.incorr(i)    = 1;end
    %same trials
    if(tt.tt_code(i) == 0),                            tag_codes.s(i)       = 1;end
    %diff trials
    if(tt.tt_code(i) > 0 && tt.tt_code(i) ~=99),       tag_codes.d(i)       = 1;end
    %d_1 trials
    if(tt.tt_code(i) == 1),                            tag_codes.d1(i)     = 1;end
    %d_2 trials
    if(tt.tt_code(i) == 2),                            tag_codes.d2(i)     = 1;end
    
    %c1
    if(tt.currCity(i) == 1),                           tag_codes.c1(i) = 1;end
    if(tt.currCity(i) == 2),                           tag_codes.c2(i) = 1;end
    if(tt.currCity(i) == 3),                           tag_codes.c3(i) = 1;end

    
    if(strcmp(tt.cityTargC(i),'T')),                   tag_codes.postT(i) = 1; end
    if(strcmp(tt.cityTargC(i),'M')),                   tag_codes.postM(i) = 1; end
    if(strcmp(tt.cityTargC(i),'N')),                   tag_codes.postN(i) = 1; end
    
    if(strcmp(tt.cityTargP(i),'T')),                   tag_codes.preT(i) = 1; end
    if(strcmp(tt.cityTargP(i),'M')),                   tag_codes.preM(i) = 1; end
    if(strcmp(tt.cityTargP(i),'N')),                   tag_codes.preN(i) = 1; end
    
    if(strcmp(tt.cityTargP(i),'T')),                   tag_codes.preT(i) = 1; end
    if(strcmp(tt.cityTargP(i),'M')),                   tag_codes.preM(i) = 1; end
    if(strcmp(tt.cityTargP(i),'N')),                   tag_codes.preN(i) = 1; end
    
    if(tt.run_num(i) ==0),                             tag_codes.r1(i) = 1; end
    if(tt.run_num(i) ==1),                             tag_codes.r2(i) = 1; end
    if(tt.run_num(i) ==2),                             tag_codes.r3(i) = 1; end
    if(tt.run_num(i) ==3),                             tag_codes.r4(i) = 1; end
    


end


