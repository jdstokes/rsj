function CreateReportBehav
close all

%% Settings.   General settings
C = Study_greco2;
T = load(fullfile(C.dir.tables,'greco_tables.mat'));
C.subjects.subj2run= C.subjects.subj2inc; 


% Show matrix of performance as a function of trial type denoted by City
% comparison type (e.g. T-T, T-M ...etc.)


% AnalysisB_BehavMatrix(T);

% Compare dPrime based on T or N

% AnalysisB_dPrime1(T);
% AnalysisB_dPrime2(T);
% AnalysisB_dPrime3(T);
% AnalysisB_dPrime4(T);
% AnalysisB_same1(T);
% AnalysisB_same2(T);
% AnalysisB_diff1(T);
% AnalysisB_diff2(T);
% AnalysisB_diff3(T);
% AnalysisB_diff4(T);

% AnalysisB_byrun1(T);
% AnalysisB_byrun2(T);
AnalysisB_byrun3(T);
AnalysisB_byrun4(T);
AnalysisB_byrun5(T);
AnalysisB_byrun6(T);

end


function AnalysisB_dPrime1(T)

data{1,1} = T.behav.dprime_all_T;
data{2,1} = T.behav.dprime_all_N;
units = 'dprime';
labels = {'T','N'};
figure
StatBarPlot(data,'all',labels,units,0,[]);
title('T dprime all vs N dprime all');

end


function AnalysisB_dPrime2(T)

data{1,1} = T.behav.dprime_d1_T;
data{2,1} = T.behav.dprime_d1_N;
units = 'dprime d1';
labels = {'T','N'};
figure
StatBarPlot(data,'all',labels,units,0,[]);
title('T dprime d1  vs N dprime d1');

end

function AnalysisB_dPrime3(T)

filter = T.behav.dprime_all > 1;
[~, index] = sort(T.behav.dprime_all(filter));

data = (T.behav.dprime_all_T(filter) - T.behav.dprime_all_N(filter))./T.behav.dprime_all(filter);
[H P] =ttest(data)
figure
bar(data(index))
ax = gca;
ax.YLabel.String = 'Train Advantage Ratio';
ax.YLabel.FontSize = 20;
ax.XLabel.String = 'Individual subjects ranked by performance';
ax.XLabel.FontSize = 20;
title('Train Advantage Ratio: High performing subjects only');

end


function AnalysisB_dPrime4(T)

filter = T.behav.dprime_all <1 & T.behav.dprime_all > .2;
[~, index] = sort(T.behav.dprime_all(filter));

data = (T.behav.dprime_all_T(filter) - T.behav.dprime_all_N(filter))./T.behav.dprime_all(filter);
[H P] =ttest(data)
figure
bar(data(index))
ax = gca;
ax.YLabel.String = 'Train Advantage Ratio';
ax.YLabel.FontSize = 20;
ax.XLabel.String = 'Individual subjects ranked by performance';
ax.XLabel.FontSize = 20;
labels = {'T','N'};

title('Train Advantage Ratio: Low performing subjects only. Excluding 2 lowest');

end

function AnalysisB_same1(T)

filter = T.behav.dprime_all > 0;

data{1,1} = T.behav.same_T(filter);
data{2,1} = T.behav.same_N(filter);
units = 'accuracy';
labels = {'T','N'};
figure
StatBarPlot(data,'all',labels,units,0,[]);
title('T same vs N same (excluding two lowest)');
end

function AnalysisB_same2(T)

filter = T.behav.dprime_all > 1;

data{1,1} = T.behav.same_T(filter);
data{2,1} = T.behav.same_N(filter);
units = 'accuracy';
labels = {'T','N'};
figure
StatBarPlot(data,'all',labels,units,0,[]);
title('T same vs N same. High performaing');
end



function AnalysisB_diff1(T)

filter = T.behav.dprime_all > 0;

data{1,1} = T.behav.diff1_T(filter);
data{2,1} = T.behav.diff1_N(filter);
units = 'accuracy';
labels = {'T','N'};
figure
StatBarPlot(data,'all',labels,units,0,[]);
title('T diff1 vs N diff1 (excluding two lowest)');
end

function AnalysisB_diff2(T)

