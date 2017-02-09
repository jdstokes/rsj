function[]=RS_SL_main_V2_new(RS)


% Load subject's RS file and Cond file
cd([RS.rs_dir,RS.subj]); load([RS.subj '_' RS.model_type '_' RS.smooth '_RS']);load([RS.subj '_conds_',num2str(RS.vars)]);load([RS.subj '_' RS.model_type '_' RS.smooth,'_conds',num2str(RS.vars),'_D','_',RS.dist_type]);
 

 
%% Spects
sub=RS.subj;
RS_input=RS_betas.data.raw;%input beta images
ScoT = 'data_z';


RS_comps ={
    
% 'CC_pair_S'
% 'CC_pair_D'
% 'CC_pair_D_1'
% 'CC_pair_D_2'
% 'CC_pair_S_C14'
% 'CC_pair_S_C23'
'CC_non_pair_S'
'CC_non_pair_D_1'
'CC_non_pair_D_2'
'CC_non_pair_D_3'

};


%% RS comp 

for iC = 1: length(RS_comps)
    
   cn=find(strcmp(RS_comps{iC},Cond_check(:,1)));
   cond(iC).name=RS_comps{iC};
   cond(iC).CC=RSC(cn).RScode;
     
end
      

clear Cond_check D RSC RS_comps V ScoT
    
    
 
%% Mask Stuff    
% RE-Load Masks
    for iMask=1:size(RS.maskList)
        masks_dir4subj=[RS.mask_dir, RS.subj];
        cd(masks_dir4subj);
        %% Read in mask and do some stuff
        try
            RS_betas.data.masks_CE_hdrs(iMask)=spm_vol(['r' RS_betas.subj '_' RS_betas.maskList{iMask}]);
            RS_betas.data.masks_CE{iMask}=RS_betas.data.masks(iMask).data;
        catch ME
            error(['Could not load mask ',RS_betas.maskList{iMask}]);
            
        end
    end
    

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    disp('Performing Searchlight...')
    %Note: radius of 4 gives 257 points per search sphere
    %radius of searchlight
    slrad = 3;
    slvoxvol = 31;% number of voxels in sphere
    %expand parameter: this program loads in your masks and creates a
    %volume in which to perform the SearchLight by filling in all the dead space
    %between masks and expanding outside the boundaries of your masks by
    %positive and negative expand(in voxels)
    expand = 2;
    %replace data (+/-)outliers*stddeviation with mean
    outliers = 3;
    %RS values are calculated using dist =
    %squareform(1-pdist(beta_either,'correlation'))
    %RS is calculated with allevents x allevents then RS values
    %are extracted and binned using sequential trial type vector
    % RSM = 180 event by 180 event, each RS value contains correlation of
    % entire SL sphere volume
    
%     for sub = substart:subend
        
        disp(['Subject ',sub])
        if exist('Time','var')
            disp([num2str(length(sub:subend)*Time/60),' minutes remaining'])
        end
%         clearvars TSTART Time
%         TSTART = tic;
%JS         cd([main_dir,'RSinput/']);
%         
        
        
%JS         load(['RSinput',subjects{sub}])
%         mmv2struct(RSinput)
%         %load condition identifiers from calcdist
%         spatcond = RSinput.Spatial.cond;
%         tempcond = RSinput.Temporal.cond;

      

        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%         cd([mask_dir,'sd',subjects1{sub},'/'])
        %%%%% This next bit loads a file header to use for writing data
        %%%%% images
