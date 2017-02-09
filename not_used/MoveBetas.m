function MoveRsbetas(C)

% Setup C variables
dir_rs = GetValue(C,'dir_rs');
spm_modelName = GetValue(C,'spm_modelName');
spm_smooth = GetValue(C,'spm_smooth');
maskType = GetValue(C,'maskType');

spm_mask = GetValue(C,'spm_mask');
spm_hpf = GetValue(C,'spm_hpf');


      old_path = fullfile(dir_rs,spm_modelName,['hpf',num2str(spm_hpf)],spm_mask,spm_smooth,maskType,'betas');
      new_path =fullfile(old_path,'none'); 
      if ~exist(new_path,'dir')
          mkdir(new_path)
      end
    
      allfiles = dir(old_path);
for i = 1:length(allfiles)
    
    if ~isempty(strfind(allfiles(i).name,'_beta'))
       movefile(fullfile(old_path,allfiles(i).name),fullfile(new_path,allfiles(i).name));
       delete(fullfile(old_path,allfiles(i).name));
    end
end
