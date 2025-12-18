%%

ResultsFiles=dir("SUPG*TV.mat") ;


for I=1:numel(ResultsFiles)


    R{I}=load(ResultsFiles(I).name);


end


%%
figure
hold off
for I=1:numel(ResultsFiles)

    plot(R{I}.TV.time,R{I}.TV.Value,LineWidth=2,Marker="o",DisplayName="m"+num2str(R{I}.CtrlVar.uvh.SUPG.tauMultiplier))

    hold on

end

legend


FindOrCreateFigure("TV int")
hold off
width=100e3; 
for I=1:numel(ResultsFiles)


    if isfield(R{I}.TV,"Int")

        plot(R{I}.TV.time,R{I}.TV.Int/width,LineWidth=2,Marker="o",DisplayName="m"+num2str(R{I}.CtrlVar.uvh.SUPG.tauMultiplier))

        hold on
    end
end

legend

FindOrCreateFigure("RMS")
hold off

for I=1:numel(ResultsFiles)


    if isfield(R{I}.TV,"RMS")

        plot(R{I}.TV.time,R{I}.TV.RMS,LineWidth=2,Marker="o",DisplayName="m"+num2str(R{I}.CtrlVar.uvh.SUPG.tauMultiplier)+" l="+num2str(R{I}.CtrlVar.MeshSize/1e3))

        hold on
    end
end

legend
title("RMS")

%%