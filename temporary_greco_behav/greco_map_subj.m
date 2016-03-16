function scores=greco_map_subj(subject)


%Load coordinates for all subjects
M = greco_map_load_coords_subj(subject);
S=strsplit(subject,'_');

%% Analysis 1
di_all= get_di_all(M(1).subj_maps);
data_all(1,1:3) = min(di_all); %#ok<*AGROW>


%Sort by T,M,N
   
   if strcmp(S(2),'A')
       scores.D1_T(1) = data_all(1,1);
       scores.D1_N(1) = data_all(1,3);
   elseif strcmp(S(2),'B')
       scores.D1_T(1) = data_all(1,3);
       scores.D1_N(1) = data_all(1,1);
   end
   scores.D1_M(1) = data_all(1,2);

% clear di_all data_all dataT dataN dataM plot_data
% 
% 
% %% Analysis 2
% %get high DI scores fore each subject
% di_all= get_di_all(M(1).subj_maps);
% [DI_high,~]=best_perm(di_all,3);
% data_all(1,1:3) =DI_high; %#ok<*AGROW>
% 
% 
% 
% %Sort by T,M,N  
%    if strcmp(S(2),'A')
%        scores.D2_T(1) = data_all(1,1);
%        scores.D2_N(1) = data_all(1,3);
%    elseif strcmp(S(2),'B')
%        scores.D2_T(1) = data_all(1,3);
%        scores.D2_N(1) = data_all(1,1);
%    end
%    scores.D2_M(1) = data_all(1,2);
% clear di_all data_all dataT dataN dataM plot_data
% 
% 
% 
% %% Analysis 3
% %get high DI scores fore each subject
% 
% 
% di_all= get_di_all(M(1).subj_maps);
% [DI_high,~]=best_perm2store(di_all);
% data_all(1,1:2) =DI_high; %#ok<*AGROW>
% 
% 
% 
% %Sort by T,N
% 
%    if strcmp(S(2),'A')
%        scores.D3_T(1) = data_all(1,1);
%        scores.D3_N(1) = data_all(1,2);
%    elseif strcmp(S(2),'B')
%        scores.D3_T(1) = data_all(1,2);
%        scores.D3_N(1) = data_all(1,1);
%    end
% clear di_all data_all dataT dataN dataM plot_data
 end

%% Get DI all
function di_all= get_di_all(map_data)

for i = 1:length(map_data)
    data = map_data(i); %#ok<*NASGU>
    
    for ii = 1:3
        
        di_all(i,ii) = get_di(data.x(:,ii+1),data.y(:,ii+1),data.x(:,1),data.y(:,1),'jared'); 

    end
    
end
end

function di = get_di(X,Y,A,B,type)
    switch type
        case 'bdr'
            data = bdr(X,Y,A,B);
            di=data.DI;
        case 'jared'
            TFORM = cp2tform([A B],[X Y],'affine');
            [A1,B1] = tformfwd(TFORM,A,B);

            MAP_poly = roipoly(ones(4000),round(X*10),round(Y*10));
            DRAW_poly = roipoly(ones(4000),round(A1*10),round(B1*10));
            overlap = MAP_poly == 1 & DRAW_poly ==1;
            map_sub = MAP_poly-DRAW_poly;
            MAPxs = map_sub == 1;
            DRAWxs = map_sub == -1;

            sh_perc_orig = (sum2(MAPxs+DRAWxs))/(sum2(MAP_poly));
            %                 sh_perc_xs  = (sum2(MAPxs+DRAWxs))/(sum2(overlap));
            di =sh_perc_orig;
    end
                
end

function [DI_high,mapID]=best_perm(di_all,num_maps)

plist = perms(1:num_maps);
for i = 1:size(plist,1)
    for j = 1:num_maps
    hold(i,j)= di_all(plist(i,j),j);
    end
    
end

[~,I]=min(mean(hold,2));

DI_high = hold(I,:);
mapID = plist(I,:);
end


function [DI_high, mapID] =best_perm2store(di_all)

plist = nchoosek(1:3,2);
for i = 1:size(plist,1)
   
    hold(i,1)= di_all(plist(i,1),1);
    hold(i,2)= di_all(plist(i,2),3);
    
end

[~,I]=min(mean(hold,2));

DI_high = hold(I,:);
mapID = plist(I,:);
    
end





