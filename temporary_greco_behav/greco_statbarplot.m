function [sig] = greco_statbarplot(data,comp)

% Groups and Elements (only matters for 2D matrix input):
% -number of rows is the number of groups
% -number of columns is the number of element
% Bar clusters columns By rows; trialtypes that you want positioned next to
% eachother, e.g., Columns should be TT (S,D1,D2) and rows would be ROIs
% (CA1,CA3,SUB)

sig = 0;
numGroups = size(data,1);
numElements = size(data,2);
[Dm,Dse]=GetSumStats(data);
bar_centers=PlotErrorBars(Dm,Dse); 

 if ~(numElements == 1 && numGroups ==1)   
     if strcmp(comp,'all') 
        sig=Compare_all(data,bar_centers);
     elseif strcmp(comp,'within')
         sig=Compare_within(data,bar_centers);  
     end
 end 

 

function [Dm,Dse]=GetSumStats(data)
    numGroups = size(data,1);
    numElements = size(data,2);

    for i = 1 : numGroups
        for j = 1 : numElements
            Dm(i,j) = nanmean(data{i,j});
            Dse(i,j) = nanstd(data{i,j})./sqrt(length(data{i,j}));
        end
    end



function sig = Compare_all(data,bar_centers)

sig= 0;
%Mean and se
[Dm,Dse]=GetSumStats(data);
%Vars
height0 = 1.05*max2(Dm+Dse);
dh = 0.03*max2(Dm+Dse);
numbars = numel(Dm);
comps = nchoosek(1:numbars,2);

 for i = 1: size(comps,1)
                    try
                        [h,p,~,~] = ttest(data{comps(i,1)},data{comps(i,2)});
                        if h==1
                            
                            plot([bar_centers(comps(i,1)),bar_centers(comps(i,2))],[height0,height0],'k','linewidth',1.5)
                            plot([bar_centers(comps(i,1)),bar_centers(comps(i,1))],[height0,height0-.3*dh],'k','linewidth',1.5)
                            plot([bar_centers(comps(i,2)),bar_centers(comps(i,2))],[height0,height0-.3*dh],'k','linewidth',1.5)
                            if p<=.01
                                plot(mean([bar_centers(comps(i,1)),bar_centers(comps(i,2))])-.1,height0+.3*dh,'b*','linewidth',1.5)
                                plot(mean([bar_centers(comps(i,1)),bar_centers(comps(i,2))])+.1,height0+.3*dh,'b*','linewidth',1.5)
                            else
                                plot(mean([bar_centers(comps(i,1)),bar_centers(comps(i,2))]),height0+.3*dh,'b*','linewidth',1.5)
                            end
                            height0 = height0+dh;
                        end
                    end
 end
 
function sig = Compare_within(data,bar_centers)
    sig = 0;
    %Mean and se
    [Dm,Dse]=GetSumStats(data);
    %Vars
    height0 = 1.05*max2(Dm+Dse);
    dh = 0.03*max2(Dm+Dse);

    numGroups = size(data,1);
    numElements = size(data,2);

    for i = 1 : numGroups
        for j1 = 1 : numElements-1
            for j2 = j1+1 : numElements
                
                      [h,p,c,t] = ttest(data{i,j1},data{i,j2});
                    if h==1
                        sig = 1;
                        plot([bar_centers(i,j1),bar_centers(i,j2)],[height0,height0],'k','linewidth',1.5)
                        plot([bar_centers(i,j1),bar_centers(i,j1)],[height0,height0-.3*dh],'k','linewidth',1.5)
                        plot([bar_centers(i,j2),bar_centers(i,j2)],[height0,height0-.3*dh],'k','linewidth',1.5)
                        if p<=.01
                            plot(mean([bar_centers(i,j1),bar_centers(i,j2)])-.1,height0+.3*dh,'b*','linewidth',1.5)
                            plot(mean([bar_centers(i,j1),bar_centers(i,j2)])+.1,height0+.3*dh,'b*','linewidth',1.5)
                        else
                            plot(mean([bar_centers(i,j1),bar_centers(i,j2)]),height0+.3*dh,'b*','linewidth',1.5)
                        end
                        height0 = height0+dh;
                    end
               
            end
        end
    end
    
 
function [centers] = PlotErrorBars(model_series,model_error)
%Plots bar graph with error bars. 

% h=bar(model_series,'FaceColor',[.4 .4 .4],'LineWidth',1.5);
h=bar(model_series,'FaceColor',[.4 .4 .4],'LineWidth',1.5);

% set(h,'BarWidth',.4);    % The bars will now touch each other
set(gca,'YGrid','on')
set(gca,'GridLineStyle','-')
hold on;
numgroups = size(model_series, 1); 
numbars = size(model_series, 2); 
groupwidth = min(0.8, numbars/(numbars+1.5));
centers = nan(size(model_series));
if numgroups ==1
    errorbar(h.XData,model_series,model_error, 'k', 'linestyle', 'none');
    centers = h.XData;
else
    for i = 1:numbars
        % Based on barweb.m by Bolu Ajiboye from MATLAB File Exchange
        x = (1:numgroups) - groupwidth/2 + (2*i-1) * groupwidth / (2*numbars);  % Aligning error bar with individual bar
        errorbar(x, model_series(:,i), model_error(:,i), 'k', 'linestyle', 'none');
        centers(1:numgroups,i)=x';
    end
    
    
end




