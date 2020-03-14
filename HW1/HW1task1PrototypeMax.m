clc,clear all
%%%%%%%%%%%%%%%%%%%%%%%
%     Parameters      %
%%%%%%%%%%%%%%%%%%%%%%%
numberOfAgents=1000;
xmin=0;
xmax=100;
ymin=0;
ymax=100;
d=0.75;
beta=0.9;
gamma=0.01;
initialInfectedPopulation=0.1;
numberOfStates=3;
numberOfDimensions=2;
numberOfTimeSteps=100;

%susceptibles=ones(numberOfAgents,numberOfDimensions);
%infected=ones(numberOfAgents,numberOfDimensions);
susceptibles2=zeros(numberOfTimeSteps,1);
infected2=zeros(numberOfTimeSteps,1);
recoverd2=zeros(numberOfTimeSteps,1);

%%%%%%%%%%%%%%%%%%%%%%%
%    Initialization   %
%%%%%%%%%%%%%%%%%%%%%%%
for i=1:numberOfAgents*(1-initialInfectedPopulation) %generating susceptibles
  for j=1:numberOfDimensions
    if j==1
      susceptibles(i,j)=randi([xmin,xmax],1,1);
    elseif j==2
      susceptibles(i,j)=randi([ymin,ymax],1,1);
    else
      disp('something went wrong!!')
    end
  end
end

for i=1:numberOfAgents*initialInfectedPopulation %generating infected
  for j=1:numberOfDimensions
    if j==1
      infected(i,j)=randi([xmin,xmax],1,1);
    elseif j==2
      infected(i,j)=randi([ymin,ymax],1,1);
    else
      disp('something went wrong!!')
    end
  end
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%     Random Walk and upading of states    %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
for t=1:500 %numberOfTimeSteps
  latticePlacement=zeros(xmax-xmin+1,ymax-ymin+1);
  for i=1:size(susceptibles,1) %number of agents on lattice points
    latticePlacement(susceptibles(i,1)+1,susceptibles(i,2)+1)=...
      1+latticePlacement(susceptibles(i,1)+1,susceptibles(i,2)+1);
  end
  
  for i=1:size(infected,1)%risk of infection for agents with same positions
    if latticePlacement(infected(i,1)+1,infected(i,2)+1)>0 && rand(1)<beta
      susceptibles=susceptibles(~ismenber(susceptibles,infected(i,:),'rows'),:);
      iTmp=ones(infected(i,1),infected(i,2),1)*infected(i,:);
      transmissionTmp= [transmissionTmp;iTmp];
      latticePlacement(infected(i,1),infected(i,2))=0;
    end
    if rand(1)<gamma
      recoverd=[recoverd;infected(i,:)];
      recoveryTmp=[recoveryTmp;infected(i,:)];
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
      if agentPosition(i,1)==0 && agentPosition(i,2)==0
        pathSelection=randi(2)*2;
      elseif agentPosition(i,1)==0 && agentPosition(i,2)==100
        pathSelection=2+ randi([0 1]);
      elseif agentPosition(i,1)==100 && agentPosition(i,2)==0
        pathSelection=1+randi([0 1])*3;
      elseif agentPosition(i,1)==100 && agentPosition(i,2)==100
        pathSelection=1+randi([0 1])*2;
      elseif agentPosition(i,1)==0
        pathSelection=randi([2,4]);
      elseif agentPosition(i,1)==100
        pathSelection=1+randi([2,3])*randi([0 1]);
      elseif agentPosition(i,2)==0
        pathSelection=abs(2*randi([1 2])-3*randi([0 1]));
      elseif agentPosition(i,2)==100
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
  figure(1)
  clf
  hold on
  for i=1:numberOfAgents
    if agentPosition(i,3)==1
      plot(agentPosition(i,1),agentPosition(i,2),'.b')
    elseif agentPosition(i,3)==2
      plot(agentPosition(i,1),agentPosition(i,2),'.r')
    elseif agentPosition(i,3)==3
      plot(agentPosition(i,1),agentPosition(i,2),'.g')
    else
      disp('ERROR!!!!')
    end
  end
  axis([0 100 0 100])
  pause(0.01)
  
  
  for i=1:numberOfAgents
    if agentPosition(i,3)==1
      susceptibles2(t)=1/numberOfAgents+susceptibles2(t);
    elseif agentPosition(i,3)==2
      infected2(t)=1/numberOfAgents+infected2(t);
    elseif agentPosition(i,3)==3
      recoverd2(t)=1/numberOfAgents+recoverd2(t);
    end
  end
end
figure(2)
hold on
plot(1:numberOfTimeSteps,susceptibles2,'b')
plot(1:numberOfTimeSteps,infected2,'r')
plot(1:numberOfTimeSteps,recoverd2,'g')
legend('susceptibles','infected','recoverd')

