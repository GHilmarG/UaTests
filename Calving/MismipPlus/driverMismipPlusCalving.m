


% c=3000 ; F=100; k=c/F 

% rename GL0-.mat GL0-10km-.mat *GL0-.mat


% UserVar.RunType="-MismipPlus-C-Fq1Fk3Fmin80cmin0Fmax100cmax300-Ini5-c0isGL0-10km-" ;

UserVar.RunType="-MismipPlus-C-Fq1Fk10Fmin80cmin0Fmax100cmax1000-Ini5-c0isGL0-5km-" ;
UserVar.RunType="-MismipPlus-C-Fq1Fk10Fmin80cmin0Fmax100cmax1000-Ini5-c0isGL0-10km-" ;

UserVar.RunType="-MismipPlus-C-Fq1Fk30Fmin80cmin0Fmax100cmax3000-Ini5-c0isGL0-10km-" ;
UserVar.RunType="-MismipPlus-C-Fq1Fk30Fmin80cmin0Fmax100cmax3000-Ini5-c0isGL0-5km-" ;
UserVar.RunType="-MismipPlus-C-Fq1Fk30Fmin80cmin0Fmax100cmax3000-Ini5-c0isGL0-4km-" ;
UserVar.RunType="-MismipPlus-C-Fq1Fk30Fmin80cmin0Fmax100cmax3000-Ini5-c0isGL0-3km-" ;
UserVar.RunType="-MismipPlus-C-Fq1Fk30Fmin80cmin0Fmax100cmax3000-Ini5-c0isGL0-2km-" ;

UserVar.RunType="-MismipPlus-C-DP-Ini5-c0isGL0-5km-" ;

BatchJob=false;




if BatchJob
    job2km=batch(@Ua,0,{UserVar},Pool=1);
else
    Ua(UserVar)
end