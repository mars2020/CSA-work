
HW3

Mauricio Canales
mc63788

Program for solving truss structures
------------------------------------------------------------

Instructions:
	
	Main:		Place input files in same directory as main and run program. 
			Outputs an excel document with displacements in the current directory on MATLAB.
 
	Functions:	All subprograms
		
		Reading_files:	Reads in files and outputs structured matrices.
		Length_Angle:	Reads in elements matrix and outputs length and angles for each element.
		Global_nodes:	Outputs gcon and the known displacements in seperate matrices.
		Stiffness:	Creates global reduced stiffness matrix and outputs the reduced displacements array.	
		Post_process:	Places found displacements in original array and outputs an excel doc with results.