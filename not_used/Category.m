classdef Category < handle
    
    properties
    name
    value
    input
    end
    
    methods
        
        function cb = rsj_study(name,value)
            cb.name = name;
            cb.value = value;
            cb.input{1}.var = name;
            cb.input{1}.val = value;
        end
        
    end
    
end