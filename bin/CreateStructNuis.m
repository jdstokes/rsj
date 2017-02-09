function CreateStructNuis(subj,C)
% CreateStructNuis
%   Load Segmentation masks
%   Load preprocessed (but not smoothed)
%   Save to run specific text file

dir_mri = C.dir.dat_mri;
funcFold = C.spm.funcFold;
funcFile = C.spm.funcFile;
hiresFold = C.spm.hiresFold;
hiresFile = C.spm.hiresFile;

tt_all =  TT_greco(subj,C);
numRuns = length(tt_all.numTrialsByRun);


names = {'rc2','rc3','rc4'};

for curRun = 1: numRuns
    
    % Load mri
    imageFunc = spm_read_vols(spm_vol(fullfile(dir_mri,subj,[funcFold,...
        num2str(curRun)],['ra',funcFile])));
    % Get func image dimensions
    funcDim = size(imageFunc);
    
    for curSeg = 1: length(names)
        
        %Load seg image
        imageSeg = spm_read_vols(spm_vol(fullfile(dir_mri,subj,hiresFold,...
            [names{curSeg},hiresFile])));
        %Build logical seg filter 3D
        setFilter3D = imageSeg ~=0;
        %Exampand logical seg filter to 4D
        segFilter4D = repmat(setFilter3D,1,1,1,funcDim(4));
        %Instantiate mask as 4D nan matrix
        imageFuncMask = nan(size(imageFunc));
        %Apply filter
        imageFuncMask(segFilter4D) = imageFunc(segFilter4D);
        %Cycle through time points and calcuate Mean omitting nans
        for I = 1:funcDim(4)
            hold = imageFuncMask(:,:,:,I);
            segNuiScores(I,curSeg) = mean(hold(:),'omitnan');
        end
    end
  clear  hold I imageFuncMask segFilter4D setFilter3D imageSeg
    
  R = zscore(segNuiScores); 
  savefile = fullfile(dir_mri,subj,[funcFold,num2str(curRun)],'segCov.mat');
  save(savefile,'R','names')
  
  clear R segNuiScores imageFunc funcDim
end








   
  
   




