
function RunString=DefineRunString()



%%  The variable RunString is a string containing various substrings that control the run. 
%
%
%
% -uvh-  : implicit uvh run
% -uv-h- : semi-implicit uv-h run
% -ES   : Element Size in km
%
%                       -side of a perfect square of equal area-
% 30km = 14km                        9.806 km
% 20km = 9.3km                       6.559 km
% 10km = 4.6km                       3.28  km
%  5km = 2.3km                       1.64  km
% 2.5km = 1.16km                     0.821 km
%
%
% -Tri?- : Element with ? number of nodes
%
% -Duvh- : Automated deactivation of elements downstream of calving fronts
% -SW??  : Level set Strip Width of ?? km, otherwise by default 50km.
%
% -P-   : Level set is Prescribed
% -C-   : Level set is evolved, with various further options possible
%
% -TM??- : min ice thickness, for example -TM0k2- implies a min thickness of 0.2 meters  
%
% Melt rate parameterizations: 
%
% -MRIM6  : Melt Rate parameterisation based on ISMIP6 forcings
%
% -MRZERO  : ab is set to zero
%
% -MR?    : Draft dependent parameterizations, as defined in DraftDependentMeltParameterisations.m
%
% abMask0    :  apply melt over nodes either currently or initially afloat, within the assimilation/relaxation period
%
% abMask0M   :  apply ADDITIONAL high melt over nodes that initially were afloat, but now have become grounded, ONLY within
%               the assimilation/relaxation period
%
% abMask0A   :  apply ADDITIONAL high melt over nodes that initially were afloat, but now have become grounded, ALWAYS (i.e.
%               throughout the run period)
%
% -MSW???L???a???-  % adds a melt perturbation within the square of width W and length L and amplitude a
%
%
% -IOR-       : InsideOut nodes with respect to grounding line calculated in a 'relaxed' manner, i.e. all nodes where 
%               GF.node  <0.5 are afloat, for the purpose of applying basal melt rates
%               
%
%   if contains(UserVar.RunType,"-IOR-")
%         [~,OceanNodes] = LakeOrOcean3(CtrlVar,MUA,F.GF,[],"Relaxed") ;
%     else
%         [~,OceanNodes] = LakeOrOcean3(CtrlVar,MUA,F.GF,[],"Strict") ;
%     end
% 
%
% -SMB??  : Surface Mass Balance
%
% -BM3-   : user bed-machine 3 data
%
% -BCIO-  : check if any boundary velocities are oriented into the domain 
%
% -DV0-   : do NOT use development version -DV1-   : do use development version
%
%
%%



RunString="ES5km-Tri3-SlidWeertman-Duvh-MRlASE3-abMask0-P-BCVel-kH10000-TM0k2-Alim-Clim-Ca1-Cs100000-Aa1-As100000-VelITS120-BM3-SMB_RACHMO2k3_2km-"; 
RunString="ES5km-Tri3-SlidWeertman-Duvh-MRlASE2-abMask0-P-BCVel-kH10000-TM0k2-Alim-Clim-Ca1-Cs100000-Aa1-As100000-VelITS120-BM3-SMB_RACHMO2k3_2km-"; 
RunString="ES5km-Tri3-SlidWeertman-Duvh-MRlASE1-abMask0-P-BCVel-kH10000-TM0k2-Alim-Clim-Ca1-Cs100000-Aa1-As100000-VelITS120-BM3-SMB_RACHMO2k3_2km-"; 
RunString="ES10km-Tri3-SlidWeertman-Duvh-MRlASE3-abMask0-P-BCVel-kH10000-TM0k2-Alim-Clim-Ca1-Cs100000-Aa1-As100000-VelITS120-BM3-SMB_RACHMO2k3_2km-"; 


