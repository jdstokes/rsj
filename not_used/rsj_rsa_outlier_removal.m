function [data_clean,perc_data_rem] = rsj_rsa_outlier_removal(data,rem_type)

data_mean = mean(data(:));%includes all voxels within ROI across all images
data_std =std(data(:));

if strcmp(rem_type,'NO')
    OL_inds = false(size(data));
elseif strcmp(rem_type,'IQR') || strcmp(rem_type,'IQRnan') || strcmp(rem_type,'IQRm')
    Qs=quantile(data(:),[.25 .75]);
    Q1=Qs(1);
    Q3=Qs(2);
    Qr=Q3-Q1;
    OL_inds = data < (Q1 - Qr) | data > (Q3 + Qr);
    clear Os Q1 Q3 Qr
elseif strcmp(rem_type,'2SD') || strcmp(rem_type,'2SDnan') || strcmp(rem_type,'2SDm')
    OL_inds=data < (data_mean-2*data_std) | data > (data_mean+2*data_std);
elseif strcmp(rem_type,'3SD') || strcmp(rem_type,'3SDnan') || strcmp(rem_type,'3SDm')
    OL_inds=data < (data_mean-3*data_std) | data > (data_mean+3*data_std);
else
    error('Choose correct OLSm');
end

%Replace with mean or nan
data_clean=data;
if strcmp(rem_type,'IQRm') || strcmp(rem_type,'2SDm') || strcmp(rem_type,'3SDm')
    data_clean(OL_inds)=data_mean;
elseif ~isempty(strfind(rem_type,'nan'))
    data_clean(OL_inds)=NaN;
else
    data_clean(OL_inds)=[];
    
end

data_numel = numel(data);
perc_data_rem = sum(OL_inds(:))/data_numel;%percentage of voxels removed


end