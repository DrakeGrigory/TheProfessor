clc
clear


Electric_vars={'xv','uv','yv','cv'};
Hydraulic_vars=horzcat(Electric_vars,'dpv');

list_type = {'Electric','Hydraulic'};
list_RMode = {'Examples','User input'};
list_EX={'Example 1 ','Example 2 '};
break_all=-1;


tf_type=-1;
%% CHOOSING SYSTEM TYPE
while (break_all==-1)

    [indx_type,tf_type] = listdlg('ListString',list_type,'SelectionMode','single');
    if(tf_type==0); break; end

    
    
    %% CHOOSING INPUT TYPE
    tf_RMode=-1;
    while (break_all==-1)
            
            [indx_RMode,tf_RMode] = listdlg('ListString',list_RMode,'SelectionMode','single');
            if(tf_RMode==0); break; end

            
            LineNum={''};
            %% PRE-LINES_IN - EXAMPLES
            if(indx_RMode==1) %examples

                  
                  
                [indx_EX,tf_EX] = listdlg('ListString',list_EX,'SelectionMode','single');

                if(indx_type==1 && tf_EX==1) %electric
                    switch indx_EX

                        case 1
                                prompt_LI_buff={'Line 1','Line 2','Line 3','Line 4','Line 5'};
                                prompt_LI=horzcat(prompt_LI_buff,Electric_vars);
                                def_LI={'0 == IR1-IC-IL-IR2','0 == U-UR1-UC','0 == U-UR1-UL-UR3','0 == U-UR1-UR2','0 == IR1-IC-IR3-IR2','[IL  UC]','[U]','[IR1 IC IR2 UR1 UR2 UR3 UL IR3]','[]'};     
                        case 2
                                prompt_LI_buff={'Line 1','Line 2','Line 3'};
                                prompt_LI=horzcat(prompt_LI_buff,Electric_vars);
                                def_LI={'0 == IR1-IC-IR2','0 == U-UR1-UC','0 == U-UR1-UR2','[UC]','[U]','[IR1 IC IR2 UR1 UR2]','[]'};
                    end
                elseif(indx_type==2 && tf_EX==1) %hydraulic
                    switch indx_EX
                        case 1
                                prompt_LI_buff={'Line 1','Line 2','Line 3','Line 4'};
                                prompt_LI=horzcat(prompt_LI_buff,Hydraulic_vars);
                                def_LI ={ 'd1_V1 == qwe1-q12', 'd1_V2 == q12+qwe2-q23','d1_V3 == q23+qwe3-qwy','qwy==C3*H3','[H3]','[qwe1 qwe2 qwe3]','[q12 q23 qwy]','[C3]','[d1_V1 d1_V2 d1_V3]'}  ;  
                        case 2
                                prompt_LI_buff={'Line 1','Line 2','Line 3'};
                                prompt_LI=horzcat(prompt_LI_buff,Hydraulic_vars);
                                def_LI ={ 'd1_V1 == qwe1-q12', 'd1_V2 == q12+qwe2-qwy','qwy==C2*H2','[H2]','[qwe1 qwe2]','[q12 qwy]','[C2]','[d1_V1 d1_V2]'}  ;  
                    end
                end
                   
                %%EXAMPLES
            %% LINES NUMBER
            elseif(indx_RMode==2) %user_input
                tf_EX=1;
    
                prompt_LN  = {'Enter lines number:'};
                def_LN     = {'10'};
                dims_LN    = [1 20];
                LineNum  = inputdlg(prompt_LN,'',dims_LN,def_LN);
                %answer = inputdlg(prompt,dlgtitle,dims,definput,opts);
               %string(LineNum)
                    
                    %% PRE-LINES_IN - USER INPUT
                    if(string(LineNum)=="")
                        LineNum=9;
                    end

                    %creating 'Line i' for prompts_LI
                    LineNum=double(string(LineNum)); 
                    prompt_LI_buff=strings(1,LineNum);
                    for i=1:LineNum
                        prompt_LI_buff(i)=append('Line ',string(i));
                    end
                    prompt_LI_buff=convertStringsToChars(prompt_LI_buff);

                    if(indx_type==1)
                        prompt_LI=horzcat(prompt_LI_buff,Electric_vars); %fitting together Line i + xv uv yv cv
                         def_LI_str=strings(1,LineNum+length(Electric_vars));
                         def_LI_str(end-3:end)="[ ]";
                         def_LI=convertStringsToChars(def_LI_str);% default value equal to nothing. ('')
                    elseif(indx_type==2)
                        prompt_LI=horzcat(prompt_LI_buff,Hydraulic_vars); %fitting together Line i + xv uv yv cv (dpv)
                         def_LI_str=strings(1,LineNum+length(Hydraulic_vars));
                         def_LI_str(end-4:end)="[ ]";
                         def_LI=convertStringsToChars(def_LI_str);% default value equal to nothing.
                    end

                       
                    
            end
            
            %% LINES_IN 
            if(~isempty(LineNum) && tf_EX==1)
                f_vars_inq=-1;
                while(break_all==-1)

                        title_LI  = 'Enter lines/equations';
                        dims_LI    = [1 50];
                        
                    Out_LI=inputdlg(prompt_LI, title_LI, dims_LI,def_LI);
                    if(isempty(Out_LI)); break; end
                        
                        %% Saving input
                        if(indx_type==1)
                            line(1,:)=string(Out_LI(1:end-4));
                                xv  =str2sym(Out_LI(end-3)); %str2sym divides these string into elements
                                uv  =str2sym(Out_LI(end-2));
                                yv  =str2sym(Out_LI(end-1));
                                cv  =str2sym(Out_LI(end-0));
                            vars_given=sort(string([xv uv yv cv]));

                        elseif(indx_type==2)
                            line(1,:)=string(Out_LI(1:end-5));
                                xv  =str2sym(Out_LI(end-4)); %str2sym divides these string into elements
                                uv  =str2sym(Out_LI(end-3));
                                yv  =str2sym(Out_LI(end-2));
                                cv  =str2sym(Out_LI(end-1));
                                dpv =str2sym(Out_LI(end-0));
                             vars_given=sort(string([xv uv yv cv dpv]));
         
                        end
                     if(isempty(vars_given)); fprintf(2,"\nERR: no vector input\n"); break; end
                    %% CHECKING VARIABLES
                     eqn_line=str2sym(line);
                     
                     [vars, f_vars_inq]=fun_varFind(eqn_line,vars_given);
                    
                    %% BREAK ALL
                     if((~isempty(Out_LI))&&(f_vars_inq==0)); break_all=1; end
                end

                if(f_vars_inq==0)
                        if(indx_type==1)
                            %% PRE-SOLVING ELECTRIC
                            phys_line=fun_E_PhysEquator([xv yv]); %creating physical equations
                            dxv= str2sym(append('d1_',string(xv)));
    
    
                            eqnS=transpose(str2sym([line phys_line])); %S stands for Solver
                            eqn_varS=transpose([dxv yv cv]);
                            xvS=xv;
                            dxvS=dxv;
    
                            
                        elseif(indx_type==2)
                            %% PRE-SOLVING HYDRAULIC
                            dxv= str2sym([append("d1_",string(xv))]);
                            [phys_line, xv2]=fun_H_PhysEquator([yv dpv]); %creating physical equations
                            dxv2=str2sym(append("d1_",xv2));
                            xv2=str2sym(xv2);
    
    
                            eqnS=transpose(str2sym([line phys_line])); %S stands for Solver
                            eqn_varS=transpose([dxv2 yv dpv]);
                            xvS=xv2;
                            dxvS=dxv2;
                        
                        else
                            error("Solver type err; bad index")
                        end
                    %% SOLVING
                    eqn_solved=fun_Solver_Model(eqnS,eqn_varS,dxvS); % Solving system model and using Laplace Tranformation
                    [eqn_Laplace_solved, Kval, K]=fun_Solver_TF(eqn_solved,dxvS,xvS,uv); % Creating all possible Transfer functions

                end

            end


    end

