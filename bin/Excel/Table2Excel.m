function Table2Excel
C = Study_greco2;
tableDir = C.dir.tables;
T = load(fullfile(tableDir,'greco_tables.mat'));
T.behav = CreateBehavPerfTable;

%Open model table
fileName = fullfile(tableDir,'greco_tables_model.csv');
writetable(T.model,fileName);
cd(tableDir);
system('open greco_tables_model.csv');

%Open betas table
fileName = fullfile(tableDir,'greco_tables_betas.csv');
writetable(T.betas,fileName);
cd(tableDir);
system('open greco_tables_betas.csv');

%Open rs table
fileName = fullfile(tableDir,'greco_tables_rs.csv');
writetable(T.rs,fileName);
cd(tableDir);
system('open greco_tables_rs.csv');


%Open behav table
fileName = fullfile(tableDir,'greco_tables_behav.csv');
writetable(T.behav,fileName);
cd(tableDir);
system('open greco_tables_behav.csv');


