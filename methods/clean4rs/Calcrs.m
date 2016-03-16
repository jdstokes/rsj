function Calcrs(subj,C)


% Setup C variables
dir_rs = GetValue(C,'dir_rs');
spm_modelName = GetValue(C,'spm_modelName');
spm_smooth = GetValue(C,'spm_smooth');
maskType = GetValue(C,'maskType');
ol_v_method = GetValue(C,'ol_v_method');
ol_v = GetValue(C,'ol_v');

GetTT = str2func(['TT','_',C.name]);
tt_all = GetTT(subj,C);                                                                   %Import numTrials
numTrials = tt_all.numTrials; 
numTrialsByRun = tt_all.numTrialsByRun;clear tt_all;
spm_mask = GetValue(C,'spm_mask');
spm_hpf = GetValue(C,'spm_hpf');
feature_mask = GetValue(C,'rs_feature_mask');

% input
ipDir = fullfile(dir_rs,spm_modelName,['hpf',num2str(spm_hpf)],spm_mask,...
    spm_smooth,maskType,'betas',feature_mask);

% output
opDir = fullfile(dir_rs,spm_modelName,['hpf',num2str(spm_hpf)],spm_mask...
    ,spm_smooth,maskType,'betas',feature_mask,'scores',...
    ['OLSv_method_',ol_v_method],['OLSv_',ol_v]); 


% Start process
load(fullfile(ipDir,[subj, '_betas']));


% Voxel outlier replacement: Replace outlier voxels with mask mean

betas_masked_OLSv = cell(size(betas_masked)); %#ok<USENS>
outlier_perc = zeros(size(roi_key));
for i=1:length(roi_key)
    
    if ~isempty(betas_masked{i})%        Skip empty rois
        if size(betas_masked{i},2)>4%    ROI must have at least 5 voxels
            
         if strcmp(ol_v_method,'mask')
            [betas_masked_OLSv{i}, outlier_perc(i)] = ...
                OutlierRemovalMask(betas_masked{i},ol_v); 
         elseif strcmp(ol_v_method,'global')
           [betas_masked_OLSv{i}, outlier_perc(i)] = ...
               OutlierRemovalGlobalMean(betas_masked{i},ol_v); 
         elseif strcmp(ol_v_method,'none')
             betas_masked_OLSv{i} = betas_masked{i};
             outlier_perc(i) = NaN;
         else
             error('Incorrect correctOLSv_method');
         end

        end
    end
end


scores = cell(size(roi_key));
id = nchoosek(1:numTrials,2);

for i=1:length(roi_key)
 %Skip masks that are empty
 
    if ~isempty(betas_masked{i})
        
        
        if size(betas_masked{i},2)>4%Mask must have at least 5 voxels
            
            %RS
            ind=any(~isnan(betas_masked_OLSv{i}),1);
            roi_betas = betas_masked_OLSv{i}(:,ind);
            scores{i}.rs = 1-pdist(roi_betas,'correlation')';
            scores{i}.rsz = real(atanh(scores{i}.rs));
            %RS normalize runs
            numRuns = length(numTrialsByRun);
          
            for run = 1:numRuns
                if run ==1
                startCnt = 1;
                endCnt =numTrialsByRun(1);
                else
                    startCnt = endCnt+1;
                    endCnt = endCnt + numTrialsByRun(run);
                end
                 scoresHold = 1-pdist(roi_betas(startCnt:endCnt,:),'correlation')';
                 pairs = nchoosek(1:numTrialsByRun(run),2);
                 indHold = abs(pairs(:,1) - pairs(:,2)) ==1;
                 
                 scores{i}.rs_runNorm(startCnt) = NaN;
                 scores{i}.rsz_runNorm(startCnt) = NaN;
                 scores{i}.rs_runNorm(startCnt+1:endCnt,1)  = zscore(scoresHold(indHold));
                 scores{i}.rsz_runNorm(startCnt+1:endCnt,1)  = zscore(real(atanh(scoresHold(indHold))));
                 
                 clear scoresHold pairs indHold
            end
            clear run startCnt endCnt
            
            %Uni
            scores{i}.uni_m =  mean(roi_betas,2);
            scores{i}.uni_sd = std(roi_betas,0,2);
            
            %Mean Diff
            for ii=1:size(id,1)
               
                scores{i}.md(ii,1)=scores{i}.uni_m(id(ii,2)) - scores{i}.uni_m(id(ii,1));
            end
        end
    end
    clear roi_betas ind