RunString="ES10km-uvh-Tri3-SlidWeertman-Duvh-MRIM6HadGEM2-abMask0M-P-BCVel-kH10000-TM0k2-Alim-Clim-Ca1-Cs100000-Aa1-As100000-VelITS120-BM3-SMB_RACHMO2k3_2km-"; 
RunString="ES2.5km-uv-h-Tri3-SlidWeertman-Duvh-MRlASE1-abMask0-P-BCVel-kH10000-TM0k2-Alim-Clim-Ca1-Cs100000-Aa1-As100000-VelITS120-BM3-SMB_RACHMO2k3_2km-"; 
RunString="ES20km-uv-h-Tri3-SlidWeertman-Duvh-MRIM6HadGEM2-abMask0-P-BCVel-kH10000-TM0k2-Alim-Clim-Ca1-Cs100000-Aa1-As100000-VelITS120-BM3-SMB_RACHMO2k3_2km-"; 
RunString="ES10km-uv-h-Tri3-SlidWeertman-Duvh-MRIM6HadGEM2-abMask0M-P-BCVel-kH10000-TM0k2-Alim-Clim-Ca1-Cs100000-Aa1-As100000-VelITS120-BM3-SMB_RACHMO2k3_2km-"; 
RunString="ES5km-uv-h-Tri3-SlidWeertman-Duvh-MRlASE3-abMask0A-P-BCVel-kH10000-TM0k2-Alim-Clim-Ca1-Cs100000-Aa1-As100000-VelITS120-BM3-SMB_RACHMO2k3_2km-";
RunString="ES5km-uv-h-Tri3-SlidWeertman-Duvh-MRlASE3-abMask0A-IOR-P-BCVel-kH10000-TM0k2-Alim-Clim-Ca1-Cs100000-Aa1-As100000-VelITS120-BM3-SMB_RACHMO2k3_2km-";
RunString="ES5km-uv-h-Tri3-SlidWeertman-Duvh-MRZERO-P-BCVel-kH10000-TM0k2-Alim-Clim-Ca1-Cs100000-Aa1-As100000-VelITS120-BM3-SMB_RACHMO2k3_2km-";  




