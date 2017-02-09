% function rs_sl_groupcluster6_noFSL

warning off;
clearvars -except RS;




func_dim = [120 120 36];
cluster_sz_thresh = 4;

%% findclusters
ana={
    
'perf_glmfit_dPrimeCC_pair_SAME_all--CC_pair_DIFF_all_15_nn2_OL1_noFSL'
};



maskList = {
    
'L_CA1.nii'
'L_CA3.nii'
'L_PHC.nii'
'L_SUB.nii'
'R_CA1.nii'
'R_CA3.nii'
'R_PHC.nii'
'R_SUB.nii'
};

reg_type={
    %   'reg1_warpedtotemplate_OL2ce105'
    %   'reg1_warpedtotemplate_OL2ce119'
    %   'reg1_warpedtotemplate_OL2ce120'
    
    %  'reg2_warpedtotemplate_OL2ce105'
    %  'reg2_warpedtotemplate_OL2ce119'
    'reg2_warpedtotemplate_OL2ce120'
    
    
    %  'reg1_warpedtotemplate_ce105'
    %  'reg1_warpedtotemplate_ce119'
    %  'reg1_warpedtotemplate_ce120'
    %
    %
    % 'reg2_warpedtotemplate_ce105'
    % 'reg2_warpedtotemplate_ce119'
    %   'reg2_warpedtotemplate_ce120'
    };






pvalue={'p05','p01'};
p_thresh=[ .05, .01];

con_mask=0; %if you want to use an activation mask
stattype=0;%0 for corr, 1 for glm
diff_type=0; %0 for diff all; 1 for diff by 1; 2 = fourth run only
cluster_output = 1;



