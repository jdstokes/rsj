function rsj_rsa_group_cum_cw(C,cond_input,legend_label)
%//////////////////////////////////////////////////////////////////////////

%rsj_rsa_group functions typically compute means and plot graphs
%Inputs:    C
%           Cond_input

%//////////////////////////////////////////////////////////////////////////
%//////////////////////////////////////////////////////////////////////////

%%%%%%%%%%%%%%%%%%%%   BEGIN
%%

disp('updating...');

%% GETSCORES
score_name = 'test_angEr';
[dataI, dataP] = GetScores(cond_input,score_name);                                            %fMRI:{cond X mask} [1:numSubj]<img measure>

%% FITMODEL
[allX,allY]=FitModel;

%% BUILDSCAT
% BuildScat(C,allX,allY);
disp('finished!');

%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%--------------------
%--------------------
%--------------------      TOOLBOX
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Get them fMRI related scores(univarate,pw rs, all rs...maybe more)
function [I,P] = GetScores(cond_input,name)
subjInd = GetSubjsInd(C);
for i=subjInd   
    for cond = 1:length(cond_input)
        subj=C.subjects.subjAll{i};
        behav = C.tt.tt_func{C.tt.tt_val}(subj,C);
        T = rsj_rsa_trial_config(behav,cond_input{cond}.input);
        a = Grab_rsa(subj,C,T,behav);
        calc = str2func(C.rs.rs_calcOpts{C.rs.rs_calcCurr});
        
        I{i,cond}  = calc(a);
        P{i,cond}=behav.(name)(Get_scores_ind(a));
    end
end

end



%%Fits model using GLMfit(basic)
    function [allX,allY]= FitModel
      
        for iM =1:NumMasksAll(C) 
              Y = [];
        X1 = [];
        X2 =[];
        %All masks
            for i1=1:size(dataI,1)
                numTri =length(dataI{i1}(:,1));
                Y =[Y;dataI{i1}(:,iM)];
                X1 = [X1;repmat(i1,numTri,1)];
                X2 = [X2;dataP{i1}];
            end
            data_table = table(nominal(X1),X2,Y);
            
            GLM{iM}=fitglm(data_table,'Y ~ X2 + Var1');
            
            allX{iM} = X2;
            allY{iM} = Y;
            clear Y X1 X2
        end
        save(fullfile('/Users/jdstokes/Dropbox/Data/dCW/analysis/param_uni',...
            [legend_label{1},'GLM']),'GLM');
        
    end

%%Builds a scatter plot   
function BuildScat(C,allX,allY)
% labels = strrep(strrep(GetMasks(C),'.nii',''),'_','');
% units = C.rs.rs_calcUnits(C.rs.rs_calcCurr);

 masks = GetMasks(C);
for i= 1:length(masks)
figure;
scatter(allX{i},allY{i});
title(masks{i});
end





end

end







