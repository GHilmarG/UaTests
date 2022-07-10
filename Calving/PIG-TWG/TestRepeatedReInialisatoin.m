Klear
load TestSaveRepeatedReInitialisation.mat


LSF0=F0.LSF; 
LSF=F0.LSF;

[XcStart,YcStart]=CalcMuaFieldsContourLine(CtrlVar,MUA,F0.LSF,Value,subdivide=true) ;

n=1000;
Nvector=nan(n,2);

for I=1:n

    Value=0 ;  [Xc,Yc]=CalcMuaFieldsContourLine(CtrlVar,MUA,F0.LSF,Value,subdivide=true) ;
    [~,~,F0.LSF]=...
        CalvingFrontLevelSetGeometricalInitialisation(CtrlVar,MUA,Xc,Yc,F0.LSF,...
        method="InputPoints",...
        ResampleCalvingFront=true,...
        CalvingFrontPointDistance=0.1e3,...
        plot=false) ;

    


    dLSF=F0.LSF-LSF;
    dLSF0=F0.LSF-LSF0;

    Nvector(I,1)=norm(dLSF)/sqrt(numel(dLSF)); 
    Nvector(I,2)=norm(dLSF0)/sqrt(numel(dLSF0)); 
    LSF=F0.LSF;

end

[XcEnd,YcEnd]=CalcMuaFieldsContourLine(CtrlVar,MUA,F0.LSF,Value,subdivide=true) ;

FindOrCreateFigure("BA")
plot(XcStart/1000,YcStart/1000,'-r')
hold on
plot(XcEnd/1000,YcEnd/1000,'-b')
axis equal

figure ; plot(Nvector(:,1)/1000,'k') ; hold on ; plot(Nvector(:,2)/1000,'r')

