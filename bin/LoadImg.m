function [data,hdr] = LoadImg(dir,mask_name)
    try
         hdr = spm_vol(fullfile(dir,mask_name));
         data=spm_read_vols(hdr);
        clear img
    catch ME
        error(['Could not load mask ',mask_name]);
    end
end