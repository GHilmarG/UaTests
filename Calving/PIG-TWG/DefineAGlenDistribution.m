function [UserVar,AGlen,n]=DefineAGlenDistribution(UserVar,CtrlVar,MUA,F)


persistent FA


if ~UserVar.AGlen.ReadFromFile


    AGlen=AGlenVersusTemp(-10);
    n=3;

else

    if isempty(FA)

        if isfile(UserVar.FAFile) || isfile(UserVar.FAFile+".mat")

            fprintf('DefineAGlenDistribution: loading file: %-s \n',UserVar.FAFile)
            load(UserVar.FAFile,'FA')
            fprintf(' done \n')

        else
            error("DefineAGlenDistribution:FileNotFound","Required input file not found")
            %load('AGlen-Estimate.mat','AGlen','xA','yA')
            %FA=scatteredInterpolant(xA,yA,AGlen);
            % save(UserVar.FAFile,'FA')

        end

    end

    AGlen=FA(MUA.coordinates(:,1),MUA.coordinates(:,2));

    n=3;





end


% 
% if contains(UserVar.RunType,"-Alim-")
% 
%     Box=[ -1616.3      -1491.8      -530.00      -395.07]*1000;
%     In=IsInBox(Box,F.x,F.y) ;
% 
%     AminTWIS=AGlenVersusTemp(-20) ;
% 
%     I= AGlen < AminTWIS & In ;
% 
%     AGlen(I)=AminTWIS;
% 
% end


n=n+zeros(MUA.Nnodes,1);

%% LSF modifications?






end
