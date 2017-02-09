function P = SL_checkReg(C,maskType,repSubj)

%Get masks
maskAll = GetMasks(maskType);

%Input rep subjects ROIs
maskIndsR = LoadRepMaskInds(C,repSubj,maskType,maskAll);



%% Calc P for subjects
P = [];
for i = 1:length(C.subjects.subj2run)
subj = C.subjects.subj2run{i};
if strcmp(subj,repSubj)
    continue    
end
%Read in comparison subject warped ROIs
maskIndsW = LoadWarpMaskInds(C,subj,repSubj,maskType,maskAll);


%Calc percentage of voxels in each warped ROI included within the common space roi
cVox = cellfun(@intersect,maskIndsR,maskIndsW,'UniformOutput',false);
cS = cellfun(@length,cVox);
wS = cellfun(@length,maskIndsW);
P =[P ; sum(cS)/sum(wS)];

end

disp(['RepSubj: ',repSubj,', ','Mask type: ',maskType,', ','Score: ',...
    num2str(mean(P))]);

end

%   -   -   -   -   -   -   -   -   -   -   -   -   -   -   -   -   -   -
%    -   -   -   -   -   -   -   -   -   -   -   -   -   -   -   -   -   -
%   -   -   -   -   -   -   -   -   -   -   -   -   -   -   -   -   -   -
%    -   -   -   -   -   -   -   -   -   -   -   -   -   -   -   -   -   -




%% LoadRepMaskInds
function maskInds = LoadRepMaskInds(C,repSubj,maskType,maskAll)


maskDir = fullfile(C.dir.dat_mask,maskType); %Mask directory


   %Cycle through each ROI
        for i=1:size(maskAll)
           m = LoadImg(fullfile(maskDir,repSubj),['r',maskAll{i}]);
           maskInds{i,1} = find(m~=0);
        end


end

%% Load subject inds
function maskInds = LoadWarpMaskInds(C,subj,repSubj,maskType,maskAll)

%Warped map subject maask directory
maskDir = fullfile(C.dir.dat_mask,maskType,...
    ['SL_reg_',maskType,'_',repSubj],subj); 


   %Cycle through each ROI
        for i=1:size(maskAll)
           m = LoadImg(maskDir,['w_r',maskAll{i}]);
           maskInds{i,1} = find(m~=0);
        end
end

function M = GetMasks(maskType)
 

switch maskType
    case {'ash_lfseg_corr_usegray'}
        M ={
            %                     'ash_left_35.nii'
            %                     'ash_left_36.nii'
            'ash_left_CA1.nii'
%             'ash_left_CA2.nii'
%             'ash_left_CA3.nii'
            %                     'ash_left_CS.nii'
            'ash_left_DG.nii'
            %                     'ash_left_ERC.nii'
            %                     'ash_left_MISC.nii'
            %                     'ash_left_head.nii'
            %                     'ash_left_subiculum.nii'
            %                     'ash_left_tail.nii'
            %                     'ash_right_35.nii'
            %                     'ash_right_36.nii'
            'ash_right_CA1.nii'
%             'ash_right_CA2.nii'
%             'ash_right_CA3.nii'
            %                     'ash_right_CS.nii'
            'ash_right_DG.nii'
            %                     'ash_right_ERC.nii'
            %                     'ash_right_MISC.nii'
            %                     'ash_right_head.nii'
            %                     'ash_right_subiculum.nii'
            %                     'ash_right_tail.nii'
            
            };
    case {'v3'}
        M ={
            'L_CA1.nii'
            'L_CA3.nii'
            'L_SUB.nii'
            'L_PHC.nii'
            
            
            'R_CA1.nii'
            'R_CA3.nii'
            'R_SUB.nii'
            'R_PHC.nii'
            };
        
        
end
end