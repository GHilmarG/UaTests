classdef  (ConstructOnLoad)  UaNewFields


    properties

        x=[]
        y=[]

        ub=[]
        vb=[]

        ud=[]
        vd=[]

        uo=[]
        vo=[]

        ua=[]
        va=[]



        s=[] 
        sInit=[]

        b=[]
        bmin=[]
        bmax=[]
        bInit=[]

        h=[]
        hInit=[]
        S=[]

        B=[]
        Bmin=[]
        Bmax=[]
        BInit=[]

        AGlen=[]
        AGlenmin=[]
        AGlenmax=[]

        C=[]
        Cmin=[]
        Cmax=[]
        m=[]
        n=[]
        rho=[]
        rhow=[]

        q=[]
        muk=[]

        Co=[]
        mo=[]
        Ca=[]
        ma=[]

        as=[]
        ab=[]
        dasdh=[]
        dabdh=[]


        dhdt=[] 
        dsdt=[] 
        dbdt=[] 

        dubdt=[]
        dvbdt=[]

        duddt=[]
        dvddt=[]



        g=[]
        alpha=[]

        time=[]
        dt=[]

        GF=[]
        GFInit=[]

        LSF=[] % Level Set Field
        LSFMask=[]
        LSFnodes=[]
        c=[]  % calving rate
        LSFqx=[]
        LSFqy=[]

        MUA=[];

    
        
    end

    properties (Dependent)

        StrainRates
        BasalSpeed

    end


    methods


        function absub=abs(obj,k)

            fprintf("Calculating absub.\n ")
            absub=k*abs(obj.ub); 

        end

        function speed=get.BasalSpeed(obj)

            if isempty(obj.ub) || isempty(obj.vb)
                fprintf("Can not calculate basal speed as the ub or vb properties are not defiend.\n ")
            else
                fprintf("Calculating speed.\n ")
                speed=sqrt(obj.ub.*obj.ub+obj.vb.*obj.vb);
            end

        end

        function StrainRates=get.StrainRates(obj)

            
            if isempty(obj.MUA)

                fprintf("Can not calculate nodal strain rates as the MUA property is not defiend.\n ")
                StrainRates=[] ;

            else

                fprintf("Calculating strain rates.\n ")
                [StrainRates.exx,StrainRates.yy,StrainRates.exy]=CalcNodalStrainRates(obj.MUA,obj.ub,obj.vb);

            end

        end

    end


end