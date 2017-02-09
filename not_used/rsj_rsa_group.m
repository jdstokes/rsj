function GroupBarPlot(C,cond_input,stat_mode,measure_func,legend_label)

%Inputs: C - Congif clas
%        cond_input - Trial-type codes.
%        stat_mode  - all or within

maskInd = GetMasksInd(C);
sC = 0;
singlesub =0;

disp('updating...');


for i=length(C.subjects.subj2run)  %Cycle through subject indices
    
    sC = sC+1;  %Index condition
    
    subj=C.subjects.subj2run{i};
    behav = TrialType(subj,C,C.tt.mode).Get_tt;

    for cond = 1:length(cond_input)


        T = rsj_rsa_trial_config(behav,cond_input{cond}.input);
        
        
        
       index  =   rsj_rsa_get_index(T,behav,C);
       loaded_scores = 
       
%        output =   rsj_rsa_indexbetas(rsj_rsa_getbetas(subj,C),ind,C);
       clear ind
       
       inDir =  fullfile(C.dir.dir_rs,C.spm.spm_modelName,...
    ['hpf',num2str(C.spm.spm_hpf)],C.spm.spm_mask,...
    C.spm.spm_smooth,C.masks.maskType,'betas',...
    C.rs.rs_feature_mask,'scores',...
    ['OLSv_method_',C.ol.ol_v_method],['OLSv_',C.ol.ol_v]);

       fName =  [subj, '_scores'];
       scores = load(fullfile(inDir,fName));
       rsj_rsa_indexbetas
       
       
       
%         A = Grab(subj,C,T,behav);
        
        
        
        if length(subjInd) > 1
            
     
            sco_allvox = Get_scores(A);
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
            sco_allvox = Get_scores(A);
%             if size(sco_allvox,1) >1
%                 scores = mean(sco_allvox,'omitnan');
%             elseif ~isempty(sco_allvox)
%                 scores = sco_allvox;
%             else
%                 scores = nan(1,length(C.masks.maskAll));
%             end
%             
            
            
            %Format scores maskwise
            mC =0;
            for j = maskInd
                mC= mC+1;
                data{mC,cond}= sco_allvox(:,j);
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


