function StatMatplot(data,comp,units,cond_names,mask_names)


if strcmp(comp,'onesample')
    h_mat=Compare_one(data); 
end

m_mat=GetSumStats(data);


PlotMat(m_mat,h_mat,units,cond_names,mask_names);


end

function m_mat=GetSumStats(data)
    numMasks = length(data);
    numMasksHalf= numMasks*.5;

   indsL = fliplr(nchoosek(1:numMasksHalf,2));
   indsR = nchoosek(1:numMasksHalf,2);
   
   m_mat = nan(length(data)/2);
   
   for i = 1:length(indsL)
       m_mat(indsL(i,1),indsL(i,2)) =  nanmean(data{indsL(i,1),indsL(i,2)});
       m_mat(indsR(i,1),indsR(i,2)) =  nanmean(data{indsR(i,1)+(numMasksHalf),indsR(i,2)+(numMasksHalf)});
       test{indsL(i,1),indsL(i,2)} =[indsL(i,1),indsL(i,2)];
       test{indsR(i,1),indsR(i,2)} =[indsR(i,1)+(numMasksHalf),indsR(i,2)+(numMasksHalf)];
   end
   
 
end

function h_mat = Compare_one(data)

    
  
    numMasks = length(data);
    numMasksHalf =numMasks*.5;
    
    h_mat = nan(numMasksHalf); 
    
   indsL = fliplr(nchoosek(1:numMasksHalf,2));
   indsR = nchoosek(1:numMasksHalf,2);
   
   
   for i = 1:length(indsL)
      
           [h,~,~,~] = ttest(data{indsL(i,1),indsL(i,2)});
           if h==1
               h_mat(indsL(i,1),indsL(i,2))= 1;
               
           end
           [h,~,~,~] = ttest(data{indsR(i,1)+(numMasksHalf),indsR(i,2)+(numMasksHalf)});
            if h==1
               h_mat(indsR(i,1),indsR(i,2))= 1;
               
           end
   end
   
end
   
                     
                   
               
  
 
function PlotMat(data_mat,h_mat,units,cond_names,mask_names)
if length(cond_names)==2
    mat_title = strrep([cond_names{1},'-',cond_names{2}],'_',' ');
else
    mat_title = strrep(cond_names,'_',' ');
end

figure;
% subplot(2,1,2)
imagesc(h_mat);



fig=figure;

imagesc(data_mat);
% colormap(bone);
% colorbar
title([strrep(units,'_',' '),' ',mat_title]);
ax = gca;

ax.XTick =1:length(mask_names)*.5;
ax.YTick =1:length(mask_names)*.5;
ax.XTickLabel=strrep(mask_names(1:(length(mask_names)*.5)),'L','');
ax.YTickLabel=strrep(mask_names(1:(length(mask_names)*.5)),'L','');

% title([strrep(units,'_',' '),' ',mat_title]);
% ay = gca;
% 
% ay.XTick =1:length(mask_names)*.5;
% ay.YTick =1:length(mask_names)*.5;
% ay.XTickLabel=strrep(mask_names(1:(length(mask_names)*.5)),'L','');
% ay.YTickLabel=strrep(mask_names(1:(length(mask_names)*.5)),'L','');
% 
% response = fig2plotly(fig, 'filename', 'matlab-basic-heatmap');
% fig2plotly();
% plotly_url = response.url;

end

