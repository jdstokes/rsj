
old_dir = '/Volumes/jdstokes/Dropbox/Data/dCER/rois/v1';
new_dir = '/Volumes/jdstokes/Dropbox/Data/dCER/rois/v1a';
  maskAll ={
                'L_CA1.nii'
                'L_CA3.nii'
                'L_EC.nii'
                'L_PC.nii'
                'L_PHC.nii'
                'L_SUB.nii'
                'R_CA1.nii'
                'R_CA3.nii'
                'R_EC.nii'
                'R_PC.nii'
                'R_PHC.nii'
                'R_SUB.nii'
                };

 subjAll  = {'ce103', 'ce104', 'ce105', 'ce106', 'ce107', 'ce108', 'ce109',...
            'ce111', 'ce112', 'ce113', 'ce114', 'ce115', 'ce116', 'ce117',...
            'ce118', 'ce119', 'ce120'};
        
        
  for i1 = 1: length(subjAll)
  contents = dir(fullfile(old_dir,subjAll{i1}));
  for i2 = 1:length(contents)
  if ~isempty(strfind(contents(i2).name,subjAll{i1})) 
      oldName = contents(i2).name;
      newName = strrep(contents(i2).name,[subjAll{i1},'_'],'');
      if ~ exist(fullfile(new_dir,subjAll{i1}),'dir')
          mkdir(fullfile(new_dir,subjAll{i1}));
      end
      movefile(fullfile(old_dir,subjAll{i1},oldName),fullfile(new_dir,subjAll{i1},newName));
      
      
  end
  end
  
  
  
  end