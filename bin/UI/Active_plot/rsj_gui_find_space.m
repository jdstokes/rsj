function rsj_gui_find_space(C)
    
  

          rspace.struct={'spm_modelName','spm_hpf','spm_mask','spm_smooth','maskType','scores','ol_v_method','ol_v'};
          rspace.options = cell(size(rspace.struct));
          
           curfold = C.dir.dir_model;
           folds = dir(curfold);
           subfolds =  GetSubFolders(folds);
           for i = length(subfolds)
           Struct.('spm_modelName'){i} = subfolds{i};
           end
           for i1 = 1:length(subfolds)
              curfold = fullfile(curfold,subfolds{i1});
              folds = dir(curfold);
              subfolds =  GetSubFolders(folds);
              for i2 = 1:length(subfolds)
              Struct.('spm_modelName'){i}.('spm_hpf'){i2} = subfolds{i2};
              end
               
           end


          for i = 1:length(path_all)
              for j = 1:length(rspace.struct)
                  curpath = strsplit(path_all{i},'/');
                  if j<=length(curpath)
                      if isempty(rspace.options{j})                
                          rspace.options{j} = curpath(j);
                      elseif ~any(strcmp(curpath(j),rspace.options{j}))
                         
                         rspace.options{j}(end+1,1) = curpath(j);
                      end
                  end
              end
              
          end
          

    end

    
    function subfolds =  GetSubFolders(folds)
    cnt=0;
    for i = 1:length(folds)
        if ~any(strcmp(folds(i).name,{'.','..','.DS_Store'}))
            cnt = cnt + 1;
            subfolds{cnt} = folds(i).name;
        end
    end
    end


