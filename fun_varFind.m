%%===================================================================================================================================================================================================

% This function finds, sorts and compares variables that can be found in equations
% Comparation occures between variables inserted into vectors (uv,xv,yv,cv,dpv) - symVar_given 
% and variables that has been read form equations

% It saves time for user in case of misstype of one single variable somewhere in the lines
% (Sometimes it becomes really time consuming) 

% ==================================================================================================================================================================================================


function [v_symVar_read, f_inq] =fun_varFind(eqn_line,v_symVar_given)

       v_newVar="";
        for k=1:length(eqn_line)
            line_newVar="";
            varNum=0;
            EqL_varFind=char(append(string(eqn_line(k)),'#')); %adding any char since solution below of variable finder skips last char and does not read properly
            j=1;
            i=1;
            while(j~=length(EqL_varFind)) % loop - looking for letter
                
                c_1=EqL_varFind(j);
                if ( (c_1>=65 && c_1<=90) || (c_1>=97 && c_1<=122) ) % A-Z a-z - checking letter with requirements of sym variables creation
            
                    newVar=c_1;
                    varNum=varNum+1;  % counter/index of newly created variables
                    
                    %loop - checking letter with requirements of sym variables creation inside of the name
                    for i=j+1:length(EqL_varFind) % starting loop with c_1 index (j index) - no redundancy
            
                        c_2=EqL_varFind(i); 
                        if ((c_2>=48 && c_2<=57) || (c_2>=65 && c_2<=90) || (c_2==95) || (c_2>=97 && c_2<=122) ) %0-9 A-Z _ a-z checking letter with requirements of sym variables creation inside of the name
                            newVar=append(newVar,c_2);
                        else 
                             
                            j=i-1; %index ends on first wrong char, therefore it must be reduced by one, for finding next var
                            break                   
                        end % IF 2                
                    end % FOR I
                end % IF 1
                

                % creating new vars if any met previous requirements
                if(varNum>0) 
                    line_newVar(varNum)=newVar;
                end
        
                j=j+1; % increasing index every loop        
            end %WHILE J
            
            %creating vector of new variables
            if v_newVar=="" 
                v_newVar=line_newVar; %if none created yet
            else  
                v_newVar=[line_newVar v_newVar]; %if any created by then
            end
        end %FOR K
        
        %sorting for comparison 
        v_symVar_read = sort(unique(v_newVar));

        %% CONDITION
     if(v_symVar_given~="") % checking if second argument is empty
        
         f_inq=0;
        
        %% function_varFind_conditions

        if(length(v_symVar_given)~=length(v_symVar_read)) %displaying vars and filling gaps for missing vars
            DataPartial = table;
            if (length(v_symVar_read) < length(v_symVar_given)) 
                
                len_vSymVar_min  =  length(v_symVar_read);
                fpr_rest_vSymVar =  transpose(strings(1,length(v_symVar_given)-length(v_symVar_read)));
                DataPartial.given=  [string(length(v_symVar_given));"---"; transpose(v_symVar_given)];
                DataPartial.read =  [string(length(v_symVar_read)) ;"---"; transpose(v_symVar_read(1:len_vSymVar_min)); fpr_rest_vSymVar];
        
            elseif (length(v_symVar_read) > length(v_symVar_given))
                
                len_vSymVar_min  =  length(v_symVar_given);
                fpr_rest_vSymVar =  transpose(strings(1,length(v_symVar_read)-length(v_symVar_given))); 
                DataPartial.given =[string(length(v_symVar_given));"---"; transpose(v_symVar_given(1:len_vSymVar_min)); fpr_rest_vSymVar];
                DataPartial.read = [string(length(v_symVar_read)) ;"---"; transpose(v_symVar_read)];
                
            end
        
            disp(DataPartial)
            fprintf(2,"Number of variables in vectors is not equal to the number of variables that can be found in equations\n")
            f_inq=1;
        
        
        else
            symVar_equal=(v_symVar_read==v_symVar_given); % checking equality 
            sV_ineq=find(symVar_equal==0);
            
            if isempty(sV_ineq)==0 %displaying inequalities
                 f_inq=1;
    
                DataOne= table; %displaying first inequal element
                DataOne.Num= sV_ineq(1);
                DataOne.given = v_symVar_given(sV_ineq(1));
                DataOne.read = v_symVar_read(sV_ineq(1));
                
                
                DataFull=table; %displaying all elements
                DataFull.Num= transpose(1:1:length(v_symVar_given));
                DataFull.given = transpose(v_symVar_given);
                DataFull.read = transpose(v_symVar_read);
                DataFull.equality = transpose(symVar_equal);
                
                disp(DataOne)
                disp(DataFull)
               
            end
            %% 
        end
        if(f_inq==0)

        %fprintf("\nvariables:\n")
        %fprintf("%s ",v_symVar_read) %adding more s adds collumns

        end
    end
end