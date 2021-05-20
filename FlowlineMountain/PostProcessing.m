%%
load("MyDataFile.mat","time","length","MB","Volume") ;


FindOrCreateFigure("Mass Balance")
plot(time,MB,'o-') ; xlabel('time (yr)') ; ylabel('Integrated Surface Mass Balance (m/yr)')


FindOrCreateFigure("Glacier length")
plot(time,length/1000,'o-') ; xlabel('time (yr)') ; ylabel('glacier length (km)')

FindOrCreateFigure("Glacier volume")
plot(time,Volume/1e9,'o-') ; xlabel('time (yr)') ; ylabel('glacier volume (km^2)')