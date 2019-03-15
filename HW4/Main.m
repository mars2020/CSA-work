%   HW4
%   Mauricio Canales
%   mc63788

clear all; clc; 

%   Adding path for input files and functions
Path = 'C:\Users\mauricio\Documents\MATLAB\CSD\HW4';
addpath(genpath(Path));

%   Input Files
Node_file = 'nodes.txt';
Element_file = 'elements.txt';
Forces_file = 'forces.txt';
Disp_file = 'displacements.txt';

%   Reading all files
[Input_data,Totals] = Reading_files(Node_file,Element_file,Forces_file,Disp_file);

%   Accessing input data
nodes = Input_data{1};
elements = Input_data{2};
forces = Input_data{3};
disp = Input_data{4};


%  Youngs Modulus, Cross Sectional Area, and available degrees of freedom
E_ele = elements(:,4);
A_ele = elements(:,5);
ndofs = 2*Totals('Total_nodes')  - Totals('Total_disp'); 


%   Calculating length and angles of elements
[L,C,S] = Length_Angle(nodes,elements,Totals);


%   Creating global ordering
[u,gcon] = Global_nodes(disp,Totals);

%   Creating reduced stiffness matrix and solving
u_red = Stiffness(gcon,elements,forces,u,E_ele,A_ele,L,C,S,Totals,ndofs);

%   Writing results into an excel document
Post_process(gcon,elements,u,u_red,Totals,ndofs,L,C,S,E_ele,A_ele);



