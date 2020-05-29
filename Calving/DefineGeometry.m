
function [UserVar,s,b,S,B,alpha]=DefineGeometry(UserVar,CtrlVar,MUA,time,FieldsToBeDefined,F)
    
    % Defines model geometry
    
    x=MUA.coordinates(:,1); y=MUA.coordinates(:,2);
    alpha=0.;
    
    if contains(UserVar.RunType,"-1dAnalyticalIceShelf-")
        B=zeros(MUA.Nnodes,1)-1e5;
    else
        B=MismBed(x,y);
    end
    
    S=B*0;
    s=[];
    b=[];
    
    
    if contains(FieldsToBeDefined,"b") ||  contains(FieldsToBeDefined,"s")
        s=F.s ;
        b=F.b ;
        
        
        if contains(UserVar.RunType,"-ManuallyModifyThickness-")
            
            
            if CtrlVar.LevelSetMethod  && ~isempty(F.LSF)
                
                if CtrlVar.CurrentRunStepNumber>=2   % allow a few run steps before starting to modify geometry
                    
                    hMin=CtrlVar.ThickMin+1 ;
                    
                    if numel(F.LSF) ~= MUA.Nnodes
                        error('wrong dimentions ' )
                    end
                    
                    Mask=CalcMeshMask(CtrlVar,MUA,F.LSF,0); 
                    s(Mask.NodesOut)=b(Mask.NodesOut)+hMin;
                    
                end
                
            else
                
                
                if ~isempty(F.GF)
                    if CtrlVar.CurrentRunStepNumber==2
                        
                        if ~isfield(CtrlVar.GF,"NodesDownstreamOfGroundingLines")
                            F.GF=IceSheetIceShelves(CtrlVar,MUA,F.GF);
                        end
                        
                        CutOff=400e3;
                        I=F.GF.NodesDownstreamOfGroundingLines & x> CutOff ;
                        hMin=CtrlVar.ThickMin+1 ;
                        s(I)=b(I)+hMin;
                        
                    end
                    
                end
            end
        end
    end
    
    % initial def for s and b at start of run
    if CtrlVar.CurrentRunStepNumber<=1
        
        
        if contains(UserVar.RunType,"-1dAnalyticalIceShelf-")
            
            %
            %
            %
            h0=1000;  % make sure this is consistent with BCs!
            s=zeros(MUA.Nnodes,1);
            b=s-h0;
            
        else
            
            % h0=1000-1000/640e3*x;
            % s=b+h0;
            
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
            
        end
    end
    
    %   h=s-b ; h(h<CtrlVar.ThickMin)=CtrlVar.ThickMin ;
    %   s=b+h ;
    
    
end
