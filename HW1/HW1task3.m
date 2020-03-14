clc,clear all
%%%%%%%%%%%%%%%%%%%%%%%
%     Parameters      %
%%%%%%%%%%%%%%%%%%%%%%%
numberOfAgents=1000;
xmin=0;
xmax=100;
ymin=0;
ymax=100;
d=0.8;
beta=0;
%gamma=0.02; Are varied for different runs!
initialInfectedPopulation=0.01;
numberOfStates=3;
numberOfDimensionsAndState=3;
numberOfTimeSteps=1000;
numberOfAvrageingPoints=10;
TotalNumberOfIterationsGamma=50;


agentPosition=ones(numberOfAgents,numberOfDimensionsAndState);
storedAgentPosition=zeros(numberOfAgents,numberOfDimensionsAndState,numberOfTimeSteps);
susceptibles=zeros(numberOfTimeSteps,1);
infected=zeros(numberOfTimeSteps,1);
recoverd=zeros(numberOfTimeSteps,1);

suseptiblesOverTime=zeros(numberOfAgents,2,numberOfTimeSteps);
infectedOverTime=zeros(numberOfAgents,2,numberOfTimeSteps);
recoverdOverTime=zeros(numberOfAgents,2,numberOfTimeSteps);

Rplot=zeros(TotalNumberOfIterationsGamma,2,2);
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
initialAgentPosition=agentPosition;
gamma=0;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%     Random Walk and upading of states    %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
for ibeta=1:2
  beta=0.2+5*(ibeta-1);
for iterationConstantGamma=1:TotalNumberOfIterationsGamma
  gamma=0.002*iterationConstantGamma;
  for avragerun=1:numberOfAvrageingPoints
    numberOfInfectedLeft=1;
      agentPosition=initialAgentPosition;
    while numberOfInfectedLeft>0
      
      %storedAgentPosition(:,:,t)=agentPosition(:,:);
      
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
      
      numberOfInfectedLeft=0; % check how many infected that remains
      for i=1:numberOfAgents
        if agentPosition(i,3)==2
          numberOfInfectedLeft=1+numberOfInfectedLeft;
        end
      end
      
    end
    
    Rinf=0;
    for i=1:numberOfAgents
      if agentPosition(i,3)==3
        Rinf=1/numberOfAgents+Rinf;
      end
    end
    
    R=beta/gamma;
    
    Rplot(iterationConstantGamma,1,ibeta)=R;
    Rplot(iterationConstantGamma,2,ibeta)=Rinf/numberOfAvrageingPoints+Rplot(iterationConstantGamma,2,ibeta);
    
  end
end
end

  figure(1)
  hold on
plot(Rplot(:,1,1),Rplot(:,2,1),'g')
plot(Rplot(:,1,2),Rplot(:,2,2),'r')




