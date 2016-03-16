function specs = study_specs
%% Description
%   Intializes basic variables for study Greco3D
%   That's it.
%% Requirements
%  v2struct package or v2struct.m

%% Begin

%behav directory
work_dir = '/Users/jdstokes/Dropbox/Data/dGR/behav/map_draw';

%subject list
subjects = {'S1_A', 'S3_A','S4_A','S5_A', 'S6_A', 'S7_A', 'S9_A',...
    'S16_A', 'S2_B', 'S8_B', 'S10_B', 'S11_B', 'S12_B',...
    'S13_B', 'S14_B', 'S15_B', 'S21_B', 'S22_B', 'S23_B','S24_A', 'S26_B'};

%store list
stores = {'Bakery','Cell phones', 'Gym', 'Chinese Food', 'Florist',...
    'Toy Store','Music Store', 'Ice Cream', 'Dentist'};

%city coordinates
coordinates(1).x = [279.74,251.32,229.88,201.28,226.39,264.04,289.14,290.84,293.10,279.74];
coordinates(1).y = [282.20,306.13,284.86,256.50,240.93,217.58,202.01,225.77,257.44,282.20];
coordinates(2).x = [279.54,257.94,230.50,214.97,225.89,255.69,282.88,286.69,291.76,279.54];
coordinates(2).y = [282.63,311.46,287.76,256.23,225.32,214.04,206.78,228.56,257.59,282.63];
coordinates(3).x = [279.33,264.56,231.12,228.67,225.39,247.34,276.62,282.53,290.42,279.33];
coordinates(3).y = [283.05,316.80,290.67,255.97,209.71,210.50,211.55,231.35,257.75,283.05];

%add all to structure
specs =v2struct(work_dir,subjects,stores,coordinates);
end