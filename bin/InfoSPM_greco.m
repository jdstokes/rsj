classdef InfoSPM_greco < InfoSPM
   

    methods
        function s = InfoSPM_greco(s)
            s.funcFold = 'func_run';
            s.funcFile = '0001epihippoperprunX4.nii';
            s.mprageFold = 'mprage';
            s.mprageFile = '0001mpragesagNS.nii';
            s.hiresFold = 'hires';
            s.hiresFile = '0001t2tsehippoperp.nii';
            s.matchedFold = 'matched';
            s.matchedFile = '0001epsegsematched.nii';
            s.motionFile = 'rp_a0001epihippoperprunX4.txt';
            s.structFile = 'segCov.mat';
            s.coregFile = 'func_run1/ra0001epihippoperprunX4.nii,1';
            s.modelName =[];
            s.hpf = [];
            s.smooth = {};       
            s.mask = [];
            s.roi_mask_name = [];
            s.response_function = [];
            s.model_type = [];
            
            
            %All
             s.modelName_all ={
                'Basic_allv1_0'
                'Basic_allv1_20'
                'Basic_allv2_0'
                'Basic_allv2_20'
                'Basic_SD1D2_0'
                'Basic_SD1D2_20'
                'STris_0'
                'STris_20'
                'STmum_0'
                'STmum_20'};
            
            s.smooth_all = {'s3ra','s2ra','s1ra','ra',};
            s.mask_all = {'m8','m3','m1','m0'};
            s.roi_mask_name_all = {'super_mask_ash'};
            s.model_type_all = {'basic','STris','STmum'};
            s.response_function_all = {'none','fir','hrf'};
            
            
       s.art_repair = [];
       s.movement_reg = [];
       s.struct_reg = [];
       s.all_runs = [];
       s.global_scaling = [];
            
            
            
        end
        
    end
    
    
end