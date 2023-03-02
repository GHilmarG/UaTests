function UserVar=DefineOutputs(UserVar,CtrlVar,MUA,BCs,F,l,GF,InvStartValues,InvFinalValues,Priors,Meas,BCsAdjoint,RunInfo)
%%
% This routine is called during the run and can be used for saving and/or plotting data.
% 
%   UserVar=DefineOutputs(UserVar,CtrlVar,MUA,BCs,F,l,GF,InvStartValues,InvFinalValues,Priors,Meas,BCsAdjoint,RunInfo)
%
% Write your own version of this routine and put it in you local run directory.
% 
%
%   This is the m-file you use to define/plot your results.
%
%   You will find all the outputs in the variable F
%
%   The variable F is a structure, and has various fields.
%
%   For example:
%
%   F.s             The upper glacier surface%
%   F.b             The lower glacier surface
%   F.B             The bedrock
%   F.rho           The ice density
%   F.C             Basal slipperiness, i.e. the variable C in the basal sliding law
%   F.AGlen         The rate factor, i.e. the variable A in Glen's flow law
%
%   F.ub            basal velocity in x-direction
%   F.vb            basal velocity in y-direction
%
%   All these variables are nodal variables, i.e. these are the corresponding values at the nodes of the computational domain.
%
%   You find informaton about the computational domain in the variable MUA
%
%   For example, the x and y coordinates of the nodes are in the nx2 array MUA.coordinates, where n is the number of nodes.
%
%   MUA.coordinates(:,1)    are the nodal x coordinates
%   MUA.coordinates(:,y)    are the nodal y coordinates
%
%
%   BCs             Structure with all boundary conditions
%   l               Lagrange parameters related to the enforcement of boundary
%                   conditions.
%   GF              Grounding floating mask for nodes and elements.
%
%   Note: If preferred to work directly with the variables rather than the respective fields of the structure F, thenF can easily be
%   converted into variables using v2struc.
%
%
%
%   Note:  For each call to this m-File, the variable
%
%       CtrlVar.DefineOutputsInfostring
%
%   gives you information about different stages of the run (start, middle
%   part, end, etc.).
%
%   So for example, when Ua calls this m-File for the last time during the
%   run, the variable has the value
%
%     CtrlVar.DefineOutputsInfostring="Last call"
%
%
%%


plots='-plot-';

if contains(plots,'-save-')
    
    % save data in files with running names
    % check if folder 'ResultsFiles' exists, if not create
    
    if exist(fullfile(cd,UserVar.Outputsdirectory),'dir')~=7
        mkdir(CtrlVar.Outputsdirectory) ;
    end
    
    if CtrlVar.DefineOutputsInfostring=="Last call"
  
        
        FileName=sprintf('%s/%07i-Nodes%i-Ele%i-Tri%i-kH%i-%s.mat',...
            CtrlVar.Outputsdirectory,round(100*F.time),MUA.Nnodes,MUA.Nele,MUA.nod,1000*CtrlVar.kH,CtrlVar.Experiment);
        fprintf(' Saving data in %s \n',FileName)
        save(FileName,'UserVar','CtrlVar','MUA','F')
        
    end
    
end

if contains(plots,'-plot-')
    
    figsWidth=1000 ; figHeights=300;
    GLgeo=[]; xGL=[] ; yGL=[];
    %%
    
    FindOrCreateFigure("FourPlots") ; % ,[50 50 figsWidth 3*figHeights]) ;

    Tile=tiledlayout(2,2) ;
    nexttile
    PlotMeshScalarVariable(CtrlVar,MUA,F.s); title(sprintf('s at t=%g',F.time))
    hold on    
    [xGL,yGL,GLgeo]=PlotGroundingLines(CtrlVar,MUA,GF,GLgeo,xGL,yGL);
   
    
    
    nexttile
    QuiverColorGHG(F.x,F.y,F.ub,F.vb,CtrlVar);
    hold on
    [xGL,yGL,GLgeo]=PlotGroundingLines(CtrlVar,MUA,GF,GLgeo,xGL,yGL);
    hold off
    
    nexttile
    PlotMeshScalarVariable(CtrlVar,MUA,F.dhdt);   title(sprintf('dhdt at t=%g',F.time))
    hold on
    [xGL,yGL,GLgeo]=PlotGroundingLines(CtrlVar,MUA,GF,GLgeo,xGL,yGL);
    
    nexttile
    PlotMeshScalarVariable(CtrlVar,MUA,F.as);   title(sprintf('ab at t=%g',F.time))
    hold on
    
    [xGL,yGL,GLgeo]=PlotGroundingLines(CtrlVar,MUA,GF,GLgeo,xGL,yGL);
    hold off
    
    Tile.Padding="compact";
    Tile.TileSpacing="compact";
    
    
    
    FindOrCreateFigure("Mesh and grounding line") ; 
    PlotMuaMesh(CtrlVar,MUA);
    hold on 
    
    [xGL,yGL,GLgeo]=PlotGroundingLines(CtrlVar,MUA,GF,GLgeo,xGL,yGL,'r','LineWidth',2);
    title(sprintf('t=%g',F.time))
    hold off
    
    drawnow
    %%
end


end