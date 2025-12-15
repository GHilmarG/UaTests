function  [UserVar,s,b,S,B,rho,rhow,g]=DefineGeometryAndDensities(UserVar,CtrlVar,MUA,F,FieldsToBeDefined)


persistent FsWeertman FbWeertman 


g=9.81/1000;
rho=917   ;
rhow=1030 ;


% Defines model geometry



B=MismBed(F.x,F.y);
S=B*0;


if contains(FieldsToBeDefined,"s")
    fprintf(' The geometry is initialised based on a previously obtained steady-state solutions. \n')
    switch CtrlVar.SlidingLaw

        case "Tsai"
            load('MismipPlusThicknessInterpolants','FsTsai','FbTsai')
            s=FsTsai(F.x,F.y) ;
            b=FbTsai(F.x,F.y) ;
        otherwise
            load('../../../Interpolants/MismipPlusThicknessInterpolants','FsWeertman','FbWeertman')
            s=FsWeertman(F.x,F.y) ;
            b=FbWeertman(F.x,F.y) ;
    end
else
    s=[] ; b=[];
end


end





