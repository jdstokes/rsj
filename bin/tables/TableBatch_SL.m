function TableBatch_SL

C = Study_greco2; %load C
tableDir = C.dir.tables; %Load table
T = load(fullfile(tableDir,'greco_tables.mat'));
C.subjects.subj2run= C.subjects.subj2inc; %Override subj2run

%BatchSearchLight(C,T);
%BuildMM(C);
BuildSpecs(C);
BatchWarp(C,T);
%BatchTtest(C,T);
%BatchCluster(C,T);
%BatchTableCSV(C,T);
P = BatchCheckReg(C);
end

function BuildMM(C)

mTypes =  {'ash_lfseg_corr_usegray','v3'};
    for j = 1:length(mTypes)
        SL_reg_MM(C,mTypes{j});
    end

end


function BuildSpecs(C)

regSubjList  = {'S5_A','S21_B','S16_A','S1_A'};
mTypes =  {'ash_lfseg_corr_usegray','v3'};
for i = 1:length(regSubjList)
    for j = 1:length(mTypes)
        SL_reg_specs(C,mTypes{j},regSubjList{i});
    end
end

end



function BatchSearchLight(C,T)


slradOpts = [4];
subjList = C.subjects.subj2run;

cur_model_ID = 'm00000089';

modelI = strcmp(cur_model_ID,cellstr(T.model.model_ID));
betaI = strcmp(cur_model_ID,cellstr(T.betas.model_ID));
rsI = strcmp(T.betas.beta_ID(betaI,:),cellstr(T.rs.beta_ID));


model_row = T.model(modelI,:);
beta_row = T.betas(betaI,:);
rs_row = T.rs(rsI,:);
for slrad = slradOpts
    for curSubj = 1:length(subjList)
        disp([subjList{curSubj},': ',beta_row.beta_ID])
        C = ConfigureModelSpecs(C,model_row);
        SL_main_greco(subjList{curSubj},C,beta_row,model_row,slrad);
        
    end
end

end

function BatchWarp(C,T)


cur_model_ID = 'm00000089';

modelI = strcmp(cur_model_ID,cellstr(T.model.model_ID));
betaI = strcmp(cur_model_ID,cellstr(T.betas.model_ID));
rsI = strcmp(T.betas.beta_ID(betaI,:),cellstr(T.rs.beta_ID));


model_row = T.model(modelI,:);
beta_row = T.betas(betaI,:);
rs_row = T.rs(rsI,:);



slradOpts = [4];
mTypes =  {'ash_lfseg_corr_usegray','v3'};
regSubjList = {'S5_A','S21_B','S16_A','S1_A'};


for i = 1:length(slradOpts)
    for j = 1:length(mTypes)
        for k =1:length(regSubjList)
            SL_warp(C,beta_row,slradOpts(i),mTypes{j},regSubjList{k});
        end
    end
end
end

function BatchTtest(C,T)

cur_model_ID = 'm00000089';

modelI = strcmp(cur_model_ID,cellstr(T.model.model_ID));
betaI = strcmp(cur_model_ID,cellstr(T.betas.model_ID));
rsI = strcmp(T.betas.beta_ID(betaI,:),cellstr(T.rs.beta_ID));


model_row = T.model(modelI,:);
beta_row = T.betas(betaI,:);
rs_row = T.rs(rsI,:);


slradOpts = [4 3 2];
mTypes =  {'v3','ash_lfseg_corr_usegray'};
regSubjList = {'S1_A','S5_A','S21_B','S16_A'};

condsList =  {
     {'same','diff1'}
     {'same','diff2'}
     {'same','diff_all'}
     {'same_N','same_T'}
     {'N','T'}
     
    };

for i = 1:length(slradOpts)
    for j = 1:length(mTypes)
        for k =1:length(regSubjList)
            for l = 1:length(condsList)
                
                disp(['TTEST: ','slrad ',num2str(slradOpts(i)),', ',mTypes{j},', ',regSubjList{k},', ',condsList{l}{1},'-',condsList{l}{2}])
            SL_analysis_ttest(C,beta_row,slradOpts(i),mTypes{j},regSubjList{k},...
                condsList{l});
            end
        end
    end
end

end



function BatchCluster(C,T)

cur_model_ID = 'm00000089';

modelI = strcmp(cur_model_ID,cellstr(T.model.model_ID));
betaI = strcmp(cur_model_ID,cellstr(T.betas.model_ID));
rsI = strcmp(T.betas.beta_ID(betaI,:),cellstr(T.rs.beta_ID));


model_row = T.model(modelI,:);
beta_row = T.betas(betaI,:);
rs_row = T.rs(rsI,:);


slradOpts = [4 3 2];
mTypes =  {'v3','ash_lfseg_corr_usegray'};
regSubjList = {'S5_A','S21_B','S16_A','S1_A'};

condsList =  {
     {'same','diff1'}
     {'same','diff2'}
     {'same','diff_all'}
     {'same_N','same_T'}
     {'N','T'}
     
    };

for i = 1:length(slradOpts)
    for j = 1:length(mTypes)
        for k =1:length(regSubjList)
            for l = 1:length(condsList)
            SL_cluster2(C,beta_row,slradOpts(i),mTypes{j},regSubjList{k},...
                condsList{l});
            end
        end
    end
end

end

function BatchTableCSV(C,T)

cur_model_ID = 'm00000089';

modelI = strcmp(cur_model_ID,cellstr(T.model.model_ID));
betaI = strcmp(cur_model_ID,cellstr(T.betas.model_ID));
rsI = strcmp(T.betas.beta_ID(betaI,:),cellstr(T.rs.beta_ID));


model_row = T.model(modelI,:);
beta_row = T.betas(betaI,:);
rs_row = T.rs(rsI,:);


slradOpts = [4 3 2];
mTypes =  {'ash_lfseg_corr_usegray'};
regSubjList = {'S1_A','S5_A','S21_B','S16_A'};

condsList =  {
     {'same','diff1'}
     {'same','diff2'}
     {'same','diff_all'}
     {'same_N','same_T'}
     {'N','T'}
     
    };

for i = 1:length(slradOpts)
    for j = 1:length(mTypes)
        for k =1:length(regSubjList)
            for l = 1:length(condsList)
            SL_buildTable(C,beta_row,slradOpts(i),mTypes{j},regSubjList{k},...
                condsList{l});
            end
        end
    end
end

end


function P = BatchCheckReg(C)

mTypes =  {'ash_lfseg_corr_usegray','v3'};
regSubjList = {'S5_A','S21_B','S16_A','S1_A'};
P = {};
    for j = 1:length(mTypes)
        for k =1:length(regSubjList)
            P = P;{SL_checkReg(C,mTypes{j},regSubjList{k})};
        end
    end
end

