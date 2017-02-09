classdef InfoDir_greco < InfoDir
   properties
       dat_mri
       dat_behav
       dat_mask

       ana_behav
       ana_rs
       ana_models
              
   end
   methods
       function s = InfoDir_greco(main,name)
         s@InfoDir(main,name);
         %data types
         s.dat_mri = fullfile(s.data,'mri');
         s.dat_behav = fullfile(s.data,'behav/behav_scan');
         s.dat_mask = fullfile(s.data,'rois');
         
         %analysis types
         s.ana_behav = fullfile(s.analysis,'behav');
         s.ana_rs = fullfile(s.analysis,'rs');
         s.ana_models = fullfile(s.analysis,'models');
         
       end

   end
end