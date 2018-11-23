function UserVar=UaOutputs(UserVar,CtrlVar,MUA,BCs,F,l,GF,InvStartValues,InvFinalValues,Priors,Meas,BCsAdjoint,RunInfo)
  
    
       %%
    %plots=' q uv dhdt h qgrad ';
    %plots=' save only ';
    %save TestSave
    plots='-h(x)-dh/dt(x)-';
    plots='-sbB-uv-speed-GL(x)-GF-u(x)-h(x)-u-v-';
    plots=' ';
    %%

    
    %%
    
    fprintf('\n --------- UaOutputs at t=%-g \n \n ',CtrlVar.time)
    
    GLgeo=GLgeometry(MUA.connectivity,MUA.coordinates,GF,CtrlVar);
    GLstd=mean(std(GLgeo(:,[3 4])))    ; GLx=mean(mean(GLgeo(:,[3 4])))    ;
    dlmwrite([UserVar.geo,'-GL.dat'],[CtrlVar.time GLx GLstd],'-append')


    
    
    %%
end  
 