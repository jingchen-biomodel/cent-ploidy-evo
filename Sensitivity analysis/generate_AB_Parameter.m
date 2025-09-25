% generate_AB_Parameter()
% From Yao et al., 2021

function [par_A,par_B,par_AB] = generate_AB_Parameter(N,d,params)
% return the sampled parameter sets A,B,AB
% N is the sample size, d is the number of parameters

rng('shuffle');
% generate 2 latin hyper unit cube samples
 A = lhsdesign(N,d);
 B = lhsdesign(N,d);

% use inverse cumulative distribution function to sample parameters 
par_A = zeros(N,d);
par_B = zeros(N,d);
par_AB = repmat(par_A,d,1); % creates d x 1 copies of par_A

for j=1:d
    pd = params{j};
    if ~isa(pd,'double')
      par_A(:,j)= icdf(pd,A(:,j)); %samples cdf up to value from latin hypercube to choose the parameter value
      par_B(:,j)= icdf(pd,B(:,j));      
    else
       par_A(:,j) = datasample(pd,N); %samples from pd N times
       par_B(:,j) = datasample(pd,N);
    end
end

%% create mixing parameter AB
for j=1:d
    par_AB(1+N*(j-1):N*j,:) = par_A; % the jth parameter column is replaced by B matrix
    par_AB(1+N*(j-1):N*j,j) = par_B(:,j);
end

end