function rsj_rsa_group_corr_matrix(C,cond_input,plot_name)

%Inputs: C - Congif clas
%        cond_input - Trial-type codes.
%        stat_mode  - all or within


subjInd = GetSubjsInd(C);
sC = 0;
singlesub =0;
numMasks = NumMasksAll(C);
mask_names = C.masks.maskAll;
disp('updating...');


for i1=subjInd   %Cycle through subject indices
    
    sC = sC+1;  %Index condition
      subj=C.subjects.subjAll{i1};
        behav = rsj_trial_type(subj,C,C.tt.mode).Get_tt;
    for cond = 1:length(cond_input)
      
        T = rsj_rsa_trial_config(behav,cond_input{cond}.input);
        a = rsj_grab(subj,C,T,behav);
        
                 
            calc = str2func(C.rs.rs_calcOpts{C.rs.rs_calcCurr});
            sco_allvox = calc(a);
            data{cond}(1:NumMasksAll(C),1:NumMasksAll(C),sC) = corr(sco_allvox);
            
           
    end
end





for i1 = 1:numMasks
for i2 = 1:numMasks
    if length(cond_input) ==1
    data_corr{i1,i2} = data{cond}(i1,i2,:);
    elseif length(cond_input) ==2
    data_corr{i1,i2} = data{1}(i1,i2,:) - data{2}(i1,i2,:);
    elseif length(cond_input)>2
        error('too many conditions man');
    end
end
end







units = C.rs.rs_calcUnits(C.rs.rs_calcCurr);

StatMatplot(data_corr,'onesample',units,plot_name,...
    strrep(strrep(mask_names,'_',''),'.nii',''));

disp('Done!');


