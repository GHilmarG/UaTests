
%%

File(1)="RF-WAIS-aw0-MS20km-D-hwmin0k1.mat";
File(2)="RF-WAIS-aw0-MS20km-D-hwmin1.mat";
File(3)="RF-WAIS-MS20km-D-hwmin1.mat";




for I=1:3

    % File(I)="RF-WAIS-"+MS(I)+".mat";
    
    MS=extractBetween(File(I),"MS","-") ; 

    load(File(I),"UserVar","CtrlVar","MUA","F0","F1","k","eta","tVector","hwMaxVector","qwVector","hwMinVector","hwMaxGroundedVector","hwMaxAfloatVector","FluxGate","ActiveSet","lambda") ;

    [UserVar,hw1,ActiveSet,lambda,output]=WaterFilmThicknessEquation(UserVar,CtrlVar,MUA,F0,F1,k,eta,ActiveSet,lambda) ;

    xint=output.fun.xint ;  yint=output.fun.yint ;  qwxint=output.fun.qx1int ; qwyint=output.fun.qy1int ;

    [qwx,qwy]=ProjectFintOntoNodes(MUA,qwxint,qwyint) ;

    xint=xint(:) ; yint=yint(:) ; qwxint=qwxint(:); qwyint=qwyint(:);
    Fqwx=scatteredInterpolant(xint,yint,qwxint);
    Fqwy=scatteredInterpolant(xint,yint,qwyint);
    [Qn,Qt,qn,qt,xc,yc,normal]=PathIntegral(CtrlVar,FluxGate(:,1),FluxGate(:,2),Fqwx,Fqwy);

    fprintf("\n \n %s: Qn=%f Gt/yr \n \n",MS, Qn/1e9)

    UaPlots(CtrlVar,MUA,F1,F1.hw,FigureTitle="hw"+File(I))
    ihmin=F1.hw == CtrlVar.WaterFilm.ThickMin ;
    hold on ; plot(F1.x(ihmin)/1000,F1.y(ihmin)/1000,'.k',MarkerSize=0.1)

    F1.ub=qwx; F1.vb=qwy ;
    UaPlots(CtrlVar,MUA,F1,"-uv-",FigureTitle="(qx,qy)"+File(I))
    title(sprintf("$\\mathbf{q}_w$ time=%g %s",CtrlVar.time,MS),Interpreter="latex")

    figNp=FindOrCreateFigure("max(hw)(t)"+File(I))  ; clf(figNp) ;
    plot(tVector,hwMaxVector,"-ok")
    hold on
    plot(tVector,hwMinVector,"-*r")
    plot(tVector,hwMaxGroundedVector,"-*g")
    plot(tVector,hwMaxAfloatVector,"-*b")
    %yline(0,"--")
    title(sprintf("%s: $h_w$",MS),Interpreter="latex")
    legend("hw max","hw min","hw max grounded","hw max afloat",Location="best")

end


%% Compare


File(1)="RF-WAIS-aw0-MS20km-D-hwmin1.mat";
File(2)="RF-WAIS-MS20km-D-hwmin1.mat";

File(1)="RF-WAIS-aw0-MS10km-D-hwmin1e-06.mat";
File(2)="RF-WAIS-MS10km-D-hwmin1e-06.mat";




