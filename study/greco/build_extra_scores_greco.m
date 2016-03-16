function scores = build_extra_scores_greco(subject)

scores = struct;

name = 'dprime';
conds = {'corr all s','incorr all d'};
scores = GetRunCodesDprime(subject,conds,name,scores);

name = 'dprime_d1';
conds = {'corr all s','incorr all d1'};
scores = GetRunCodesDprime(subject,conds,name,scores);

name = 'dprime_d2';
conds = {'corr all s','incorr all d2'};
scores = GetRunCodesDprime(subject,conds,name,scores);

name = 'dprime_t';
conds = {'corr all s t','incorr all d t'};
scores = GetRunCodesDprime(subject,conds,name,scores);

name = 'dprime_n';
conds = {'corr all s n','incorr all d n'};
scores = GetRunCodesDprime(subject,conds,name,scores);

name = 'dprime_m';
conds = {'corr all s m','incorr all d m'};
scores = GetRunCodesDprime(subject,conds,name,scores);

name = 'dprime_t';
conds = {'corr all s t','incorr all d1 t'};
scores = GetRunCodesDprime(subject,conds,name,scores);

name = 'dprime_d1_n';
conds = {'corr all s n','incorr all d1 n'};
scores = GetRunCodesDprime(subject,conds,name,scores);

name = 'dprime_d2_t';
conds = {'corr all s t','incorr all d2 t'};
scores = GetRunCodesDprime(subject,conds,name,scores);

name = 'dprime_d2_n';
conds = {'corr all s n','incorr all d2 n'};
scores = GetRunCodesDprime(subject,conds,name,scores);

%% Other
name = 'corr';
conds = 'corr all';
scores = GetRunCodesReg(subject,conds,name,scores);

name = 'corr_s';
conds = 'corr all s';
scores = GetRunCodesReg(subject,conds,name,scores);

name = 'corr_d';
conds = 'corr all d';
scores = GetRunCodesReg(subject,conds,name,scores);

name = 'corr_d1';
conds = 'corr all d1';
scores = GetRunCodesReg(subject,conds,name,scores);

name = 'corr_d2';
conds = 'corr all d2';
scores = GetRunCodesReg(subject,conds,name,scores);

%% other map
map = greco_map_subj(subject);
scores.map_T = map.D1_T;
scores.map_N = map.D1_N;
scores.map_M = map.D1_M;

end



%% run specific
function scores = GetRunCodesDprime(subject,conds,name,scores)
[~,data]=greco_behav_dprime({subject},conds);
scores.(name) = data;
clear data

runs = {'r1','r2','r3','r4'};
new_conds = cell(size(conds));
 for i = 1:length(runs)
    for j=1:length(conds)
        new_conds{j} = [conds{j},' ',runs{i}];
    end
    [~,data]=greco_behav_dprime({subject},new_conds);
     scores.([name,'_',runs{i}]) = data;

 end
end

%% run specific
function scores = GetRunCodesReg(subject,conds,name,scores)
[data,~ ]= greco_behav_scores({subject},conds);
scores.(name) = data;
clear data

runs = {'r1','r2','r3','r4'};
 for i = 1:length(runs)
    new_conds = [conds,' ',runs{i}];
    [data,~ ]= greco_behav_scores({subject},new_conds);
    scores.([name,'_',runs{i}]) = data;

 end
end
