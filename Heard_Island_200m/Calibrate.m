function Calibrate()

    load('thickness.mat');
    area = thickness; area(thickness>CtrlVar.ThickMin)=1; area(thickness<=CtrlVar.ThickMin)=0;
    area = FEintegrate2D(CtrlVar,MUA,area);
    dT = (-5:0.1:5);
    error = zeros(length(dT),1);
    as_all = zeros(length(dT),1);
    for step=1:length(dT)
        as = SMBSchemePDD(dT(step));
        as = FEintegrate2D(CtrlVar,MUA,as);
        as = sum(as)/sum(area);
        error(step)=abs(-275.363218713645/1000-as);
        as_all(step)=as;
    end

    ind = find(error==min(error));
    final_dT = dT(ind);
    save final_dT.mat final_dT;

end