


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

RunType=strings(5,1) ; 

RunType(1)="-MismipPlus-C-DP-Ini5-c0isGL0-10km-" ;
RunType(2)="-MismipPlus-C-DP-Ini5-c0isGL0-5km-" ;
RunType(3)="-MismipPlus-C-DP-Ini5-c0isGL0-4km-" ;
RunType(4)="-MismipPlus-C-DP-Ini5-c0isGL0-3km-" ;
RunType(5)="-MismipPlus-C-DP-Ini5-c0isGL0-2km-" ;
RunType(6)="-MismipPlus-C-DP-Ini5-c0isGL0-1km-" ;

Irange=6;


BatchJob=true;

if BatchJob

    for iJob=Irange

        UserVar.RunType=RunType(iJob)  ; % "-MismipPlus-C-DP-Ini5-c0isGL0-5km-" ;
        job1km=batch(@Ua,0,{UserVar},Pool=1);
        pause(30) 

    end

else

    UserVar.RunType=RunType(Irange)  ;
    Ua(UserVar)

end