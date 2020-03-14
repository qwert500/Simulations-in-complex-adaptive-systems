clc,clear all
%%%%%%%%%%%%%%%%%%%%%%
%    Parameters      %
%%%%%%%%%%%%%%%%%%%%%%
N=128;
p=0.6; %probability for tree to grow on emty spot
f=1; %probability of lightning to strike on a spoot
numberOfTimeSteps=1;

tmpFirePosition2=[];
firePosition=zeros(N,N);
treePosition=zeros(N,N);
firePositionForPlot=zeros(N,2,numberOfTimeSteps);
%%%%%%%%%%%%%%%%%%%%%%
%      The run       %
%%%%%%%%%%%%%%%%%%%%%%
for t=1:numberOfTimeSteps
  check=0;
  for i=1:N %growing trees
    for j=1:N
      rn=rand(1);
      if rn<p
        check=check+1;
        treePosition(i,j)=1;
      end
    end
  end
  
  rn=rand(1);
  if rn<f
    xLightning=randi([1,N],1);
    yLightning=randi([1,N],1);
    if treePosition(xLightning,yLightning)==1
      
      treePosition(xLightning,yLightning)=0;
      firePosition(xLightning,yLightning)=1;
      tmpFirePosition=[xLightning yLightning];
      burningTreesLeft=size(tmpFirePosition,1);
      while burningTreesLeft>0
        
        for i=1:size(tmpFirePosition,1)
          
          for j=1:4 %von neuman spreads in 4 directions
            if j==1 % xposition-1 von neumann
              if tmpFirePosition(i,1)-1<1 && treePosition(N,tmpFirePosition(i,2))==1
                treePosition(N,tmpFirePosition(i,2))=0;
                firePosition(N,tmpFirePosition(i,2))=1;
                tmpFirePosition2=[tmpFirePosition2;[N tmpFirePosition(i,2)]];
                
              elseif treePosition(tmpFirePosition(i,1)-1,tmpFirePosition(i,2))==1
                treePosition(tmpFirePosition(i,1)-1,tmpFirePosition(i,2))=0;
                firePosition(tmpFirePosition(i,1)-1,tmpFirePosition(i,2))=1;
                tmpFirePosition2=[tmpFirePosition2;[tmpFirePosition(i,1) tmpFirePosition(i,2)]];
              else
                disp('J==1 something went wrong')
              end
            elseif j==2 % x position +1 von neumann
              if tmpFirePosition(i,1)+1>N && treePosition(1,tmpFirePosition(i,2))==1
                treePosition(1,tmpFirePosition(i,2))=0;
                firePosition(1,tmpFirePosition(i,2))=1;
                tmpFirePosition2=[tmpFirePosition2;[1,tmpFirePosition(i,2)]];
                
              elseif treePosition(tmpFirePosition(i,1)-1,tmpFirePosition(i,2))==1
                treePosition(tmpFirePosition(i,1)+1,tmpFirePosition(i,2))=0;
                firePosition(tmpFirePosition(i,1)+1,tmpFirePosition(i,2))=1;
                tmpFirePosition2=[tmpFirePosition2;[tmpFirePosition(i,1)+1,tmpFirePosition(i,2)]];
              else
                disp('J==2 something went wrong')
              end
            elseif j==3 % y position -1 von neumann
              if tmpFirePosition(i,2)-1<1 && treePosition(tmpFirePosition(i,1),N)==1
                treePosition(tmpFirePosition(i,1),N)=0;
                firePosition(tmpFirePosition(i,1),N)=1;
                tmpFirePosition2=[tmpFirePosition2;[tmpFirePosition(i,1), N]];
                
              elseif treePosition(tmpFirePosition(i,1),tmpFirePosition(i,2)-1)==1
                treePosition(tmpFirePosition(i,1),tmpFirePosition(i,2)-1)=0;
                firePosition(tmpFirePosition(i,1),tmpFirePosition(i,2)-1)=1;
                tmpFirePosition2=[tmpFirePosition2;[tmpFirePosition(i,1),tmpFirePosition(i,2)-1]];
              else
                disp('J==3 something went wrong')
              end
            elseif j==4 % y position +1 von neumann
              if tmpFirePosition(i,2)+1>N && treePosition(tmpFirePosition(i,1),1)==1
                treePosition(tmpFirePosition(i,1),1)=0;
                firePosition(tmpFirePosition(i,1),1)=1;
                tmpFirePosition2=[tmpFirePosition2;[tmpFirePosition(i,1),1]];
                
              elseif treePosition(tmpFirePosition(i,1),tmpFirePosition(i,2)+1)==1
                treePosition(tmpFirePosition(i,1),tmpFirePosition(i,2)+1)=0;
                firePosition(tmpFirePosition(i,1),tmpFirePosition(i,2)+1)=1;
                tmpFirePosition2=[tmpFirePosition2;[tmpFirePosition(i,1),tmpFirePosition(i,2)+1]];
              else
                disp('J==4 something went wrong')
              end  
            end
          end
        end
        for i=1:size(tmpFirePosition,1)
        firePositionForPlot(:,:,t)=[firePositionForPlot(:,:,t);tmpFirePosition(i,:)];
        end
        tmpFirePosition=[];
        tmpFirePosition=tmpFirePosition2;
        tmpFirePosition2=[];
        burningTreesLeft=size(tmpFirePosition,1)
      end %while ends here
    end
  end
  k=0;
  treePlot=[];
  for i=1:N
    for j=1:N
      if treePosition(i,j)==1
        k=k+1;
  treePlot(k,:)=[i j];
      end
    end
  end
  kk=0;
  firePlot=[];
  for i=1:N
    for j=1:N
      if firePositionForPlot(i,j,t)==1
        kk=kk+1
  firePlot(kk,:)=[i j];
      end
    end
  end
  firePlotFinal(:,:,t)=firePlot(:,:);
end
hold on
scatter(treePlot(:,1),treePlot(:,2),30,'filled','g')
scatter(firePlot(:,1),firePlot(:,2),100,'filled','r')  
            
            
            
            
            
            
            
            
            
            
            
            
            
            