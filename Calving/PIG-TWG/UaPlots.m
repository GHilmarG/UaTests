function cbar=UaPlots(CtrlVar,MUA,F,Variable,options)

arguments
    CtrlVar struct
    MUA     struct
    F       UaFields
    Variable   {string, double}
    options.PlotGroundingLines  logical = true
    options.PlotCalvingFronts  logical = true
    options.CalvingFrontColor char = "k"
    options.GroundingLineColor char = "r"
    % options.ColorMap double=othercolor('YlGnBu6',1028)
    % options.ColorMap double=othercolor("Mlightterrain",1028)
    % options.ColorMap double=othercolor("Mdarkterrain",1028)
    % options.ColorMap double=othercolor("Mtemperaturemap",1028)
    options.ColorMap double=othercolor("YlGnBu8",1028)  % See othercolor.m for more options
end


if isnumeric(Variable)

      [~,cbar]=PlotMeshScalarVariable(CtrlVar,MUA,Variable);

else


    switch lower(Variable)

        case {"speed","-speed-"}

            speed=sqrt(F.ub.*F.ub+F.vb.*F.vb) ;

            [~,cbar]=PlotMeshScalarVariable(CtrlVar,MUA,speed);

        otherwise

            [~,cbar]=PlotMeshScalarVariable(CtrlVar,MUA,F.(Variable));


    end
end

hold on ;

if options.PlotGroundingLines
    PlotGroundingLines(CtrlVar,MUA,F.GF,[],[],[],color=options.GroundingLineColor);
end

if options.PlotCalvingFronts
    PlotCalvingFronts(CtrlVar,MUA,F,color=options.CalvingFrontColor);
end

colormap(options.ColorMap); 



end