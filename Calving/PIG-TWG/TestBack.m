




load TestSave

 [gamma,r,Du,Dv,Dh,Dl,BackTrackInfo,rForce,rWork,D2] = rLineminUaTest(CtrlVar,UserVar,func,r0,r1,K,L,dub,dvb,dh,dl,dJdu,dJdv,dJdh,dJdl,Normalisation,MUA.M) ;
 




 % 
 % 
 % 
 % 
 % r0=0.07253153    	 r1/r0=8.016738e+07  	 rNewton/r0=0.9928952     	 rminCauchyM/r0=0.9998208     	 rDescent/r0=0.968173      	 rCN/r0=1.001593      
	%  g0=0             	    g1=1             	    gNewton=0.003588291   	             gM=1             	    gDescent=1.75661e-12   	    gCM=0.007011034   
	%  normNewton=1.963578e+11  	 normCauchy/normNewton=1.632536e-07  	 normCN/normNewton=NaN           
 % 	 =================>  Best method is Steepest Descent  with rmin/r0=0.968173    <=====================