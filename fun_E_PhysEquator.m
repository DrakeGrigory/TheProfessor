
% ==================================================================================================================================================================================================

% This function uses physics laws to automatically create some of the equations for user; f.e. Ux=Rx*Ix
% This reduces amount of time needed to execute program and also reduces chances of error making
% ==================================================================================================================================================================================================


function phys_Eqn = fun_E_PhysEquator(all_v)

    varIndexNum=0; %equations number/index
    for j=1:length(all_v)
        av_char = char(all_v(j));
                    
    
        if ((av_char(1)=="U")&&(length(av_char)>=2))     %finding variable index
            if(av_char(2)=='R')
    
                  varIndex=av_char(3:length(av_char)); %finding index of variable
                  varIndexNum=varIndexNum+1;           
                  phys_line(varIndexNum) = "0 == " + string(all_v(j))...
                                            +"-R"+varIndex + "*" + "IR"+ varIndex; %equation
                  
    
            elseif (av_char(2)=='C') % var UCx     out: C*d1_UCx-ICx   
                
        
                  varIndex=av_char(3:length(av_char));
                  varIndexNum=varIndexNum+1;
                  phys_line(varIndexNum) = "0 == " + "C"+ varIndex + "*" + "d1_"+string(all_v(j)) + "-IC"+varIndex; %equation
                  
    
            elseif (av_char(2)=='L') % var: ULx    out: ULx=L*d1_ILx 

                  varIndex=av_char(3:length(av_char));
                  varIndexNum=varIndexNum+1;
                  phys_line(varIndexNum) = "0 == " + "L" + varIndex + "*" + "d1_IL" + varIndex + "-" + string(all_v(j)); %equation
                  
                  
            end 
        end
    end
    phys_Eqn=phys_line;
end
  





















