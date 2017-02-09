function BuildSuperMask_ash(subj,C)


     matlabbatch = batch_super_mask(subj,C);
    spm_jobman('initcfg')
    spm('defaults', 'FMRI');
    spm_jobman('serial', matlabbatch);  
end




function [matlabbatch]=batch_super_mask(subj,C)

dir_mask =C.dir.dat_mask;
maskType = C.masks.maskType;

matlabbatch{1}.spm.util.imcalc.input = BuildMasks(subj,C);
matlabbatch{1}.spm.util.imcalc.output = 'super_mask_ash.nii';
matlabbatch{1}.spm.util.imcalc.outdir = {fullfile(dir_mask,maskType,subj)};
matlabbatch{1}.spm.util.imcalc.expression = 'i1+i2+i3+i4+i5+i6+i7+i8+i9+i10+i11+i12+i13+i14+i15+i16+i17+i18+i19+i20+i21+i22+i23+i24';

matlabbatch{1}.spm.util.imcalc.options.dmtx = 0;
matlabbatch{1}.spm.util.imcalc.options.mask = 0;
matlabbatch{1}.spm.util.imcalc.options.interp = 1;
matlabbatch{1}.spm.util.imcalc.options.dtype = 4;



end

function [output]=BuildMasks(subj,C)
dir_mask =C.dir.dat_mask;
maskAll = C.masks.maskAll;
maskType = C.masks.maskType;


 for i = 1:length(maskAll)
     output{i,1} = fullfile(dir_mask,maskType,subj,['r',maskAll{i},',1']) ; 
 end
     
end

