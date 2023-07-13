
%%

n=20; m=10; l=3;
y=zeros(n,1); yy=y;

% parpool(m)

%for I=1:m
spmd (m)
    for k=1:l

        y=y+spmdIndex*ones(n,1);

    end
    [spmdIndex , spmdSize]
    %Y=spmdReduce(@plus,y,1);
    Y=spmdPlus(y,1);
end

Y{1}

%%


l=2;
m=3;
y=0; 
spmd (m)
    for k=1:l

        y=y+spmdIndex;

    end
    [spmdIndex , spmdSize]
    %Y=spmdReduce(@plus,y,1);
    Y=spmdPlus(y,1);
end

YY=spmdPlus(y,1);

Y{1}
YY{1}