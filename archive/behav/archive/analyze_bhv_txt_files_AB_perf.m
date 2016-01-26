%% Iain's Word Wheel: Yon83 hi res fMRI

% This script is used to analyze the behavioral data from e-prime and
% organize it for use in other programs. To run and extract variables based
% on names established in edat,expocd ..
cd ..
rt edat files using Export > Other >
% missing = null; tick "no unicode"
% If a subject fails to load at tdfread, remove the 2 time columns
% Original script written by AB for analyzing edat VWM colorwheel data.
% Adapted by AB to analyze LTM word wheel (or circle word) data from IH
% study. Change this section's variables to set analysis parameters. Change
% "modname" to reflect these parameters and save new csv files in new
% folder. (keeping the same model name will overwrite earler files.)
% Make sure you have a "CSV_Files" folder.


clear
ori_dir = pwd;
%dirpath = 'C:/Users/aborders.AD3/Dropbox/Projects/Word_wheel/'; %Work comp
%dirpath = '/Users/Alyssa/Dropbox/Yonelinas_Iain/'; %AB macbook
dirpath = '/Volumes/jdstokes/Dropbox/Data/dCW/behav/'; % server
cd (dirpath);   %Set working directory

s_onset_pt = 1; % Lock onset to s_loc = 1, s_word = 2, s_recall = 3, 
t_onset_pt = 1; %t_word = 1, t_recall = 2 
dur = 0; % during presentation? or 0 for epoch
ang_thresh = 10; % any resp < threshold is a hit
ang_buffer = 30; % any resp > buffer is a miss
use_buff = 1; % excludes trials with 'ambiguous' error resp
modname = 'ABcon_files';

subs = {'cw03' 'cw04' 'cw05' 'cw06' 'cw07' 'cw08' 'cw09' 'cw10' 'cw11' 'cw12' 'cw13' 'cw14' 'cw15' 'cw16' 'cw17'};
%subs = {'s03' 's04' 's05' 's06' 's07' 's08' 's09' 's10' 's11' 's12' 's13' 's14' 's15' 's16' 's17'};


%% Start loop
for isub = 1:length(subs);
    Input_Sub = subs{isub};
    fprintf('Analyzing subject %s\n', Input_Sub);
    
    %% Load Data
     fpath = fullfile('/bhv_files/',Input_Sub); %server
        
    %fpath = '/bhv_files/'; %AB

    fstub = sprintf('%s.txt', Input_Sub);
    fname = fullfile(dirpath, fpath, fstub);
    q = tdfread(fname);
    
    
    all_trials = cellstr(q.Running0x5BTrial0x5D); %study/test block
    StudyMask = strcmp('StudyBlock', all_trials);
    TestMask = strcmp('TestBlock', all_trials);
    ntrials = length(all_trials);

    
    centerY = q.screenheight(1)/2;
    centerX = q.screenwidth(1)/2;
    respX = q.MouseX;
    respY = q.MouseY;
    corrX = q.Xpos;
    corrY = q.Ypos;
    conf_px = cellstr(q.SliderPos);
    
    words = cellstr(q.Word);
    uwords = unique(words);
    
    %% Create Columns
    
    col_trial_num = q.Trial;
    col_run = q.Block;
    col_sub = repmat(str2num(Input_Sub(3:4)),ntrials,1); % server
       
    %col_sub = repmat(str2num(Input_Sub(2:3)),ntrials,1); % AB

    col_dur = dur*ones(ntrials,1);
    col_trial = (1*StudyMask)+(2*TestMask); % 1:Study, 2:Test
    col_coord = q.AngleRad; %Coordinates of truelocaion @study
    col_id = nan(ntrials,1); %Either number(1-96) for each pair, or the word
    col_anger = nan(ntrials,1);
    col_onset = nan(ntrials,1);
    
%     col_onset_Sloc = nan(ntrials,1);
%     col_onset_Sword = nan(ntrials,1);
%     col_onset_Srec = nan(ntrials,1);
%     
%     col_onset_Trec = nan(ntrials,1);
%     col_onset_Tword = nan(ntrials,1);
%     col_onset_TR = nan(ntrials,1);

 
    
    %% Calculate the start of each run (approx from first trial)
    runnums = unique(col_run);
    runOnsets = [];
    
    for irun = 1:length(runnums)
        trial1_onset = find(q.Block == irun,1);
        runstart = (q.NextTrial0x2EOnsetTime(trial1_onset,1)) - 4000;
        nts = sum(q.Block == irun);
        ronset = repmat(runstart,nts, 1);
        runOnsets = [runOnsets; ronset];
    end %irun
    
