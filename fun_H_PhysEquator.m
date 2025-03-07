
% ==================================================================================================================================================================================================

% This function uses physics laws to automatically create some of the equations for user; 
% This reduces amount of time needed to execute program and also reduces chances of error making

% ==================================================================================================================================================================================================


function [phys_Eqn, dxv]= fun_H_PhysEquator(all_v) %all_variables_vector
dVlen=4; %assuming length of derivative of 4 since derivative: dx_Vy
qlen=1;
    varIndexNum=0; %equations number/index
    varIndexNumXV=0; %xv variables count
    dxv="";
        for j=1:length(all_v)
            av_char = char(all_v(j)); %string element to char
                        
        


                        if(length(av_char)>dVlen && strcmp(av_char(1:dVlen),'d1_V')) %case derivative
                
                              varIndex=av_char(dVlen+1:end); %finding variable index
                              varIndexNum=varIndexNum+1;           
                              phys_line(varIndexNum) = "0 == " + string(all_v(j)) + "-A"+varIndex + "*" + "d1_H"+varIndex;  
                              
                              %% Creating vector of xv (of all xv) 
                              varIndexNumXV=varIndexNumXV+1;
                              dxv(varIndexNumXV)="H"+varIndex;


                
                        elseif (strcmp(av_char(1:qlen),'q') && (av_char(2)>='0' && av_char(2)<='9') )   %case q1, q12, q1_2
                             

                               varIndex=av_char(qlen+1:end);
                               varIndexNum=varIndexNum+1;
                               
                                %case q1 / q12 -> C1*H1 / C12*H1
                               if(length(varIndex)==1 || (length(varIndex)==2 &&   (all(varIndex>='0') && all(varIndex<='9') ))) %% q1 or q1x x=<0,9> case

                                    phys_line(varIndexNum) = "0 == "+"q"+varIndex + "-C"+varIndex+  "*H"+varIndex(1);  %creating equation

                               elseif(length(varIndex)==3) %case q1_2  -> C12(H1-H2)
                                   

                                   if( (varIndex(1)>='0' && varIndex(1)<='9') && varIndex(2)=='_' && (varIndex(3)>='0' && varIndex(3)<='9') ) %sym var creation requirements
                                        phys_line(varIndexNum) = "0 == "+string(all_v(j)) + "-C"+varIndex(1:2:3)+  "*(H"+varIndex(1)+"-H"+varIndex(3)+")"; %creating equation
                                   end
                               
                               end
                                                           
                              
                        end 

        end
        phys_Eqn=phys_line;
          
        %transpose(phys_Eqn)
end



















