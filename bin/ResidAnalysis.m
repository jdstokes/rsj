function ResidAnalysis(C,stat_mode,betas_rows)


disp('updating plot...');

maskInd = GetMasksInd(C);


for curRow = 1:height(betas_rows)
    %Loop subjects
    for curSubj= 1:length(C.subjects.subj2run)
        
        
        subj=C.subjects.subj2run{curSubj};
        
        
        
        %Load scores (RS scores, mean beta scores)
        inDir =  fullfile(C.dir.analysis,'betas_masked',betas_rows.beta_ID(curRow,:));
        fName =  [subj, '_betasMasked'];
        B = load(fullfile(inDir,fName));
        
        
        %Loop masks
        numMasks = length(B.resid_masked);
        cntM = 0;
        for curMask = maskInd
            cntM = cntM+1;
            if ~isempty(B.resid_masked{curMask})
                data{cntM,curRow}(curSubj) =  mean(B.resid_masked{curMask},'omitnan');
            else
                data{cntM,curRow}(curSubj) = NaN;
            end
        end
    end
end
 
labels = strrep(cellstr(betas_rows.beta_ID),'b0000','');


StatBarPlot(data,stat_mode,labels,'residual',0,[]);

disp('Done!');
end

