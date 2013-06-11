function   [mu,sigma]  = mixGaussAnalysis(X,c)
% Fit Gaussian Mixture Model for input data X, c classes. For simplicity
% and stability covariance are set to be diagonal.
% Input:
% X:[nxd]. n observations by d variables.
% c: no. of classes.
% Output:
% mu: [cxd]. Each row is the mean of a class.
% sigma:[dxc].

% Initialization
% vl_kmeans can be replaced by MATLAB's kmeans, but this one is
% significantly faster. The toolbox can be downloaded at vlfeat.org.
[idx mu] = kmeans(X,c);
clear idx
mu = mu;
mu_prev = mu;

% A priori probability of each class.
[n d] = size(X);
prior = ones(c,1)/c;
prior_prev = prior;

% A posterior probability of each sample belonging to each class.
post = ones(n,c)/c;
% set sigma as an array representing diagonal matrix
sigma = ones(1,d,c);sigma_prev = sigma;
likeli = zeros(n,c);

maxIter = 100;
thresh = 1;
error = 0;

for t=1:maxIter
    % E-step
    for i = 1:c
        post(:,i)= mvnpdf(X,mu_prev(i,:),sigma_prev(:,:,i))*prior_prev(i);
        likeli(:,i) = mvnpdf(X,mu_prev(i,:),sigma_prev(:,:,i));
    end
    for j = 1:n
        post(j,:) = post(j,:)/sum(post(j,:));
    end    
    % M-step    
    mu = post'*X./repmat(sum(post)',1,d);
    for i = 1:c
       sigma(:,:,i) = diag((X'-repmat(mu(i,:)',1,n))*diag(post(:,i))*(X'-repmat(mu(i,:)',1,n))'/sum(post(:,i)));  % ����ط���ʱ���˺ܾ�T_T�˺�����ʾ����ʱ��һ��Ҫ����Խǻ�������sigma��������diag(post(:,i))����ȡÿ���������ڵ�i��ĺ������������2414x1�������Ϊ2414x2414ά�ĶԽ�������X��PX���빫ʽ�е����
    end
    
    % Regularize
    sigma = sigma + 1e-4;
    for i = 1:c
        prior(i) = sum(post(:,i))/n;
    end
    
    for i = 1:c
        error = error + norm(mu(i,:)-mu_prev(i,:)) + norm(sigma(:,:,i)-sigma_prev(:,:,i));
    end
    
    if error < thresh
        break
    end
    mu_prev = mu;
    sigma_prev = sigma;
    prior_prev = prior;
    error = 0;
end

fprintf('Iteration times: %d\n',t);