function [environment,res,time] = sol(environment,start,num)
Q_table = zeros(1600,8); % Q表
gamma = 0.9;% 折扣率
alpha = 0.09;% 学习率
epsilon = 1;% 初始epsilon
decay = 0.999;% epsilon衰减率
x = start(1)+1;% 起始位置
y = start(2)+1;
state = com_state(x,y);% 起始状态
episode = 30000;% 每个任务的总训练回合数
%%%%%%%%%%%%%%%%%训练过程%%%%%%%%%%%%%%%%
res = [];%记录步长
time = [];
for i=1:episode
    done = false;
    number = 0;
    if epsilon>0.02
        epsilon = epsilon*decay;% epsilon衰减
    end
    while done==false && number<200% 程序设定最多探索的步长
        number=number+1;
        if rand(1)<epsilon
            action = round(rand(1,1)*7)+1;%随机选取动作
        else
            [~,action] = max(Q_table(state,:),[],2);%最大的动作
        end

        [x,y] = move(x,y,action);% 计算下一步x,y
        r = environment(x,y);% 计算奖励
        if r>10 || r<-10% 只要碰到障碍或者出界或者碰到其他目标/起始点，就done，并恢复到起始位置
            done = true;
            max_Q = 0;
            x = start(1)+1;
            y = start(2)+1;
            new_state = com_state(x,y);
        else
            new_state = com_state(x,y);
            [max_Q,~] = max(Q_table(new_state),[],2);% Q_target
        end
        % 更新Q
        Q_table(state,action) = Q_table(state,action)+alpha*(r+gamma*max_Q-Q_table(state,action));
        state = new_state;
    end
res = [res number];
time = [time i];
end
%%%%%%%%%%测试过程（也就是实际的路径）%%%%%%%%%%
done = false;
number = 0;
x = start(1)+1;
y = start(2)+1;
state = com_state(x,y);
while done==false && number<200
    number = number + 1; 
    [~,action] = max(Q_table(state,:),[],2);%直接选取最大的动作而不是仿真
    [x,y] = move(x,y,action);%计算下一步x,y
    r = environment(x,y);%计算奖励
    if r<-10 || r>10%只要碰到障碍或者出界
        done = true;
        max_Q = 0;
    else
        environment(x,y)=num;
        new_state = com_state(x,y);%换算成状态
        [max_Q,~] = max(Q_table(new_state),[],2);
    end
    Q_table(state,action) = Q_table(state,action)+alpha*(r+gamma*max_Q-Q_table(state,action));
    state = new_state;
end