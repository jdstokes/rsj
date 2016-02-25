function rsj_rsa_group(C,cond_input,stat_mode,measure_func,legend_label)

%Inputs: C - Congif clas
%        cond_input - Trial-type codes.
%        stat_mode  - all or within


subjInd = GetSubjsInd(C);
maskInd = GetMasksInd(C);
sC = 0;
singlesub =0;

disp('updating...');


for i=subjInd   %Cycle through subject indices
    
    sC = sC+1;  %Index condition
    
    subj=C.subjects.subjAll{i};
    behav = rsj_trial_type(subj,C,C.tt.mode).Get_tt;

    for cond = 1:length(cond_input)
%         behav = C.tt.tt_func{C.tt.tt_val}(subj,C);
        T = rsj_rsa_trial_config(behav,cond_input{cond}.input);
        a = rsj_grab(subj,C,T,behav);
        if length(subjInd) > 1
            
     
            sco_allvox = Get_scores(a);
            if size(sco_allvox,1) >1
                scores = mean(sco_allvox,'omitnan');
            elseif ~isempty(sco_allvox)
                scores = sco_allvox;
            else
                scores = nan(1,length(C.masks.maskAll));
            end
            clear sco_allvox
            
            
            %Format scores maskwise
            mC =0;
            for j = maskInd
                mC= mC+1;
                data{mC,cond}(sC,1)= scores(j);
            end
            clear scores
            
            %Single subject data
        elseif length(subjInd) == 1
            singlesub =1;
            calc = str2func(C.rs.rs_calcOpts{C.rs.rs_calcCurr});
            scores = calc(a);
            mC =0;
            for j = maskInd
                mC= mC+1;
                data{mC,cond}= scores(:,j);
            end
            
        end
        
    end
end


if strcmp(measure_func,'subtraction') && mod(length(cond_input),2)==0
    cnt =0;
    for i = 1:2:length(cond_input)
        cnt=cnt+1;
        for j = 1: size(data,1)
        data_sub(j,cnt) = {data{j,i} - data{j,i+1}}; %#ok<*AGROW>
        end
    end
    data = data_sub;
    clear data_sub
end


%build x axis labels
labels = strrep(strrep(GetMasks(C),'.nii',''),'_','');
units = C.rs.rs_calcUnits(C.rs.rs_calcCurr);
%plot bars with stats
StatBarPlot(data,stat_mode,labels,units,singlesub,legend_label);

disp('Done!');


