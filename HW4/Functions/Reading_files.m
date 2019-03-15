%   Reading all files
%   Parameters: all input files

function [Input_data,Totals] = Reading_files(Node_file,Element_file,Forces_file,Disp_file)

%   Reading node file
ID_nodes = fopen(Node_file,'r');                            %   What data each column contains for all files                
total_nodes = str2num(fgetl(ID_nodes));                              
nodes = zeros(total_nodes,3);                               %   Nodes
for i=1:total_nodes                                         %   node    x   y
    nodes(i,:) = str2num(fgetl(ID_nodes));
end
fclose(ID_nodes);

%   Reading elements file
ID_elements = fopen(Element_file,'r');
total_elements = str2num(fgetl(ID_elements));
elements = zeros(total_elements,5);                         %   Elements
for i=1:total_elements                                      % element   node1   node2   Young Modulus   Cross Area
    elements(i,:) = str2num(fgetl(ID_elements));
end
fclose(ID_elements);

%   Reading applied forces file
ID_forces = fopen(Forces_file,'r');
total_forces = str2num(fgetl(ID_forces));
forces = zeros(total_forces,3);                             %   Forces
for i=1:total_forces                                        %   node    dof     value
    forces(i,:) = str2num(fgetl(ID_forces));
end
fclose(ID_forces);

%   Reading known displacements file
ID_disp = fopen(Disp_file,'r');
total_disp = str2num(fgetl(ID_disp));
disp = zeros(total_disp,3);                                 %   Displacements
for i=1:total_disp                                          %   node    dof     value   
    disp(i,:) = str2num(fgetl(ID_disp));
end
fclose(ID_disp);

%   Output after reading files
Input_data = {nodes,elements,forces,disp};

Keys_total = {'Total_nodes','Total_elements','Total_forces','Total_disp'};
values = [total_nodes,total_elements,total_forces,total_disp];
Totals = containers.Map(Keys_total,values);
end


