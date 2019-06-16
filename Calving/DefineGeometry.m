<<<<<<< HEAD


function [UserVar,s,b,S,B,alpha]=DefineGeometry(UserVar,CtrlVar,MUA,time,FieldsToBeDefined,F)

persistent  ThicknessReset

% Defines model geometry

x=MUA.coordinates(:,1); y=MUA.coordinates(:,2);
alpha=0.;
B=MismBed(x,y);
S=B*0;

if time< eps
    b=B;
    h0=1000-1000/640e3*x;
    s=b+h0;
else
    if contains(FieldsToBeDefined,'s') &&  contains(FieldsToBeDefined,'b')
        b=F.b ;
        s=F.s ;
        
        if isempty(ThicknessReset)
            fprintf('DG #s=%i #b=%i #S=%i #B=%i #h=%i #GF.node=%i \n ',numel(F.s),numel(F.b),numel(F.S),numel(F.B),numel(F.h),numel(F.GF.node))
            Draft=F.h.*(1-F.rho/F.rhow) ; % .*F.GF.node;
            b=F.b ;
            s=F.s ;
            
            I=Draft < 100 ;
            s(I)=b(I)+CtrlVar.ThickMin+1;
            ThicknessReset=true;
        end
        
    else
        s=[];
        b=[];
    end
end




end
=======


function [UserVar,s,b,S,B,alpha]=DefineGeometry(UserVar,CtrlVar,MUA,time,FieldsToBeDefined,F)

% Defines model geometry

x=MUA.coordinates(:,1); y=MUA.coordinates(:,2);
alpha=0.;
B=MismBed(x,y);
S=B*0;

if time< eps
    b=B;
    h0=1000-1000/640e3*x;
    s=b+h0;
else
    %Draft=F.h.*(1-F.rho/F.rhow);
    b=F.b ;
    s=F.s ;

end




end
>>>>>>> development