%% Trial by trial (within isub loop)    
for itrial = 1:ntrials
    
    %% Word ID

    %Assigns unique number for each word pair
    iword = words{itrial};
    iwid = find(ismember(uwords, iword)==1);
    col_id(itrial,1) = iwid;

    % OR

    %Lists the actual words presented at study/test
    % col_id(itrials,1) = words{itrial};

    
    %% Calculate angle error: Response
    
    if respX(itrial) == centerX && respY(itrial) == centerY
        col_anger(itrial,1) = nan;
        %If they don't move the mouse, skip trial
        
    else
        ang1 = atan2(centerY - corrY(itrial), ...
            corrX(itrial) - centerX)*180/pi;
        ang2 = atan2(centerY - respY(itrial), ...
            respX(itrial) - centerX)*180/pi;
        
        rawanger = ceil(min(mod(ang1-ang2, 360),mod(ang2-ang1, 360)));
        iangerr = max(1,rawanger); %must be at least 1 deg off
        col_anger(itrial,1) = iangerr;
    end
    
    
    %% Trial onsets: (corrected for block onset and changed to seconds)

    %STUDY trials
    if col_trial(itrial) == 1
        
        %choose s_onset lock
        if s_onset_pt == 1 %location
            s_rawOnset = cellstr(q.Circle0x2EOnsetTime);
        elseif s_onset_pt == 2 %word
            s_rawOnset = cellstr(num2str(q.WordPresent0x2EOnsetTime));
        elseif s_onset_pt == 3 %recall
            s_rawOnset = cellstr(q.SelectLocationStudy0x2EOnsetTime);
        end
        s_onset = str2num(s_rawOnset{itrial});
        
        
        if s_onset_pt ==1 %loc onset is 600 ms earlier
            s_onset = s_onset-600;
        end
        
        ionset = s_onset - runOnsets(itrial);
        
%         % calc onset for all points of the study phase 
%         sLoc_rawOnset = cellstr(q.Circle0x2EOnsetTime); %loc
%         sLoc_onset = (str2num(sLoc_rawOnset{itrial})-600) - runOnsets(itrial); %loc onset is 600 ms before circle slide
%         col_onset_Sloc(itrial,1) = sLoc_onset/1000;
%         
%         sWord_rawOnset = cellstr(num2str(q.WordPresent0x2EOnsetTime)); %word
%         sWord_onset = str2num(sWord_rawOnset{itrial}) - runOnsets(itrial);
%         col_onset_Sword(itrial,1) = sWord_onset/1000;
%         
%         sRec_rawOnset = cellstr(q.SelectLocationStudy0x2EOnsetTime); %recall
%         sRec_onset = str2num(sRec_rawOnset{itrial}) - runOnsets(itrial);
%         col_onset_Srec(itrial,1) = sRec_onset/1000;
            


    %TEST trials
    elseif col_trial(itrial) == 2

        %choose t_onset lock
        if t_onset_pt == 1 %word
            t_rawOnset = cellstr(num2str(q.WordPresent0x2EOnsetTime));
        elseif t_onset_pt == 2 %recall
            t_rawOnset = cellstr(q.SelectLocation0x2EOnsetTime);
        end
        t_onset = str2num(t_rawOnset{itrial});
        ionset = t_onset - runOnsets(itrial);
     
        
%         %choose t_onset lock
%         tWord_rawOnset = cellstr(num2str(q.WordPresent0x2EOnsetTime)); %word
%         tWord_onset = str2num(tWord_rawOnset{itrial}) - runOnsets(itrial);
%         col_onset_Tword(itrial,1) = tWord_onset/1000;
%        
%         tRec_rawOnset = cellstr(q.SelectLocation0x2EOnsetTime); %recall
%         tRec_onset = str2num(tRec_rawOnset{itrial}) - runOnsets(itrial);
%         col_onset_Trec(itrial,1) = tRec_onset/1000;
        
    end %study/test onsets
    
    
    col_onset(itrial,1) = ionset/1000;

    
    
    
end %itrials

%% Categorize responses: accuray   
    if use_buff == 1 
        % Error within threshold = 1, error greater than BUFFER = 2
        col_acc = (+(col_anger <= ang_thresh))+(2*(col_anger >= ang_buffer));
        nHits = sum(col_acc == 1);
        nMiss = sum(col_acc == 2);
        nBuff = sum(col_acc == 0);
        
    else
        % Error within threshold = 1, Error greater than THRESHOLD = 2
        col_acc = (+(col_anger <= ang_thresh))+(2*(col_anger > ang_thresh));
        nHits = sum(col_acc == 1);
        nMiss = sum(col_acc == 2);
        nBuff = nan;
        
    end %acc
    
fprintf('\nSubject %s\nHits: %d\nMisses: %d\nOther: %d\n\n', Input_Sub, nHits, nMiss, nBuff);
   

%% Subsequent memory FX: replace both angle and accuracy

col_testanger = col_anger;

for itr = 1:length(col_testanger);
    if col_trial(itr) == 1; %study
       IDind = find(col_id == col_id(itr));
       col_testanger(itr) = col_anger(IDind(2));
       col_acc(itr) = col_acc(IDind(2));
    end 
end
    
%% Use FPRINTF to write the header and DLMWRITE to write the numeric content    
    hdr = {'subject' 'col_trial_num' 'Run' 'Onset' 'trial_type' 'duration' 'accuracy' 'response' 'test_angEr' 'word_ID' 'Study_Loc'};
    data = [col_sub col_trial_num col_run col_onset col_trial col_dur col_acc col_anger col_testanger col_id col_coord];
    m = [hdr;num2cell(data)];
%         
%         if ~exist('./txt_Files')
%             mkdir ./txt_Files
%         end
%         cd ./txt_Files/
        
        if ~exist(fullfile(modname,subs{isub}),'dir')
        mkdir(fullfile(modname,Input_Sub));
        end
        cd(fullfile(modname,Input_Sub));
        
        cname = sprintf('%s.txt', Input_Sub);
        fid = fopen(cname, 'w'); 
        fprintf(fid, '%s\t', m{1,1:end-1});
        fprintf(fid, '%s\n', m{1,end});
        fclose(fid);
        dlmwrite(cname, m(2:end,:),'-append','delimiter','\t');
        cd ../../ 
      
end %sub loop        
  
cd(ori_dir); % reset to whatever dir you started in


