function data = GetImgScores(C,cond_input,rs_ID,removeOL)

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
            if ~isempty(S.scores{curMask})
                scoresIndexed= S.scores{curMask}.(C.scores.score_type)(condIndex);
                if removeOL
                 scoresIndexed = RemoveOutliers(scoresIndexed);
                end
                data{cntM,cond}(curSubj) =  mean(scoresIndexed,'omitnan');
            else
                data{cntM,cond}(curSubj) = NaN;
            end
        end
    end
    
end


end


function data_clean = RemoveOutliers(data)
        Qs=quantile(data,[.25 .75]);
        Q1=Qs(1);
        Q3=Qs(2);
        Qr=Q3-Q1;
        OL_inds = data > (Q1 - Qr) |  data <(Q3 + Qr);
        data_clean = data(OL_inds);

end


