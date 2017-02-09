function Check_residual(subj,C)
%CheckResidual Load and mask SPM residual images
%   Detailed explanation goes here

%%% Setup input variables
dir_mask =C.dir.dat_mask;
maskType = C.masks.maskType;
tt_all =  TT_greco(subj,C);
numRuns = length(tt_all.numTrialsByRun);

dir_mri = C.dir.dat_mri;
dir_rs = C.dir.ana_rs;
dir_analysis = C.dir.ana_models;
spm_funcFold = C.spm.funcFold;
spm_funcFile = C.spm.funcFile;
spm_modelName = C.spm.modelName;
spm_smooth = C.spm.smooth;
spm_motionFile = C.spm.motionFile;
spm_hpf = C.spm.hpf;
spm_mask = C.spm.mask;
super_mask = C.spm.roi_mask_name;
spm_response_function = C.spm.response_function;
maskAll = C.masks.maskAll;
spm_fir_length = C.spm.fir_length;
spm_fir_order = C.spm.fir_order;

%input/output
switch spm_response_function            
    case {'none','hrf'}
        ipBetaDir = fullfile(dir_analysis, spm_modelName,subj,super_mask,...
            spm_mask,['hpf',num2str(spm_hpf)],spm_response_function, ...
            spm_smooth);
        
        opDir = fullfile(dir_rs,spm_modelName,super_mask,spm_mask,...
     ['hpf',num2str(spm_hpf)],spm_response_function,spm_smooth,maskType,...
     'resid','none'); 
 
    case {'fir'}
        ipBetaDir = fullfile(dir_analysis, spm_modelName,subj,super_mask,...
            spm_mask,['hpf',num2str(spm_hpf)],...
            ['fir',num2str(spm_fir_length),'_',num2str(spm_fir_order)],...
            spm_smooth);
        
         opDir = fullfile(dir_analysis, spm_modelName,subj,super_mask,...
            spm_mask,['hpf',num2str(spm_hpf)],...
            ['fir',num2str(spm_fir_length),'_',num2str(spm_fir_order)],...
            spm_smooth);
        
        opDir = fullfile(dir_rs,spm_modelName,super_mask,spm_mask,...
     ['hpf',num2str(spm_hpf)],...
     ['fir',num2str(spm_fir_length),'_',num2str(spm_fir_order)],...
     spm_smooth,maskType,'resid','none');
end  


ipMaskDir = fullfile(dir_mask,maskType,subj);




% Load betas
load(fullfile(ipBetaDir,'SPM.mat'));
beta_tag1 = 'cond';

rgs=SPM.xX.name'; %(extract regressor names)
bts={SPM.Vbeta.fname}';%(list all beta.nii names)
clear SPM
cnt=0;

for i=1:length(rgs)
    if strfind(rgs{i},beta_tag1)%TRIAL CODE
        cnt=cnt+1;
        data.name_beta{cnt,1}=bts{i};
        data.name_reg{cnt,1}=rgs{i};
        hold =fmris_read_nifti(fullfile(ipBetaDir,bts{i}));
        data.img{cnt,1} = hold.data;
        rgs_of_interest{cnt,1} = rgs{i};
        clear hold
    end
end


% Mask Betas
betas_masked = cell(size(maskAll));
for i=1:size(maskAll)
   m = LoadMask(ipMaskDir,['r',maskAll{i}]);
   CheckMaskDim(maskAll,size(m),size(data.img{1}))
   betas_masked{i,1} = ApplyMask(m,data.img);
end
clear data m    


% Load reg
hold =fmris_read_nifti(fullfile(ipBetaDir,'ResMS.nii'));
reg.img{1} = hold.data;

% Mask reg
reg_masked = cell(size(maskAll));
for i=1:size(maskAll)
   m = LoadMask(ipMaskDir,['r',maskAll{i}]);
   CheckMaskDim(maskAll,size(m),size(reg.img{1}))
   reg_masked{i,1} = ApplyMask(m,reg.img);
end
clear data m 



roi_key=maskAll; %#ok<NASGU>



%%Save .mat
if ~exist(opDir,'dir'),mkdir(opDir);end
save(fullfile(opDir,[subj, '_resid']),'betas_masked','reg_masked','rgs_of_interest','roi_key');  %save betas
end

    
function mask = LoadMask(dir,mask_name)
    try
%         img=fmris_read_nifti(fullfile(dir,mask_name));
%         mask=img.data;
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
      



