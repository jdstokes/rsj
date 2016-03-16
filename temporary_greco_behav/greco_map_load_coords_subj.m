function M = greco_map_load_coords_subj(subject)
%% Decription


    S = study_specs;
    work_dir = S.work_dir;
    key_stores = S.stores;
    coordinates = S.coordinates;
    clear S
    
   
        
        data= tdfread(fullfile(work_dir,[subject,'_MD_output.csv']));
        
        
        maps=unique(cellstr(data.Map_name));
       
        for i = 1: length(maps)
            ind = strcmp(maps{i},cellstr(data.Map_name));
         
            x = data.Position_x(ind);
            y = data.Position_z(ind);
            stores = cellstr(data.Store_name(ind,:));
            for store_key = 1:length(key_stores)
                for store_sub = 1:length(stores)
                    if strcmp(key_stores{store_key},stores{store_sub})
                       x(store_sub,2) = coordinates(1).x(store_key);
                       y(store_sub,2) = coordinates(1).y(store_key);
                       x(store_sub,3) = coordinates(2).x(store_key);
                       y(store_sub,3) = coordinates(2).y(store_key);
                       x(store_sub,4) = coordinates(3).x(store_key);
                       y(store_sub,4) = coordinates(3).y(store_key);
                    end
                end
                
            end
            
            
            subj_maps(i).stores = stores;
            subj_maps(i).x = x;
            subj_maps(i).y = y;
            clear stores x y
        end  
        
        M(1).subj_maps = subj_maps;
        clear subj_maps

    
