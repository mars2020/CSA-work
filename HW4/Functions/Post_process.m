%   Post processing filling in displacement vector
%   Parameters: global ordering, known displacements, found displacements,
%               total values, available degrees of freedom
function Post_process(gcon,elements,u,u_red,Totals,ndofs,L,C,S,E_ele,A_ele)

% Number of dimensions 
n = 2; 

%   yield strength and yield load

syms I sig

%   Placing found displacements in original displacement array
for i=1:Totals('Total_nodes') 
    for j=1:n
        dof = gcon(i,j);
        if dof <= ndofs
            u(i,j) = u_red(dof);
        end
    end
end

%   Calculating strains,stresses, and forces
strain = zeros(Totals('Total_elements'),1);
stress = zeros(Totals('Total_elements'),1);
F_ele  = zeros(Totals('Total_elements'),1);
for i=1:Totals('Total_elements')
    n1 = elements(i,2);
    n2 = elements(i,3);
    u1 = u(n1,1);
    v1 = u(n1,2);
    u2 = u(n2,1);
    v2 = u(n2,2);
    strain(i,1) = (u2-u1)*C(i,1)/L(i,1) + (v2-v1)*S(i,1)/L(i,1);
    stress(i,1) = E_ele(i,1)*strain(i,1);
    F_ele(i,1)  = A_ele(i,1)*stress(i,1);
end

%   Calculating external forces
F_ext = zeros(Totals('Total_nodes'),2);
for i=1:Totals('Total_elements')
    n1 = elements(i,2);
    F_ext(n1,1) = F_ext(n1,1) - F_ele(i,1)*C(i,1);
    F_ext(n1,2) = F_ext(n1,2) - F_ele(i,1)*S(i,1);
    n2 = elements(i,3);
    F_ext(n2,1) = F_ext(n2,1) - F_ele(i,1)*C(i,1);
    F_ext(n2,2) = F_ext(n2,2) - F_ele(i,1)*S(i,1);
end

%   Calculating P critical for buckling

for i=1:Totals('Total_elements')
   if F_ele(i,1) < 0
       Pcr_buckling(i,1) = (E_ele(i)/(F_ele(i,1)*L(i)^2));
   end
end
[Pcr_buckling,element_buckling] = min(Pcr_buckling);
element_buckling
Pcr_buckling = abs(Pcr_buckling)*I

%   Checking critical tension and critical compression
[yielding,element_yielding] = max(F_ele);
element_yielding
Yield = (A_ele(element_yielding)/yielding)*sig

%   creating output file with displacements

%   creating node vector column   
node_v = 1:Totals('Total_nodes');
node = repelem(node_v,2)';
%   creating degrees of freedom vector column
dof = ones(2*Totals('Total_nodes'),1);
dof(2:2:2*Totals('Total_nodes'),1) = 2;
%   rearranging dispplacements into vector column
new_disp(1:2:2*Totals('Total_nodes'),1) = u(:,1);
new_disp(2:2:2*Totals('Total_nodes'),1) = u(:,2);
%   elements column
elements_col = 1:Totals('Total_elements');

%   writing displacements results into an excel document
Displacements_table = table(node,dof,new_disp);      %round(new_disp,#)
Displacements_table.Properties.VariableNames = {'Node','Dof','Disp'};
units = {'units (PL/EA)'};
xlswrite('Displacement_Results.xls',units,'Sheet1','D1');
writetable(Displacements_table,'Displacement_Results.xls');



Elements_table = table(elements_col',strain,stress,F_ele);
Elements_table.Properties.VariableNames = {'Element','Strain','Stress','Force'};
writetable(Elements_table,'Displacement_Results.xls','Sheet',2);


end