%   Creating Global node matrix (gcon)
%   Parameters: displacements array,total values for each file

function [u,gcon] = Global_nodes(disp,Totals)

%   initializing displacements array
u = zeros(Totals('Total_nodes'),2);

%   creating gcon
for i=1:Totals('Total_nodes')                       
   gcon(i,1) = 2*i-1;                       
   gcon(i,2) = 2*i;                         
end                                         


for i=1:Totals('Total_disp')
    
    dofi = gcon(disp(i,1),disp(i,2));       % dof of node with known displacement
    u(disp(i,1),disp(i,2)) = disp(i,3);     % filling in known displacements
    
    for j=1:Totals('Total_nodes')           % reordering gcon 
        for k=1:2
            dofj = gcon(j,k); 
            if dofj > dofi                               
                gcon(j,k) = gcon(j,k)-1;  
            end
        end
    end
    
    gcon(disp(i,1),disp(i,2)) = 2*Totals('Total_nodes'); % moving known displacment to bottom of gcon
end
 
end
