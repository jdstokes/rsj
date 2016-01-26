classdef rsj_grab
    properties
        subj
        ss 
        ts
        behav
    end

 methods
        function rsa = rsj_grab(subj,ss,ts,behav)
            % Usage: 
            % Purpose: 
            %
            % Inputs: ss
            %         behav
            %         ts
            rsa.subj = subj;
            rsa.ss  = ss;
            rsa.ts  = ts;
            rsa.behav   = behav;
        end
        
        function disp(varargin)
            disp('Properties: subj, ss, behav, ts');
        end
        
        function [data] = Get_scores(rsa)
            %----------Build OLindsByCond -->> Retrieve scores -->> Pull scores
            ind  =   rsj_rsa_get_index(rsa.ts,rsa.behav,rsa.ss);
            [data] =   rsj_rsa_indexbetas(rsj_rsa_getbetas(rsa.subj,rsa.ss),ind,rsa.ss);
        end
        
%         function [ind] = Get_scores_ind(rsa)
%             ind  =   rsj_rsa_get_index(rsa.ts,rsa.behav,NumTrials(rsa.ss),'rs_all');
%             
%         end
%         
%         function [data] = Get_scores_dprime(rsa)
%             ind  =   rsj_rsa_get_index(rsa.ts,rsa.behav,NumTrials(rsa.ss),'uni');
%             [data] =   Behav_get_perf(rsa.subj,rsa.ss,ind,'dprime');
%         end
        
    
              
 
 
    
 end
end

                
                    