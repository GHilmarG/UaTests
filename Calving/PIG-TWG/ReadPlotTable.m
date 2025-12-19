
Glacier="Thwaites" ; 
%Glacier="PIG" ; 
load(Glacier+"Table.mat","TableSLR")  
AreaOfOcean=3.625e14 ;
%%

MeshSizes=sort(unique(TableSLR.MeshSize),"descend");
fig=figure(10);
hold off
for I=1:numel(MeshSizes)

    IND=abs(TableSLR.MeshSize - MeshSizes(I))<0.001;
    
    time=TableSLR.time(IND);
    VAF=TableSLR.VAF(IND);
    SLC=-1000*(VAF-VAF(1))/AreaOfOcean;  % units mm
    %plot(TableSLR.time(IND),TableSLR.SLC(IND),DisplayName=num2str(MeshSizes(I)))
    plot(time,SLC,DisplayName=num2str(MeshSizes(I)))
    hold on
end
legend

%% netcdf

Files=strings(5,1);

Files(5)=Glacier+"_UNN_Ua_Hilmar_MeshSize0.81994km.nc";
Files(4)=Glacier+"_UNN_Ua_Hilmar_MeshSize3.2798km.nc";
Files(3)=Glacier+"_UNN_Ua_Hilmar_MeshSize9.8393km.nc";
Files(2)=Glacier+"_UNN_Ua_Hilmar_MeshSize1.6399km.nc";
Files(1)=Glacier+"_UNN_Ua_Hilmar_MeshSize6.5595km.nc";


F=figure(100) ; clf(F)

for I=1:5

    time=ncread(Files(I),"time");
    vaf=ncread(Files(I),"vaf");
    AreaOfOcean=3.625e14 ;
    VAF=-(vaf-vaf(1));
    SLC=VAF/AreaOfOcean;
    DN=sprintf("Mesh Size %3.2f km",str2double(extractBetween(Files(I),"MeshSize","km")));

    %yyaxis left
    %plot(time,VAF/1e9,DisplayName=DN)
    %yyaxis right
    plot(time,1000*SLC,DisplayName=DN,LineWidth=2)
    hold on
end

xlabel("time (yr) ")
ylabel("Sea level rise (mm)")
legend(Location="best")
title("Sea level rise from "+Glacier)

FigurFileName=replace("Sea level rise from "+Glacier," ","_");
savefig(F,FigurFileName)
%%

