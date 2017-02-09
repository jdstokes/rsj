function rsj_rsa_group_corr(C,cond_input,stat_mode,mask_comp,mask_comp_name,measure_func,legend_label)

%Inputs: C - Congif clas
%        cond_input - Trial-type codes.
%        stat_mode  - all or within


subjInd = GetSubjsInd(C);
sC = 0;
singlesub =0;

disp('updating...');


for i1=subjInd   %Cycle through subject indices
    
    sC = sC+1;  %Index condition
    
    for cond = 1:length(cond_input)
        subj=C.subjects.subjAll{i1};
        behav = rsj_trial_type(subj,C,C.tt.mode).Get_tt;
        T = rsj_rsa_trial_config(behav,cond_input{cond}.input);
        A = rsj_grab(subj,C,T,behav);
        sco_allvox = Get_scores(A);
        data{cond}(1:NumMasksAll(C),1:NumMasksAll(C),sC) = corr(sco_allvox); %#ok<*AGROW>
    end
end

for cond = 1:length(cond_input)
for i2 = 1:size(mask_comp,1)
    data_corr{cond,i2} = data{cond}(mask_comp(i2,1),mask_comp(i2,2),:);
end
end


if strcmp(measure_func,'subtraction') && mod(length(cond_input),2)==0
    cnt =0;
    for i = 1:2:length(cond_input)
        cnt=cnt+1;
        for j = 1:size(data_corr,2)
        data_sub(cnt,j) = {data_corr{i,j} - data_corr{i+1,j}};
        end
    end
    data_corr = data_sub;
    clear data_sub
end



labels = mask_comp_name;
units = C.rs.rs_calcUnits(C.rs.rs_calcCurr);


StatBarPlot(data_corr',stat_mode,labels,units,singlesub,legend_label );

disp('Done!');


