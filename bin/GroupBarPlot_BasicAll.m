function GroupBarPlot_BasicAll(C,rs_ID)

%% Display
disp('updating plot...');

%% Parameters
numRuns = 4;

%% ROIS.    Configure ROI indices
roiInd = GetMasksInd(C);



%% Subjects.   Loop subjects
for curSubj= 1:length(C.subjects.subj2run)  
    
    subj=C.subjects.subj2run{curSubj}; %subj ID
  
    
%% Scores.    Load scores (RS scores, mean beta scores)
       inDir =  fullfile(C.dir.analysis,'scores',rs_ID);
       fName =  [subj, '_scores'];
       S = load(fullfile(inDir,fName));
       cntM = 0;
        for curR = roiInd
            cntM = cntM+1;
            if ~isempty(S.scores.(C.scores.OL_type){curR})
                
                data{cntM,1}(curSubj) = mean(S.scores.none{curR}.uni_m);
            else
                data{cntM,1}(curSubj) = NaN;
            end
        end
end







labels = strrep(strrep(GetMasks(C),'.nii',''),'_','');


StatBarPlot(data,'none',labels,'mean beta',0,[]);

disp('Done!');


