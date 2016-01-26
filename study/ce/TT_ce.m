function tt = TT_ce(subj,C,varargin)


format = '_all.csv';
fileName = fullfile(C.dir.dir_behavioral,subj,[subj,format]);
data = tdfread(fileName,',');


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  Build TT and add additional columns to data
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

dur= 20.0;
NumTrials = length(data.Run);


for i1=1:NumTrials;
  if i1 ==1 || data.Run(i1) ~= data.Run(i1-1)
      tri = 1;
  else
      tri = tri +1;
  end
      
      
    % Extract run specific trial order number
    data.Trial(i1) = tri;
    % Extract run number
    run = data.Run(i1);
  
    % Build TT
    ttspm(run).EVENTNUM{tri}= i1;
    ttspm(run).ONSET{tri}= data.Movie_start(i1);
    ttspm(run).DUR{tri}= dur;                                 
end


% Add new additional variables to data

%change char arrays to cell
vars = fieldnames(data);
for i2 = 1:length(vars)
    if ischar(data.(vars{i2}))
        data.(vars{i2}) = cellstr(data.(vars{i2}));
    end
end
data.NumTrials = NumTrials;

%Configure output
if nargin == 3 
    if strcmp(varargin{1},'spm')
        tt = ttspm;
    else
        error('bad argument');
    end
elseif nargin == 2
    tt = data;
else
    error('too many inputs');
end