%         hdr = spm_vol(['coregdsd',subjects1{sub},'_Left_CA1.nii']);

        hdr=RS_betas.data.masks_CE_hdrs(1);%Load first mask detes
        hdr1 = hdr;
        hdr1.fname = 'megamask.nii';
      
        hdr2 = hdr;
        hdr2.fname = 'Searchlight.nii';

        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        % Initialize megamask (total searchlight volume)
        megamask = zeros(size(RS_betas.data.masks_CE{1,1}));
        %combine all masks into megamask
        for i = 1:length(RS_betas.data.masks_CE)
            megamask = megamask + RS_betas.data.masks_CE{i};
        end
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
        for y = 1:size(megamask,2)
            for z = 1:size(megamask,3)
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
                    inds = max((inds(1)-expand),(1+size(megamask,1)/2)):min((inds(end)+expand),size(megamask,1));
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
                    inds = (inds(1)-expand):(inds(end)+expand);
                    z(inds) = 1;
                    megamask(x,y,:) = z;
                    clearvars inds
                end
            end
        end
        clearvars x y z inds
        spm_write_vol(hdr1,megamask);
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        % This section scans the sphere surrounding each point within megamask, if
        % the sphere contains all ones and contains slvoxvol points, the sphere
        % falls completely within the expanded mask and therefore is a valid searchlight
        % indice
        % - This sections outputs:
        %                   searchlightinds - list of all valid searchlight indices
        %                   sphereinds - list of all points within the searchlight
        %                        sphere associated with each searchlight ind [x y z]
        %                   sphereindscol - an array of spereinds where each column
        %                        contains a complete searchlight sphere to be used
        %                        for masking
        
        % sphereview(sphereindscol(:,searchlightind)) = searchlight mask
        % alternatively: functionaldata(sphereindscol(:,searchlightind)) = masked functional data
        
        searchlightview = zeros(size(megamask));
        sphereview = zeros(size(megamask));
        indcol = find(megamask==1);
        [I J K] = ind2sub(size(megamask),indcol);
        collect = 1;
        searchlightinds=[];
        sphere1 = [];
        sphereinds = {};
        for iter = 1:length(indcol)%Loop through each voxel in megamask
            for i = -slrad:slrad
                for j = -floor(sqrt((slrad^2)-(i^2))):floor(sqrt((slrad^2)-(i^2)))
                    for k = -1:1%-floor(sqrt((slrad^2)-(i^2))):floor(sqrt((slrad^2)-(i^2)))
                        if (i^2+j^2+k^2) <= (slrad^2)
                            if (I(iter)+i) < size(megamask,1) && (J(iter)+j) < size(megamask,2) && (K(iter)+k) < size(megamask,3)
                                collect(end+1) = megamask(I(iter)+i,J(iter)+j,K(iter)+k);
                                sphere1(end+1,:) = [I(iter)+i,J(iter)+j,K(iter)+k];
                            end
                        end
                    end
                end
            end
%             if length(find(collect==0))<1&&length(collect)>=slvoxvol
                searchlightinds(end+1) = indcol(iter);
                sphereinds{end+1}=sphere1;
