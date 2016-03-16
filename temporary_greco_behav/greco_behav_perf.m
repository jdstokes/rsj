


conds = {'corr all s','incorr all d2'};
subjects = greco_choose_subjects();
[~,data]=greco_behav_dprime(subjects,conds);

[B,I]=sort(data);
B(1:3) = [];
I(1:3) = [];
for sub = 1:10
    if sub ~=1
        I(1)=[];
    end
%T - M    
conds = {{'corr all s t','incorr all d1 t'},{'corr all s m','incorr all d1 m'}};
data = cell(1,length(conds));
group =zeros(1,length(conds));
for i = 1:length(conds)
[group(i),data{1,i}]=greco_behav_dprime(subjects(I),conds{i});
end
t_diff(sub,1)=group(1)-group(2);

%N - M
conds = {{'corr all s n','incorr all d1 n'},{'corr all s m','incorr all d1 m'}};
data = cell(1,length(conds));
group =zeros(1,length(conds));
for i = 1:length(conds)
[group(i),data{1,i}]=greco_behav_dprime(subjects(I),conds{i});
end
n_diff(sub,1)=group(1)-group(2);

    
end



%% Plot
close all
figure('Color',[1 1 1],'Position',[-798   551   725   451])
plot(t_diff,'b',...
    'LineWidth',3)
hold
plot(n_diff,'g',...
    'LineWidth',3)

title('Higher performers exhibit training effect boost')
set(gca,'FontSize',20);
set(gca,'FontWeight','bold');
set(gca,'LineWidth',2);
ylabel(sprintf('Non-morph city advantage\n(Non-morph minus morph dprime)'));
legend('Trained','Novel')
set(gca,'XTick',[])
xlabel(sprintf('Cumulative group performance\n(dprime)'))
% set(gca,'XTickLabel',18:-1:0)

