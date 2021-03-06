function TableMaskBetas



%load C
C = Study_greco2;

%Load table
tableDir = C.dir.tables;
T = load(fullfile(tableDir,'greco_tables.mat'));

%Choose subjects (to be modified
C.subjects.subj2run= {'S16_A','S9_A'}; %Override subj2run
% C.subjects.subj2run= C.subjects.subj2inc; %Override subj2run


%Setup parameters
maskType = C.masks.maskType; %Mask type
maskAll = C.masks.maskAll; %Mask names
maskDir = fullfile(C.dir.dat_mask,maskType); %Mask directory

%%Loop through subjects
subj2run =C.subjects.subj2run; %Subject list
for curSubj  = 1:length(subj2run)
    subj = subj2run{curSubj};
    numModels = height(T.model);
    
    %%Loop through Models
    for curModel = 46
        
        %%Configure C with parameters from Table
        C = ConfigureModelSpecs(C,T.model,curModel);
        
        %%Lookup model ID
        model_ID = T.model.model_ID(curModel,:);
        
        %%Initialize model directory
        modelDir = fullfile(C.dir.ana_models,model_ID,subj);
        
        %Create a beta_ID if it doesn't exist. Otherwise create a new
        %beta_ID. Then update the T.betas Table
        [beta_ID,T.betas] = LogBetaTable(T.betas,model_ID,maskType);
        
        betaDir  = fullfile(C.dir.analysis,'betas_masked',beta_ID);
        betaFile = fullfile(betaDir,[subj, '_betas.mat']);
        
        
        %Check to see if file exist
        if exist(betaFile,'file')
            disp([betaFile,[' exists']]);
            continue
        end
        
        %Build model directory if it doesn't exist
        if ~exist(betaDir,'dir'),mkdir(betaDir);end
        
        
        switch C.spm.model_type
            case {'Basic', 'STris'}
                model_spm = load(fullfile(modelDir,'SPM.mat'));
                rgs=model_spm.SPM.xX.name'; %(extract regressor names)
                bts={model_spm.SPM.Vbeta.fname}';%(list all beta.nii names)
                clear model_spm
                cnt=0;
                
                switch C.spm.model_type
                    case 'Basic'
                        beta_tag = 'Cond';
                    case 'STris'
                        beta_tag = 'Event';
                end
                
                
                %Load betas
                for i=1:length(rgs)
                    if strfind(rgs{i},beta_tag)%TRIAL CODE
                        cnt=cnt+1;
                        data.name_beta{cnt,1}=bts{i};
                        data.name_reg{cnt,1}=rgs{i};
                        hold =fmris_read_nifti(fullfile(modelDir,bts{i}));
                        data.beta_img{cnt,1} = hold.data;
                        clear hold
                    end
                end
                
                
                %Load residual
                hold =fmris_read_nifti(fullfile(modelDir,'ResMS.nii'));
                data.resid_img{1} = hold.data;
                clear hold
                
                
                %Cycle through each ROI
                betas_masked = cell(size(maskAll));
                for i=1:size(maskAll)
                    m = LoadMask(fullfile(maskDir,subj),['r',maskAll{i}]);
                    CheckMaskDim(maskAll,size(m),size(data.beta_img{1}))
                    betas_masked{i,1} = ApplyMask(m,data.beta_img);
                    resid_masked{i,1} = ApplyMask(m,data.resid_img);
                end
                
                roi_key=maskAll;
                
                
                %%Save .mat
                save(betaFile,'betas_masked','resid_masked','roi_key');
                
                
            case 'STmum'
                
                %Build a vector of all trial indices
                trialInds = GetTrialInds(subj,C);
                
                
                
                %Load betas
                for curEvent = trialInds
                    model_spm = load(fullfile(modelDir,['event_',num2str(curEvent)],'SPM.mat'));
                    rgs=model_spm.SPM.xX.name'; %(extract regressor names)
                    bts={model_spm.SPM.Vbeta.fname}';%(list all beta.nii names)
                    clear model_spm

                    
                    
                    %Declare beta tag of interest
                    beta_tag = ['Event_',num2str(curEvent)];
                    
                    for i=1:length(rgs)
                        if strfind(rgs{i},beta_tag)%TRIAL CODE
                            data.name_beta{curEvent,1}=bts{i};
                            data.name_reg{curEvent,1}=rgs{i};
                            hold =fmris_read_nifti(fullfile(modelDir,...
                                ['event_',num2str(curEvent)],bts{i}));
                            data.beta_img{curEvent,1} = hold.data;
                            clear hold
                        end
                    end
                    
                    
                    %Load residual(s)
                    hold =fmris_read_nifti(fullfile(modelDir,['event_',num2str(curEvent)],'ResMS.nii'));
                    data.resid_img{curEvent,1} = hold.data;
                    clear hold
                end
                
                %Cycle through each ROI
                betas_masked = cell(size(maskAll));
                for i=1:size(maskAll)
                    m = LoadMask(fullfile(maskDir,subj),['r',maskAll{i}]);
                    CheckMaskDim(maskAll,size(m),size(data.beta_img{1}))
                    betas_masked{i,1} = ApplyMask(m,data.beta_img);
                    resid_masked{i,1} = ApplyMask(m,data.resid_img);
                end
                
                roi_key=maskAll;
                
                
                %%Save .mat
                save(betaFile,'betas_masked','resid_masked','roi_key');
                
        end
    end
    
    %%Save Table
    betas = T.betas;
    model = T.model;
    rs = T.rs;
    save(fullfile(tableDir,'greco_tables.mat'),'betas','model','rs');
    
    
end
end

    
function mask = LoadMask(dir,mask_name)
    try
         mask=spm_read_vols(spm_vol(fullfile(dir,mask_name)));
        clear img
    catch ME
        error(['Could not load mask ',mask_name]);
    end
end

function CheckMaskDim(mask,mask_dim,image_dim)

    if mask_dim ~= image_dim
        error(['mask ',mask, ' voxel dimensions do not match Betas']);
    end
end



function  data_splice_R = ApplyMask(mask,data)

    mask_inds = find(mask~=0);
    data_splice = nan(length(data),length(mask_inds));
    for iBeta = 1:length(data)
        %Get mask index length
        data_splice(iBeta,1:length(mask_inds)) = data{iBeta}(mask_inds);    
    end
    
    data_splice_R = data_splice(:,~any(isnan(data_splice),1));
    clear data_splice mask_inds
end
      

    
%%Create a unique model ID
function [beta_ID,T] = LogBetaTable(T,model_ID,maskType)


%Check if table is empty
if isempty(T)
    beta_ID = ['b',sprintf('%08d', 1)];
    T.beta_ID = beta_ID;
    T.model_ID = model_ID;
    T.maskType = maskType;
else
    
    newT = table;
    newT.model_ID = model_ID;
    newT.maskType = maskType;
    
    %Check if entry exist
    intersectT = intersect(newT,T(:,2:end));

    if ~isempty(intersectT)
    ind_model_ID = find(strcmp(intersectT.model_ID,cellstr(T.model_ID)));
    ind_maskType = find(strcmp(intersectT.maskType,cellstr(T.maskType)));
    intersect_ind=intersect(ind_model_ID,ind_maskType);
    end
    
    
    
   if isempty(intersectT) || isempty(intersect_ind)
        numRows = height(T);
        all_ID = T.beta_ID;
        for i = numRows+1:1000
            rowID = ['b',sprintf('%08d', i)];
            if ~strcmp(rowID,all_ID)
                %Add ID to table
                beta_ID = rowID;
                break
            end
        end
        newT.beta_ID = beta_ID;
        T = [T;newT];
   else
       beta_ID = T.beta_ID(intersect_ind,:);
    end
end
end



function trialInds = GetTrialInds(subj,C)
tt_all =  TT_greco(subj,C);
tt = tt_all.spm;
clear tt_all

trialInds = [];

for runNum = 1:length(tt)
    trialInds = [trialInds,cell2mat(tt(runNum).EVENTNUM)];
end

end








