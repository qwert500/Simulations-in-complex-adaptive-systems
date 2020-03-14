
clc,clear all
%%%%%%%%%%%%%%%%%%%%%%%
%     Parameters      %
%%%%%%%%%%%%%%%%%%%%%%%
numberOfAgents=1000;
xmin=0;
xmax=100;
ymin=0;
ymax=100;
d=0.4;
beta=0.4;
gamma=0.01;
initialInfectedPopulation=0.02;
numberOfStates=3;
numberOfDimensionsAndState=3;
numberOfTimeSteps=1000;

agentPosition=ones(numberOfAgents,numberOfDimensionsAndState);
storedAgentPosition=zeros(numberOfAgents,numberOfDimensionsAndState,numberOfTimeSteps);
susceptibles=zeros(numberOfTimeSteps,1);
infected=zeros(numberOfTimeSteps,1);
recoverd=zeros(numberOfTimeSteps,1);

suseptiblesOverTime=zeros(numberOfAgents,2,numberOfTimeSteps);
infectedOverTime=zeros(numberOfAgents,2,numberOfTimeSteps);
recoverdOverTime=zeros(numberOfAgents,2,numberOfTimeSteps);

%%%%%%%%%%%%%%%%%%%%%%%
%    Initialization   %
%%%%%%%%%%%%%%%%%%%%%%%
for i=1:numberOfAgents
  for j=1:numberOfDimensionsAndState-1
    if j==1
      agentPosition(i,j)=randi([xmin,xmax],1,1);
    elseif j==2
      agentPosition(i,j)=randi([ymin,ymax],1,1);
    else
      disp('something went wrong!!')
    end
  end
end

initialNumberOfInfected=fix(numberOfAgents*initialInfectedPopulation);
for i=1:initialNumberOfInfected
  agentPosition(i,3)=2;
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%     Random Walk and upading of states    %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
for t=1:numberOfTimeSteps
  storedAgentPosition(:,:,t)=agentPosition(:,:);
  
  latticePlacement=zeros(xmax-xmin+1,ymax-ymin+1);
  for i=1:numberOfAgents %number of agents on lattice points
    latticePlacement(agentPosition(i,1)+1,agentPosition(i,2)+1)=...
      1+latticePlacement(agentPosition(i,1)+1,agentPosition(i,2)+1);
  end
  
  for i=1:numberOfAgents %risk of infection for agents with same positions
    if agentPosition(i,3)==2 && latticePlacement(agentPosition(i,1)+1,agentPosition(i,2)+1)>1 && rand(1)<beta
      for j=1:numberOfAgents
        if agentPosition(i,1)==agentPosition(j,1) && agentPosition(i,2)==agentPosition(j,2) && agentPosition(j,3)==1
          agentPosition(j,3)=2;
        end
      end
    end
  end
  
  for i=1:numberOfAgents %chance of recovery
    rn=rand(1);
    if rn<gamma && agentPosition(i,3)==2
      agentPosition(i,3)=3;
    end
  end
  
  for i=1:numberOfAgents %The Walk
    rn=rand;
    if rn<d
      %Boundary of lattice
      if agentPosition(i,1)==xmin && agentPosition(i,2)==ymin
        pathSelection=randi(2)*2;
      elseif agentPosition(i,1)==xmin && agentPosition(i,2)==ymax
        pathSelection=2+ randi([0 1]);
      elseif agentPosition(i,1)==xmax && agentPosition(i,2)==ymin
        pathSelection=1+randi([0 1])*3;
      elseif agentPosition(i,1)==xmax && agentPosition(i,2)==ymax
        pathSelection=1+randi([0 1])*2;
      elseif agentPosition(i,1)==xmin
        pathSelection=randi([2,4]);
      elseif agentPosition(i,1)==xmax
        pathSelection=1+randi([2,3])*randi([0 1]);
      elseif agentPosition(i,2)==ymin
        pathSelection=abs(2*randi([1 2])-3*randi([0 1]));
      elseif agentPosition(i,2)==ymax
        pathSelection=randi([1 3]);
      else
        pathSelection=randi([1 4]);
      end
      if pathSelection==1
        agentPosition(i,1)=agentPosition(i,1)-1;
      elseif pathSelection==2
        agentPosition(i,1)=agentPosition(i,1)+1;
      elseif pathSelection==3
        agentPosition(i,2)=agentPosition(i,2)-1;
      elseif pathSelection==4
        agentPosition(i,2)=agentPosition(i,2)+1;
      else
        disp('something went to shit')
      end
    end
  end
  
  for i=1:numberOfAgents
    if agentPosition(i,3)==1
      susceptibles(t)=1/numberOfAgents+susceptibles(t);
    elseif agentPosition(i,3)==2
      infected(t)=1/numberOfAgents+infected(t);
    elseif agentPosition(i,3)==3
      recoverd(t)=1/numberOfAgents+recoverd(t);
    end
  end
end
figure(1)
hold on
plot(1:numberOfTimeSteps,susceptibles,'b')
plot(1:numberOfTimeSteps,infected,'r')
plot(1:numberOfTimeSteps,recoverd,'g')
legend('susceptibles','infected','recoverd')


for t=1:numberOfTimeSteps
j=1;
jj=1;
jjj=1;
 hold on
  for i=1:numberOfAgents
    if storedAgentPosition(i,3,t)==1
      j=j+1;
     suseptiblesOverTime(j,1,t)=storedAgentPosition(i,1,t);
     suseptiblesOverTime(j,2,t)=storedAgentPosition(i,2,t);
    elseif storedAgentPosition(i,3,t)==2
      jj=jj+1;
      infectedOverTime(jj,1,t)=storedAgentPosition(i,1,t);
     infectedOverTime(jj,2,t)=storedAgentPosition(i,2,t);
    elseif storedAgentPosition(i,3,t)==3
      jjj=jjj+1;
      recoverdOverTime(jjj,1,t)=storedAgentPosition(i,1,t);
     recoverdOverTime(jjj,2,t)=storedAgentPosition(i,2,t);
    else
      disp('ERROR!!!!')
    end
  end
end

figure(2)
for t=1:numberOfTimeSteps
  clf
 hold on
 scatter(suseptiblesOverTime(:,1,t),suseptiblesOverTime(:,2,t),100,'filled','b')
 scatter(infectedOverTime(:,1,t),infectedOverTime(:,2,t),100,'filled','r')
 scatter(recoverdOverTime(:,1,t),recoverdOverTime(:,2,t),100,'filled','g')
  axis([xmin xmax ymin ymax])
  pause(0.00000000001)
end


