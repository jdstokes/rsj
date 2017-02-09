function CalcScores(subj,C,rs_row,model_row)



%% Load data
betasDir = fullfile(C.dir.analysis,'betas_masked',rs_row.beta_ID);
B = load(fullfile(betasDir,[subj, '_betasMasked.mat']));
roi_key = B.roi_key;
scoreDir =  fullfile(C.dir.analysis,'scores',rs_row.rs_ID,subj);   


%% CheckFile. Check to see if output folder exists and if it does, abort
if exist(scoreDir), disp([scoreDir,' already exists']); return; end

%% Load masked betas
B = load(fullfile(betasDir,[subj, '_betasMasked.mat']));
clear betasDir

%% Get Trial information
for cR=1:length(B.roi_key)
    if ~isempty(B.betas_masked{cR})
        numTrials = size(B.betas_masked{cR},1);
        break
    end
end


GetTT = str2func(['TT','_',C.name]);
tt_all = GetTT(subj,C);                                                                   %Import numTrials
% numTrials = tt_all.numTrials; 
numTrialsByRun = tt_all.numTrialsByRun; %% Only to be used for ST models
clear tt_all GetTT

% outlier_removal_all = {'none','global_2SD','global_3SD','global_IQR',...
%     'voxel_2SD','voxel_3SD','voxel_IQR','old_2SD',...
%     'old_3SD','old_IQR'};
                   
                   outlier_removal_all = {'none','global_2SD','global_3SD','global_IQR',...
                       'voxel_2SD','voxel_3SD','voxel_IQR','old_2SD',...
                       'old_3SD','old_IQR'};
                   
%Model options
model_type = model_row.spec_name(1:5); 
response_function = model_row.response_function;

                   
                   
                   
                   
%% Coming soon
feature_mask_all ={};



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Remove outliers
 for cO = 1:length(outlier_removal_all)
     OL = outlier_removal_all{cO};
     betas_masked_OLS.(OL) = cell(size(B.roi_key));
     %Loop ROIs
     for cR=1:length(B.roi_key)         
         if ~isempty(B.betas_masked{cR})%        Skip empty rois
             if size(B.betas_masked{cR},2)>4%    ROI must have at least 5 voxels
           
                 betas_masked_OLS.(OL){cR} = ORmethod(B.betas_masked{cR},OL);
 
             end
         end
     end
 end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Get scores
id = nchoosek(1:numTrials,2);
uni_guide = B.name_reg;
rs_guide = B.name_reg(id);

    for cO = 1:length(outlier_removal_all)
        
        OL = outlier_removal_all{cO};
        scores = cell(size(B.roi_key));
        
   for cR=1:length(B.roi_key)     
    %Skip masks that are empty
    if ~isempty(betas_masked_OLS.(OL){cR})
        if size(betas_masked_OLS.(OL){cR},2)>4%Mask must have at least 5 voxels
            
        
        
            roi_betas = betas_masked_OLS.(OL){cR};

            scores{cR,1}.rs = 1-pdist(roi_betas,'correlation')';
            scores{cR,1}.rsz = real(atanh(scores{cR}.rs));
            scores{cR,1}.uni_m =  mean(roi_betas,2);
            scores{cR,1}.uni_sd = std(roi_betas,0,2);
            clear roi_betas
        end
    end
    clear roi_betas ind
    end
    
    
%% Residuals
% score_res = ScoreResiduals(B);

%% Save .mat
if ~exist(scoreDir,'dir'),mkdir(scoreDir);end
save(fullfile(scoreDir,['score_',OL]),'scores');  

end


save(fullfile(scoreDir,'score_guide'),'rs_guide','uni_guide');    

end


%% OutlierRemoval.
function  data_clean = ORmethod(data,rem_type)
%data rows: timepoints
%data columns: voxels
    
