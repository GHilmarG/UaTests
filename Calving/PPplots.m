
%%

File(1)="TestLSFresults-Iceshelf-mu1-dt0k1-2-20000";
File(2)="TestLSFresults-Iceshelf-mu1-dt0k1-20-2000";
File(3)="TestLSFresults-Iceshelf-mu1-dt0k1-100-2000" ;

File(4)="TestLSFresults-Iceshelf-mu1-dt0k1-10-20000" ;
File(5)="TestLSFresults-Iceshelf-mu10000-dt0k1-10-20000" ;
File(6)="TestLSFresults-Iceshelf-mu1000000-dt0k1-10-20000";
File(7)="TestLSFresults-Iceshelf-mu10000000-dt0k1-10-20000";
File(8)="TestLSFresults-Iceshelf-mu100000000-dt0k1-10-20000";
File(9)="TestLSFresults-Iceshelf-mu10000000000-dt0k1-10-20000";




File(11)="TestLSFresults-Iceshelf-mu10000000-dt0k1-10-20000-xc100000";

File(10)="TestLSFresults-Iceshelf-mu10000000-dt0k1-10-20000-xc50000";
File(12)="TestLSFresults-Iceshelf-mu10000000-dt0k1-10-20000-xc50000--pseudo-forward-";
File(13)="TestLSFresults-Iceshelf-mu10000000-dt0k01-10-20000-xc50000-";
File(14)="TestLSFresults-Iceshelf-mu5000000-dt0k01-10-20000-xc50000-";
File(15)="TestLSFresults-Iceshelf-mu10000000-dt0k10-2-20000-xc50000-";
File(16)="TestLSFresults-Iceshelf-muucl-dt0k10-2-20000-xc50000-";
File(17)="TestLSFresults-Iceshelf-muucl-dt0k10-10-20000-xc50000-";

File(18)="TestLSFresults-Iceshelf-muScaleucl-muValue1000-dt0k10-10-20000-xc50000-" ; 
File(19)="TestLSFresults-Iceshelf-p2q2-muScaleucl-muValue100-dt0k10-10-20000-xc50000-";
File(20)="TestLSFresults-Iceshelf-p2q2-muScaleucl-muValue10-dt0k10-10-20000-xc50000-";

File(21)="TestLSFresults-Iceshelf-F0test-p2q2-muScaleconstant-muValue10000000-dt0k10-10-20000-xc50000-" ;
File(22)="TestLSFresults-Iceshelf-F0test2-p2q2-muScaleconstant-muValue10000000-dt0k10-10-20000-xc50000-" ;
File(23)="TestLSFresults-Iceshelf-F0test3-p2q2-muScaleconstant-muValue10000000-dt0k10-10-20000-xc50000-l1000";
File(24)="TestLSFresults-Iceshelf-F0test3-p2q2-muScaleconstant-muValue10000000-dt0k10-10-20000-xc50000-l1000-N6";

col=["m","b","g","c","r","y"];
close all
K=0 ;
fig=FindOrCreateFigure("PPplots") ;
hold off
for I=[23 24] % [10 21 22 23]
    
    load(File(I))
    
    K=K+1;
    
 
    yyaxis left
    plot(tVector,xcLSFNumerical/1000,'.',color=col(K),LineWidth=0.5,DisplayName="numerical")
    hold on
    plot(tVector,xcAnalytical/1000,'-k',DisplayName="analytical") ;
 
    
   
    xlabel("$t \; \mathrm{(yr)}$","Interpreter","latex")
    ylabel("$x_c\;\mathrm{(km)}$","Interpreter","latex")
    %ylim([100 200])
    yyaxis right
    hold on
    plot(tVector,(xcAnalytical-xcLSFNumerical)/1000,'--',color=col(K),Linewidth=0.5,DisplayName="error")
    % plot(xlim,[0 0],'-r')
    ylabel("$\Delta x_c$ (Analytical-Numerical) $\;\mathrm{(km)}$","Interpreter","latex")
    
    %legend("$x_c$ analytical","$x_c$ numerical","Nearest node to $x_c$","$\Delta x_c$ (Analytical-Numerical)",...
    %    "interpreter","latex","location","northwest")
    
    %    legend("$x_c$ analytical","$x_c$ numerical","$\Delta x_c$ (Analytical-Numerical)",...
    %        "interpreter","latex","location","northeast")
    
    
    
    title(sprintf("std %f ",std(xcAnalytical-xcLSFNumerical,'omitnan')))
end
l=plot(xlim,[0 0],'-r');

% l.Annotation.LegendInformation.IconDisplayStyle = 'off';
% lgd=legend(...
%     "interpreter","latex","location","northeast");
% lgd.NumColumns = 3;

% exportgraphics(gca,"PPplots.pdf") ; 
