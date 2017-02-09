function newStrings = FixStrings(oldStrings,stuffToRemove,stuffToReplace)

%%Check inputs
if(~(iscell(oldStrings)  && iscell(stuffToRemove)))
    error('Both oldSTrings and stuffToRemove arguments need to be cell arrays you unpegged monkey ass');
end


%%Declare newStrings
newStrings = oldStrings;
clear oldStrings

%%Loop through stuffToRemove and remove from oldStrings
for i = 1:length(stuffToRemove)
    newStrings = strrep(newStrings,stuffToRemove{i},stuffToReplace{i});
end