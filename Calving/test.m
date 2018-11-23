
%%
filename='GmshFile.msh' ; 
msh = load_gmsh2(filename);

%%
filename='GmshFileNew.msh' ; 
%filename='GmshFileOld.msh' ; 
msh = load_gmshGHG(filename);

%%
N_n      = dlmread(file,'',[5-1 1-1 5-1 1-1]);
N_e      = dlmread(file,'',[7+N_n 0 7+N_n 0]);
node_id     = dlmread(file,'',[5 0 4+N_n 0]);
nodes       = dlmread(file,'',[5 1 4+N_n 3]);
elements    = dlmread(file,'',[8+N_n 0 7+N_n+N_e 7]);
