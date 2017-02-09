function Excel2Table

%Load greco_tables.mat in order to check field names
C = Study_greco2;
tableDir = C.dir.tables;
% T = load(fullfile(tableDir,'greco_tables.mat'));

%Get table data for Models
fileName = fullfile(tableDir,'greco_tables_model.csv');
data = tdfread(fileName,',');
T.model = struct2table(data);


%Get table data for Betas
fileName = fullfile(tableDir,'greco_tables_betas.csv');
data = tdfread(fileName,',');
T.betas = struct2table(data);

%Get table data for RS
fileName = fullfile(tableDir,'greco_tables_rs.csv');
data = tdfread(fileName,',');
T.rs = struct2table(data);


%Get table data for Behav
fileName = fullfile(tableDir,'greco_tables_behav.csv');
data = tdfread(fileName,',');
T.behav = struct2table(data);

%Save .mat
model = T.model;
betas = T.betas;
rs = T.rs;
behav = T.behav;
save(fullfile(tableDir,'greco_tables.mat'),'model','betas','rs','behav');