end

if(break_all==1)

    vars =fun_varFind(eqn_Laplace_solved,""); %finding vars
    unwanted_v=string([xv yv sym('s')]); %defining unwanted vars

    const_vars=vars(~ismember(vars', unwanted_v', 'rows')); %erasing not const variables form vars
    
    
        title_VSV  = 'Enter const var values:';
        prompt_VSV = convertStringsToChars(const_vars);
        def_VSV    = convertStringsToChars(strings(1,length(const_vars))+"1");
        dims_VSV   = [1 50];

     varsSV=inputdlg(prompt_VSV, title_VSV, dims_VSV,def_VSV); %Value input to const_vars - prompt
     

     if(~isempty(varsSV)) %subing symbolic expressions 
        varsSV=transpose(str2sym(string(varsSV)));

        
        K_subbed=subs(K,str2sym(const_vars),varsSV);
        Kval_subbed=subs(Kval,str2sym(const_vars),varsSV);


            fprintf("\n==== ALL Transfer Functions SUBBED ====\n")
            for j=1:length(K_subbed(:,1)) 
                fprintf("\n%s",transpose(K_subbed(j,:)))
                fprintf("\n")
         
            end
            fprintf("\nWhere:   K_Y(s)_U(s)\n")

     end




end

fprintf("\n\n=========EOF")