


Klear


%%
[UserVar,RunInfo,F,l,BCs,dt]=uvh2(UserVar,RunInfo,CtrlVar,MUA,F0,F,l,l,BCs);

  if ~isnumeric(Par.VelColorMap)
        NN=10*N ;
        cmap=colormap(sprintf('%s(%i)',Par.VelColorMap,NN));
    else
        cmap=Par.VelColorMap ;
        NN=size(cmap,1); 
    end

    if strcmp(Par.VelPlotIntervalSpacing,'log10')==1
        % create a `logarithmic' colormap
        

        index=fix((NN-1)*(exp((0:N-1)/(N-1))-1)/(exp(1)-1)+1);
        cmap=colormap(cmap(index,:));

    end