filter = T.behav.dprime_all > 1;

data{1,1} = T.behav.diff1_T(filter);
data{2,1} = T.behav.diff1_N(filter);
units = 'accuracy';
labels = {'T','N'};
figure
StatBarPlot(data,'all',labels,units,0,[]);
title('T diff1 vs N diff1. High performing');
end


function AnalysisB_diff3(T)

filter = T.behav.dprime_all > 0;

data{1,1} = T.behav.diff1_M_preT(filter);
data{2,1} = T.behav.diff1_M_preN(filter);
units = 'accuracy';
labels = {'T','N'};
figure
StatBarPlot(data,'all',labels,units,0,[]);
title('M preT diff1 vs M preN diff1. (excluding two lowest) ');
end

function AnalysisB_diff4(T)

filter = T.behav.dprime_all > 1;

data{1,1} = T.behav.diff1_M_preT(filter);
data{2,1} = T.behav.diff1_M_preN(filter);
units = 'accuracy';
labels = {'T','N'};
figure
StatBarPlot(data,'all',labels,units,0,[]);
title('M preT diff1 vs M preN diff1. High performing');
end


function AnalysisB_byrun1(T)

filter = T.behav.dprime_all > .2;

data{1,1} = T.behav.dprime_d1_r1(filter);
data{2,1} = T.behav.dprime_d1_r2(filter);
data{3,1} = T.behav.dprime_d1_r3(filter);
data{4,1} = T.behav.dprime_d1_r4(filter);


units = 'accuracy';
labels = {'run1','run2','run3','run4'};
figure
StatBarPlot(data,'all',labels,units,0,[]);
title('Dprime D1 X Run');


end


function AnalysisB_byrun2(T)

filter = T.behav.dprime_all > 1;
figure
labels = {'run1','run2','run3','run4'};


hold on
data(1) = nanmean(T.behav.dprime_d1_T_r1(filter));
data(2) = nanmean(T.behav.dprime_d1_T_r2(filter));
data(3) = nanmean(T.behav.dprime_d1_T_r3(filter));
data(4) = nanmean(T.behav.dprime_d1_T_r4(filter));
plot(data);

data(1) = nanmean(T.behav.dprime_d1_N_r1(filter));
data(2) = nanmean(T.behav.dprime_d1_N_r2(filter));
data(3) = nanmean(T.behav.dprime_d1_N_r3(filter));
data(4) = nanmean(T.behav.dprime_d1_N_r4(filter));
plot(data);

data(1) = nanmean(T.behav.dprime_d1_M_r1(filter));
data(2) = nanmean(T.behav.dprime_d1_M_r2(filter));
data(3) = nanmean(T.behav.dprime_d1_M_r3(filter));
data(4) = nanmean(T.behav.dprime_d1_M_r4(filter));
plot(data);

ax = gca;
ax.XTick= [1:4]
ax.YLabel.String = 'dprime d1';
ax.YLabel.FontSize = 20;
ax.XLabel.String = 'Run';
ax.XLabel.FontSize = 20;
title('dprime d1 by run (high performing)');
legend({'T','N','M'})


end


function AnalysisB_byrun3(T)

filter = T.behav.dprime_all > .2;
figure
labels = {'run1','run2','run3','run4'};


hold on
data(1) = nanmean(T.behav.same_T_r1(filter));
data(2) = nanmean(T.behav.same_T_r2(filter));
data(3) = nanmean(T.behav.same_T_r3(filter));
data(4) = nanmean(T.behav.same_T_r4(filter));
plot(data);

data(1) = nanmean(T.behav.same_N_r1(filter));
data(2) = nanmean(T.behav.same_N_r2(filter));
data(3) = nanmean(T.behav.same_N_r3(filter));
data(4) = nanmean(T.behav.same_N_r4(filter));
plot(data);

data(1) = nanmean(T.behav.same_M_r1(filter));
data(2) = nanmean(T.behav.same_M_r2(filter));
data(3) = nanmean(T.behav.same_M_r3(filter));
data(4) = nanmean(T.behav.same_M_r4(filter));
plot(data);

