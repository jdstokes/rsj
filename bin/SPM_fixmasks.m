function SPM_fixmasks(subj,C)


FixAffine(subj,C);
matlabbatch = batch_spec_template(subj,C);
spm_jobman('initcfg')
spm('defaults', 'FMRI');
spm_jobman('serial', matlabbatch);

end


function [matlabbatch]=batch_spec_template(subj,C)
dir_mri = C.dir.dat_mri;
dir_mask = C.dir.dat_mask;

hiresFold = C.spm.hiresFold;
hiresFile = C.spm.hiresFile;
matchedFold = C.spm.matchedFold;
matchedFile = C.spm.matchedFile;
coregFile = C.spm.coregFile;


matlabbatch{1}.spm.spatial.coreg.estwrite.ref = {fullfile(dir_mri,subj,coregFile)};
matlabbatch{1}.spm.spatial.coreg.estwrite.source = {fullfile(dir_mri,subj,matchedFold,matchedFile)};
matlabbatch{1}.spm.spatial.coreg.estwrite.other = {''};
matlabbatch{1}.spm.spatial.coreg.estwrite.eoptions.cost_fun = 'nmi';
matlabbatch{1}.spm.spatial.coreg.estwrite.eoptions.sep = [4 2];
matlabbatch{1}.spm.spatial.coreg.estwrite.eoptions.tol = [0.02 0.02 0.02 0.001 0.001 0.001 0.01 0.01 0.01 0.001 0.001 0.001];
matlabbatch{1}.spm.spatial.coreg.estwrite.eoptions.fwhm = [7 7];
matlabbatch{1}.spm.spatial.coreg.estwrite.roptions.interp = 4;
matlabbatch{1}.spm.spatial.coreg.estwrite.roptions.wrap = [0 0 0];
matlabbatch{1}.spm.spatial.coreg.estwrite.roptions.mask = 0;
matlabbatch{1}.spm.spatial.coreg.estwrite.roptions.prefix = 'r';
matlabbatch{2}.spm.spatial.coreg.estwrite.ref(1) = cfg_dep('Coregister: Estimate & Reslice: Resliced Images', substruct('.','val', '{}',{1}, '.','val', '{}',{1}, '.','val', '{}',{1}, '.','val', '{}',{1}), substruct('.','rfiles'));
matlabbatch{2}.spm.spatial.coreg.estwrite.source = {fullfile(dir_mri,subj,hiresFold,hiresFile)};
matlabbatch{2}.spm.spatial.coreg.estwrite.other = BuildMasks(subj,C);
matlabbatch{2}.spm.spatial.coreg.estwrite.eoptions.cost_fun = 'nmi';
matlabbatch{2}.spm.spatial.coreg.estwrite.eoptions.sep = [4 2];
matlabbatch{2}.spm.spatial.coreg.estwrite.eoptions.tol = [0.02 0.02 0.02 0.001 0.001 0.001 0.01 0.01 0.01 0.001 0.001 0.001];
matlabbatch{2}.spm.spatial.coreg.estwrite.eoptions.fwhm = [7 7];
matlabbatch{2}.spm.spatial.coreg.estwrite.roptions.interp = 4;
matlabbatch{2}.spm.spatial.coreg.estwrite.roptions.wrap = [0 0 0];
matlabbatch{2}.spm.spatial.coreg.estwrite.roptions.mask = 0;
matlabbatch{2}.spm.spatial.coreg.estwrite.roptions.prefix = 'r';

matlabbatch{2}.spm.spatial.coreg.estwrite.roptions.prefix = 'r';


end

function [output]=BuildMasks(subj,C)
dir_mask =C.dir.dat_mask;
maskAll = C.masks.maskAll;
maskType = C.masks.maskType;


 for i = 1:length(maskAll)
     output{i,1} = fullfile(dir_mask,maskType,subj,[maskAll{i},',1']) ; 
 end
     
end

function FixAffine(subj,C)
dir_mri = C.dir.dat_mri;
dir_mask =C.dir.dat_mask;
maskAll = C.masks.maskAll;
hiresFold = C.spm.hiresFold;
hiresFile = C.spm.hiresFile;
maskType = C.masks.maskType;

    hdrstruct = spm_vol(fullfile(dir_mri,subj,hiresFold,hiresFile));
    
    for i=1:length(maskAll)
           
    hdr_m = spm_vol(fullfile(dir_mask,maskType,subj,maskAll{i}));
    img_m = spm_read_vols(hdr_m); 
    
    %reset mask affine matrices to structural affine matrices
    hdr_m.private.mat = hdrstruct.private.mat;
    hdr_m.private.mat0 = hdrstruct.private.mat0;
    hdr_m.mat = hdrstruct.mat;
    spm_write_vol(hdr_m,img_m);    
        
    clear  hdr_m img_m;
    end
end
