function data = GetImgScores(C,cond_input,rs_ID,removeOL)



maskInd = GetMasksInd(C);



%Loop subjects
for curSubj= 1:length(C.subjects.subj2run)
    
    subj=C.subjects.subj2run{curSubj};
      %Load scores (RS scores, mean beta scores)
        inDir =  fullfile(C.dir.analysis,'scores',rs_ID,subj);
        fName =  ['score_',C.scores.OL_type];
        S = load(fullfile(inDir,fName));
        G = load(fullfile(inDir,'score_guide'));
        
    
    %Loop conditions
    for cond = 1:length(cond_input)
         
        switch C.scores.score_type
            case 'rsz'
                condIndex = GetRSIndex(G.rs_guide,cond_input{cond});
            case 'uni_m'
                condIndex = GetUniIndex(G.uni_guide,cond_input{cond});
        end
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

function index = GetRSIndex(guide,cond)

indC = zeros(size(guide));
indR =  ones(size(guide));
switch cond
    
    
    case 'T-T'
        indC = FilterGuide(guide,'Cond_T');
        indC = all(indC,2);
    case 'N-N'
        indC = FilterGuide(guide,'Cond_N'); 
        indC = all(indC,2);
    case 'M-M'
        indC = FilterGuide(guide,'Cond_M'); 
        indC = all(indC,2);        
    case 'T-M'
        typeA = 'Cond_T';
        typeB = 'Cond_M';
        condA1 = FilterGuide(guide(:,1),typeA);   
        condA2 = FilterGuide(guide(:,2),typeA);
        condB1 = FilterGuide(guide(:,1),typeB);
        condB2 = FilterGuide(guide(:,2),typeB);        
        indC =(condA1 & condB2) + (condB1 & condA2);
    case 'N-M'
        typeA = 'Cond_N';
        typeB = 'Cond_M';
        condA1 = FilterGuide(guide(:,1),typeA);   
        condA2 = FilterGuide(guide(:,2),typeA);
        condB1 = FilterGuide(guide(:,1),typeB);
        condB2 = FilterGuide(guide(:,2),typeB);        
        indC =(condA1 & condB2) + (condB1 & condA2);
    case 'T-N'
        typeA = 'Cond_T';
        typeB = 'Cond_N';
        condA1 = FilterGuide(guide(:,1),typeA);   
        condA2 = FilterGuide(guide(:,2),typeA);
        condB1 = FilterGuide(guide(:,1),typeB);
        condB2 = FilterGuide(guide(:,2),typeB);        
        indC =(condA1 & condB2) + (condB1 & condA2);  
end  


indR =  ones(size(guide,1),1);
runT = {'Sn(1)','Sn(2)','Sn(3)','Sn(4)'};
for curRun = 1:length(runT)    
    hold = FilterGuide(guide,runT{curRun});
    indR(all(hold,2)) = 0;
    clear hold
end


index = logical(indR .* indC);

end


function index = FilterGuide(guide,phrase)
index = strfind(guide,phrase);
index = cellfun(@any, index);
end

function index = GetUniIndex(guide,cond)

index = FilterGuide(guide,cond);

end



