function SL_analysis_ttest(C,beta_row,slrad,maskType,repSubj,conds)


subjList = C.subjects.subj2run;
warpedfold = ['warped_',maskType,'_',repSubj];
imgDim = [120,120,36];  
% conds = {'same','diff1'};


%% Load warped SL images
condA = nan([length(subjList),imgDim]);
condB = nan([length(subjList),imgDim]);
for subj = 1:length(subjList)
anaDir = fullfile(C.dir.analysis,'searchLight',beta_row.beta_ID,['radius_',num2str(slrad)],subjList{subj},warpedfold);
try
condA(subj,:,:,:) = LoadImg(anaDir,['w_rs_cond_',conds{1},'.nii']);
condB(subj,:,:,:) = LoadImg(anaDir,['w_rs_cond_',conds{2},'.nii']);
catch
    keyboard
end
end

%% Load rep subject supermask
[megamask, hdrimg] = SL_megamask(repSubj,C); %Currently this is created from ASHs super mask
mmInd = find(megamask ==1);
ignoreInd =squeeze(~all(condA) & ~all(condB));

[H,P,~,STATS] =ttest(condA,condB);
H = squeeze(H);
P_1min = squeeze(P);
clear P
P_1min(mmInd) = (1 - P_1min(mmInd)); % 1 minus Pvalue
P_1min(ignoreInd) = 0;
T = squeeze(STATS.tstat);
T(ignoreInd) = 0;

clear STATS



anaDir = fullfile(C.dir.analysis,'searchLight',beta_row.beta_ID,...
    'sl_analysis',['radius_',num2str(slrad)],warpedfold,['T_',conds{1},'_',conds{2}]);
mkdir(anaDir);

hdrimg= rmfield(hdrimg,'pinfo');

hdrimg.fname = fullfile(anaDir,'P_1min.nii');
spm_write_vol(hdrimg,P_1min);


hdrimg.fname = fullfile(anaDir,'H.nii');
spm_write_vol(hdrimg,H);

hdrimg.fname = fullfile(anaDir,'T.nii');
spm_write_vol(hdrimg,T);

clear  P_1min T H

