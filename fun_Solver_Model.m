function eqn_solved=fun_Solver_Model(eqn, eqn_var,dxv)

    fprintf("\nEquations (not solved):\n\n")
    disp(eqn);
    
    struct_eqn_solved=solve(eqn,eqn_var); %solving - creating stucture

    cell_eqn_solved = struct2cell(struct_eqn_solved);
    cell_eqn_solved = cell_eqn_solved(1:length(dxv));

    eqn_solved=sym(zeros(length(dxv),1));
    for i=1:length(dxv)
        eqn_solved(i) = (dxv(i)==sym(cell_eqn_solved{i})); %creating symbolic equations
    end

    fprintf("\nEquations (solved ):\n\n")
    disp(eqn_solved)

end