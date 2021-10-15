

function [UserVar,s,b,S,B,alpha]=DefineGeometry(UserVar,CtrlVar,MUA,time,FieldsToBeDefined)

% Defines model geometry


x=MUA.coordinates(:,1); y=MUA.coordinates(:,2);
alpha=0.;


B=MismBed(x,y);

S=B*0;
b=B;
h0=300;
s=b+h0;


if contains(FieldsToBeDefined,"s")
    fprintf(' The geometry is initialised based on a previously obtained steady-state solutions. \n')
    switch CtrlVar.SlidingLaw

        case "Tsai"
            load('MismipPlusThicknessInterpolants','FsTsai','FbTsai')
            s=FsTsai(x,y) ;
            b=FbTsai(x,y) ;
        otherwise
            load('../../../Interpolants/MismipPlusThicknessInterpolants','FsWeertman','FbWeertman')
            s=FsWeertman(x,y) ;
            b=FbWeertman(x,y) ;
    end
else
    s=[] ; b=[];
end


end
