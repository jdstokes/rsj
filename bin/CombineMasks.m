function CombineMasks(subj,C)

%Setup parameters
maskType = C.masks.maskType; %Mask type
maskDir = fullfile(C.dir.dat_mask,maskType); %Mask directory



maskGroup{1} = {
    'rash_right_CA2.nii'
    'rash_right_CA3.nii'
    'rash_right_DG.nii'
    };


maskGroup{2} = {
    
'rash_left_CA2.nii'
'rash_left_CA3.nii'
'rash_left_DG.nii'
};


newMaskNames = {'rash_right_CA23DG.nii','rash_left_CA23DG.nii'};


for curGroup = 1:length(maskGroup)
    newMask =[];
    for curMask=1:size(maskGroup{curGroup})
        if isempty(newMask)
            [newMask, hdr] = LoadImg(fullfile(maskDir,subj),[maskGroup{curGroup}{curMask}]);
        else
            newMask = newMask + LoadImg(fullfile(maskDir,subj),[maskGroup{curGroup}{curMask}]);
        end
    end

        
        hdr.fname = fullfile(maskDir,subj,newMaskNames{curGroup});
        spm_write_vol(hdr,newMask);
        
        clear newMask hdr
end