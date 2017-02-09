function newTable = FilterTableScores(T,F)
% Filter Table Scores
%   Table T is your table that possesses colnames F.names with values
%   F.vals. F.names and F.vals are cell arrays of equal lengths. F.vals
%   must be appropriate for F.names
%   Example:
% F.Names = {'spec_name','struct_reg','hpf','response_function'};
% F.Vals =  { 'STris_20',0,50,'hrf'};
%       Using this filter structure would result in a table consisting of
%       rows that contain these specific values within the respective
%       columns.

% Check inputs
if (length(F.Names) ~= length(F.Vals)) || ...
        (~iscell(F.Names) && ~iscell(F.Vals))
    error('colNames and colVals must be equal length cell arrays');
end



numScores = height(T.rs);
rmIndex = [];
for cS = 1:numScores

    scoreRow = T.rs(cS,:);
    modelRow = GetModelRow(scoreRow,T);
    
    %% Build filter rm index
    for curN = 1:length(F.Names)
    
        switch class(F.Vals{curN})
            case 'char'
                if ~any(strfind(modelRow.(F.Names{curN}),F.Vals{curN}))
                   rmIndex = [rmIndex; cS];
                end
            case 'double'
                if modelRow.(F.Names{curN}) ~= F.Vals{curN}
                   rmIndex = [rmIndex; cS];
                end    
        end 
    end  
    


end

newTable = T.rs;
newTable(rmIndex,:) = [];

end
