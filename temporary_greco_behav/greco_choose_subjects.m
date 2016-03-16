function [subjects] = greco_choose_subjects(varargin)
%Jared Stokes


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%greco subjects%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
sub.all = {};
sub.ga = {'S1_A';'S3_A';'S4_A';'S5_A';'S6_A';'S7_A';'S9_A';'S16_A';'S24_A'};
sub.gb = {'S2_B';'S8_B';'S10_B';'S11_B';'S12_B';'S13_B';'S14_B';'S15_B';'S21_B';'S22_B';'S23_B';'S26_B'};
% sub.ga_lp = {'S3_A'};
% sub.gb_lp = {'S2_B';'S13_B';'S14_B'};
%%%%%%%%%%%%%%%%%%%%%%hh and ll
% sub.g_hhp ={'S5_A';'S7_A';'S9_A';'S16_A';'S10_B';'S11_B'};
% sub.g_lhp  ={'S1_A';'S4_A';'S6_A';'S8_B';'S12_B';'S15_B'};
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

if isempty(varargin)
    subjects = [sub.ga;sub.gb];
% elseif strcmp(varargin,'hp only')
%     subjects = [sub.ga;sub.gb];
elseif strcmp(varargin,'a')
    subjects = [sub.ga];
elseif strcmp(varargin,'b')
    subjects = [sub.gb];
% elseif strcmp(varargin,'hhp only')
%     subjects = [sub.g_hhp];
% elseif strcmp(varargin,'lhp only')
%     subjects = [sub.g_lhp];  
else
     error('bad input');      
end