function  [UserVar,BCs]=DefineBoundaryConditions(UserVar,CtrlVar,MUA,F,BCs)



switch UserVar.Example


    case "-Antarctica-"

        r=vecnorm([F.x F.y],2,2)  ;
        I=find(r<100e3 | F.x< -2000e3) ;
        BCs.hFixedNode=I ; BCs.hFixedValue=F.N(I) ;   % N set to Phi, -> gradient of (Phi-N) will be zeros


    case {"-Dome-Phi-", "-Hat-Phi-"}



        switch CtrlVar.GWE.Variable

            case "-phi-" 

                % Setting \phi=rhow g b + pw at boundary
                BCs.hFixedNode=MUA.Boundary.Nodes;
                pw=0;
                BCs.hFixedValue=F.rhow*F.g.*F.b(BCs.hFixedNode) +pw;

            case "-N-"


                % Setting N=0 at boundary
                
                % pw=0 -> g rho (s-b) - N =0
                %      -> N= g rho h
                
                nodes=MUA.Boundary.Nodes;
                BCs.hFixedNode=nodes;
                BCs.hFixedValue=F.g.*F.rho.*(F.s(nodes)-F.b(nodes)) ;



            otherwise

                errro("case not found")

        end

end


FindOrCreateFigure("BCs") ; PlotBoundaryConditions(CtrlVar,MUA,BCs);

end