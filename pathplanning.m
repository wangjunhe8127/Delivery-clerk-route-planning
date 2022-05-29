clear ;
close all;
clc;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%各个点位设置%%%%%%%%%%%%%%%%%%%%%%%%%
[obs1,obs2,obs3,start1,start2,start3,obj1,obj2,obj3,obj4,obj5,obj6] = set_init();%障碍，起始点，目标点
%%%%%%%%%%%%%%%%%%%%%%%%%%%%设置环境矩阵%%%%%%%%%%%%%%%%%%%%%%%%%
ObsRadius = 2;%障碍宽
n = 40; %边长
environment = -1*ones(n+1,n+1);%初始环境矩阵，无障碍处设置为-1
%环境矩阵中障碍设置为-50
environment(obs1(1) - ObsRadius:obs1(1) + ObsRadius,obs1(2) - ObsRadius:obs1(2) + ObsRadius)=-50;
environment(obs2(1) - ObsRadius:obs2(1) + ObsRadius,obs2(2) - ObsRadius:obs2(2) + ObsRadius)=-50;
environment(obs3(1),obs3(2):obs3(2) + ObsRadius)=-50;
environment(obs3(1):obs3(1) + ObsRadius,obs3(2))=-50;
%环境矩阵中出界设置为-100
environment(1:41,1) = -100;
environment(1:41,41) = -100;
environment(1,1:41) = -100;
environment(41,1:41) = -100;
%%%%%%%%%%%%%%%%%%%%%%%%%%学习并更新环境矩阵%%%%%%%%%%%%%%%%%%%%%
%智能体1学习第一个点
environment(obj1(1)+1,obj1(2)+1) = 50; % 将终点设置50
environment(start1(1)+1,start1(2)+1) = -50; % 指定起点设置为-50，防止穿过起点
[environment,res1,~] = sol(environment,start1,-50.1);%开始学习并得到轨迹
%智能体1学习第二个点
environment(obj2(1)+1,obj2(2)+1) = 50; 
environment(obj1(1)+1,obj1(2)+1) = -50; 
[environment,res2,~] = sol(environment,obj1,-50.2);
environment(obj2(1)+1,obj2(2)+1) = -50; % 将智能体1的最后一个目标点设置为-50，防止后面轨迹穿过
%智能体2学习第一个点
environment(obj3(1)+1,obj3(2)+1) = 50; 
environment(start2(1)+1,start2(2)+1) = -50; 
[environment,res3,~] = sol(environment,start2,-50.3);
%智能体2学习第二个点
environment(obj4(1)+1,obj4(2)+1) = 50; 
environment(obj3(1)+1,obj3(2)+1) = -50; 
[environment,res4,~] = sol(environment,obj3,-50.4);
environment(obj4(1)+1,obj4(2)+1) = -50;
%智能体3学习第一个点
environment(obj5(1)+1,obj5(2)+1) = 50; % 指定终点坐标
environment(start3(1)+1,start3(2)+1) = -50; % 指定终点坐标
[environment,res5,~] = sol(environment,start3,-50.5);
%智能体3学习第二个点
environment(obj6(1)+1,obj6(2)+1) = 50; % 指定终点坐标
environment(obj5(1)+1,obj5(2)+1) = -50; % 指定终点坐标
[environment,res6,t] = sol(environment,obj5,-50.6);
environment(obj6(1)+1,obj6(2)+1) = -50; % 指定终点坐标
%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%画图%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
figure
%绘制
environment(obj1(1)+1,obj1(2)+1) = 10; plot(obj1(1)+1,obj1(2)+1,'ro','MarkerFaceColor','r'),hold on;
environment(obj2(1)+1,obj2(2)+1) = 20; plot(obj2(1)+1,obj2(2)+1,'bo','MarkerFaceColor','b'),hold on;
environment(obj3(1)+1,obj3(2)+1) = 30; plot(obj3(1)+1,obj3(2)+1,'mo','MarkerFaceColor','m'),hold on;
environment(obj4(1)+1,obj4(2)+1) = 40; plot(obj4(1)+1,obj4(2)+1,'yo','MarkerFaceColor','y'),hold on;
environment(obj5(1)+1,obj5(2)+1) = 50; plot(obj5(1)+1,obj5(2)+1,'co','MarkerFaceColor','c'),hold on;
environment(obj6(1)+1,obj6(2)+1) = 60; plot(obj6(1)+1,obj6(2)+1,'go','MarkerFaceColor','g'),hold on;
environment(start1(1)+1,start1(2)+1) = 100; plot(start1(1)+1,start1(2)+1,'rs','MarkerFaceColor','r','MarkerSize',12),hold on;
environment(start2(1)+1,start2(2)+1) = 300; plot(start2(1)+1,start2(2)+1,'ms','MarkerFaceColor','m','MarkerSize',12),hold on;
environment(start3(1)+1,start3(2)+1) = 500; plot(start3(1)+1,start3(2)+1,'cs','MarkerFaceColor','c','MarkerSize',12),hold on;
%绘制轨迹
for i = 1:41
    for j =1:41
        if environment(i,j)==-50.1
            plot(i,j,'r+')
            hold on
        elseif environment(i,j)==-50.2
            plot(i,j,'b+')
            hold on
        elseif environment(i,j)==-50.3
            plot(i,j,'k+')

            hold on
        elseif environment(i,j)==-50.4
            plot(i,j,'y+')
            hold on
        elseif environment(i,j)==-50.5
            plot(i,j,'c+')
            hold on
        elseif environment(i,j)==-50.6
            plot(i,j,'g+')
            hold on
        elseif environment(i,j)==-50%绘制宿舍楼
            plot(i,j,'ko','MarkerFaceColor','k')
            hold on
        elseif environment(i,j)==-100%绘制边界
            plot(i,j,'ko','MarkerFaceColor','k')
            hold on
        end
    end
end
legend('配送点1','配送点2','配送点3','配送点4','配送点5','配送点6','外卖员1','外卖员2','外卖员3','宿舍楼和边界')
axis([1,41,1,41]);

figure
all = res1+res2+res3;
plot(t,all);%绘制每个智能体的步长，步长越小，说明越能更早的找到目标点
