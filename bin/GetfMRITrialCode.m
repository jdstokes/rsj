function input = GetfMRITrialCode(cond_name)

input =[];

switch cond_name

    case 'all'
       input =  AddComp(input,{'tt_code'},[0 1 2]);
    
    case 'T_T'
        input = AddComp(input,{'cityTargP'},{'T'});
        input = AddComp(input,{'cityTargC'},{'T'});
    case 'T_M'
        input = AddComp(input,{'cityTargP'},{'T'});
        input = AddComp(input,{'cityTargC'},{'M'});
    case 'T_N'
        input = AddComp(input,{'cityTargP'},{'T'});
        input = AddComp(input,{'cityTargC'},{'N'});
    case 'M_M'
        input = AddComp(input,{'cityTargP'},{'M'});
        input = AddComp(input,{'cityTargC'},{'M'});
    case 'M_T'
        input = AddComp(input,{'cityTargP'},{'M'});
        input = AddComp(input,{'cityTargC'},{'T'});
    case 'M_N'
        input = AddComp(input,{'cityTargP'},{'M'});
        input = AddComp(input,{'cityTargC'},{'N'});
    case 'N_N'
        input = AddComp(input,{'cityTargP'},{'N'});
        input = AddComp(input,{'cityTargC'},{'N'});
    case 'N_M'
        input = AddComp(input,{'cityTargP'},{'N'});
        input = AddComp(input,{'cityTargC'},{'M'});
    case 'N_T'
        input = AddComp(input,{'cityTargP'},{'N'});
        input = AddComp(input,{'cityTargC'},{'T'});
        
        
        
        
    case 'N'
        input = AddComp(input,{'cityTargC'},{'N'});
    case 'M'
        input = AddComp(input,{'cityTargC'},{'M'});
    case 'T'
        input = AddComp(input,{'cityTargC'},{'T'});
        
        
        %% Group
    case 'same'
        input = AddComp(input,{'tt_code'},[0]);
    case 'diff_all'
        input = AddComp(input,{'tt_code'},[1 2]);
    case 'diff1'
        input = AddComp(input,{'tt_code'},[1]);
    case 'diff2'
        input = AddComp(input,{'tt_code'},[1 2]);
    case 'same_T'
        input = AddComp(input,{'tt_code'},[0]);
        input = AddComp(input,{'cityTargC'},{'T'});
    case 'diff_all_T'
        input = AddComp(input,{'tt_code'},[1 2]);
        input = AddComp(input,{'cityTargC'},{'T'});
        
    case 'diff1_T'
        input = AddComp(input,{'tt_code'},[1]);
        input = AddComp(input,{'cityTargC'},{'T'});
        
    case 'diff2_T'
        input = AddComp(input,{'tt_code'},[2]);
        input = AddComp(input,{'cityTargC'},{'T'});
        
        
    case 'same_N'
        input = AddComp(input,{'tt_code'},[0]);
        input = AddComp(input,{'cityTargC'},{'N'});
        
    case 'diff_all_N'
        input = AddComp(input,{'tt_code'},[1 2]);
        input = AddComp(input,{'cityTargC'},{'N'});
        
    case 'diff1_N'
        input = AddComp(input,{'tt_code'},[1]);
        input = AddComp(input,{'cityTargC'},{'N'});
        
    case 'diff2_N'
        input = AddComp(input,{'tt_code'},[1]);
        input = AddComp(input,{'cityTargC'},{'N'});
        
    case 'same_M'
        input = AddComp(input,{'tt_code'},[0]);
        input = AddComp(input,{'cityTargC'},{'M'});
    case 'diff1_M'
        input = AddComp(input,{'tt_code'},[1]);
        input = AddComp(input,{'cityTargC'},{'M'});
    case 'C1_C1'
        input = AddComp(input,{'priorCity'},[1]);
        input =  AddComp(input,{'currCity'},[1]);
        
    case 'C1_C2'
        input = AddComp(input,{'priorCity'},[1]);
        input = AddComp(input,{'currCity'},[2]);
        
    case 'C1_C3'
        input = AddComp(input,{'priorCity'},[1]);
        input = AddComp(input,{'currCity'},[3]);
    case 'C2_C2'
        input = AddComp(input,{'priorCity'},[2]);
        input = AddComp(input,{'currCity'},[2]);
    case 'C2_C1'
        input = AddComp(input,{'priorCity'},[1]);
        input = AddComp(input,{'currCity'},[2]);
        
    case 'C2_C3'
        input = AddComp(input,{'priorCity'},[2]);
        input = AddComp(input,{'currCity'},[3]);
        
    case 'C3_C3'
        input = AddComp(input,{'priorCity'},[3]);
        input = AddComp(input,{'currCity'},[3]);
    case 'C3_C2'
        input = AddComp(input,{'priorCity'},[3]);
        input = AddComp(input,{'currCity'},[2]);
    case 'C3_C1'
        input = AddComp(input,{'priorCity'},[3]);
        input = AddComp(input,{'currCity'},[1]);
        
    case 'all_r1'
        input =  AddComp(input,{'tt_code'},[0 1 2]);
        input = AddComp(input,{'run_num'},[0]);
    case 'all_r2'
        input =  AddComp(input,{'tt_code'},[0 1 2]);
        input = AddComp(input,{'run_num'},[1]);
    case 'all_r3'
        input =  AddComp(input,{'tt_code'},[0 1 2]);
        input = AddComp(input,{'run_num'},[2]);
    case 'all_r4'
        input =  AddComp(input,{'tt_code'},[0 1 2]);
        input = AddComp(input,{'run_num'},[3]);
        
    case 'same_r1'
        input = AddComp(input,{'tt_code'},[0]);
        input = AddComp(input,{'run_num'},[0]);
        
    case 'same_r2'
        input = AddComp(input,{'tt_code'},[0]);
        input = AddComp(input,{'run_num'},[1]);
    case 'same_r3'
        input = AddComp(input,{'tt_code'},[0]);
        input = AddComp(input,{'run_num'},[2]);
    case 'same_r4'
        input = AddComp(input,{'tt_code'},[0]);
        input = AddComp(input,{'run_num'},[3]);
        
    case 'diff1_r1'
        input = AddComp(input,{'tt_code'},[1]);
        input = AddComp(input,{'run_num'},[0]);
    case 'diff1_r2'
        input = AddComp(input,{'tt_code'},[1]);
        input = AddComp(input,{'run_num'},[1]);
    case 'diff1_r3'
        input = AddComp(input,{'tt_code'},[1]);
        input = AddComp(input,{'run_num'},[2]);
    case 'diff1_r4'
        input = AddComp(input,{'tt_code'},[1]);
        input = AddComp(input,{'run_num'},[3]);
        
    case 'same_T_r1'
        input = AddComp(input,{'tt_code'},[0]);
        input = AddComp(input,{'run_num'},[0]);
        input = AddComp(input,{'cityTargC'},{'T'});
    case 'same_T_r2'
        input = AddComp(input,{'tt_code'},[0]);
        input = AddComp(input,{'run_num'},[1]);
        input = AddComp(input,{'cityTargC'},{'T'});
    case 'same_T_r3'
        input = AddComp(input,{'tt_code'},[0]);
        input = AddComp(input,{'run_num'},[2]);
        input = AddComp(input,{'cityTargC'},{'T'});
    case 'same_T_r4'
        input = AddComp(input,{'tt_code'},[0]);
        input = AddComp(input,{'run_num'},[3]);
        input = AddComp(input,{'cityTargC'},{'T'});
        
    case 'same_M_r1'
        input = AddComp(input,{'tt_code'},[0]);
        input = AddComp(input,{'run_num'},[0]);
        input = AddComp(input,{'cityTargC'},{'M'});
    case 'same_M_r2'
        input = AddComp(input,{'tt_code'},[0]);
        input = AddComp(input,{'run_num'},[1]);
        input = AddComp(input,{'cityTargC'},{'M'});
    case 'same_M_r3'
        input = AddComp(input,{'tt_code'},[0]);
        input = AddComp(input,{'run_num'},[2]);
        input = AddComp(input,{'cityTargC'},{'M'});
    case 'same_M_r4'
        input = AddComp(input,{'tt_code'},[0]);
        input = AddComp(input,{'run_num'},[3]);
        input = AddComp(input,{'cityTargC'},{'M'});
    case 'same_N_r1'
        input = AddComp(input,{'tt_code'},[0]);
        input = AddComp(input,{'run_num'},[0]);
        input = AddComp(input,{'cityTargC'},{'N'});
    case 'same_N_r2'
        input = AddComp(input,{'tt_code'},[0]);
        input = AddComp(input,{'run_num'},[1]);
        input = AddComp(input,{'cityTargC'},{'N'});
    case 'same_N_r3'
        input = AddComp(input,{'tt_code'},[0]);
        input = AddComp(input,{'run_num'},[2]);
        input = AddComp(input,{'cityTargC'},{'N'});
    case 'same_N_r4'
        input = AddComp(input,{'tt_code'},[0]);
        input = AddComp(input,{'run_num'},[3]);
        input = AddComp(input,{'cityTargC'},{'N'});
        
    case 'diff1_T_r1'
        input = AddComp(input,{'tt_code'},[1]);
        input = AddComp(input,{'run_num'},[0]);
        input = AddComp(input,{'cityTargC'},{'T'});
    case 'diff1_T_r2'
        input = AddComp(input,{'tt_code'},[1]);
        input = AddComp(input,{'run_num'},[1]);
        input = AddComp(input,{'cityTargC'},{'T'});
    case 'diff1_T_r3'
        input = AddComp(input,{'tt_code'},[1]);
        input = AddComp(input,{'run_num'},[2]);
        input = AddComp(input,{'cityTargC'},{'T'});
    case 'diff1_T_r4'
        input = AddComp(input,{'tt_code'},[1]);
        input = AddComp(input,{'run_num'},[3]);
        input = AddComp(input,{'cityTargC'},{'T'});
    case 'diff1_M_r1'
        input = AddComp(input,{'tt_code'},[1]);
        input = AddComp(input,{'run_num'},[0]);
        input = AddComp(input,{'cityTargC'},{'M'});
    case 'diff1_M_r2'
        input = AddComp(input,{'tt_code'},[1]);
        input = AddComp(input,{'run_num'},[1]);
        input = AddComp(input,{'cityTargC'},{'M'});
    case 'diff1_M_r3'
        input = AddComp(input,{'tt_code'},[1]);
        input = AddComp(input,{'run_num'},[2]);
        input = AddComp(input,{'cityTargC'},{'M'});
    case 'diff1_M_r4'
        input = AddComp(input,{'tt_code'},[1]);
        input = AddComp(input,{'run_num'},[3]);
        input = AddComp(input,{'cityTargC'},{'M'});
        
    case 'diff1_N_r1'
        input = AddComp(input,{'tt_code'},[1]);
        input = AddComp(input,{'run_num'},[0]);
        input = AddComp(input,{'cityTargC'},{'N'});
    case 'diff1_N_r2'
        input = AddComp(input,{'tt_code'},[1]);
        input = AddComp(input,{'run_num'},[1]);
        input = AddComp(input,{'cityTargC'},{'N'});
    case 'diff1_N_r3'
        input = AddComp(input,{'tt_code'},[1]);
        input = AddComp(input,{'run_num'},[2]);
        input = AddComp(input,{'cityTargC'},{'N'});
    case 'diff1_N_r4'
        input = AddComp(input,{'tt_code'},[1]);
        input = AddComp(input,{'run_num'},[3]);
        input = AddComp(input,{'cityTargC'},{'N'});
    otherwise
        error('Trial name not configured');
        
end


end

function I = AddComp(I,var,val)
if isempty(I)
    I{1}.var = var;
    I{1}.val = val;
else
    cnt = length(I) +1;
    I{cnt}.var = var;
    I{cnt}.val = val;
end

end


