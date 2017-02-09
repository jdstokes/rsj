function data = GetImgScores(C,cond_input,rs_ID,removeOL,subtract)

maskInd = GetMasksInd(C);

%Loop subjects
for curSubj= 1:length(C.subjects.subj2run)
    
    subj=C.subjects.subj2run{curSubj};
    behavIndexAll = BehavData(subj,C,C.scores.mode).GetIndices;
    
    %Load scores (RS scores, mean beta scores)
    inDir =  fullfile(C.dir.analysis,'scores',rs_ID,subj);
    fName =  ['score_',C.scores.OL_type];
    S = load(fullfile(inDir,fName));
    
    
    %Loop conditions
    for cond = 1:length(cond_input)
        
        % Converts 'cond_input' into correct trial code
        T = ConfigTrial(behavIndexAll,cond_input{cond}.input);
        condIndex  =   GetCondIndex(T,behavIndexAll,C);
        

        
        %Loop masks
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


if subtract
    if ~mod( length(cond_input),2) ==0
        error('Need even number of conditions for subtraction');
        
    end
    
    cnt = 0;
    for cond = 1:2:length(cond_input)
        cnt = cnt+1;
        for curMask = 1:size(data,1)
            
        subData{curMask,cnt} = data{curMask,cond} - data{curMask,cond+1}; 
        end
        
    end
    
    data = subData;
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


