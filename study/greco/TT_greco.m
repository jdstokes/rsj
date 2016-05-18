function tt_all = TT_greco(subj,C)


format = '.txt';
fileName = fullfile(C.dir.dir_behavioral,subj,[subj,format]);
tt = tdfread(fileName);
clear C fileName 

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  Build TT and add additional columns to tt
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Calculate number of trials. maybe unique to subject
numTrials = length(tt.Global_trial_num);
numTrialsByRun = [sum(tt.run_num ==0),sum(tt.run_num ==1),...
                  sum(tt.run_num ==2),sum(tt.run_num ==3)];



tt.event = (1:numTrials)';
dur= 20.0;
S =strsplit(subj,'_');

id = S(2); %shape training signifier
clear S
tt= Get_conditions(tt,id,numTrials);

%% tt_all
tt_all.rs_pair = tt;
tt_all.rs_all = GetConditionsRS(tt,numTrials);
tt_all.spm = GetConditionsSPM(tt,numTrials,dur);%%ttspm;
tt_all.numTrials = numTrials;
tt_all.numTrialsByRun = numTrialsByRun;
tt_all.behav = build_codes_greco(tt_all);

% tt_all.behav_xtra_scores = build_extra_scores_greco(subj);
end

function tt = Get_conditions(tt,id,numTrials)

for i1=1:numTrials;
  
    % Extract run specific trial order number
    tri = tt.Global_trial_num(i1);
    % Extract run number
    run = tt.run_num(i1) +1;
    %Build new variable cityTarg/TARGCITY
    if(strcmp(id,'A'))
        switch tt.currCity(i1)
            case 1
                cityTargC(i1,1) = 'T';
            case 2
                cityTargC(i1,1) = 'M';
            case 3
                cityTargC(i1,1) = 'N';
        end
        switch tt.priorCity(i1)
            case 1
                cityTargP(i1,1) = 'T';
            case 2
                cityTargP(i1,1) = 'M';
            case 3
                cityTargP(i1,1) = 'N';
            case 99
                cityTargP(i1,1) = 'b'; 
        end
        
   
        
    elseif(strcmp(id,'B'))
        switch tt.currCity(i1)
            case 1
                cityTargC(i1,1) = 'N';
            case 2
                cityTargC(i1,1) = 'M';
            case 3
                cityTargC(i1,1) = 'T';
           
        end
        switch tt.priorCity(i1)
            case 1
                cityTargP(i1,1) = 'N';
            case 2
                cityTargP(i1,1) = 'M';
            case 3
                cityTargP(i1,1) = 'T';
             
            otherwise
                cityTargP(i1,1) = 'b'; 
        end
 
    end
    
    if cityTargC(i1,1) == 'T' || cityTargP(i1,1) == 'T'
        cityTargE(i1,1) = 'T';
        
    elseif cityTargC(i1,1) == 'N' || cityTargP(i1,1) == 'N'
        cityTargE(i1,1) = 'N';
    else
        cityTargE(i1,1) = '-';
    end
    
    
    if tt.priorCity(i1) ~= 99
       tt_code(i1,1) = abs(tt.currCity(i1) - tt.priorCity(i1));
    else
        tt_code(i1,1) = 99;
    end
    
  
end



% Add new additional variables to tt
tt.cityTargC = cityTargC;
tt.cityTargP = cityTargP;
tt.cityTargE = cityTargE;
tt.tt_code = tt_code;
%change char arrays to cell
vars = fieldnames(tt);
for i1 = 1:length(vars)
    if ischar(tt.(vars{i1}))
        tt.(vars{i1}) = cellstr(tt.(vars{i1}));
    end
end
end


function ttspm = GetConditionsSPM(tt,numTrials,dur)
        for i1=1:numTrials;
            
            % Extract run specific trial order number
            tri = tt.Global_trial_num(i1);
            % Extract run number
            run = tt.run_num(i1) +1;
            ttspm(run).EVENTNUM{tri}= tt.event(i1);
            ttspm(run).ONSET{tri}= tt.trial_time(i1);
            ttspm(run).RESPTIME{tri}= tt.resp_time(i1);
            ttspm(run).DUR{tri}= dur;
            ttspm(run).RESPONSE{tri}= tt.resp_key(i1);
            ttspm(run).TT_MAIN{tri}= tt.trial_type(i1);
            ttspm(run).TT_CURCITY{tri}= tt.currCity(i1);
            ttspm(run).TT_PRECITY{tri}= tt.priorCity(i1);
            ttspm(run).TT_CURTARGCITY{tri}= tt.cityTargC(i1);
            ttspm(run).TT_PRETARGCITY{tri}= tt.cityTargP(i1);
            ttspm(run).TT_CODE{tri}= tt.tt_code(i1);
            
        end
    end




function ttrs  = GetConditionsRS(tt,numTrials)
pairs = nchoosek(1:numTrials,2);
ttrs.ind_non_pair = abs(pairs(:,1) - pairs(:,2)) ~=1;
for i = 1:size(pairs,1)
    x = pairs(i,1);
    y = pairs(i,2);
    
    ttrs.rs_withinrun(i,1)  = tt.run_num(x) == tt.run_num(y);
    ttrs.rs_pair_code(i,1)  = abs(tt.currCity(x) - tt.currCity(y));
    ttrs.run1(i,1)  = tt.run_num(x) ==0 &   tt.run_num(y) ==0;
    ttrs.run2(i,1)  = tt.run_num(x) ==1 &   tt.run_num(y) ==1;
    ttrs.run3(i,1)  = tt.run_num(x) ==2 &   tt.run_num(y) ==2;
    ttrs.run4(i,1)  = tt.run_num(x) ==3 &   tt.run_num(y) ==3;
    
    ttrs.rs_tt_same(i,1) = tt.tt_code(x) ==0 &   tt.tt_code(y) ==0;
    ttrs.rs_tt_diff1(i,1) = tt.tt_code(x) ==1 &  tt.tt_code(y) ==1;
    ttrs.rs_tt_diff2(i,1) = tt.tt_code(x) ==2 &  tt.tt_code(y) ==2;
    ttrs.rs_tt_diff12(i,1) =  any([ttrs.rs_tt_diff1(i),ttrs.rs_tt_diff2(i)]);
    ttrs.rs_TargC(i,1) = tt.cityTargC{x} == 'T'| tt.cityTargC{y} == 'T';
    ttrs.rs_MorphC(i,1) = tt.cityTargC{x} == 'M'| tt.cityTargC{y} == 'M';
    ttrs.rs_NovC(i,1) = tt.cityTargC{x} == 'N'| tt.cityTargC{y} == 'N';
    ttrs.rs_acc_all(i,1) = tt.acc(x) == 1 & tt.acc(y) == 1;
    ttrs.rs_acc_or(i,1) = tt.acc(x) == 1 | tt.acc(y) == 1;
end

end