end   

%%Save .mat
if ~exist(opDir,'dir'),mkdir(opDir);end
save(fullfile(opDir,[subj, '_scores']),'scores','outlier_perc');  %save betas
end


%% OutlierRemoval
function [data_clean,perc_data_rem]=OutlierRemovalMask(data,rem_type)
%data rows: timepoints
%data columns: voxels
    
    if strcmp(rem_type,'NO')
        OL_inds = false(size(data));
    elseif strcmp(rem_type,'IQR') || strcmp(rem_type,'IQRnan') || strcmp(rem_type,'IQRm')
        Qs=quantile(data,[.25 .75]);
        Q1=Qs(1,:);
        Q3=Qs(2,:);
        Qr=Q3-Q1;
        OL_inds = bsxfun(@lt, data, Q1 - Qr) | bsxfun(@gt, data,Q3 + Qr);
        clear Os Q1 Q3 Qr
    elseif strcmp(rem_type,'2SD') || strcmp(rem_type,'2SDnan') || strcmp(rem_type,'2SDm') 
        OL_inds = bsxfun(@lt, data, mean(data)- std(data)*2) | bsxfun(@gt, data, mean(data)+ std(data)*2);
    elseif strcmp(rem_type,'3SD') || strcmp(rem_type,'3SDnan') || strcmp(rem_type,'3SDm')
        OL_inds = bsxfun(@lt, data, mean(data)- std(data)*3) |  bsxfun(@gt, data, mean(data)+ std(data)*3);
    else
        error('Choose correct OLSm');
    end

    %Replace with mean or nan
    data_clean=data;
    if any(strcmp(rem_type,{'IQRm','2SDm','3SDm'}))
          colmeans = repmat(mean(data),size(data,1),1);
          data_clean(OL_inds)= colmeans(OL_inds);
          clear colmeans
    elseif any(strcmp(rem_type,{'IQRnan','2SDnan','3SDnan'}))
        data_clean(OL_inds)=NaN;
    else
        error('Choose correct OLS');
    end

    perc_data_rem = sum(OL_inds(:))/numel(data);%percentage of voxels removed
end
function [data_clean,perc_data_rem]=OutlierRemovalGlobalMean(data,rem_type)

     data_mean = mean(data(:));%includes all voxels within ROI across all images
     data_std =std(data(:));

    if strcmp(rem_type,'NO')
        OL_inds = false(size(data));
    elseif strcmp(rem_type,'IQR') || strcmp(rem_type,'IQRnan') || strcmp(rem_type,'IQRm')
        Qs=quantile(data(:),[.25 .75]);
        Q1=Qs(1);
        Q3=Qs(2);
        Qr=Q3-Q1;
        OL_inds = data < (Q1 - Qr) | data > (Q3 + Qr);
        clear Os Q1 Q3 Qr
    elseif strcmp(rem_type,'2SD') || strcmp(rem_type,'2SDnan') || strcmp(rem_type,'2SDm') 
        OL_inds=data < (data_mean-2*data_std) | data > (data_mean+2*data_std);
    elseif strcmp(rem_type,'3SD') || strcmp(rem_type,'3SDnan') || strcmp(rem_type,'3SDm')
        OL_inds=data < (data_mean-3*data_std) | data > (data_mean+3*data_std);
    else
        error('Choose correct OLSm');
    end

    %Replace with mean or nan
    data_clean=data;
    if strcmp(rem_type,'IQRm') || strcmp(rem_type,'2SDm') || strcmp(rem_type,'3SDm')
          data_clean(OL_inds)=data_mean;
    elseif ~isempty(strfind(rem_type,'nan'))
        data_clean(OL_inds)=NaN;
    else
        data_clean(OL_inds)=[];
 
    end

    data_numel = numel(data);
    perc_data_rem = sum(OL_inds(:))/data_numel;%percentage of voxels removed
end


