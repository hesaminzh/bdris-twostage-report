function [X]=group_symuni(X,Ng)
% github: https://github.com/YijieLinaMao/BD-RIS-low-complexity
Nr=size(X,1);
X=kron(eye(Nr/Ng),ones(Ng,Ng)).*X;

X=symuni(X);

end

