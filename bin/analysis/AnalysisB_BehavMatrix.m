function AnalysisB_BehavMatrix(T)
 data(1,1) = nanmean(T.behav.T_T);
 data(1,2) = nanmean(T.behav.T_M);
 data(1,3) = nanmean(T.behav.T_N);
 data(2,1) = nanmean(T.behav.M_T);
 data(2,2) = nanmean(T.behav.M_M);
 data(2,3) = nanmean(T.behav.M_N);
 data(3,1) = nanmean(T.behav.N_T);
 data(3,2) = nanmean(T.behav.N_M);
 data(3,3) = nanmean(T.behav.N_N);

figure;
imagesc(data);
ax = gca;
ax.YTick = [1 2 3];
ax.XTick = [1 2 3];
ax.YTickLabel ={'T pre','M pre','N pre'};
ax.XTickLabel ={'T post','M post','N post'};
ax.FontSize = 20;

colorbar;
title('Accuracy: Trial Pairs');

end