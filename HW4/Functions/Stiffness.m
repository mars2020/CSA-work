%   Creating local stiffness matrix and placing in global stiffness
%   Parameters: global ordering,elements array, forces array, known displacements
%               array, young modulus, area, length, cosine, sine, total values, available degrees of freedom 

function u_red = Stiffness(gcon,elements,forces,u,E_ele,A_ele,L,C,S,Totals,ndofs)
%   Order of magnitude for E and A
Emag = 10^9;
Amag = 1;
%   initializing forces
Force = zeros(2*Totals('Total_nodes'),1); 
%   filling temporary array with applied forces 
for i=1:Totals('Total_forces')
     Force(gcon(forces(1,1),forces(1,2))) = forces(i,3);    
end 

%   Filling in reduced forces array
for i=1:ndofs
    F_red(i,1) = Force(i);
end

%   Initializing stiffness arrays
K_red = zeros(ndofs,ndofs);
K_local = zeros(4,4);

%   Creating local stiffness matrix
for i=1:Totals('Total_elements')
    Coef = Emag*Amag*((E_ele(i)*A_ele(i))/L(i));
    C2 = C(i)^2; SC = S(i)*C(i); S2 = S(i)^2;
    
    K_local(1,1) = Coef*C2; 
    K_local(1,2) = Coef*SC;
    K_local(1,3) = Coef*-C2;
    K_local(1,4) = Coef*-SC;
    K_local(2,1) = Coef*SC;
    K_local(2,2) = Coef*S2;
    K_local(2,3) = Coef*-SC;
    K_local(2,4) = Coef*-S2;
    K_local(3,1) = Coef*-C2;
    K_local(3,2) = Coef*-SC;
    K_local(3,3) = Coef*C2;
    K_local(3,4) = Coef*SC; 
    K_local(4,1) = Coef*-SC;
    K_local(4,2) = Coef*-S2;
    K_local(4,3) = Coef*SC;
    K_local(4,4) = Coef*S2;

%   Creating Global Stiffness matrix
for inode=1:2
    for idof=1:2
        Ldofi = 2*(inode-1)+idof;    %  dof in the rows for local K (1-4)            
        Gdofi = gcon(elements(i,inode+1),idof); % node 1 and 2 dof 1 and 2 for global K                                                                
        if Gdofi <= ndofs   % checks if row dof of node is inside K reduced. Has to be either 1 or 2 in this case
            for jnode=1:2
                for jdof=1:2
                    Ldofj = 2*(jnode-1)+jdof; % dof in the cols for local K (1-4) 
                    Gdofj = gcon(elements(i,jnode+1),jdof); % node 1 and 2 dof 1 and 2 for global K
                    if Gdofj > ndofs  % checks to see if col dof is outside K reduced 
                        F_red(Gdofi) = F_red(Gdofi) - K_local(Ldofi,Ldofj)*u(elements(i,jnode+1),jdof);
                    else
                        K_red(Gdofi,Gdofj) = K_red(Gdofi,Gdofj)+K_local(Ldofi,Ldofj);
                    end
                end
            end
        end
    end
end
end
%   Solving for unknown displacements
u_red = K_red\F_red;

end