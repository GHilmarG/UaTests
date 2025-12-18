

%%

load('PIG-TWG-RestartFile.mat','CtrlVarInRestartFile','MUA','F')

CtrlVar=CtrlVarInRestartFile ;

UserVar.FasFile="Fas_SMB_RACMO2k3_1979_2011.mat" ; %  surface mass balance
UserVar.IceSheetIceShelves=false ;



FigureDirectory="C:\Users\Hilmar\OneDrive - Northumbria University - Production Azure AD\Work\Manuscripts\2022 ThwaitesIceShelfButtressing\Figures\";



Fig=FindOrCreateFigure("ab profiles") ;  clf(Fig)

F.b=linspace(-1000,0,MUA.Nnodes); F.b=F.b(:); 

UserVar.RunType="-MR0-"; [UserVar,as,ab,dasdh,dabdh]=DefineMassBalance(UserVar,CtrlVar,MUA,F)  ;

plot(-ab,F.b,"-",LineWidth=3.5,DisplayName=replace(UserVar.RunType,"-",""))
hold on

UserVar.RunType="-MR1-"; [UserVar,as,ab,dasdh,dabdh]=DefineMassBalance(UserVar,CtrlVar,MUA,F)  ; plot(-ab,F.b,"--",LineWidth=1.5,DisplayName=replace(UserVar.RunType,"-",""))
UserVar.RunType="-MR2-"; [UserVar,as,ab,dasdh,dabdh]=DefineMassBalance(UserVar,CtrlVar,MUA,F)  ; plot(-ab,F.b,"--",LineWidth=1.5,DisplayName=replace(UserVar.RunType,"-",""))
UserVar.RunType="-MR3-"; [UserVar,as,ab,dasdh,dabdh]=DefineMassBalance(UserVar,CtrlVar,MUA,F)  ; plot(-ab,F.b,"-",LineWidth=1.5,DisplayName=replace(UserVar.RunType,"-",""))
UserVar.RunType="-MR4-"; [UserVar,as,ab,dasdh,dabdh]=DefineMassBalance(UserVar,CtrlVar,MUA,F)  ; plot(-ab,F.b,"-",LineWidth=3.5,DisplayName=replace(UserVar.RunType,"-",""))
UserVar.RunType="-MR5-"; [UserVar,as,ab,dasdh,dabdh]=DefineMassBalance(UserVar,CtrlVar,MUA,F)  ; plot(-ab,F.b,"--",LineWidth=2,DisplayName=replace(UserVar.RunType,"-",""))



xlabel("Basal Melt Rate (m/yr)",Interpreter="latex")
ylabel("Ice Shelf Draft (m)",Interpreter="latex")
xlim([0 200])
legend


f = gcf; exportgraphics(f,'BasalMeltRateParameterisations.pdf')