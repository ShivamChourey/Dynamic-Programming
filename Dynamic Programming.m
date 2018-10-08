
clc;
close all;
clear all;

% input file format is specified to be a text file containing
% first line to be 
fid = fopen('input1.txt');
TotalVertices = fgetl(fid);
TotalVertices = str2num(TotalVertices);
StartingVertex = fgetl(fid);
StartingVertex = str2num(StartingVertex);
GoalVertex = fgetl(fid);
GoalVertex = str2num(GoalVertex);
V = zeros(TotalVertices,TotalVertices);
V(:,:) = Inf; %high-default value
V(:,TotalVertices) = Inf;
V(TotalVertices,TotalVertices) = 0;

B = zeros(TotalVertices, 1);

MainArray = dlmread('input1.txt',' ',3,0);

K = 0;
while K < TotalVertices
 % Write V into the file
 vertexIndex = TotalVertices;
 while vertexIndex > 0
     [V, B] = DynamicProgramCalculate(vertexIndex, MainArray, TotalVertices, GoalVertex, K, V, K, B);
     vertexIndex = vertexIndex - 1;
 end
 K = K+1;
end

%print path
fileID = fopen('output1.txt','w');
temp = StartingVertex;
while temp ~= GoalVertex
    fprintf(fileID, '%d  ', temp);%print temp
    temp = B(temp);
end
fprintf(fileID, '%d  ', temp);
fprintf(fileID, '\n');


for tmpIndex = 1:TotalVertices
    fprintf(fileID, '%f  ',V(tmpIndex,1));
end


function[V, B] = DynamicProgramCalculate(i, PrimArray, TotalVertices, GoalVertex, K, V, Level, B)

if i == GoalVertex
    Value = 0;
    V(i, TotalVertices-K) = 0;
    B(i)=i;
    return;
end

if Level == 0;
    V(i, TotalVertices-K) = Inf;
    return;
end

    %Find outgoing vertices from current node
    CurrentNodeRowIndexList = find(PrimArray(:,1) == i);
    Size = size(CurrentNodeRowIndexList);
    nIndex = 1;
    H(1:TotalVertices,1) = Inf;
    while nIndex <= Size(1)
        Neighbour = PrimArray(CurrentNodeRowIndexList(nIndex),2);
        EdgeCost =  PrimArray(CurrentNodeRowIndexList(nIndex),3);
        H(nIndex,1) =  EdgeCost + V(Neighbour, TotalVertices - K+1) ;
        nIndex = nIndex+1;
    end
    
    [V(i, TotalVertices-K), MinIndex] = min(H);
    if MinIndex > Size(1)
        MinIndex = 1;
    end
    BestNeighbour = CurrentNodeRowIndexList(MinIndex);
    B(i) = PrimArray(BestNeighbour,2);
    
    Value = min(H);

end