ax = gca;
ax.XTick= [1:4]
ax.YLabel.String = 'dprime d1';
ax.YLabel.FontSize = 20;
ax.XLabel.String = 'Run';
ax.XLabel.FontSize = 20;
title('same by run (excluding two low performing');
legend({'T','N','M'})


end


function AnalysisB_byrun4(T)

filter = T.behav.dprime_all > 1;
figure
labels = {'run1','run2','run3','run4'};


hold on
data(1) = nanmean(T.behav.same_T_r1(filter));
data(2) = nanmean(T.behav.same_T_r2(filter));
data(3) = nanmean(T.behav.same_T_r3(filter));
data(4) = nanmean(T.behav.same_T_r4(filter));
plot(data);

data(1) = nanmean(T.behav.same_N_r1(filter));
data(2) = nanmean(T.behav.same_N_r2(filter));
data(3) = nanmean(T.behav.same_N_r3(filter));
data(4) = nanmean(T.behav.same_N_r4(filter));
plot(data);

data(1) = nanmean(T.behav.same_M_r1(filter));
data(2) = nanmean(T.behav.same_M_r2(filter));
data(3) = nanmean(T.behav.same_M_r3(filter));
data(4) = nanmean(T.behav.same_M_r4(filter));
plot(data);

ax = gca;
ax.XTick= [1:4];
ax.YLabel.String = 'dprime d1';
ax.YLabel.FontSize = 20;
ax.XLabel.String = 'Run';
ax.XLabel.FontSize = 20;
title('same by run (high performing)');
legend({'T','N','M'})


end



function AnalysisB_byrun5(T)

filter = T.behav.dprime_all > .2;
figure
labels = {'run1','run2','run3','run4'};


hold on
data(1) = nanmean(T.behav.diff1_T_r1(filter));
data(2) = nanmean(T.behav.diff1_T_r2(filter));
data(3) = nanmean(T.behav.diff1_T_r3(filter));
data(4) = nanmean(T.behav.diff1_T_r4(filter));
plot(data);

data(1) = nanmean(T.behav.diff1_N_r1(filter));
data(2) = nanmean(T.behav.diff1_N_r2(filter));
data(3) = nanmean(T.behav.diff1_N_r3(filter));
data(4) = nanmean(T.behav.diff1_N_r4(filter));
plot(data);

data(1) = nanmean(T.behav.diff1_M_r1(filter));
data(2) = nanmean(T.behav.diff1_M_r2(filter));
data(3) = nanmean(T.behav.diff1_M_r3(filter));
data(4) = nanmean(T.behav.diff1_M_r4(filter));
plot(data);

ax = gca;
ax.XTick= [1:4]
ax.YLabel.String = 'acc';
ax.YLabel.FontSize = 20;
ax.XLabel.String = 'Run';
ax.XLabel.FontSize = 20;
title('diff1 by run (excluding two low performing)');
legend({'T','N','M'})


end

function AnalysisB_byrun6(T)

filter = T.behav.dprime_all > 1;
figure
labels = {'run1','run2','run3','run4'};


hold on
data(1) = nanmean(T.behav.diff1_T_r1(filter));
data(2) = nanmean(T.behav.diff1_T_r2(filter));
data(3) = nanmean(T.behav.diff1_T_r3(filter));
data(4) = nanmean(T.behav.diff1_T_r4(filter));
plot(data);

data(1) = nanmean(T.behav.diff1_N_r1(filter));
data(2) = nanmean(T.behav.diff1_N_r2(filter));
data(3) = nanmean(T.behav.diff1_N_r3(filter));
data(4) = nanmean(T.behav.diff1_N_r4(filter));
plot(data);

data(1) = nanmean(T.behav.diff1_M_r1(filter));
data(2) = nanmean(T.behav.diff1_M_r2(filter));
data(3) = nanmean(T.behav.diff1_M_r3(filter));
data(4) = nanmean(T.behav.diff1_M_r4(filter));
plot(data);

ax = gca;
ax.XTick= [1:4]
ax.YLabel.String = 'acc';
ax.YLabel.FontSize = 20;
ax.XLabel.String = 'Run';
ax.XLabel.FontSize = 20;
title('diff1 by run (excluding two low performing)');
legend({'T','N','M'})


end