%             end
            collect=1;
            sphere1=[];
        end
        sphereindscol = [];
        for search = 1:length(searchlightinds)
            sphereindscol(:,end+1) = sub2ind(size(megamask),sphereinds{search}(:,1),sphereinds{search}(:,2),sphereinds{search}(:,3));
        end
        
        %This section can be used to print some images to check that the searchlight is behaving
        %searchlightview(searchlightinds)=1;
        %sphereview(sphereindscol)=1;
        %spm_write_vol(hdr2,searchlightview);
        %hdr3 = hdr;
        %hdr3.fname='Searchlightvolume.nii';
        %spm_write_vol(hdr3,sphereview);
        
        %What we have so far:
        %   megamask is a slightly inflated, filled-in version of all masks
        %   searchlightinds is a column of all search points fitting within megamask
        %   sphereinds is collection of spheres associated with searchlightinds in 3d
        %   sphereindscol is sphereinds in 1d indices
        % Notes: much faster than previous version could skip some of the file
        %    writing to speed it up even faster.  Also some variables might not be
        %    necessary.
        % Next: want to copy format of masked_R, for each mask, masked_R is a
        %              num of voxels by num of events matrix of functional
        %              data.
        % Pre allocate Statistics images
        % These are t test images (you'll need one for each ttest you
        % perform)
    
        % Start searchlight
        count=0;
        clear masked masked2
        RS_img=struct;   
        perimg=struct;
        for search = 1:length(searchlightinds)
            
            allnaninds = [];
            
            for event = 1:length(RS_input)
                
                sph_sz(search) = size(sphereindscol(:,search),1); %size of sphere
                
                masked(1:sph_sz,event)=RS_input(event).data(sphereindscol(:,search));
                naninds = find(isnan(masked(:,event)));
                allnaninds = union(allnaninds,naninds);
                sph_nans(search) = size(find(isnan(masked(:,event))),1); %num NaNs in sphere
            end
            % Eliminate voxels containing nan for atleast one trial
            masked2=masked;
            masked2(allnaninds,:) = [];
            clear masked
            %             masked_T(allnanindsT,:) = [];
            
            % Replace outliers with mean
            Searchmean = mean(mean(masked2));
            %             SearchmeanT = mean(mean(masked_T));
            Searchstd = mean(std(masked2));
            %             SearchstdT = mean(std(masked_T));
            
            Searchcutoff = [-outliers*Searchstd+Searchmean outliers*Searchstd+Searchmean];
            %             SearchcutoffT = [-outliers*SearchstdT+SearchmeanT outliers*SearchstdT+SearchmeanT];
            
            cutoffinds = union(find(masked2>Searchcutoff(2)),find(masked2<Searchcutoff(1)));
            %             cutoffindsT = union(find(masked2_T>SearchcutoffT(2)),find(masked_T<SearchcutoffT(1)));
            masked2(cutoffinds) = Searchmean;
            %             masked_T(cutoffindsT) = SearchmeanT;
            
            %Now: we are ready to make a correlation matrix and follow the steps
            %from the pipeline to extract condition RS values
            % This would give us condition RS values at each searchlight
            % indice
            
            %Correlation Matrix-This is where RS happens
            
            
            try
                rsm = squareform(1-pdist(masked2','correlation'));
                RSsub=(1-pdist(masked2','correlation'))';
            catch ME
                
                rsm=zeros(size(masked2,2));
                RSsub=zeros(size(nchoosek(1:length(RS_input),2),1),1);
                count=count+1;
            end
            
            %%Searchlight results by condition
           
            for iC = 1 : length(cond)
                           
                        
                        if search==1
                            RS_img(iC).SLdata=zeros(size(megamask));
                        end
                
               
                        %% Remove outlier RS scores
                        RS_scores = RSsub(cond(iC).CC);
                        
                        Qs=quantile(RS_scores,[.25 .75]);
                        Q1=Qs(1);
                        Q3=Qs(2);
                        Qr=Q3-Q1;
                        NonOL_inds = RS_scores > (Q1 - Qr) & RS_scores < (Q3 + Qr);
                        
                        
                    
                    %Remove outliers
                    RS_scores=RS_scores(NonOL_inds);
                    
                    
                    RS_img(iC).SLdata(searchlightinds(search))=100*nanmean(RS_scores);
                    RS_img(iC).cond_name=cond(iC).name;
                    
                clear RS_scores NonOL_inds Q1 Q3 Qr Qs
                        
                                        
                        
                        
            end%RS_comps
            
            
            
%

            
            clearvars h1 v1 p1 t1 h2 v2 p2 t2 h3 v3 p3 t3
            clearvars masked  naninds  allnaninds  Searchmean  Searchstd  Searchcutoff  cutoffinds  rsm 
        end%searchlight indice loop
        SLinds=searchlightinds;
        %Copy header for ttest images and write all stats images
        mkdir([RS.sl_dir,sub])
        cd([RS.sl_dir,sub])

        
        
        
  %% Save out results and output SL images

  %Check if SL output folder exists
  if exist([RS.sl_dir RS.subj '/Searchlightoutput_OL2_new_Cl_' num2str(slrad)],'dir')
      
     rmdir([RS.sl_dir RS.subj '/Searchlightoutput_OL2_new_Cl_' num2str(slrad)],'s')
  end
     mkdir([RS.sl_dir RS.subj '/Searchlightoutput_OL2_new_Cl_' num2str(slrad)])   
         
     cd([RS.sl_dir RS.subj '/Searchlightoutput_OL2_new_Cl_' num2str(slrad)])
     
     

        for iC=1:length(cond)  
        hdrimg = hdr;
        hdrimg.fname = ['rs_cond_' RS_img(iC).cond_name  '.nii'];
        spm_write_vol(hdrimg,RS_img(iC).SLdata);
            
        end
     
        
%         
%     SL.SLinds = SLinds;
%     SL.sph_sz = sph_sz;
%     SL.sph_nans=sph_nans;
%     SL.RSimg=RSimg;
%     SL.perimg=perimg;   
%         

     
%     save('searchlight_RS','SL')
    cd(RS.script_dir)
    
