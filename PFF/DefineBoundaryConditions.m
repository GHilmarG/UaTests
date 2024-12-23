function  BCs=DefineBoundaryConditions(UserVar,CtrlVar,MUA,F,BCs) 

%%
% BCs=DefineBoundaryConditions(UserVar,CtrlVar,MUA,BCs,time,s,b,h,S,B,ub,vb,ud,vd,GF)
%
% BC is a matlab object with the following fields 
%
%   BCs = 
% 
%   BoundaryConditions with properties:
% 
%              ubFixedNode: []
%             ubFixedValue: []
%              vbFixedNode: []
%             vbFixedValue: []
%              ubTiedNodeA: []
%              ubTiedNodeB: []
%              vbTiedNodeA: []
%              vbTiedNodeB: []
%      ubvbFixedNormalNode: []
%     ubvbFixedNormalValue: []
%              udFixedNode: []
%             udFixedValue: []
%              vdFixedNode: []
%             vdFixedValue: []
%              udTiedNodeA: []
%              udTiedNodeB: []
%              vdTiedNodeA: []
%              vdTiedNodeB: []
%      udvdFixedNormalNode: []
%     udvdFixedNormalValue: []
%               hFixedNode: []
%              hFixedValue: []
%               hTiedNodeA: []
%               hTiedNodeB: []
%                 hPosNode: []
%                hPosValue: []
%       
%
% see also BoundaryConditions.m
% 
% Examples:
%
%  To set velocities at all grounded nodes along the boundary to zero:
%
%   GroundedBoundaryNodes=MUA.Boundary.Nodes(GF.node(MUA.Boundary.Nodes)>0.5);
%   BCs.vbFixedNode=GroundedBoundaryNodes; 
%   BCs.ubFixedNode=GroundedBoundaryNodes; 
%   BCs.ubFixedValue=BCs.ubFixedNode*0;
%   BCs.vbFixedValue=BCs.vbFixedNode*0;
%
% 
%%


switch  CtrlVar.BCs


    case "-uv-"

        tolerance=1;
        V=5000 ; % This is the +/- v velocity applied at upper and lower boundaries


        xmax=max(F.x) ; ymax=max(F.y) ; xmin=min(F.x) ;  ymin=min(F.y) ;

        UpperEdgeNodes= MUA.Boundary.Nodes(abs(F.y(MUA.Boundary.Nodes)-ymax) <tolerance) ;
        LowerEdgeNodes= MUA.Boundary.Nodes(abs(F.y(MUA.Boundary.Nodes)-ymin) <tolerance) ;
        LeftEdgeNodes= MUA.Boundary.Nodes(abs(F.x(MUA.Boundary.Nodes)-xmin) <tolerance) ;

        BCs.ubFixedNode=[UpperEdgeNodes; LowerEdgeNodes ; LeftEdgeNodes] ;  BCs.ubFixedValue=BCs.ubFixedNode*0;
        BCs.vbFixedNode=[UpperEdgeNodes ; LowerEdgeNodes] ; BCs.vbFixedValue=[UpperEdgeNodes*0+V ; LowerEdgeNodes*0-V];


        % BCs.ubFixedNode=1 ;  BCs.ubFixedValue=BCs.ubFixedNode*0;

    case "-phi-"


        switch UserVar.Experiment

            case "single notch"

             

                l=CtrlVar.PhaseFieldFracture.l ;
                Iy0=find(abs(F.y)<(l/2) & F.x > 50e3 );
                BCs.hFixedNode=Iy0 ;  
                BCs.hFixedValue=Iy0*0+1 ;


            case "double notch"


                l=CtrlVar.PhaseFieldFracture.l ;
                
                yr=20e3;
                yl=-20e3 ;

                Iy0=(abs(F.y-yr)<(l/2) & F.x <-50e3 )  | (abs(F.y-yl)<(l/2) & F.x >50e3 ) ; 
                
                Iy0=find(Iy0) ;     



                BCs.hFixedNode=Iy0 ;  
                BCs.hFixedValue=Iy0*0+1 ;


            otherwise

                error("case not found")


        end
    otherwise

        error("case not found")

end


end