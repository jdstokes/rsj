classdef InfoDir < handle
   properties
        main
        data
        analysis
        reports
        docs
        tables
   end
   methods
       function s = InfoDir(outer,name)
            s.main = fullfile(outer,name);
            s.data = fullfile(s.main,'data');
            s.analysis = fullfile(s.main,'analysis');
            s.reports = fullfile(s.main,'reports');
            s.docs = fullfile(s.main,'docs');
            s.tables = fullfile(s.analysis,'tables');
           
       end
       
       
       function buildDir(s)
           
           dirNames = fieldnames(s);
           for i = 1:length(dirNames)
               if ~exist(s.(dirNames{i}),'dir')
                   mkdir(s.(dirNames{i}))
               end
               
           end
           
       end
   end
end