
function PlotUa(CtrlVar,MUA,F,Field)



if nargin==0
    
    Field='-h-';
    MUA = evalin('base', 'MUA');
    F = evalin('base', 'F');
    CtrlVar=evalin('base','CtrlVar');
    
end

if nargin==1 && ( isstring(CtrlVar)  || ischar(CtrlVar) )
    
    Field=CtrlVar;
    MUA = evalin('base', 'MUA');
    F = evalin('base', 'F');
    CtrlVar=evalin('base','CtrlVar');
    
end


if contains(Field,'-h-')
    
    Position=[];
    figIceThickness=FindOrCreateFigure('Ice thickness (h)',Position) ;
    [~,cbar]=PlotMeshScalarVariable(CtrlVar,MUA,F.h) ;
    title(cbar,'h (m)')
    title('Ice thickness')
end



end