function  [UserVar,s,b,S,B,rho,rhow,g]=DefineGeometryAndDensities(UserVar,CtrlVar,MUA,F,FieldsToBeDefined)


persistent Fs Fb

if isempty(Fs)
          
    load("SteadyStateInterpolants.mat","Fb","Fs")

end

g=9.81/1000;
rho=917   ;
rhow=1030 ;

B=Bedgeometry(UserVar,CtrlVar,MUA,F);
s=[] ; b=[] ; 

if contains(FieldsToBeDefined,"-s-")
    s=Fs(F.x,F.y);
end

if contains(FieldsToBeDefined,"-b-")
    b=Fb(F.x,F.y);
end

S=zeros(MUA.Nnodes,1);


end




