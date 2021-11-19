function  [UserVar,s,b,S,B,rho,rhow,g]=DefineGeometryAndDensities(UserVar,CtrlVar,MUA,F,FieldsToBeDefined)


persistent Fs Fb

if isempty(Fs)


    switch UserVar.Region

        case "-Lethu-"

            load("SteadyStateInterpolantsLethu.mat","Fb","Fs")

        case "-LethuNS-"
            
            load("SteadyStateInterpolantsLethuNS.mat","Fb","Fs")
            %s=50*ones(MUA.Nnodes,1);
            %b=zeros(MUA.Nnodes,1);
            %Fs=scatteredInterpolant(F.x,F.y,s);
            %Fb=scatteredInterpolant(F.x,F.y,b);

            % load("SteadyStateInterpolantsLethuNS.mat","Fb","Fs")

    end
end

g=9.81/1000;
rho=917   ;
rhow=1030 ;

B=Bedgeometry(UserVar,CtrlVar,MUA,F,UserVar.Region);
s=[] ; b=[] ;

if contains(FieldsToBeDefined,"-s-")
    s=Fs(F.x,F.y);
end

if contains(FieldsToBeDefined,"-b-")
    b=Fb(F.x,F.y);
end

S=zeros(MUA.Nnodes,1);


end




