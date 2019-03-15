%   Calculates length and angles of each element
%   Parameters: nodes array, elements array, total values for each file
function [L,C,S] = Length_Angle(nodes,elements,Totals)

for i=1:Totals('Total_elements')
    % accessing coordinates
    x1 = nodes(elements(i,2),2);
    y1 = nodes(elements(i,2),3);
    x2 = nodes(elements(i,3),2);
    y2 = nodes(elements(i,3),3);
    % calculating length, cosine, and sine of each element
    L(i,1) = sqrt((y2-y1)^2 + (x2-x1)^2);
    C(i,1) = (x2-x1)/L(i);
    S(i,1) = (y2-y1)/L(i);
    
    
end


end