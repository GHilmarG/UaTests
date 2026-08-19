
%%


load("SurfaceTime-uv-h-uv_h_MaxIt1_Theta0k5_dt1.mat","t","sMax","sMin")

sFig=FindOrCreateFigure("s(t) compare") ; clf(sFig) 

yyaxis left
plot(t,sMin,"o-",DisplayName="min(s): uv-h")
ylabel("$\min(s)$ (m)",Interpreter="latex")
yyaxis right
plot(t,sMax,"s-",DisplayName="max(s): uv-h")


hold on 

load("SurfaceTime-uvh-Theta0k5_dt1.mat","t","sMax","sMin")

yyaxis left
plot(t,sMin,"o-",DisplayName="min(s): uvh",LineWidth=2)
ylabel("$\min(s)$ (m)",Interpreter="latex")
yyaxis right
plot(t,sMax,"s-",DisplayName="max(s): uvh",LineWidth=2)



lg=legend;
xlabel("time (yr)")
ylabel("$\max(s)$ (m)",Interpreter="latex")


%%



s0Fig=FindOrCreateFigure("s0 compare") ; clf(s0Fig) 

load("SurfaceTime-uv-h-uv_h_MaxIt1_Theta0k5_dt1.mat","t","s0")
plot(t,s0,"o-b",DisplayName="s(x=0,y=0,t): uv-h 1It hTheta=0.5")
ylabel("$s(0,0,t)$ (m)",Interpreter="latex")

hold on 



 load("SurfaceTime-uv-h-uv_h_MaxIt10_Theta0k5_dt1.mat","t","s0")
 plot(t,s0,"o-g",DisplayName="s(x=0,y=0,t): uv-h 10It hTheta=0.5 dt=1")
 ylabel("$s(0,0,t)$ (m)",Interpreter="latex")

 load("SurfaceTime-uv-h-uv_h_MaxIt1_Theta0_dt1.mat","t","s0")
 plot(t,s0,"x-c",DisplayName="s(x=0,y=0,t): uv-h 1It hTheta=0 dt=1")
 ylabel("$s(0,0,t)$ (m)",Interpreter="latex")

 load("SurfaceTime-uv-h-uv_h_MaxIt1_Theta0_dt10.mat","t","s0")
 plot(t,s0,"s--g",DisplayName="s(x=0,y=0,t): uv-h 1It hTheta=0 d10")
 ylabel("$s(0,0,t)$ (m)",Interpreter="latex")


load("SurfaceTime-uvh-Theta0k5_dt1.mat","t","s0")
plot(t,s0,"o-r",DisplayName="s(x=0,y=0,t): uvh uvhTheta=0.5 dt=1",LineWidth=2)
ylabel("$s(0,0,t)$ (m)",Interpreter="latex")


load("SurfaceTime-uvh-Theta0k5_dt10.mat","t","s0")
plot(t,s0,"o--r",DisplayName="s(x=0,y=0,t): uvh uvhTheta=0.5 dt=10",LineWidth=2)
ylabel("$s(0,0,t)$ (m)",Interpreter="latex")

lg=legend;
xlabel("time (yr)")
ylabel("$s(0,0,t)$ (m)",Interpreter="latex")


%%