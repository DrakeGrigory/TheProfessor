function [eqn_Laplace_solved, Kval, K]=fun_Solver_TF(eqn_solved,dxv,xv,uv)

    syms s
    eqn_Laplace=subs(eqn_solved,dxv,xv*s); %subing differentials of xv with xv*s  

    
    struct_eqn_Laplace_solved=solve(eqn_Laplace,xv); %solving subbed equations

    if(isa(struct_eqn_Laplace_solved,'sym'))
        sym_ELS=sym(struct_eqn_Laplace_solved);%solve while returning one element does not create struct - casting not necessary
    else
        sym_ELS=sym(struct2cell(struct_eqn_Laplace_solved)); %casting: struct->cell->sym %ELS - sym_eqn_Laplace_solved
    end 
    
    %% Solving Laplace Equations for xv
    eqn_Laplace_solved = (transpose(xv)==sym_ELS); %creating solved LEQN
    fprintf("\nTF EQN Solved:\n\n")
    disp(eqn_Laplace_solved)


    %% Transfer Functions names
    
    K_names=strings(length(xv),length(uv));
   
    for j=1:length(xv)
        for i=1:length(uv)
            K_names(j,i)=upper("K_"+string(xv(j))+"_"+string(uv(i))); %making name for every TF
            
        end
    end


    %% creating all possible TF 
    K=sym(zeros(size(K_names)));
    Kval=K;
    for j=1:length(xv)
        for i=1:length(uv)
            Kval(j,i)=(sym_ELS(j)./transpose(uv(i)));
            
            if(length(uv)>1)
                
                Kval(j,i)=simplify(subs(Kval(j,i),uv([1:i-1,i+1:end]),zeros(1,length(uv)-1)));
            end
            K(j,i)=sym(K_names(j,i))==Kval(j,i); %creating every TF
        end
    end
    %K_names
    %% printing all possible TF
    fprintf("\n==== ALL Transfer Functions ====\n")
    for j=1:length(xv) 
        fprintf("\n%s",transpose(K(j,:)))
        fprintf("\n")
 
    end
    fprintf("\nWhere:   K_Y(s)_U(s)\n")
    
end

