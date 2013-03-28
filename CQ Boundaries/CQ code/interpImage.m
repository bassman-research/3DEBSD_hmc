function ImatrixNew = interpImage(Imatrix,bkrnd_col)

[m n p] = size(Imatrix);

if strcmp(bkrnd_col,'white')
    bkrnd = 1;
elseif strcmp(bkrnd_col,'black')
    bkrnd = 0;
else
    sprintf('specify background color as "black" or "white"')
end

ImatrixNew = Imatrix;

for i=1:m
    for j=1:n
        if all(Imatrix(i,j,:)==bkrnd)
            Cround = [];
            if i>1&&any(Imatrix(i-1,j,:)~=bkrnd)
                Cround = [Cround squeeze(Imatrix(i-1,j,:))];
               
            end
            if i<m&&any(Imatrix(i+1,j,:)~=bkrnd)
                Cround = [Cround squeeze(Imatrix(i+1,j,:))];
            end
            if j>1&&any(Imatrix(i,j-1,:)~=bkrnd)
                Cround = [Cround squeeze(Imatrix(i,j-1,:))];
            end
            if j<n&&any(Imatrix(i,j+1,:)~=bkrnd)
                Cround = [Cround squeeze(Imatrix(i,j+1,:))];
            end
            if length(Cround)<3
                Cround = bkrnd*ones(1,3);
            end
            Cround = mean(Cround,2);
            ImatrixNew(i,j,:)=Cround;
        end
    end
end
