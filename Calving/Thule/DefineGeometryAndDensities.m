function  [UserVar,s,b,S,B,rho,rhow,g]=DefineGeometryAndDensities(UserVar,CtrlVar,MUA,F,FieldsToBeDefined)


persistent Fs Fb


g=9.81/1000;
rho=917   ;
rhow=1030 ;




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



B=Bedgeometry(UserVar,CtrlVar,MUA,F,BedName=UserVar.Region);
S=zeros(MUA.Nnodes,1);

s=[] ; b=[] ;

if contains(FieldsToBeDefined,"-s-") || contains(FieldsToBeDefined,"-b-")

    if contains(UserVar.RunType,"-SSmin-")
        s=10; b=0;
    elseif contains(UserVar.RunType,"-SSmax-")
        r=sqrt(F.x.*F.x+F.y.*F.y) ; 
        B0=2000 ; % B(0,0) for Thule
        h0=2000; 
        s0=B0+h0; 
        R=750e3; 
        s=s0*sqrt(1-r/R);
        s(r>=R)=0;
        b=Calc_bh_From_sBS(CtrlVar,MUA,s,B,S,rho,rhow);
    else

        b=Fb(F.x,F.y);
        s=Fs(F.x,F.y);
    end
end


end