for I=1:2

    % File(I)="RF-WAIS-"+MS(I)+".mat";
    
    MS=extractBetween(File(I),"MS","-") ; 

    load(File(I),"UserVar","CtrlVar","MUA","F0","F1","k","eta","tVector","hwMaxVector","qwVector","hwMinVector","hwMaxGroundedVector","hwMaxAfloatVector","FluxGate","ActiveSet","lambda") ;

    [UserVar,hw1,ActiveSet,lambda,output]=WaterFilmThicknessEquation(UserVar,CtrlVar,MUA,F0,F1,k,eta,ActiveSet,lambda) ;

    xint=output.fun.xint ;  yint=output.fun.yint ;  qwxint=output.fun.qx1int ; qwyint=output.fun.qy1int ;

    [qwx,qwy]=ProjectFintOntoNodes(MUA,qwxint,qwyint) ;

    xint=xint(:) ; yint=yint(:) ; qwxint=qwxint(:); qwyint=qwyint(:);
    Fqwx=scatteredInterpolant(xint,yint,qwxint);
    Fqwy=scatteredInterpolant(xint,yint,qwyint);
    [Qn,Qt,qn,qt,xc,yc,normal]=PathIntegral(CtrlVar,FluxGate(:,1),FluxGate(:,2),Fqwx,Fqwy);

    fprintf("\n \n %s: Qn=%f Gt/yr \n \n",MS, Qn/1e9)

    UaPlots(CtrlVar,MUA,F1,F1.hw,FigureTitle="hw"+File(I))
    ihmin=F1.hw == CtrlVar.WaterFilm.ThickMin ;
    hold on ; plot(F1.x(ihmin)/1000,F1.y(ihmin)/1000,'.k',MarkerSize=0.1)

    F1.ub=qwx; F1.vb=qwy ; % the units are m^2 /yr
    UaPlots(CtrlVar,MUA,F1,"-uv-",FigureTitle="(qx,qy)"+File(I))
    title(sprintf("$\\mathbf{q}_w$ time=%g %s",CtrlVar.time,MS),Interpreter="latex")

    figNp=FindOrCreateFigure("max(hw)(t)"+File(I))  ; clf(figNp) ;
    plot(tVector,hwMaxVector,"-ok")
    hold on
    plot(tVector,hwMinVector,"-*r")
    plot(tVector,hwMaxGroundedVector,"-*g")
    plot(tVector,hwMaxAfloatVector,"-*b")
    %yline(0,"--")
    title(sprintf("%s: $h_w$",MS),Interpreter="latex")
    legend("hw max","hw min","hw max grounded","hw max afloat",Location="best")


    if I==2

        F1.ub=qwx-qwxRef ;F1.vb=qwy-qwyRef ;
        cbar=UaPlots(CtrlVar,MUA,F1,"-uv-",FigureTitle="(dqx,dqy)") ;
        title(sprintf("$\\Delta\\mathbf{q}_w$ time=%g %s",CtrlVar.time,MS),Interpreter="latex")
        title(cbar,"($\mathrm{m^2 \, yr^{-1}}$)") ;
    
    end


    if I==1
        qwxRef=qwx ; qwyRef=qwy;  F1Ref=F1;
    end



end


%% example plots
F1.ub=qwx-qwxRef ;F1.vb=qwy-qwyRef ;  % the units are m^2 /yr
cbar=UaPlots(CtrlVar,MUA,F1,"-uv-",FigureTitle="(dqx,dqy) PIG") ;
title(sprintf("$\\Delta\\mathbf{q}_w$ time=%g %s",CtrlVar.time,MS),Interpreter="latex")
title(cbar,"($\mathrm{m^2 \, yr^{-1}}$)") ;
axis([-2000 -1200 -500 50])
xlabel("xps (km)")
ylabel("yps (km)")
hold on ; PlotLatLonGrid();
PlotCalvingFronts();
title("Subglacial Water Flux")
exportgraphics(gcf,'PIG-TWG-WaterFluxes-10km.pdf')
exportgraphics(gcf,'PIG-TWG-WaterFluxes-10km.png')
%%
F1.ub=qwx-qwxRef ;F1.vb=qwy-qwyRef ;
cbar=UaPlots(CtrlVar,MUA,F1,"-uv-",FigureTitle="(dqx,dqy) Siple") ;
title(sprintf("$\\Delta\\mathbf{q}_w$ time=%g %s",CtrlVar.time,MS),Interpreter="latex")
title(cbar,"($\mathrm{m^2 \, yr^{-1}}$)") ;
axis([-1000 -50 -1400 -380])
xlabel("xps (km)")
ylabel("yps (km)")
hold on ; PlotLatLonGrid();
PlotCalvingFronts();
title("Subglacial Water Flux")
exportgraphics(gcf,'SIPLE-WaterFluxes-10km.pdf')
exportgraphics(gcf,'SIPLE-WaterFluxes-10km.png')

%%