




function PlotResultsFromThicknessInversion(CtrlVar,MUA,F,BCs,Priors,Meas,Method,hest,kIso,kAlong,kCross)





FigTitle=sprintf("kIso=%5.1f kAlong=%5.1f kAcross=%5.1f",mean(kIso),mean(kAlong),mean(kCross));



UaPlots(CtrlVar,MUA,F,hest,FigureTitle="hest") ; 
title("h estimated")
axis tight

%nexttile ; 
% 
UaPlots(CtrlVar,MUA,F,htrue,FigureTitle="h true") ; title(FigTitle)
axis tight


%nexttile ;
% h1=histogram(hest-htrue); h1.Normalization="probability";

FindOrCreateFigure("compare")
yyaxis left
plot(htrue,hest,'.')
hold on
plot(xlim,xlim);
ylim(xlim)
ylabel("h estimated")
yyaxis right
plot(htrue,hest-htrue,'.')
ylabel("hest-htrue")

lm=fitlm(hest,htrue);
title(sprintf("R2=%f",lm.Rsquared.Ordinary));
xlabel("h true")  ;

%UaPlots(CtrlVar,MUA,F,"speed") ; % title("")
%axis tight

% nexttile ; 

UaPlots(CtrlVar,MUA,F,hest-htrue,FigureTitle="hest-htrue") ;  title("hest-htrue")

if ~isempty(Priors.h)
    UaPlots(CtrlVar,MUA,F,Priors.h,FigureTitle="hprior") ;  title("h prior")
end

if ~isempty(Meas.h)
    UaPlots(CtrlVar,MUA,F,Meas.h,FigureTitle="hmeas") ;  title("h measurements")
end



end