function subjectsF = subject_filter(foldpath,subjects,type)


switch type
    case 't > n'
conds = {'corr all s t','incorr all d t'};
[~,data1]=greco_behav_dprime(foldpath,subjects,conds);

conds = {'corr all s n','incorr all d n'};
[~,data2]=greco_behav_dprime(foldpath,subjects,conds);

subjectsF = subjects(data1 > data2);

    case 'n > t'
        
          
conds = {'corr all s t','incorr all d t'};
[~,data1]=greco_behav_dprime(foldpath,subjects,conds);

conds = {'corr all s n','incorr all d n'};
[~,data2]=greco_behav_dprime(foldpath,subjects,conds);

subjectsF = subjects(data1 < data2); 

    case 'high perf'
        conds = {'corr all s','incorr all d'};
        [~,data]=greco_behav_dprime(foldpath,subjects,conds);
        subjectsF = subjects(data >= mean(data));
        
        
    case 'low perf'
         conds = {'corr all s','incorr all d'};
        [~,data]=greco_behav_dprime(foldpath,subjects,conds);
        subjectsF = subjects(data <= mean(data));
        
end
