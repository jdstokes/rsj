function ASHS2nii(subj,C)
%Load ASHS output and parse into seperate .nii files
%ash output





hem = {'left','right'};
types = {'lfseg_heur','lfseg_corr_nogray','lfseg_corr_usegray'};

for i = 1:length(hem)
    for j =1:length(types)
        
        BuildROIs(subj,C,hem{i},types{j})
        
    end
end
end


function BuildROIs(subj,C,hem,type)

%declare vars
dir_roi= GetValue(C,'dir_mask');
ash_input = 'ash_stuff';
roi_names = {'CA1','CA2','DG','CA3','head','tail','MISC','subiculum','ERC','35','36','CS'}; %corresponds to code ints, 1-13
roi_ind = [1,2,3,4,5,6,7,8,9,11,12,13];


%setup input/output dir
dirInput = fullfile(dir_roi,ash_input,subj,'final') ;%dirName = '/Volumes/jdstokes/Studies/Data/dGR/rois/ash_stuff/S1_A/final/';
dirOutput = fullfile(dir_roi,['ash_',type],subj);
if ~exist(dirOutput,'dir')
    mkdir(dirOutput);
end

%get ashs roi file
fileName = [subj,'_',hem,'_',type,'.nii.gz'];%'S1_A_left_lfseg_corr_nogray.nii.gz'
ashsPath = fullfile(dirInput,fileName);
if ~exist(ashsPath,'file')
    error([ashsPath,' does not exist.'])
end
gunzip(ashsPath);
ashsPath = strrep(ashsPath,'.gz','');

hdr = spm_vol(ashsPath);
img = spm_read_vols(hdr);
cnt = 0;


%extract and build ROIs
for i = roi_ind
    cnt = cnt +1;
    new_hdr = hdr;
    new_hdr.fname = fullfile(dirOutput,['ash_',hem,'_',roi_names{cnt},'.nii']);
    new_img = img ==i;
    spm_write_vol(new_hdr,new_img);
    
    clear new_hdr new_img
end

end


%%EXTRA stuff! no
% ashs_roi_key ='/Volumes/jdstokes/Studies/ash/atlas/snap/snaplabels.txt';
% text_file = ashs_roi_key;
% fileID = fopen(text_file,'r');
% text = textscan(fileID,'%s',27,'Delimiter','\n');
