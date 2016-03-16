function rsj_spm_fixmasks(subj,C)


FixAffine(subj,C);
matlabbatch = batch_spec_template(subj,C);
spm_jobman('initcfg')
spm('defaults', 'FMRI');
spm_jobman('serial', matlabbatch);

end


function [matlabbatch]=batch_spec_template(subj,C)
dir_mri = C.dir.dir_mri;
hiresFold = C.spm.spm_hiresFold;
hiresFile = C.spm.spm_hiresFile;
matchedFold = C.spm.spm_matchedFold;
matchedFile = C.spm.spm_matchedFile;
coregFile = C.spm.spm_coregFile;


matlabbatch{1}.spm.spatial.coreg.estimate.ref = {fullfile(dir_mri,subj,matchedFold,matchedFile)};
matlabbatch{1}.spm.spatial.coreg.estimate.source = {fullfile(dir_mri,subj,coregFile)};
matlabbatch{1}.spm.spatial.coreg.estimate.other = {''};
matlabbatch{1}.spm.spatial.coreg.estimate.eoptions.cost_fun = 'nmi';
matlabbatch{1}.spm.spatial.coreg.estimate.eoptions.sep = [4 2];
matlabbatch{1}.spm.spatial.coreg.estimate.eoptions.tol = [0.02 0.02 0.02 0.001 0.001 0.001 0.01 0.01 0.01 0.001 0.001 0.001];
matlabbatch{1}.spm.spatial.coreg.estimate.eoptions.fwhm = [7 7];
matlabbatch{2}.spm.spatial.coreg.estimate.ref(1) = cfg_dep;
matlabbatch{2}.spm.spatial.coreg.estimate.ref(1).tname = 'Reference Image';
matlabbatch{2}.spm.spatial.coreg.estimate.ref(1).tgt_spec{1}(1).name = 'filter';
matlabbatch{2}.spm.spatial.coreg.estimate.ref(1).tgt_spec{1}(1).value = 'image';
matlabbatch{2}.spm.spatial.coreg.estimate.ref(1).tgt_spec{1}(2).name = 'strtype';
matlabbatch{2}.spm.spatial.coreg.estimate.ref(1).tgt_spec{1}(2).value = 'e';
matlabbatch{2}.spm.spatial.coreg.estimate.ref(1).sname = 'Coregister: Estimate: Coregistered Images';
matlabbatch{2}.spm.spatial.coreg.estimate.ref(1).src_exbranch = substruct('.','val', '{}',{1}, '.','val', '{}',{1}, '.','val', '{}',{1}, '.','val', '{}',{1});
matlabbatch{2}.spm.spatial.coreg.estimate.ref(1).src_output = substruct('.','cfiles');
matlabbatch{2}.spm.spatial.coreg.estimate.source = {fullfile(dir_mri,subj,hiresFold,hiresFile)};
%%
matlabbatch{2}.spm.spatial.coreg.estimate.other = BuildMasks(subj,C);
%%
matlabbatch{2}.spm.spatial.coreg.estimate.eoptions.cost_fun = 'nmi';
matlabbatch{2}.spm.spatial.coreg.estimate.eoptions.sep = [4 2];
matlabbatch{2}.spm.spatial.coreg.estimate.eoptions.tol = [0.02 0.02 0.02 0.001 0.001 0.001 0.01 0.01 0.01 0.001 0.001 0.001];
matlabbatch{2}.spm.spatial.coreg.estimate.eoptions.fwhm = [7 7];
matlabbatch{3}.spm.spatial.coreg.write.ref = {fullfile(dir_mri,subj,coregFile)};
matlabbatch{3}.spm.spatial.coreg.write.source(1) = cfg_dep;
matlabbatch{3}.spm.spatial.coreg.write.source(1).tname = 'Images to Reslice';
matlabbatch{3}.spm.spatial.coreg.write.source(1).tgt_spec{1}(1).name = 'filter';
matlabbatch{3}.spm.spatial.coreg.write.source(1).tgt_spec{1}(1).value = 'image';
matlabbatch{3}.spm.spatial.coreg.write.source(1).tgt_spec{1}(2).name = 'strtype';
matlabbatch{3}.spm.spatial.coreg.write.source(1).tgt_spec{1}(2).value = 'e';
matlabbatch{3}.spm.spatial.coreg.write.source(1).sname = 'Coregister: Estimate: Coregistered Images';
matlabbatch{3}.spm.spatial.coreg.write.source(1).src_exbranch = substruct('.','val', '{}',{2}, '.','val', '{}',{1}, '.','val', '{}',{1}, '.','val', '{}',{1});
matlabbatch{3}.spm.spatial.coreg.write.source(1).src_output = substruct('.','cfiles');
matlabbatch{3}.spm.spatial.coreg.write.roptions.interp = 1;
matlabbatch{3}.spm.spatial.coreg.write.roptions.wrap = [0 0 0];
matlabbatch{3}.spm.spatial.coreg.write.roptions.mask = 0;
matlabbatch{3}.spm.spatial.coreg.write.roptions.prefix = 'r';

end

function [output]=BuildMasks(subj,C)
dir_mask =C.dir.dir_mask;
maskAll = C.masks.maskAll;
maskType = C.masks.maskType;


 for i = 1:length(maskAll)
     output{i,1} = fullfile(dir_mask,maskType,subj,[maskAll{i},',1']) ; 
 end
     
end

function FixAffine(subj,C)
dir_mri = C.dir.dir_mri;
dir_mask =C.dir.dir_mask;
maskAll = C.masks.maskAll;
hiresFold = C.spm.spm_hiresFold;
hiresFile = C.spm.spm_hiresFile;
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