%%  MRZERO-P-BCVel (no additional melt if re-grounded, melt only applied strictly downstream of grounding lines 

RunString="ES2.5km-uvh-Tri3-SlidWeertman-Duvh-MRZERO-P-BCVel-kH10000-TM0k2-Alim-Clim-Ca1-Cs100000-Aa1-As100000-VelITS120-BM3-SMB_RACHMO2k3_2km-"; % 2500
RunString="ES5km-uvh-Tri3-SlidWeertman-Duvh-MRZERO-P-BCVel-kH10000-TM0k2-Alim-Clim-Ca1-Cs100000-Aa1-As100000-VelITS120-BM3-SMB_RACHMO2k3_2km-";   % 2500
RunString="ES10km-uvh-Tri3-SlidWeertman-Duvh-MRZERO-P-BCVel-kH10000-TM0k2-Alim-Clim-Ca1-Cs100000-Aa1-As100000-VelITS120-BM3-SMB_RACHMO2k3_2km-";  % 2500
RunString="ES20km-uvh-Tri3-SlidWeertman-Duvh-MRZERO-P-BCVel-kH10000-TM0k2-Alim-Clim-Ca1-Cs100000-Aa1-As100000-VelITS120-BM3-SMB_RACHMO2k3_2km-";  % 2500
RunString="ES30km-uvh-Tri3-SlidWeertman-Duvh-MRZERO-P-BCVel-kH10000-TM0k2-Alim-Clim-Ca1-Cs100000-Aa1-As100000-VelITS120-BM3-SMB_RACHMO2k3_2km-";  % 2500

% additionally apply melt at nodes that are re-grounded, and check for inflow boundary nodes 
% NOTE: -BICO- should have been -BCIO-, so no check for inflow boundary nodes was done. But keeping names unchanged for
% simplicity. 
RunString="ES30km-uvh-Tri3-SlidWeertman-Duvh-MRZERO-abMask0A-P-BCVel-BICO-kH10000-TM0k2-Alim-Clim-Ca1-Cs100000-Aa1-As100000-VelITS120-BM3-SMB_RACHMO2k3_2km-"; 
RunString="ES20km-uvh-Tri3-SlidWeertman-Duvh-MRZERO-abMask0A-P-BCVel-BICO-kH10000-TM0k2-Alim-Clim-Ca1-Cs100000-Aa1-As100000-VelITS120-BM3-SMB_RACHMO2k3_2km-"; 
RunString="ES10km-uvh-Tri3-SlidWeertman-Duvh-MRZERO-abMask0A-P-BCVel-BICO-kH10000-TM0k2-Alim-Clim-Ca1-Cs100000-Aa1-As100000-VelITS120-BM3-SMB_RACHMO2k3_2km-"; 
RunString="ES5km-uvh-Tri3-SlidWeertman-Duvh-MRZERO-abMask0A-P-BCVel-BICO-kH10000-TM0k2-Alim-Clim-Ca1-Cs100000-Aa1-As100000-VelITS120-BM3-SMB_RACHMO2k3_2km-"; 

% RunString="ES2.5km-uv-h-Tri3-SlidWeertman-Duvh-MRZERO-P-BCVel-kH10000-TM0k2-Alim-Clim-Ca1-Cs100000-Aa1-As100000-VelITS120-BM3-SMB_RACHMO2k3_2km-"; % no files
% RunString="ES5km-uv-h-Tri3-SlidWeertman-Duvh-MRZERO-P-BCVel-kH10000-TM0k2-Alim-Clim-Ca1-Cs100000-Aa1-As100000-VelITS120-BM3-SMB_RACHMO2k3_2km-"; % 2316
% RunString="ES10km-uv-h-Tri3-SlidWeertman-Duvh-MRZERO-P-BCVel-kH10000-TM0k2-Alim-Clim-Ca1-Cs100000-Aa1-As100000-VelITS120-BM3-SMB_RACHMO2k3_2km-"; % 2324
% RunString="ES20km-uv-h-Tri3-SlidWeertman-Duvh-MRZERO-P-BCVel-kH10000-TM0k2-Alim-Clim-Ca1-Cs100000-Aa1-As100000-VelITS120-BM3-SMB_RACHMO2k3_2km-"; % no files
% RunString="ES30km-uv-h-Tri3-SlidWeertman-Duvh-MRZERO-P-BCVel-kH10000-TM0k2-Alim-Clim-Ca1-Cs100000-Aa1-As100000-VelITS120-BM3-SMB_RACHMO2k3_2km-"; % 2020





%% MRlASE3-abMask0A-IOR-P-BCVel  : using melt rate parameterizations "lASE3" which is defined in DrafDependentMeltParameterisations.m, 
%                                   -IOR- implies inside/outside/relaxed i.e.  [~,OceanNodes] = LakeOrOcean3(CtrlVar,MUA,F.GF,[],"Relaxed") ;
%                                   -abMask0A- : apply additional melt of nodes that initially were afloat, should the become
%                                   grounded (a way of suppressing advance of the PIG grounding line)
 
 RunString="ES2.5km-uvh-Tri3-SlidWeertman-Duvh-MRlASE3-abMask0A-IOR-P-BCVel-kH10000-TM0k2-Alim-Clim-Ca1-Cs100000-Aa1-As100000-VelITS120-BM3-SMB_RACHMO2k3_2km-";   % 2469  (collapse, but later, running on Dell)
% RunString="ES5km-uvh-Tri3-SlidWeertman-Duvh-MRlASE3-abMask0A-IOR-P-BCVel-kH10000-TM0k2-Alim-Clim-Ca1-Cs100000-Aa1-As100000-VelITS120-BM3-SMB_RACHMO2k3_2km-";     % 2500 (collapse)
% RunString="ES10km-uvh-Tri3-SlidWeertman-Duvh-MRlASE3-abMask0A-IOR-P-BCVel-kH10000-TM0k2-Alim-Clim-Ca1-Cs100000-Aa1-As100000-VelITS120-BM3-SMB_RACHMO2k3_2km-";    % 2500 (collapse, yr 2410 missing)
% RunString="ES20km-uvh-Tri3-SlidWeertman-Duvh-MRlASE3-abMask0A-IOR-P-BCVel-kH10000-TM0k2-Alim-Clim-Ca1-Cs100000-Aa1-As100000-VelITS120-BM3-SMB_RACHMO2k3_2km-";    % 2500 (No collapse!)
% RunString="ES30km-uvh-Tri3-SlidWeertman-Duvh-MRlASE3-abMask0A-IOR-P-BCVel-kH10000-TM0k2-Alim-Clim-Ca1-Cs100000-Aa1-As100000-VelITS120-BM3-SMB_RACHMO2k3_2km-";    % 2500 (No collapse!)


% RunString="ES2.5km-uv-h-Tri3-SlidWeertman-Duvh-MRlASE3-abMask0A-IOR-P-BCVel-kH10000-TM0k2-Alim-Clim-Ca1-Cs100000-Aa1-As100000-VelITS120-BM3-SMB_RACHMO2k3_2km-"; % 2174 
% RunString="ES5km-uv-h-Tri3-SlidWeertman-Duvh-MRlASE3-abMask0A-IOR-P-BCVel-kH10000-TM0k2-Alim-Clim-Ca1-Cs100000-Aa1-As100000-VelITS120-BM3-SMB_RACHMO2k3_2km-"; % no files
% RunString="ES10km-uv-h-Tri3-SlidWeertman-Duvh-MRlASE3-abMask0A-IOR-P-BCVel-kH10000-TM0k2-Alim-Clim-Ca1-Cs100000-Aa1-As100000-VelITS120-BM3-SMB_RACHMO2k3_2km-";  % no files
% RunString="ES20km-uv-h-Tri3-SlidWeertman-Duvh-MRlASE3-abMask0A-IOR-P-BCVel-kH10000-TM0k2-Alim-Clim-Ca1-Cs100000-Aa1-As100000-VelITS120-BM3-SMB_RACHMO2k3_2km-";  % no files

%% Reversibility experiments  

RunString="ES10km-uvh-Tri3-SlidWeertman-Duvh-MRlASE3-abMask0A-IOR-Rgl50-P-BCVel-kH10000-TM0k2-Alim-Clim-Ca1-Cs100000-Aa1-As100000-VelITS120-BM3-SMB_RACHMO2k3_2km-";    
RunString="ES10km-uvh-Tri3-SlidWeertman-Duvh-MRlASE3-abMask0A-IOR-Rt2050-P-BCVel-kH10000-TM0k2-Alim-Clim-Ca1-Cs100000-Aa1-As100000-VelITS120-BM3-SMB_RACHMO2k3_2km-";    

%% MRlASE3-abMask0A-P-BCVel (here the "strict" melt mask is applied, ie melt does not go directly to the grounding line)  

% RunString="ES5km-uv-h-Tri3-SlidWeertman-Duvh-MRlASE3-abMask0A-P-BCVel-kH10000-TM0k2-Alim-Clim-Ca1-Cs100000-Aa1-As100000-VelITS120-BM3-SMB_RACHMO2k3_2km-";   % till 2200, should be extended
% RunString="ES5km-uvh-Tri3-SlidWeertman-Duvh-MRlASE3-abMask0A-P-BCVel-kH10000-TM0k2-Alim-Clim-Ca1-Cs100000-Aa1-As100000-VelITS120-BM3-SMB_RACHMO2k3_2km-";   % til 2020 ? ( 

% RunString="ES10km-uv-h-Tri3-SlidWeertman-Duvh-MRlASE3-abMask0A-P-BCVel-kH10000-TM0k2-Alim-Clim-Ca1-Cs100000-Aa1-As100000-VelITS120-BM3-SMB_RACHMO2k3_2km-";   % no files
% RunString="ES20km-uv-h-Tri3-SlidWeertman-Duvh-MRlASE3-abMask0A-P-BCVel-kH10000-TM0k2-Alim-Clim-Ca1-Cs100000-Aa1-As100000-VelITS120-BM3-SMB_RACHMO2k3_2km-";   % no files

% RunString="ES5km-uvh-Tri3-SlidWeertman-Duvh-MRlASE1-abMask0A-P-BCVel-kH10000-TM0k2-Alim-Clim-Ca1-Cs100000-Aa1-As100000-VelITS120-BM3-SMB_RACHMO2k3_2km-";   % no files
% RunString="ES5km-uvh-Tri3-SlidWeertman-Duvh-MRlASE2-abMask0A-P-BCVel-kH10000-TM0k2-Alim-Clim-Ca1-Cs100000-Aa1-As100000-VelITS120-BM3-SMB_RACHMO2k3_2km-";   % no files

%% MRIM6HadGEM2-abMask0A-P-BCVel  (here the "strict" melt mask is applied, ie melt does not go directly to the grounding line)  

% RunString="ES2.5km-uvh-Tri3-SlidWeertman-Duvh-MRIM6HadGEM2-abMask0A-P-BCVel-kH10000-TM0k2-Alim-Clim-Ca1-Cs100000-Aa1-As100000-VelITS120-BM3-SMB_RACHMO2k3_2km-"; % 2057, 2091, 2108, 2203
% RunString="ES5km-uvh-Tri3-SlidWeertman-Duvh-MRIM6HadGEM2-abMask0A-P-BCVel-kH10000-TM0k2-Alim-Clim-Ca1-Cs100000-Aa1-As100000-VelITS120-BM3-SMB_RACHMO2k3_2km-";   % 2103, 2143, 2301
% RunString="ES10km-uvh-Tri3-SlidWeertman-Duvh-MRIM6HadGEM2-abMask0A-P-BCVel-kH10000-TM0k2-Alim-Clim-Ca1-Cs100000-Aa1-As100000-VelITS120-BM3-SMB_RACHMO2k3_2km-";  % 2035, 2117, 2214, 2301 (done)
% RunString="ES20km-uvh-Tri3-SlidWeertman-Duvh-MRIM6HadGEM2-abMask0A-P-BCVel-kH10000-TM0k2-Alim-Clim-Ca1-Cs100000-Aa1-As100000-VelITS120-BM3-SMB_RACHMO2k3_2km-";  % 2144, 2300, no collapse
% RunString="ES30km-uvh-Tri3-SlidWeertman-Duvh-MRIM6HadGEM2-abMask0A-P-BCVel-kH10000-TM0k2-Alim-Clim-Ca1-Cs100000-Aa1-As100000-VelITS120-BM3-SMB_RACHMO2k3_2km-";  % 2301 (done)


% additionally modify boundary conditions if boundary velocities pointing into the domain. 
% RunString="ES2.5km-uvh-Tri3-SlidWeertman-Duvh-MRIM6HadGEM2-abMask0A-P-BCVel-BCIO-kH10000-TM0k2-Alim-Clim-Ca1-Cs100000-Aa1-As100000-VelITS120-BM3-SMB_RACHMO2k3_2km-"; % 2226, restart
% RunString="ES5km-uvh-Tri3-SlidWeertman-Duvh-MRIM6HadGEM2-abMask0A-P-BCVel-BCIO-kH10000-TM0k2-Alim-Clim-Ca1-Cs100000-Aa1-As100000-VelITS120-BM3-SMB_RACHMO2k3_2km-"; % no files

% RunString="ES5km-uv-h-Tri3-SlidWeertman-Duvh-MRIM6HadGEM2-abMask0A-P-BCVel-kH10000-TM0k2-Alim-Clim-Ca1-Cs100000-Aa1-As100000-VelITS120-BM3-SMB_RACHMO2k3_2km-"; % 2078
% RunString="ES10km-uv-h-Tri3-SlidWeertman-Duvh-MRIM6HadGEM2-abMask0A-P-BCVel-kH10000-TM0k2-Alim-Clim-Ca1-Cs100000-Aa1-As100000-VelITS120-BM3-SMB_RACHMO2k3_2km-"; % 2100

%% Melt square

RunString="ES10km-uvh-Tri3-SlidWeertman-Duvh-MRlASE3-abMask0A-IOR-MSW50L200a500-P-BCVel-kH10000-TM0k2-Alim-Clim-Ca1-Cs100000-Aa1-As100000-VelITS120-BM3-SMB_RACHMO2k3_2km-";    

%%
MeltSquareString=extractBetween(RunString,"-MS","-",Boundaries="inclusive")   

if isempty(MeltSquareString)
    UserVar.isMeltSquare=false;
else
    UserVar.isMeltSquare=true;
    UserVar.MeltSquareWidth=str2double(extractBetween(MeltSquareString,"W","L",Boundaries="exclusive"));
    UserVar.MeltSquarLength=str2double(extractBetween(MeltSquareString,"L","a",Boundaries="exclusive"));
    UserVar.MeltSquarMelt=str2double(extractBetween(MeltSquareString,"a","-",Boundaries="exclusive"));
end

end


end
