function C = ConfigureModelSpecs(C,model_row)
C.spm.modelName =  strtrim(model_row.spec_name);
C.spm.model_type = model_row.spec_name(1:5); %first five letters of ModelName
C.spm.hpf = model_row.hpf;
C.spm.smooth = model_row.smooth;
C.spm.mask = model_row.mask;
C.spm.roi_mask_name = strtrim(model_row.roi_mask_name);
C.spm.response_function = strtrim(model_row.response_function);
C.spm.fir_length = model_row.fir_length;
C.spm.fir_order = model_row.fir_order;
C.spm.movement_reg = model_row.movement_reg;
C.spm.struct_reg = model_row.struct_reg;
C.spm.art_repair = model_row.art_repair;
C.spm.all_runs = model_row.all_runs;
C.spm.global_scaling = model_row.global_scaling;
end
