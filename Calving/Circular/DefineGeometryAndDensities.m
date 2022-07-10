function  [UserVar,s,b,S,B,rho,rhow,g]=DefineGeometryAndDensities(UserVar,CtrlVar,MUA,F,FieldsToBeDefined)


persistent Fs Fb


g=9.81/1000;
rho=917   ;
rhow=1030 ;


if UserVar.Region=="-IceShelf-"

    s=ones(MUA.Nnodes,1);
    b=-ones(MUA.Nnodes,1);
    S=zeros(MUA.Nnodes,1) ;
    B=zeros(MUA.Nnodes,1)-1e10;


    return
end



if isempty(Fs)


    switch UserVar.Region

        case "-Thule-"

            load("SteadyStateInterpolantsThule.mat","Fb","Fs")

        case "-ThuleNS-"

            load("SteadyStateInterpolantsThuleNS.mat","Fb","Fs")
            %s=50*ones(MUA.Nnodes,1);
            %b=zeros(MUA.Nnodes,1);
            %Fs=scatteredInterpolant(F.x,F.y,s);
            %Fb=scatteredInterpolant(F.x,F.y,b);

            % load("SteadyStateInterpolantsThuleNS.mat","Fb","Fs")




        otherwise

            error("case not found")

    end
end



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




