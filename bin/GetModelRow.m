function modelRow = GetModelRow(score_row,T)
betaIDCell = cellstr(T.betas.beta_ID);
betaRow = T.betas(strcmp(score_row.beta_ID,betaIDCell),:);
modelIDCell = cellstr(T.model.model_ID);
modelRow = T.model(strcmp(betaRow.model_ID,modelIDCell),:);
end
