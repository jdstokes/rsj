function [megamask, hdr] = SL_megamask(subj,C)

maskAll = C.masks.maskAll; %Mask names
maskType = C.masks.maskType; %Mask type
maskDir = fullfile(C.dir.dat_mask,maskType); %Mask directory

dir_mri = C.dir.dat_mri;
hiresFold = C.spm.hiresFold;
hiresFile = C.spm.hiresFile;

% Load supermask
[megamask, hdr] = LoadImg(fullfile(maskDir,subj),'super_mask_ash.nii');    
% [~,hrHdr]     = LoadImg(fullfile(dir_mri,subj,hiresFold),['r',hiresFile]);    
% Expansion size
expand =4;

%This makes the mask uniform: all ones
inds = find(megamask>0);
megamask(inds) = 1;
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        % This section fills in gaps in megamask and expands mask radius by
        % expand(defined at top of Searchlight section)
        % This code creates a volume in each hemisphere and thus separates
        % the x dimension down the middle, you could alternatively skip this
        % distinction and create one big volume by deleting do x right and
        % modifying do x left to look like do y and do z
        
        %do x left
   
        for y = 1 : size(megamask,2)
            for z = 1 : size(megamask,3)
                x = megamask(1:(size(megamask,1)/2),y,z);
                inds = find(x>0);
                if length(inds)>1
                    inds = max((inds(1)-expand),1):min((inds(end)+expand),(size(megamask,1)/2));
                    x(inds) = 1;
                    megamask(1:(size(megamask,1)/2),y,z) = x;
                    clearvars inds
                end
            end
        end
        clearvars x y z inds
        %do x right
        for y = 1:size(megamask,2)
            for z = 1:size(megamask,3)
                x = megamask((1+size(megamask,1)/2):end,y,z);
                inds = find(x>0);
                if length(inds)>1
%                     inds =
%                     max((inds(1)-expand),(1+size(megamask,1)/2)):min((inds(end)+expand),size(megamask,1));
%                     Jared changed 10/8/16 discuss with colin think this
%                     was an error
                    inds = max((inds(1)-expand),1):min((inds(end)+expand),(size(megamask,1)/2));
                    x(inds) = 1;
                    megamask((1+size(megamask,1)/2):end,y,z) = x;
                    clearvars inds
                end
            end
        end
        clearvars x y z inds
        %do y
        for x = 1:size(megamask,1)
            for z = 1:size(megamask,3)
                y = megamask(x,:,z);
                inds = find(y>0);
                if length(inds)>1
                    inds = (inds(1)-expand):(inds(end)+expand);
                    y(inds) = 1;
                    megamask(x,:,z) = y;
                    clearvars inds
                end
            end
        end
        clearvars x y z inds
        %do z
        for x = 1:size(megamask,1)
            for y = 1:size(megamask,2)
                z = megamask(x,y,:);
                inds = find(z>0);
                if length(inds)>1
                    try
                    inds = (inds(1)-expand):(inds(end)+expand);
                    inds(inds < 2 |inds > size(megamask,3)) =[];
                    z(inds) = 1;
                    megamask(x,y,:) = z;
                    clearvars inds
                    catch ME
                        keyboard
                    end
                end
            end
        end
        clearvars x y z inds
