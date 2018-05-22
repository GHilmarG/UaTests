%%
TG3=1;
filename=sprintf('TG3is%i.mat',TG3);  load(filename,'time','h','dhdt','CtrlVar','TRIxy','x','y')
hTG3=h ; dhdtTG3=dhdt;

TG3=0;
filename=sprintf('TG3is%i.mat',TG3);  load(filename,'time','h','dhdt','CtrlVar','TRIxy','x','y')

figure(CtrlVar.TG3+1) ;
trisurf(TRIxy,x/CtrlVar.PlotXYscale,y/CtrlVar.PlotXYscale,h-hTG3,'EdgeColor','none') ; title(sprintf(' h-hTG3 at t=%-g, TG3=%-i',time,CtrlVar.TG3))
view(5.5,12)