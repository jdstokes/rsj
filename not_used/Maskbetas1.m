function Maskbetas(subj,C)
%Input: 
%       Single Trial Beta Model SPMs
%       ROIs
%Output:
%       ROI masked, Single Trial Betas       

% Setup C variables
dir_analysis = C.dir.ana_models;
dir_rs = C.dir.ana_rs;
spm_modelName = C.spm.modelName;
spm_smooth = C.spm.smooth;
dir_mask = C.dir.dat_mask;
maskType = C.masks.maskType;
maskAll = C.masks.maskAll;
super_mask = C.spm.roi_mask_name;

spm_mask = C.spm.mask;
spm_hpf = C.spm.hpf;
spm_response_function = C.spm.response_function;


% input

switch spm_response_function            
    case {'none','hrf'}
        ipBetaDir = fullfile(dir_analysis, spm_modelName,subj,super_mask,...
            spm_mask,['hpf',num2str(spm_hpf)],spm_response_function, ...
            spm_smooth);
    case {'fir'}
        opDir = fullfile(dir_analysis, spm_modelName,subj,super_mask,...
            spm_mask,['hpf',num2str(spm_hpf)],...
            ['fir',num2str(spm_fir_length),'_',num2str(spm_fir_order)],...
            spm_smooth);
end    



ipMaskDir = fullfile(dir_mask,maskType,subj);

% ouput
opDir = fullfile(dir_rs,spm_modelName,subj,super_mask,...
            spm_mask,['hpf',num2str(spm_hpf)],spm_response_function, ...
            spm_smooth,maskType,'betas','none'); %output directory

%  Start process
load(fullfile(ipBetaDir,'SPM.mat'));
beta_tag = 'Run';

rgs=SPM.xX.name'; %(extract regressor names)
bts={SPM.Vbeta.fname}';%(list all beta.nii names)
clear SPM
cnt=0;

for i=1:length(rgs)
    if strfind(rgs{i},beta_tag)%TRIAL CODE
        cnt=cnt+1;
        data.name_beta{cnt,1}=bts{i};
        data.name_reg{cnt,1}=rgs{i};
        hold =fmris_read_nifti(fullfile(ipBetaDir,bts{i}));
        data.img{cnt,1} = hold.data;
        clear hold
    end
end

%%Cycle through each ROI
betas_masked = cell(size(maskAll));
for i=1:size(maskAll)
   m = LoadMask(ipMaskDir,['r',maskAll{i}]);
   CheckMaskDim(maskAll,size(m),size(data.img{1}))
   betas_masked{i,1} = ApplyMask(m,data.img);
end
    
roi_key=maskAll; %#ok<NASGU>
%%Save .mat
if ~exist(opDir,'dir'),mkdir(opDir);end
save(fullfile(opDir,[subj, '_betas']),'betas_masked','roi_key');  %save betas
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
      

    











