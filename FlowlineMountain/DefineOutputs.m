function  UserVar=DefineOutputs(UserVar,CtrlVar,MUA,BCs,F,l,GF,InvStartValues,InvFinalValues,Priors,Meas,BCsAdjoint,RunInfo)

    %%
    %
    %   This is the m-file you use to define/plot your results.
    %
    %   You will find all the outputs in the variable F
    %
    %   The variable F is a structure, and has various fields.
    %
    %   For example:
    %
    %   F.s             The upper glacier surface
    %   F.b             The lower glacier surface
    %   F.h             Ice thickness (F.h=F.s-F.b)
    %   F.B             The bedrock
    %   F.rho           The ice density
    %   F.C             Basal slipperiness, i.e. the variable C in the basal sliding law
    %   F.AGlen         The rate factor, i.e. the variable A in Glen's flow law
    %
    %   F.ub            basal velocity in x-direction
    %   F.vb            basal velocity in y-direction
    %
    %   All these variables are nodal variables, i.e. these are the corresponding values at the nodes of the computational domain.
    %
    %   You find information about the computational domain in the variable MUA
    %
    %   For example, the x and y coordinates of the nodes are in the nx2 array MUA.coordinates, where n is the number of nodes.
    %
    %   MUA.coordinates(:,1)    are the nodal x coordinates
    %   MUA.coordinates(:,2)    are the nodal y coordinates
    %
    %   CtrlVar.time            time
    %   CtrlVar.dt              time step
    %
    %   Note:  For each call to this m-File, the variable
    %
    %       CtrlVar.DefineOutputsInfostring
    %
    %   gives you information about different stages of the run (start, middle
    %   part, end, etc.).
    %
    %   So for example, when Ua calls this m-File for the last time during the
    %   run, the variable has the value
    %
    %     CtrlVar.DefineOutputsInfostring="Last call"
    %
    %
    %%

    persistent nCounter timeLast length time  MB Volume

    if isempty(nCounter)

        % Every time this m-file is called all values from previous calles are lost, except if I specify the
        % variables as 'persistent'.
        %
        % I want to store the length of the glacier as a function of time, so I
        % define two arrays to store these values at each time step as
        % persitent variables.

        nCounter=0;

        length=NaN(10000,1);  % I'm pre-allocating here, 10000 is just a number that I think will be large enough
        time=NaN(10000,1) ;   % This number should be at least as large as the number of runsteps.
        MB=NaN(10000,1) ; 
        Volume=NaN(10000,1) ; 

    end

  
    SaveFileEachRunStep=false ;
    PlotFigures=true ;


    x=MUA.coordinates(:,1);  y=MUA.coordinates(:,2);


    nCounter=nCounter+1 ;

    if PlotFigures
        if nCounter>1

            dt=CtrlVar.time-timeLast;

            if dt>0



                Figdhdt=FindOrCreateFigure("dh/dt") ;
                
                hold off
                yyaxis left
                plot(x/1000,F.dhdt,'.b')
                xlabel('x (km)','interpreter','latex') ; 
                ylabel('$dh/dt$ (m/yr)','interpreter','latex') ;
                ylim([0 5])
                
                yyaxis right
                plot(x/1000,F.ud,'r.',LineWidth=2) ; 
                hold on ; 
                plot(x/1000,F.ub,'c.',LineWidth=2) ;
                ylabel('$u_d$ and $u_b$ (m/yr)','interpreter','latex') ;
                
                title(sprintf('$dh/dt$  at  $t=$%-g (yr)',CtrlVar.time),'interpreter','latex',FontSize=14) ;
                legend("$dh/dt$","$u_d$","$u_b$",interpreter="latex")
                Figdhdt.Position=[ 635       487.67       625.33       393.33] ;
            end
        end
    end

    
    timeLast=CtrlVar.time ;



    % For convinience, create variables to store the x and y coordinates of the nodes.

    if SaveFileEachRunStep

        % save data in files with running names
        % check if folder 'ResultsFiles' exists, if not create

        if strcmp(CtrlVar.DefineOutputsInfostring,'First call ') && exist('ResultsFiles','dir')~=7
            mkdir('ResultsFiles') ;
        end


        FileName=['ResultsFiles/',sprintf('%07i',round(100*CtrlVar.time)),'-TransPlots-',CtrlVar.Experiment];
        fprintf(' Saving data in %s \n',FileName)
        save(FileName,'CtrlVar','MUA','F')

    end


    if PlotFigures
        
        [~,I]=sort(x);
        
        FigM=FindOrCreateFigure("Mountain") ;
        
       
        xBedrockPoly=[x(I);x(I(1))];
        BedrockPoly=[F.B(I);F.B(I(1))] ;
        GlacierPoly=[F.s(I);fliplr(F.b(I))] ;
        xGlacierPoly=[x(I);fliplr(x(I))] ;
        
        hold off
        
        fill(xBedrockPoly/1000,BedrockPoly,[0.9 0.9 0.9],'LineStyle','none'); hold on
        fill(xGlacierPoly/1000,GlacierPoly,'b','Linestyle','none');
        

        hold on
        [zero,I]=min(abs(F.as)); ELA=F.s(I) ; 
        plot(x/1000,x*0+ELA,'r'); 
        text(40,ELA,'ELA','VerticalAlignment','bottom','color','r','interpreter','latex')
        %%ylabel('Equlibrium Line (m)','interpreter','latex')
        title(sprintf('t=%-g (yr)',CtrlVar.time),'interpreter','latex',FontSize=14) ; 
        xlabel('$x$ (km)','interpreter','latex') ; 
        ylabel('$z$ (m)','interpreter','latex')
        axis tight
        FigM.Position=[ 1263.7       486.33       1286.7          860] ; 
        
        

        %%

        Figh=FindOrCreateFigure("Ice thickness distribution") ;
        plot(x/1000,F.h,'.') ;
        xlabel('x (km)','interpreter','latex');
        ylabel('ice thickness (m)','interpreter','latex') ;
        title(sprintf('t=%-g (yr)',CtrlVar.time),'interpreter','latex',FontSize=14) ;
        Figh.Position=[7       487.67          626       392.67]; 

    end

    
    
    %
    % figure(10) ; plot(F.x/1000,F.as,LineWidth=2) ; 
    % xlabel("$x$ (km)","interpreter","latex") ; 
    % ylabel("surface mass balance, $a_s(x)$ (m/yr)","interpreter","latex") ; 
    % ax=gca ; ax.XAxisLocation = 'origin'; box off
    %
    %
    %
    
    %%
    % x=MUA.coordinates(:,1);  y=MUA.coordinates(:,2);
    % FindOrCreateFigure("Velocity in x direction") ;
    % plot(x/1000,F.ub,'.') ; xlabel('x (km)') ; ylabel('y (m/a)') ; title(sprintf('t=%-g (yr)',CtrlVar.time)) ;
    %%


    % FindOrCreateFigure("Mesh") ; PlotMuaMesh(CtrlVar,MUA) ;

    %% How to identify if the glacier has reached a steady-state?


    % What do we have?
    % we have the time:  CtrlVar.time
    % and we have the ice thickness, and more

    % Idea: What about plotting maximum ice thickness as a function of time?
    % And then see if this curve is approaching a steady-state value.

    % What do we need to do?
    %
    % We need to save time and max(F.h) and then plot at the end of the run, or
    % save in a separate file and then plot.
    %

    % How to calculate the length, l, of the glacier?
    % Answer: l=max(x(F.h>2))

    % the length of the glacier is the maximum value of x for which the ice
    % thickness is greater than the minimum ice-thickness, which is 2 meters.
    L=max(x(F.h>2));  % this is the length of the glacier,
    % but note that right at the beginning of the run
    % there might not be any nodes where the thickness is
    % greater than the minimum value (this would result in L
    % being empty).
    if ~isempty(L)

        % now put length and time into seperate (persistent) variables.

        length(nCounter)=L;
        time(nCounter)=CtrlVar.time ;
        
        % Now also integrate the surface mass-balance distribution, F.as, over the glacier.
        % Remember only to include the glaciated area. This can, for example, be done by setting
        % as to zero outside of the glaciated area. The extent of the glacier at any given time is here
        % defined as all areas having ice thickness of more than 2 m. 
        as=F.as ; as(F.h<=2)=0 ; 
        MB(nCounter)=sum(FEintegrate2D(CtrlVar,MUA,as));
        
        % very often the integrated mass balance is then normalized with the area of the glacier at each tim.
        Area=sum(FEintegrate2D(CtrlVar,MUA,F.h>2));  % notice that here F.h>2 is either 1 or 0
        MB(nCounter)=MB(nCounter)/Area;   % mean specific mass balance (m/yr)
        Volume(nCounter)=sum(FEintegrate2D(CtrlVar,MUA,F.h));
        
        % figure ; plot(time,length/1000) ; ylabel('length (km)' ) ; xlabel('time (yr)')
        
        
    end
    
    if PlotFigures
        FGL=FindOrCreateFigure('Glacier Length and Mass Balance') ;
        hold on
        yyaxis left
        plot(time,length/1000,'ob')
        ylabel('Length (km)','interpreter','latex')
        yyaxis right
        plot(time,MB,'*r')
        tt=xlim ; 
        plot(tt,tt*0,'r-') ; 
        ylabel('Mean Specific Mass Balance (m/yr)','interpreter','latex')
        xlabel('time (yr)','interpreter','latex')
        FGL.Position=[9.6667       965.67       1250.7       381.33] ; 
        title('Glacier Length (horizontal half-span) and the Mean Specific Mass Balance','interpreter','latex',FontSize=14)
        % legend("Length","Mass Balance")
        hold off
    end
    
    if CtrlVar.DefineOutputsInfostring=="Last call"
        % OK, so this is the last time this m-file is called during the run.
        % And now we save the data into a file, so that we can then read it in
        % later and plot the results.
        save("MyDataFile.mat","time","length","MB","Volume")
    end

drawnow
end
