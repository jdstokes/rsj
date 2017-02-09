classdef InfoMasks_greco < InfoMasks
    % InfoMasks_greco
    %   Properties:
    %       maskAll
    %       maskType
    %       maskType
    properties
    end
    
    methods
        function s = InfoMasks_greco
            s.maskType = 'ash_lfseg_corr_usegray';
            
            switch  s.maskType
                
                case {'ash_lfseg_corr_usegray','ash_lfseg_heur'...
                        'ash_lfseg_corr_nogray'}
                s.maskAll ={
                    'ash_left_35.nii'
                    'ash_left_36.nii'
                    'ash_left_CA1.nii'
                    'ash_left_CA2.nii'
                    'ash_left_CA3.nii'
                    'ash_left_CS.nii'
                    'ash_left_DG.nii'
                    'ash_left_ERC.nii'
                    'ash_left_MISC.nii'
                    'ash_left_head.nii'
                    'ash_left_subiculum.nii'
                    'ash_left_tail.nii'
                    
                    
                    'ash_right_35.nii'
                    'ash_right_36.nii'
                    'ash_right_CA1.nii'
                    'ash_right_CA2.nii'
                    'ash_right_CA3.nii'
                    'ash_right_CS.nii'
                    'ash_right_DG.nii'
                    'ash_right_ERC.nii'
                    'ash_right_MISC.nii'
                    'ash_right_head.nii'
                    'ash_right_subiculum.nii'
                    'ash_right_tail.nii'
%                     'ash_left_CA23DG.nii'
%                     'ash_right_CA23DG.nii'
                    
                    
                    };
                case {'v1','v2','v3'}
                    
                  maskAll ={
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
        
        
    end
end
