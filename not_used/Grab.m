function output = Grab(subj,ss,ts,behav)
   
             %Phasing this out 8/1/2016
            %----------Build OLindsByCond -->> Retrieve scores -->> Pull scores
            ind  =   rsj_rsa_get_index(ts,behav,ss);
            output =   rsj_rsa_indexbetas(rsj_rsa_getbetas(subj,ss),ind,ss);
            clear ind

end

                
                    