
find   . -name '*.m' -print0 | xargs -0 sed -i 's/\[C,m\]/\[UserVar,C,m\]/g'
find   . -name '*.m' -print0 | xargs -0 sed -i 's/\[AGlen,n\]/\[UserVar,AGlen,n\]/g'
find   . -name '*.m' -print0 | xargs -0 sed -r -i 's/BCs\=\(/\[UserVar,BCs\]\=\(/g'
find   . -name '*.m' -print0 | xargs -0 sed -i 's/\[rho,rhow,g\]/\[UserVar,rho,rhow,g\]/g'
find   . -name '*.m' -print0 | xargs -0 sed -i 's/\[s,b,S,B,alpha\]/\[UserVar,s,b,S,B,alpha\]/g'
find   . -name '*.m' -print0 | xargs -0 sed -i 's/\[as,ab/\[UserVar,as,ab/g'

find   . -name '*.m' -print0 | xargs -0 sed -i 's/Experiment,CtrlVar/UserVar,CtrlVar/g'




