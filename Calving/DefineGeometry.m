
function [UserVar,s,b,S,B,alpha]=DefineGeometry(UserVar,CtrlVar,MUA,time,FieldsToBeDefined,F)
    
    % Defines model geometry
    
    x=MUA.coordinates(:,1); y=MUA.coordinates(:,2);
    alpha=0.;
    
    
    switch UserVar.InitialGeometry
        
        case "-1dAnalyticalIceShelf-"
            
            [s,b]=AnalyticalOneDimentionalIceShelf(CtrlVar,MUA);
            B=zeros(MUA.Nnodes,1)-1e5;
            S=zeros(MUA.Nnodes,1) ;
            
        case "-Constant-" % "Mismip3"  "Constant" ;
            
            h0=1000;  % make sure this is consistent with BCs!
            s=zeros(MUA.Nnodes,1);
            b=s-h0;
            
            if contains(UserVar.RunType,"-TravellingFront-")
                xc=93.1e3;
                I=MUA.coordinates(:,1)>xc ;
                h=s-b;
                h(I)=2 ;
                b=s-h;
                
            end
            B=zeros(MUA.Nnodes,1)-1e5;
            S=zeros(MUA.Nnodes,1) ;
            
        case "-MismipPlus-" % "Mismip3"  "Constant" ;
            
            B=MismBed(x,y);
            S=B*0;
            if contains(FieldsToBeDefined,"s")
                fprintf(' The geometry is initialised based on a previously obtained steady-state solutions. \n')
                switch CtrlVar.SlidingLaw
                    
                    case "Tsai"
                        load('MismipPlusThicknessInterpolants','FsTsai','FbTsai')
                        s=FsTsai(x,y) ;
                        b=FbTsai(x,y) ;
                    otherwise
                        load('MismipPlusThicknessInterpolants','FsWeertman','FbWeertman')
                        s=FsWeertman(x,y) ;
                        b=FbWeertman(x,y) ;
                end
            else
                s=[] ; b=[];
            end
    end
    
end
