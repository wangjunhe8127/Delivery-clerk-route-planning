function [now_x,now_y] = move(pre_x,pre_y,num)
if num==1
    x = 0;
    y = 1;
elseif num==2
    x = 0;
    y = -1;
elseif num==3
    x = -1;
    y = 0;
elseif num==4
    x = 1;
    y = 0;
elseif num==5
    x = -1;
    y = -1;
elseif num==6
    x = -1;
    y = 1;
elseif num==7
    x = 1;
    y = -1;
else
    x = 1;
    y = 1;
end
now_x = pre_x+x;
now_y = pre_y+y;
end