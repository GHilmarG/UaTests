
%% an example using dhdt with B inversion and IceStream geometry
dx=[ 0.001   0.01    0.1     1       5      10      20      30      50      100];
f1=[0.0639  0.496   4.829   48.1    240     481     963     1446    2415     4879];
f2=[0.0167  0.0168  0.0169  0.0169  0.034   0.404   3.38    11.25   49.6     342 ] ;
c2=[0.0168  0.0168  0.0168  0.0168  0.0132  0.00758 0.055   0.160   0.692   7.199 ] ;
c4=[0.0168  0.0168  0.0168  0.0168  0.0167  0.0170  0.046   0.203   1.489   19.38 ] ;

% After correction 
f2=[7.7e-5  1.34e-5  3.1e-6    1.04995e-4   0.047       0.41        3.34   11.09    NaN     NaN ]   ;
c2=[2.95e-5 3.64e-6 1.617e-6   1.64e-4      0.0040      0.0161      0.067   0.171   0.695   7.102 ] ;
c4=[4.09e-5  4.58e-6  2.8e-6   1.39e-6      0.000343    0.00232     0.0317  0.186   1.451   19.07 ] ;

figure
loglog(dx,f1,'-or') 
hold on
loglog(dx,f2,'-^g') 
loglog(dx,c2,'-+b') 
loglog(dx,c4,'-*c') 

legend('forward-first-order','forward-second-order','central-second-order','central-fourth-order')
%axis([1 100 1e-3 1e4])
ylabel('|dJdpAdjoint-dJdpFD|/|dJdpAdjoint|')
xlabel('FD step size')

%%


%%
% UserVar.Inverse.Syntdata.GeoPerturbation='valley'; UserVar.RunType='valley';  UserVar.vShift=1000 ; % This generates a synthetic valley shaped b geometry
% CtrlVar.Inverse.TestAdjoint.iRange=[220:250] 
% CtrlVar.Inverse.InvertFor='-B-'
% CtrlVar.Inverse.Measurements='-dhdt-' 
% UserVar.Inverse.SynthData.Pert="-B-" 
dx=[ 0.001   0.01    0.1     1       5      10      25          50      100];
f1=[NaN      2.74    2.74    2.69   2.47    2.22    1.694       1.398   1.7];
c2=[NaN      NaN    NaN     2.75     2.76     NaN     NaN         NaN     NaN];

% after correction
dx=[ 0.001   0.01    0.1        0.5             0.75            1               1.5         2           5           10          25          ];
c2=[NaN      NaN     0.00024532 0.00117071      0.00304373      0.0053961       0.0121409   0.0215829   0.134827    0.538678    3.34148     ];  
c4=[NaN      NaN     0.00087942 0.000321278     5.75846e-05     3.96034e-06     9.69234e-06 2.39632e-05 0.000646843 0.00766275  0.151626    ];


figure
loglog(dx,c2,'-or') 
hold on
%loglog(dx,f2,'-^g') 
%loglog(dx,c2,'-+b') 
loglog(dx,c4,'-*c') 

%legend('forward-first-order','forward-second-order','central-second-order','central-fourth-order')
%axis([1 100 1e-3 1e4])
ylabel('|dJdpAdjoint-dJdpFD|/|dJdpAdjoint|')
xlabel('FD step size')



%%
% UserVar.RunType='IceStream';   UserVar.Inverse.Syntdata.GeoPerturbation='gauss';
% CtrlVar.Inverse.TestAdjoint.FiniteDifferenceStepSize=1e-5 ;
% CtrlVar.Inverse.TestAdjoint.iRange=[220:250] 
% CtrlVar.Inverse.InvertFor='-logC-'
% CtrlVar.Inverse.Measurements='-dhdt-' 
% UserVar.Inverse.SynthData.Pert="-B-" 
dx=[1e-6                    1e-5             1e-4           1e-3            1e-2            1e-1        1] ; 
c2=[2.00761e-06             2.00893e-05      0.00019904     0.00459092      0.458079        37.0746     246257] ; 
c4=[7.35153e-06             7.35234e-05      0.000743551    8.35087e-07     0.00428215      6.12244     106308] ; 

figure
loglog(dx,c2,'-or') 
hold on
loglog(dx,c4,'-*c')
ylabel('|dJdpAdjoint-dJdpFD|/|dJdpAdjoint|')
xlabel('FD step size')


%%
% UserVar.Inverse.Syntdata.GeoPerturbation='valley'; UserVar.RunType='valley';  UserVar.vShift=-4000 ;
% CtrlVar.Inverse.TestAdjoint.FiniteDifferenceStepSize=1e-3 ;
% All nodes

% CtrlVar.Inverse.Measurements='-dhdt-' 
% with dBFuvLambda=dIdbq(CtrlVar,MUA,uAdjoint,vAdjoint,F,dhdp,dbdp,dBdp);
% ||dJdpTest-dJdp||/||dJdp||= 7.21402e-06 
%
% and with new, using partial int.
% ||dJdpTest-dJdp||/||dJdp||= 0.0225598 
% This done for only strickly upstream nodes
% New with -uv- 
 % ||dJdpTest-dJdp||/||dJdp||= 0.0334448 
% old one
 %||dJdpTest-dJdp||/||dJdp||= 8.26264e-06 

 %%
% Very confused now
 UserVar.Inverse.Syntdata.GeoPerturbation='valley'; 
 UserVar.RunType='valley';  
 UserVar.vShift=1000 ; 
 UserVar.Inverse.SynthData.Pert="-B-";
 CtrlVar.Inverse.Measurements='-uv-dhdt-' ;  
 CtrlVar.Inverse.InvertFor='-B-'  ; 
 CtrlVar.Inverse.TestAdjoint.FiniteDifferenceStepSize=1e-3 ;
 
 New: 2.67759e-06 
 Old: 2.68451e-06
 
 % now do as above but set
 UserVar.vShift=-1000 ; 
  
 % old: 0.109456 (generally very good, but a few very large values in adjoint gradient, seen in both dBFuvLambda and -dhJhdot less extreme value in dBFuvLambda2
 
 
 % Notice high values in dhJhdot and decided to test this in isolation by setting
 % 
 
 
 
