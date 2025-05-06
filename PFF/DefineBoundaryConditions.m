




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
        RightEdgeNodes= MUA.Boundary.Nodes(abs(F.x(MUA.Boundary.Nodes)-xmax) <tolerance) ;


        if   UserVar.Experiment=="ice shelf single notch" || UserVar.Experiment=="damaged/deactivated"

                        
       %     I=MUA.Boundary.Nodes(F.x(MUA.Boundary.Nodes) < xmax)  ; 
            I=MUA.Boundary.Nodes(F.x(MUA.Boundary.Nodes) < 80e3)  ; 

            
            BCs.ubFixedNode=I ; BCs.ubFixedValue=BCs.ubFixedNode*0;
            BCs.vbFixedNode=I ; BCs.vbFixedValue=BCs.vbFixedNode*0;

        elseif UserVar.Experiment=="1D ice shelf"

            BCs.ubFixedNode=[LeftEdgeNodes ; RightEdgeNodes ] ;  BCs.ubFixedValue=BCs.ubFixedNode*0;
            BCs.vbFixedNode=[LeftEdgeNodes ; UpperEdgeNodes ; LowerEdgeNodes ; RightEdgeNodes ] ; BCs.vbFixedValue= BCs.vbFixedNode*0; 


        elseif UserVar.Experiment=="ice shelf stream flow"


            
             
             % BCs.ubFixedNode=[UpperEdgeNodes; LowerEdgeNodes ; LeftEdgeNodes] ;
             
             xU=F.x(MUA.Boundary.Nodes);
             yU=F.y(MUA.Boundary.Nodes);
             
             % Iu=xU < 0 | (xU>=0 & abs(yU)>20e3 ) ;
             % 
             % 
             % BCs.ubFixedNode=MUA.Boundary.Nodes(Iu);
             % BCs.ubFixedValue=BCs.ubFixedNode*0;
             % 
             % 
             % BCs.vbFixedNode=[UpperEdgeNodes ; LowerEdgeNodes] ; BCs.vbFixedValue=[UpperEdgeNodes*0; LowerEdgeNodes*0];

             Iu=xU < 60e3 & ~(yU<-80e3 & xU> -90e3) ; 
             BCs.ubFixedNode=MUA.Boundary.Nodes(Iu); BCs.ubFixedValue=BCs.ubFixedNode*0;

              BCs.vbFixedNode=[LeftEdgeNodes ; UpperEdgeNodes ; LowerEdgeNodes ] ; BCs.vbFixedValue= BCs.vbFixedNode*0; 

              %BCs.vbFixedNode=MUA.Boundary.Nodes(Iu); BCs.vbFixedValue=BCs.vbFixedNode*0;



        elseif UserVar.Experiment=="ice shelf constricted"

            uFixedNodes=setdiff(MUA.Boundary.Nodes,[RightEdgeNodes;LowerEdgeNodes;UpperEdgeNodes]) ;
            BCs.ubFixedNode=uFixedNodes;  BCs.ubFixedValue=BCs.ubFixedNode*0;
           
            vFixedNodes=setdiff(MUA.Boundary.Nodes,RightEdgeNodes) ;
            BCs.vbFixedNode=vFixedNodes;  BCs.vbFixedValue=BCs.vbFixedNode*0;



        else


            BCs.ubFixedNode=[UpperEdgeNodes; LowerEdgeNodes ; LeftEdgeNodes] ;  BCs.ubFixedValue=BCs.ubFixedNode*0;
            BCs.vbFixedNode=[UpperEdgeNodes ; LowerEdgeNodes] ; BCs.vbFixedValue=[UpperEdgeNodes*0+V; LowerEdgeNodes*0-V];


            % BCs.ubFixedNode=1 ;  BCs.ubFixedValue=BCs.ubFixedNode*0;
        end

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

            case "ice shelf single notch"


                l=CtrlVar.PhaseFieldFracture.l ;
                Iy0=(abs(F.x-80e3 ) < (l/2) )  & (F.y<-60e3);

                Iy0=find(Iy0) ;



                BCs.hFixedNode=Iy0 ;
                BCs.hFixedValue=Iy0*0+1 ;

            case "ice shelf stream flow"

                  BCs.hFixedNode=[];
                BCs.hFixedValue=[];

            case "ice shelf constricted" 

                  BCs.hFixedNode=[];
                BCs.hFixedValue=[];


            otherwise

                error("case not found")


        end
    otherwise

        error("case not found")

end


% BCs.hFixedNode=1:MUA.Nnodes;  BCs.hFixedValue=BCs.hFixedNode*0; 



end