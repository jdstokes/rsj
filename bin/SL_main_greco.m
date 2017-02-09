function SL_main_greco(subj,C,beta_row,model_row,slrad)


warning off
%Load Betas (unmasked)
B = load(fullfile(C.dir.analysis,'betas_masked',beta_row.beta_ID,....
    [subj, '_betas.mat']));
RS_input= B.betas;
%Setup SL parameters
C.scores.mode = 'rs_pair';
C.scores.score_type = 'rsz';
maskAll = C.masks.maskAll; %Mask names
maskType = C.masks.maskType; %Mask type
maskDir = fullfile(C.dir.dat_mask,maskType); %Mask directory


%% Trial cagetory indices

% cond_labels = {'all','T_T','T_M','T_N','M_M','M_T','M_N','N_N','N_M','N_T',...
%     'same','diff_all','diff1','diff2','same_T','diff_all_T','diff1_T',...
%     'diff2_T','same_N','diff_all_N','diff1_N','diff2_N','same_M',...
%     'diff1_M','C1_C1','C1_C2','C1_C3','C2_C2','C2_C1','C2_C3','C3_C3',...
%     'C3_C2','C3_C1','all_r1','all_r2','all_r3','all_r4','same_r1',...
%     'same_r2','same_r3','same_r4','diff1_r1','diff1_r2','diff1_r3',...
%     'diff1_r4','same_T_r1','same_T_r2','same_T_r3','same_T_r4',...
%     'same_M_r1','same_M_r2','same_M_r3','same_M_r4','same_N_r1',...
%     'same_N_r2','same_N_r3','same_N_r4','diff1_T_r1','diff1_T_r2',...
%     'diff1_T_r3','diff1_T_r4','diff1_M_r1','diff1_M_r2','diff1_M_r3',...
%     'diff1_M_r4','diff1_N_r1','diff1_N_r2','diff1_N_r3','diff1_N_r4',...
%     'N','M','T'};

cond_labels = {'all'};

for cond = 1:length(cond_labels)
    cond_input{cond}.input = GetfMRITrialCode(cond_labels{cond});
end




behavIndexAll = BehavData(subj,C,C.scores.mode).GetIndices;
for cond = 1:length(cond_input)
    
    T = ConfigTrial(behavIndexAll,cond_input{cond}.input);
    condIndex{cond}  =   GetCondIndex(T,behavIndexAll,C);
    
end




%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
disp('Performing Searchlight...')
%Note: radius of 4 gives 139 points per search sphere
%radius of searchlight

slvoxvol = GetSLSize(slrad);% number of voxels in sphere
%expand parameter: this program loads in your masks and creates a
%volume in which to perform the SearchLight by filling in all the dead space
%between masks and expanding outside the boundaries of your masks by
%positive and negative expand(in voxels)
expand =4;
%replace data (+/-)outliers*stddeviation with mean
outliers = 3;
%RS values are calculated using dist =
%squareform(1-pdist(beta_either,'correlation'))
%RS is calculated with allevents x allevents then RS values
%are extracted and binned using sequential trial type vector
% RSM = 180 event by 180 event, each RS value contains correlation of
% entire SL sphere volume

%     for sub = substart:subend

disp(['Subject ',subj])
if exist('Time','var')
    disp([num2str(length(sub:subend)*Time/60),' minutes remaining'])
end


 [megamask, imgHdr] = SL_megamask(subj,C); 
 
 %%Let's try without megamask
%  megamask = ones(size(megamask));
 

%         spm_write_vol(hdr1,megamask);
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
                        try
                            collect(end+1) = megamask(I(iter)+i,J(iter)+j,K(iter)+k);
                            sphere1(end+1,:) = [I(iter)+i,J(iter)+j,K(iter)+k];
                        catch ME
%                             keyboard
                        end
                    end
                end
            end
        end
    end
    if length(find(collect==0))<1&&length(collect)>=slvoxvol
        searchlightinds(end+1) = indcol(iter);
        sphereinds{end+1}=sphere1;
    end
    collect=1;
    sphere1=[];
end
sphereindscol = [];
for search = 1:length(searchlightinds)
    hold =sub2ind(size(megamask),sphereinds{search}(:,1),sphereinds{search}(:,2),sphereinds{search}(:,3));
    try
    sphereindscol(:,end+1) = hold;
    catch M
%         keyboard
    end
    
    clear hold
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
        
        masked(1:sph_sz,event)=RS_input{event}(sphereindscol(:,search));
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
        RSsub=(1-pdist(masked2','correlation'))';
        RSsub =real(atanh(RSsub));
 
    catch ME
        
        RSsub=zeros(size(nchoosek(1:length(RS_input),2),1),1);
        count=count+1;
    end
    
    %%Searchlight results by condition
    
    for cond = 1 : length(condIndex)
        
        
        if search==1
            RS_img(cond).SLdata=zeros(size(megamask));
        end
        
        
        %% Remove outlier RS scores
        RS_scores = RSsub(condIndex{cond});
        
        Qs=quantile(RS_scores,[.25 .75]);
        Q1=Qs(1);
        Q3=Qs(2);
        Qr=Q3-Q1;
        NonOL_inds = RS_scores > (Q1 - Qr) & RS_scores < (Q3 + Qr);
        
        
        
        %Remove outliers
        RS_scores=RS_scores(NonOL_inds);
        
        
        RS_img(cond).SLdata(searchlightinds(search))=nanmean(RS_scores);
        %                     RS_img(iC).cond_name=cond(iC).name;
        
        clear RS_scores NonOL_inds Q1 Q3 Qr Qs
        
        
        
        
    end%RS_comps
    
    clearvars h1 v1 p1 t1 h2 v2 p2 t2 h3 v3 p3 t3
    clearvars RSsub masked  naninds  allnaninds  Searchmean  Searchstd  Searchcutoff  cutoffinds 
end%searchlight indice loop







%% Save out results and output SL images
slDir = fullfile(C.dir.analysis,'searchLight',beta_row.beta_ID,['radius_',num2str(slrad)],subj);
mkdir(slDir);

for cond=1:length(condIndex)
    hdrimg = imgHdr;
    hdrimg= rmfield(hdrimg,'pinfo');
    hdrimg.fname = fullfile(slDir,['rs_cond_' cond_labels{cond}  '.nii']);
    spm_write_vol(hdrimg,RS_img(cond).SLdata);
end




end

function slSize = GetSLSize(slrad)
slSize = 0;
for i = -slrad:slrad
    for j = -floor(sqrt((slrad^2)-(i^2))):floor(sqrt((slrad^2)-(i^2)))
        for k = -1:1%-floor(sqrt((slrad^2)-(i^2))):floor(sqrt((slrad^2)-(i^2)))
            if (i^2+j^2+k^2) <= (slrad^2)
%                 if (I(iter)+i) < size(megamask,1) && (J(iter)+j) < size(megamask,2) && (K(iter)+k) < size(megamask,3)
                    slSize = slSize +1;
%                 end
            end
        end
    end
end

end





