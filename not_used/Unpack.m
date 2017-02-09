function output = Unpack(C,mode)
% mode: 'rs_pair', 'rs_all', 'behav', ' behav_scores'


tt_struct = TrialType(C.subjects.subjAll{1},C,mode).Get_tt;
output.names = fieldnames(tt_struct);

% only get variables with categorical responses. Set at at
% threshold of 10 which is super liberatl
cnt = 0;
for i1 = 1:length(output.names)
    output.vals.(output.names{i1}) = unique(tt_struct.(output.names{i1}));
    if length(unique(tt_struct.(output.names{i1}))) <10
        cnt = cnt+1;
        output.menu{cnt,1} = output.names{i1};
    end
end
output.menu = [{'null'};output.menu];
end
