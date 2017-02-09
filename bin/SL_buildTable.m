function SL_buildTable(C,beta_row,slrad,maskType,repSubj,conds)
%img dim


% cluster threshold
thresh = .95;

%load rep subjects mask

maskAll = {
%                     'ash_left_35.nii'
%                     'ash_left_36.nii'
                    'ash_left_CA1.nii'
                    'ash_left_CA2.nii'
                    'ash_left_CA3.nii'
%                     'ash_left_CS.nii'
                    'ash_left_DG.nii'
%                     'ash_left_ERC.nii'
%                     'ash_left_MISC.nii'
%                     'ash_left_head.nii'
%                     'ash_left_subiculum.nii'
%                     'ash_left_tail.nii'
%                     'ash_right_35.nii'
%                     'ash_right_36.nii'
                    'ash_right_CA1.nii'
                    'ash_right_CA2.nii'
                    'ash_right_CA3.nii'
%                     'ash_right_CS.nii'
                    'ash_right_DG.nii'
%                     'ash_right_ERC.nii'
%                     'ash_right_MISC.nii'
%                     'ash_right_head.nii'
%                     'ash_right_subiculum.nii'
%                     'ash_right_tail.nii'

};


maskInds = LoadRepMaskInds(C,repSubj,maskType,maskAll);



% Get clusters
anaSLcomp = fullfile(C.dir.analysis,'searchLight',beta_row.beta_ID,...
    'sl_analysis',['radius_',num2str(slrad)],...
    ['warped_',maskType,'_',repSubj],...
    ['T_',conds{1},'_',conds{2}]);
clusterDir = fullfile(anaSLcomp,['clusters',num2str(thresh)]);
clusterNames = dir([clusterDir,'/*.nii']);

Trow = table;
Tall = table;
for clust = 1:length(clusterNames)
    Trow = table;
    Trow.name = {clusterNames(clust).name};
    clusterImg = LoadImg(clusterDir,clusterNames(clust).name);
    Trow.size = length(find(clusterImg));
    T= AddTableRow(find(clusterImg),maskInds,maskAll);
    Trow = [Trow, T];
    try
    Tall = [Tall;Trow];
    catch
        keyboard
    end
end

if height(Tall) >0
writetable(Tall,fullfile(clusterDir,[[conds{1},'_',conds{2}],'_rad',num2str(slrad),'_',repSubj,'.csv']));
end

end




function T= AddTableRow(clustI,maskInds,maskAll)

T =table;
maskAll = FixStrings(maskAll,{'.nii'},{''});
totalVox = length(clustI);
cnt = 0;
        for i = 1:length(maskInds)
            
            
           if ~isempty(intersect(clustI,maskInds{i}))
           disp(['total voxels: ',...
               num2str(length(clustI)), ' ',maskAll{i},...
               ' num voxels: ',num2str(length(intersect(clustI,maskInds{i})))])
          
           T.(maskAll{i}) =  length(intersect(clustI,maskInds{i}));
           cnt = cnt + length(intersect(clustI,maskInds{i}));
           else
            T.(maskAll{i}) = 0;   
           end
        end
        
T.other = totalVox - cnt;
        
               
end





function maskInds = LoadRepMaskInds(C,repSubj,maskType,maskAll)


maskDir = fullfile(C.dir.dat_mask,maskType); %Mask directory


   %Cycle through each ROI
        for i=1:size(maskAll)
           m = LoadImg(fullfile(maskDir,repSubj),['r',maskAll{i}]);
           maskInds{i} = find(m~=0);
        end


end