
%%

FigureDirectory="C:\Users\Hilmar\OneDrive - Northumbria University - Production Azure AD\Work\Manuscripts\2022 ThwaitesIceShelfButtressing\Figures\";

cd(FigureDirectory)



fig(1)=openfig("VelocityDiff0002000Thwaites.fig");
fig(2)=openfig("HeightAboveFlotationDiff0002000Thwaites.fig");



new_fig = figure;
ax_new = gobjects(size(fig));
for i=1:2
    ax = subplot(1,2,i);
    ax_old = findobj(fig(i), 'type', 'axes');
    ax_new(i) = copyobj(ax_old, new_fig);

    cb=findobj(fig(1),'type','colorbar');
    ax_new(i) = copyobj(cb, new_fig);


    ax_new(i).YLimMode = 'manual';
    ax_new(i).Position = ax.Position;
    ax_new(i).Position(4) = ax_new(i).Position(4)-0.02;
    delete(ax);
end


