function [NNx,NNy] = adapt_NN(NNx,NNy,note,alpha,P,D)
% adapt NNs based on a new recorded displacement
% and coefficient alpha
netX = NNx{note};
netY = NNy{note};
est_Dx = netX(P');
est_Dy = netY(P');
new_Dx = est_Dx - alpha * (est_Dx - D(:,1)');
new_Dy = est_Dy - alpha * (est_Dy - D(:,2)');
[new_netX,~,~,~] = adapt(netX,P',new_Dx);
[new_netY,~,~,~] = adapt(netY,P',new_Dy);
NNx{note} = new_netX;
NNy{note} = new_netY;
fileID = fopen('adapted_notes.txt','a+');
fprintf(fileID,' %d',note);
fclose(fileID);
end