for ri = 1: length(reg_type)
    %%rep subj
    %     if strcmp(reg_type{ri},'warpedtotemplate')
    %         rep_subj='ce105';
    %     else
    rep_subj=reg_type{ri}(strfind(reg_type{ri},'ce'):strfind(reg_type{ri},'ce')+4);
    %     end
    
    %%load masks of representattive subjects subject,
    cd([RS.rs_dir, rep_subj,'/' ]); load([rep_subj,'_', RS.model_type,'_',RS.smooth,'_RS']);
    rep_masks_CE = RS_betas.data.masks_CE;
    rep_maskList = RS_betas.maskList;
    clear RS_betas;
    
    for ai=1:length(ana)
        
        cd([RS.sl_dir,'Groupstats_New/',reg_type{ri},'/',ana{ai}])
        
        %Delete old cluster files
        contents=dir;
        for i = 5:length(contents)
            if contents(i).isdir
                rmdir(contents(i).name,'s');
            end
        end
        clear i contents;
        
        
        %% Read in images
        if stattype==0
            
            t_name=[ana{ai}, '_t.nii'];
            p_name=[ana{ai},'_1minusP.nii'];
            beta_name = [ana{ai},'_B.nii'];
            
            hdr = spm_vol(t_name);
            t_img = spm_read_vols(hdr);
            
            
            
            hdr = spm_vol(p_name);
            p_img = spm_read_vols(hdr);
            
            hdr = spm_vol(beta_name);
            
            beta_img = spm_read_vols(hdr);
            
            
        elseif stattype==1
            
            t_name=[ana{ai},'_t.nii'];
            p_name=[ana{ai},'_1minusP.nii'];
            df_name=[ana{ai},'_df.nii'];
            
            
            
            hdr = spm_vol(t_name);
            t_img = spm_read_vols(hdr);
            
            hdr = spm_vol(p_name);
            p_img = spm_read_vols(hdr);
            
            
            hdr = spm_vol(df_name);
            df_img = spm_read_vols(hdr);
        end
        
        
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %% Specify masking contrasts; only used if masking by a Cond A vs Cond B t-test; seldom used
        if   stattype==1
            if strfind(ana{ai},'CC_pair_SAME_all--CC_pair_DIFF_all')
                name1='CC_pair_SAME_all--CC_pair_DIFF_all_ttest.nii';
                name2='CC_pair_DIFF_all--CC_pair_SAME_all_ttest.nii';
            elseif strfind(ana{ai},'CC_pair_SAME_all--CC_pair_D_2')
                name1='CC_pair_SAME_all--CC_pair_D_2_ttest.nii';
                name2='CC_pair_D_2--CC_pair_SAME_all_ttest.nii';
            elseif strfind(ana{ai},'CC_pair_S_Run4--CC_pair_D_Run4')
                name1='CC_pair_S_Run4--CC_pair_D_Run4_ttest.nii';
                name2='CC_pair_D_Run4--CC_pair_S_Run4_ttest.nii';
            elseif strfind(ana{ai},'CC_pair_S_Run2t4--CC_pair_D_Run2t4')
                name1='CC_pair_S_Run2t4--CC_pair_D_Run2t4_ttest.nii';
                name2='CC_pair_D_Run2t4--CC_pair_S_Run2t4_ttest.nii';
            elseif strfind(ana{ai},'CC_pair_S_Run3--CC_pair_D_Run3')
                name1='CC_pair_S_Run3--CC_pair_D_Run3_ttest.nii';
                name2='CC_pair_D_Run3--CC_pair_S_Run3_ttest.nii';
            elseif strfind(ana{ai},'CC_pair_S_Run2t4--CC_pair_D_1_Run2t4')
                name1='CC_pair_S_Run2t4--CC_pair_D_1_Run2t4_ttest.nii';
                name2='CC_pair_D_1_Run2t4--CC_pair_S_Run2t4_ttest.nii';
                
                %%single conditon
            elseif strfind(ana{ai},'CC_pair_SAME_all')
                name1='CC_pair_SAME_all_ttest.nii';
            elseif strfind(ana{ai},'CC_pair_S_Run2t4')
                name1='CC_pair_S_Run2t4_ttest.nii';
            end
            
            
            
            
            %% Mask images
            
            if exist('name1','var') && exist('name2','var')
                
                hdr = spm_vol(name1);
                mask1= spm_read_vols(hdr);
                
                hdr = spm_vol(name2);
                mask2= spm_read_vols(hdr);
                
                clear sd_name ds_name
            elseif exist('name1','var')
                
                hdr = spm_vol(name1);
                mask1= spm_read_vols(hdr);
                
            end
        end
        
        %% Pos/neg image names; Basically just utilizes the t_img nii to mask p_img into positive and negative images
        pos_p_img_name=['pos_',p_name];
        neg_p_img_name=['neg_',p_name];
        
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%\
        if stattype == 0
            %%Output pos/neg P score images
            pos_t_img = t_img > 0;
            neg_t_img = t_img < 0;
            
            pos_p_img = p_img .* pos_t_img;
            neg_p_img = p_img .* neg_t_img;
            
            
        elseif stattype==1
            %%Output pos/neg P score images
            pos_beta_img = beta_img > 0;
            neg_beta_img = beta_img < 0;
            
            pos_p_img = p_img .* pos_beta_img;
            neg_p_img = p_img .* neg_beta_img;
            
        end
        
        
        %make directories for Pos/Neg output
        mkdir(strrep(pos_p_img_name,'.nii',''));
        mkdir(strrep(neg_p_img_name,'.nii',''));
        
        %write images
        
        
        cd([RS.sl_dir,'Groupstats_New/',reg_type{ri},'/',ana{ai},'/',strrep(pos_p_img_name,'.nii','')]);
        hdr.fname=pos_p_img_name;
        spm_write_vol(hdr,pos_p_img);
        
        cd([RS.sl_dir,'Groupstats_New/',reg_type{ri},'/',ana{ai},'/',strrep(neg_p_img_name,'.nii','')]);
        hdr.fname=neg_p_img_name;
        spm_write_vol(hdr,neg_p_img);
        
        clear p_img p_name t_name neg_p_img_name neg_p_img pos_p_img_name pos_p_img neg_t_img pos_t_img;
        
        %back to analysies folder
        cd([RS.sl_dir,'Groupstats_New/',reg_type{ri},'/',ana{ai}])
        
        
        
        
        %% Images masked by t image;seldom used
        if stattype == 0
            if con_mask==1
                
                
                %image names
                pos_p_sd_img_name=['pos_sd_',pos_p_img_name];
                neg_p_sd_img_name=['neg_sd_',neg_p_img_name];
                pos_p_ds_img_name=['pos_ds_',pos_p_img_name];
                neg_p_ds_img_name=['neg_ds_',neg_p_img_name];
                
                %image masking step
                pos_p_sd_img = pos_p_img .* (mask1 > 1);
                neg_p_sd_img = neg_p_img .* (mask1 > 1);
                if exist('mask2','var')
                    pos_p_ds_img = pos_p_img .* (mask2 > 1);
                    neg_p_ds_img = neg_p_img .* (mask2 > 1);
                end
                
                
                %make directories
                mkdir(strrep(pos_p_sd_img_name,'.nii',''));
                mkdir(strrep(neg_p_sd_img_name,'.nii',''));
                mkdir(strrep(pos_p_ds_img_name,'.nii',''));
                mkdir(strrep(neg_p_ds_img_name,'.nii',''));
                
                cd([RS.sl_dir,'Groupstats_New/',reg_type{ri},'/',ana{ai},'/',strrep(pos_p_sd_img_name,'.nii','')]);
                hdr.fname=pos_p_sd_img_name;
                spm_write_vol(hdr,pos_p_sd_img);
                
                cd([RS.sl_dir,'Groupstats_New/',reg_type{ri},'/',ana{ai},'/',strrep(neg_p_sd_img_name,'.nii','')]);
                hdr.fname=neg_p_sd_img_name;
                spm_write_vol(hdr,neg_p_sd_img);
                
                
                cd([RS.sl_dir,'Groupstats_New/',reg_type{ri},'/',ana{ai},'/',strrep(pos_p_ds_img_name,'.nii','')]);
                hdr.fname=pos_p_ds_img_name;
                spm_write_vol(hdr,pos_p_ds_img);
                
                cd([RS.sl_dir,'Groupstats_New/',reg_type{ri},'/',ana{ai},'/',strrep(neg_p_ds_img_name,'.nii','')]);
                hdr.fname=neg_p_ds_img_name;
                spm_write_vol(hdr,neg_p_ds_img);
            end
        end
        
        
        %back to analysies folder
        cd([RS.sl_dir,'Groupstats_New/',reg_type{ri},'/',ana{ai}])
        
        
        %% Output cluster stuff
        %get subfolder names
        d = dir;
        isub = [d(:).isdir]; %# returns logical vector
        nameFolds = {d(isub).name}';
        nameFolds(1:2) = [];
        
        clear d isub;
        
        for iN=1:length(nameFolds)
            for iT=1:length(p_thresh)
                
                
                analysis_name = nameFolds{iN};
                
                cd([RS.sl_dir,'Groupstats_New/',reg_type{ri},'/',ana{ai},'/',analysis_name]);
                
                %% Total clusters (non-masked across megamask for both Positive and Negative P value maps
                
                thresh = (1 -p_thresh(iT) ) * 1000;
                %positive
                %     disp(['Cluster Results: ',analysis_name])
                %             clustecho=evalc(['!/Usr/local/fsl/bin/cluster --in=' RS.sl_dir 'Groupstats_New/',reg_type{ri},'/',ana{ai},'/', analysis_name,'/', analysis_name,'.nii -t ' ...
                %                 num2str(thresh) ' -o ' RS.sl_dir 'Groupstats_New/', '/',reg_type{ri},'/',ana{ai},'/', analysis_name,'/',pvalue{ti},'_cluster_',analysis_name, '.nii > ',pvalue{ti},'_cluster_' ...
                %                 ,analysis_name, '.txt' ]);
                %             evalc(['!gzip -df ' RS.sl_dir 'Groupstats_New/',reg_type{ri},'/',ana{ai},'/', analysis_name, '/',pvalue{ti},'_cluster_',analysis_name,'.gz']);
                %
                
                
                %load image
                hdr = spm_vol( [RS.sl_dir 'Groupstats_New/',reg_type{ri},'/',ana{ai},'/', analysis_name,'/', analysis_name,'.nii']);
                img = spm_read_vols(hdr);
                [ClusterInds, MaxSize, MaxCount ] = maxclustersize(img,thresh);
                
                
                
                for iCl =1:length(ClusterInds)
                    for iMask=1:length(rep_maskList)
                        %Get mask inds
                        %                    mask_inds = find(masks_CE{1}==1);
                        
                        clust=zeros(func_dim);
                        clust(ClusterInds{iCl})=1;
                        
                        mask_int_ind = find(clust==1 & rep_masks_CE{iMask});
                        all_clusters.analysis(iN).(pvalue{iT}).cluster(iCl).masks(iMask).ClusterInds = mask_int_ind;
                        all_clusters.analysis(iN).(pvalue{iT}).cluster(iCl).masks(iMask).Cluster_size = length(mask_int_ind);
                        all_clusters.analysis(iN).(pvalue{iT}).cluster(iCl).masks(iMask).mask_name = rep_maskList{iMask,1};
                        all_clusters.analysis(iN).(pvalue{iT}).cluster(iCl).masks(iMask).mask_size = rep_maskList{iMask,2};
                        %loop through cluster indices
                        
                        clear clust
                        
                    end%iMask=1:length(RS.maskList)
                    
                    
                    all_clusters.analysis(iN).(pvalue{iT}).Cluster_Size(iCl) = length(ClusterInds{iCl});
                end%iCl=1:length(ClusterInds)
                
                
                
                
                all_clusters.analysis(iN).(pvalue{iT}).allClusterInds = ClusterInds;
                
                all_clusters.analysis(iN).(pvalue{iT}).analysis_name = nameFolds{iN};
                
                clear img ClusterInds MaxSize MaxCount
                
                
                
                
                
                
                
                %% Mask stat image(s)(pos/neg) with ROI masks.
                
                %             hdr = spm_vol( [analysis_name, '.nii']);
                %             stat_img = spm_read_vols(hdr);
                %
                %             for iMask=1:length(RS.maskList)
                %
                %                 stat_img_masked=stat_img.*masks_CE{iMask};
                %                 hdr.fname= [strrep(analysis_name,'.nii','') '_' RS.maskList{iMask}];
                %                 spm_write_vol(hdr, stat_img_masked);
                %
                %                 clear stat_img_masked n_stat_img_masked;
                %             end
                %
                %             clear hdr stat_img;
                %
                %% Find clusters within each mask
                %             for iMask=1:length(RS.maskList)
                %
                %                 %         disp(['Cluster Results: ',analysis_name,' ', RS.maskList{iMask} ])
                %                 clustecho=evalc(['!/Usr/local/fsl/bin/cluster --in=' RS.sl_dir 'Groupstats_New/',reg_type{ri},'/',ana{ai},'/', analysis_name,'/', strrep(analysis_name,'.nii','') '_' RS.maskList{iMask} ' -t ' num2str(thresh) ' -o ' RS.sl_dir 'Groupstats_New/', reg_type{ri},'/',ana{ai},'/', analysis_name,'/',pvalue{ti},'_cluster_' ...
                %                     strrep(analysis_name,'.nii',''),'_',RS.maskList{iMask} '> ',pvalue{ti},'_cluster_',strrep(analysis_name,'.nii',''),'_',strrep(RS.maskList{iMask},'.nii',''),'.txt']);
                %                 evalc(['!gzip -df ',RS.sl_dir,'Groupstats_New/', reg_type{ri},'/',ana{ai},'/', analysis_name, '/',pvalue{ti},'_cluster_',strrep(analysis_name,'.nii',''),'_',RS.maskList{iMask},'.gz']);
                %             end
                %
                %
                %
                %             %% Out put significant clusters
                %
                %             cluster_fold=[RS.sl_dir,'Groupstats_New/', reg_type{ri},'/',ana{ai},'/','sig_clusters/'];
                %             mkdir(cluster_fold);
                %
                %
                %             for iMask=1:length(RS.maskList)
                %                 cnt=0;
                %                 %     cd([RS.sl_dir,'Groupstats_New/',reg_type{ri},'/',ana{ai},'/',analysis_name]);
                %                 text = importdata([pvalue{ti},'_cluster_' strrep(analysis_name,'.nii','') '_' strrep(RS.maskList{iMask},'.nii','') '.txt' ]);
                %                 hdr = spm_vol([pvalue{ti},'_cluster_'  strrep(analysis_name,'.nii','') '_' RS.maskList{iMask}]);
                %                 img = spm_read_vols(hdr);
                %                 if isfield(text,'data')
                %                     for i=1:size(text.data,1)
                %
                %                         if text.data(i,2)>4
                %                             disp('sig cluster')
                %                             cnt=cnt+1;
                %                             img1=img;
                %                             img1(img==text.data(i,1))=1;
                %                             img1(img~=text.data(i,1))=0;
                %
                %                             cd(cluster_fold);%write to cluster folder
                %                             hdr.fname = ['sig_',pvalue{ti},'_cluster_' num2str(cnt) '_' strrep(analysis_name,'.nii','') '_' RS.maskList{iMask}] ;
                %                             spm_write_vol(hdr,  img1);
                %                             cd([RS.sl_dir,'Groupstats_New/',reg_type{ri},'/',ana{ai},'/',analysis_name]);%Go back to analysis folder
                %
                %                             clear img1
                %                         end
                %                     end
                %                 end
                %                 clear img hdr text cnt
                %
                %             end
                %
                
                
                
                
                %             %% Combine text
                %             %positive
                %             if ~exist('group_cluster','var')
                %                 cnt=0;
                %             else
                %                 cnt=size(group_cluster,2);
                %             end
                
                %             for iM=1:length(RS.maskList)%length(RS.maskList)
                %                 text = importdata([pvalue{ti},'_cluster_',analysis_name,'_', strrep(RS.maskList{iM},'.nii','') '.txt' ]);
                %                 if isstruct(text)
                %
                %                     if cnt==0
                %                         header=horzcat(text.colheaders,{'Subregion'},{'Analysis'},{'P-threshold'},{'rep_subj'});
                %                     end
                %                     d=num2cell(text.data);
                %                     d(1:size(d,1),10)=RS.maskList(iM);
                %                     d(1:size(d,1),11)={analysis_name};
                %
                %                     d(1:size(d,1),12)={pvalue{ti}};
                %                     d(1:size(d,1),13)={rep_subj};
                %
                %                     for clust=1:size(d,1)
                %
                %                         if d{clust,2}>4
                %                             cnt=cnt+1;
                %                             if cnt==1
                %                                 group_cluster=d(clust,:);
                %                             elseif cnt>0
                %                                 group_cluster=vertcat(group_cluster,d(clust,:));
                %                             end
                %                         end
                %                     end
                %                 end
                %
                %             end
                
                
                %        if exist('group_cluster','var')
                %         output=vertcat(header,group_cluster);
                %        elseif exist('header','var')
                %            output=header;
                %            else
                %                output=text;
                %        end
                
                
            end%iN=length(nameFolds)
        end%ti=length(p_thresh)
        clear iN ti
        
        
        %% header
        %%1              %%2            %%3          %%4           %%5    %%6                    %%7          %%8        %%9         %%10        %%11          %%12
        header =[{'Clust_index'},{'Clust_size'},{'analysis'},{'p-thresh'},{'ROI'},{'Masked_cluster_sz'},{'%_cluster'},{'%_mask'},{'mean_t'},{'peak_t'},{'mean_beta'},{'peak_beta'}];
        
        last_col=size(header,2);
        %add percent mask columns
        
        for iM = 1:length(maskList)
            
            header(1,last_col + (iM*2 - 1)) = {['perc_mean_peak_' maskList{iM}]};
            header(1,last_col + (iM*2)) =  {['perc_mean_mean_' maskList{iM}]};
            
        end
        
        
        %% Configure output
        cnt=0;
        for iN = 1:length(nameFolds)
            for iT = 1:length(p_thresh)
                
                if isfield(all_clusters.analysis(iN).(pvalue{iT}),'cluster')
                    for iC = 1:length(all_clusters.analysis(iN).(pvalue{iT}).cluster)
                        
                        if all_clusters.analysis(iN).(pvalue{iT}).Cluster_Size(iC) > cluster_sz_thresh
                            
                            
                            %% Output clusters
                            if cluster_output == 1
                                %Make cluster folder
                                cluster_fold=[RS.sl_dir,'Groupstats_New/', reg_type{ri},'/',ana{ai},'/','sig_clusters_all/'];
                                mkdir(cluster_fold);
                                
                                
                                cluster_inds = all_clusters.analysis(iN).(pvalue{iT}).allClusterInds{iC};
                                img = zeros(func_dim);
                                img(cluster_inds) = 1;
                                
                                
                                cd(cluster_fold);
                                %write to cluster folder
                                hdr.fname = [ pvalue{iT} '_'  all_clusters.analysis(iN).(pvalue{iT}).analysis_name  '_' num2str(iC) '.nii' ] ;
                                spm_write_vol(hdr,  img);
                                
                                clear img cluster_inds
                                
                            end
                            %%
                            
                            
                            
                            
                            
                            
                            
                            
                            for iM = 1:length(maskList)
                                
                                mn=find(strcmp(maskList{iM},rep_maskList(:,1)));
                                
                                
                                if all_clusters.analysis(iN).(pvalue{iT}).cluster(iC).masks(mn).Cluster_size > 0% if cluster is large enough
                                    
                                    
                                    
                                    
                                    
                                    
                                    cnt=cnt+1;
                                    output{cnt,1} = iC;
                                    output{cnt,2} = all_clusters.analysis(iN).(pvalue{iT}).Cluster_Size(iC) ;
                                    output{cnt,3} = all_clusters.analysis(iN).(pvalue{iT}).analysis_name;%analysis
                                    output{cnt,4} = pvalue{iT};
                                    output{cnt,5} = all_clusters.analysis(iN).(pvalue{iT}).cluster(iC).masks(mn).mask_name;%Mask
                                    output{cnt,6} = all_clusters.analysis(iN).(pvalue{iT}).cluster(iC).masks(mn).Cluster_size;%cluster size
                                    output{cnt,7} = all_clusters.analysis(iN).(pvalue{iT}).cluster(iC).masks(mn).Cluster_size/all_clusters.analysis(iN).(pvalue{iT}).Cluster_Size(iC);% %_cluster
                                    output{cnt,8} = all_clusters.analysis(iN).(pvalue{iT}).cluster(iC).masks(mn).Cluster_size/all_clusters.analysis(iN).(pvalue{iT}).cluster(iC).masks(mn).mask_size;% %_cluster
                                    
                                    %% get t scores
                                    maskClustInd = all_clusters.analysis(iN).(pvalue{iT}).cluster(iC).masks(mn).ClusterInds;
                                    
                                    
                                    output{cnt,9} =  mean(t_img(maskClustInd)/1000);
                                    
                                    if mean(t_img(maskClustInd)/1000) > 0
                                        output{cnt,10} =  max(t_img(maskClustInd)/1000);
                                    elseif mean(t_img(maskClustInd)/1000) < 0
                                        output{cnt,10} =  min(t_img(maskClustInd)/1000);
                                    end
                                    
                                    output{cnt,11} =  mean(beta_img(maskClustInd)/1000);
                                    if mean(beta_img(maskClustInd)/1000) > 0
                                        
                                        output{cnt,12} =  max(beta_img(maskClustInd)/1000);
                                    elseif mean(beta_img(maskClustInd)/1000) < 0
                                        
                                        output{cnt,12} =  min(beta_img(maskClustInd)/1000);
                                    end
                                    %% Accumulated values
                                    for iM = 1: length(maskList)
                                        for iS = 1:length(RS.subjList)
                                            
                                            %load warped percent image
                                            perc_img_name = [RS.sl_dir RS.subjList{iS} '/' reg_type{1} '/' 'w_percent'  maskList{iM} ];
                                            hdr = spm_vol(perc_img_name);
                                            perc_img = spm_read_vols(hdr);
                                            clust_perc_mean(iS)=mean(perc_img(maskClustInd));
                                            clust_perc_peak(iS)=max(perc_img(maskClustInd));
                                            clear perc_img perc_img_name
                                        end
                                        
                                        
                                        output{cnt,last_col + (iM*2-1)} = mean(clust_perc_peak);
                                        output{cnt,last_col + (iM*2)} = mean(clust_perc_mean);
                                        
                                        
                                        
                                        
                                        clear clust_perc
                                    end
                                    
                                    
                                    %% Output ROI clusters
                                    
                                    %output{cnt,6} is the masked cluster size
                                    if cluster_output == 1 &&  output{cnt,6} > cluster_sz_thresh
                                        %Make cluster folder
                                        cluster_fold=[RS.sl_dir,'Groupstats_New/', reg_type{ri},'/',ana{ai},'/','sig_clusters_ROI/'];
                                        mkdir(cluster_fold);
                                        
                                        mask_name = output{cnt,5};
                                        cluster_inds = maskClustInd;
                                        img = zeros(func_dim);
                                        img(cluster_inds) = 1;
                                        
                                        
                                        cd(cluster_fold);
                                        %write to cluster folder
                                        hdr.fname = [ pvalue{iT} '_'  all_clusters.analysis(iN).(pvalue{iT}).analysis_name  '_' num2str(iC) '_' mask_name ] ;
                                        spm_write_vol(hdr,  img);
                                        
                                        clear img cluster_inds
                                        
                                    end
                                    %%
                                    
                                    
                                    
                                end
                                
                            end
                        end
                    end
                end
            end
        end
        
        
        output=vertcat(header,output);
        cell2csv([RS.sl_dir,'Groupstats_New/',reg_type{ri},'/',ana{ai},'/', 'clusters',rep_subj,'.csv'],output);
        
        
        
        
        
        
        %
        %
        
        %
        
        
        %
        %
        %clear output group_cluster header d text cnt var;
    end%ai=length(ana)
end%ri=length(ri)

clear ai ri

cd(RS.script_dir)