data_clean=data;

    switch rem_type
        case  'none'
        OL_inds = false(size(data));
        
        case 'voxel_IQR'
        Qs=quantile(data,[.25 .75]);
        Q1=Qs(1,:);
        Q3=Qs(2,:);
        Qr=Q3-Q1;
        OL_inds = bsxfun(@lt, data, Q1 - Qr) | bsxfun(@gt, data,Q3 + Qr);
        colmeans = repmat(mean(data),size(data,1),1);
        data_clean(OL_inds)= colmeans(OL_inds);
        case 'voxel_2SD'
        OL_inds = bsxfun(@lt, data, mean(data)- std(data)*2) | bsxfun(@gt, data, mean(data)+ std(data)*2);
        colmeans = repmat(mean(data),size(data,1),1);
        data_clean(OL_inds)= colmeans(OL_inds);
        case 'voxel_3SD'
        OL_inds = bsxfun(@lt, data, mean(data)- std(data)*3) |  bsxfun(@gt, data, mean(data)+ std(data)*3);
        colmeans = repmat(mean(data),size(data,1),1);
        data_clean(OL_inds)= colmeans(OL_inds);
        case 'global_IQR'
            data_mean = mean(data(:));%includes all voxels within ROI across all images
            data_std =std(data(:));
     
            Qs=quantile(data(:),[.25 .75]);
            Q1=Qs(1);
            Q3=Qs(2);
            Qr=Q3-Q1;
            OL_inds = data < (Q1 - Qr) | data > (Q3 + Qr);
            data_clean(OL_inds)=data_mean;
        
        case 'global_2SD'
            data_mean = mean(data(:));%includes all voxels within ROI across all images
            data_std =std(data(:));
                    OL_inds=data < (data_mean-2*data_std) | data > (data_mean+2*data_std);
                    data_clean(OL_inds)=data_mean;

        case 'global_3SD'
            data_mean = mean(data(:));%includes all voxels within ROI across all images
            data_std =std(data(:));
                    OL_inds=data < (data_mean-3*data_std) | data > (data_mean+3*data_std);
                    data_clean(OL_inds)=data_mean;
                    
        case 'old_IQR'
            data_mean = mean(data(:));%includes all voxels within ROI across all images
            data_std =std(data(:));
     
            Qs=quantile(data(:),[.25 .75]);
            Q1=Qs(1);
            Q3=Qs(2);
            Qr=Q3-Q1;
            OL_inds = data < (Q1 - Qr) | data > (Q3 + Qr);
            for curVox = 1:size(data_clean,2)
                if(any(OL_inds(:,curVox)))
                    data_clean(:,curVox) = NaN;
                end
            end
            
            data_clean(:,any(isnan(data_clean))) = [];
        case 'old_2SD'
            data_mean = mean(data(:));
            data_std =std(data(:));
            OL_inds=data < (data_mean-2*data_std) | data > (data_mean+2*data_std);
            for curVox = 1:size(data_clean,2)
                if(any(OL_inds(:,curVox)))
                    data_clean(:,curVox) = NaN;
                    
                end
            end
                        data_clean(:,any(isnan(data_clean))) = [];

        case 'old_3SD'
            data_mean = mean(data(:));
            data_std =std(data(:));
            OL_inds=data < (data_mean-3*data_std) | data > (data_mean+3*data_std);
            for curVox = 1:size(data_clean,2)
                if(any(OL_inds(:,curVox)))
                    data_clean(:,curVox) = NaN;
                    
                end
            end
            
                        data_clean(:,any(isnan(data_clean))) = [];

        otherwise
        error('Choose correct outlier method');
    end

 
%     %percentage of voxels removed

%      perc_data_rem = sum(OL_inds(:))/numel(data);
%      disp([rem_type,': ',num2str(perc_data_rem)]);
end


%% Score Residuals. Calc Mean, STD X mask
function scores = ScoreResiduals(B)
%Loop ROIs
for cR=1:length(B.roi_key)
    for cRes = 1: size(B.resid_masked{cR},1)
        %Skip empty rois
        if ~isempty(B.betas_masked{cR})
            
            %ROI must have at least 5 voxels
            if size(B.betas_masked{cR},2)>4
                
                scores{cR,1}.uni_m(cRes,1) =  mean(B.resid_masked{cR}(cRes,:),2);
                scores{cR,1}.uni_sd(cRes,1) = std(B.resid_masked{cR}(cRes,:),0,2);
            end
        else
             scores{cR,1} = [];
        end
    end
end
    
    
end



%% RS normalize runs
%             %Skip RS if 'basic' model type or 'fir' response function
%           if ~(strcmp(model_type,'Basic') || strcmp(response_function,'fir'))
%             numRuns = length(numTrialsByRun);
%           
%             for run = 1:numRuns
%                 if run ==1
%                 startCnt = 1;
%                 endCnt =numTrialsByRun(1);
%                 else
%                     startCnt = endCnt+1;
%                     endCnt = endCnt + numTrialsByRun(run);
%                 end
%                  scoresHold = 1-pdist(roi_betas(startCnt:endCnt,:),'correlation')';
%                  pairs = nchoosek(1:numTrialsByRun(run),2);
%                  indHold = abs(pairs(:,1) - pairs(:,2)) ==1;
%                  
% %                  scores{cR,1}.rs_runNorm(startCnt) = NaN;
% %                  scores{cR,1}.rsz_runNorm(startCnt) = NaN;
% % %                  scores{cR,1}.rs_runNorm(startCnt+1:endCnt,1)  = zscore(scoresHold(indHold));
% %                  scores{cR,1}.rsz_runNorm(startCnt+1:endCnt,1)  = zscore(real(atanh(scoresHold(indHold))));
%                  
%                  clear scoresHold pairs indHold
%             end
%             clear run startCnt endCnt