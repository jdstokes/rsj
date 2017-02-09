function GroupBarPlot(C,cond_input,stat_mode,legend_label,rs_ID)




maskInd = GetMasksInd(C);



%Loop subjects
for curSubj= 1:length(C.subjects.subj2run)  

    subj=C.subjects.subj2run{curSubj};
    behavIndexAll = BehavData(subj,C,C.scores.mode).GetIndices;

    %Loop conditions
    for cond = 1:length(cond_input)

        % Converts 'cond_input' into correct trial code
        T = ConfigTrial(behavIndexAll,cond_input{cond}.input);
        condIndex  =   GetCondIndex(T,behavIndexAll,C);
        
       %Load scores (RS scores, mean beta scores)
        inDir =  fullfile(C.dir.analysis,'scores',rs_ID,subj);
        fName =  ['score_',C.scores.OL_type];
        S = load(fullfile(inDir,fName));
        
       
       
       %Loop masks
       numMasks = length(S.scores);
       cntM = 0;
        for curMask = maskInd
            cntM = cntM+1;
            if ~isempty(S.scores.{curMask})
                scoresIndexed= S.scores.{curMask}.(C.scores.score_type)(condIndex);
                data{cntM,cond}(curSubj) =  mean(scoresIndexed,'omitnan');
            else
                data{cntM,cond}(curSubj) = NaN;
            end
        end
        end

    end





labels = strrep(strrep(GetMasks(C),'.nii',''),'_','');


StatBarPlot(data,stat_mode,labels,'ps',0,legend_label);

disp('Done!');


