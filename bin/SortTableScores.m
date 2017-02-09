function newTable = SortTableScores(dataTable,colNames)

numScores = height(dataTable.rs);
newTable = dataTable.rs;

for curS = 1:length(colNames)
for cS = 1:numScores
    scoreRow = newTable(cS,:);
    modelRow = GetModelRow(scoreRow,dataTable);
    sorterValues(cS,1) = modelRow.(colNames{curS});
end

    [Y,I]= sort(sorterValues);
    
    newTable = newTable(I,:);
    clear sorterValues
end
end

