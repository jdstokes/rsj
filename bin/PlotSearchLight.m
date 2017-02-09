function PlotSearchLight
%Study properties
C = Study_greco2;


%Load tables
tableDir = C.dir.tables;
T = load(fullfile(tableDir,'greco_tables.mat'));

%Subject list
C.subjects.subj2run= C.subjects.subj2inc; %Override subj2run
subj2run = C.subjects.subj2run;

%Beta row ID
cur_model_ID = 'm00000089';
modelI = strcmp(cur_model_ID,cellstr(T.model.model_ID));
betaI = strcmp(cur_model_ID,cellstr(T.betas.model_ID));
rsI = strcmp(T.betas.beta_ID(betaI,:),cellstr(T.rs.beta_ID));
model_row = T.model(modelI,:);
beta_row = T.betas(betaI,:);
rs_row = T.rs(rsI,:);
%Registration type
repSubj = 'S16_A';
regType = 'reg_S16_A';
%img dim
imgDim = [120,120,36];

%categories of interest
cats = {'same','diff2'};


% data = GetClusterVals();

% Load warped cat image and mask using
%     function data = GetClusterVals
        
        
        thresh = .95;
        clust = 1;
        anaSLcomp = fullfile(C.dir.analysis,'searchLight',beta_row.beta_ID,...
            'sl_analysis',regType,['T_',cats{1},'_',cats{2}]);
        clusterDir = fullfile(anaSLcomp,['clusters',num2str(thresh)]);
        clusterNames = dir([clusterDir,'/*.nii']);
        
        
        
        for curCat = 1:length(cats)
            for subj = 1:length(subj2run)
                
                %Load cat
                anaSLcat = fullfile(C.dir.analysis,'searchLight',...
                    beta_row.beta_ID,subj2run{subj},regType);
                img = LoadImg(anaSLcat,['w_rs_cond_',cats{curCat},'.nii']);
                
                for clust = 1:length(clusterNames)
                    clusterImg = LoadImg(clusterDir,clusterNames(clust).name);
                    data{clust,curCat}(subj) = mean(img(logical(clusterImg)));
                end
            end
        end
%     end

%clusternames
for i = 1:length(clusterNames)
    cnames{i} = clusterNames(i).name;
    
end

cnames = FixStrings(cnames,{'_','.nii','ash'},{' ','',''});

save(fullfile(clusterDir,'forBarPlot'),'data','cnames','cats')


 StatBarPlot(data,'within',cnames,'rs',0,cats);




end