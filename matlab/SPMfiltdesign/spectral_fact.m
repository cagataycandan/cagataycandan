% The following function is adapted from 
% http://web.cvxr.com/cvx/examples/filter_design/html/spectral_fact.html
%
% The original function is written for real valued auto-correlation
% function. The function is adapted to the complex valued case. 
%
% September 2018, 
% Cagatay Candan
%

% Spectral factorization using Kolmogorov 1939 approach.
% (code follows pp. 232-233, Signal Analysis, by A. Papoulis)
%
% Computes the minimum-phase impulse response which satisfies
% given auto-correlation.
%
% Input:
%   r: top-half of the auto-correlation coefficients
%      starts from 0th element to end of the auto-corelation
%      should be passed in as a column vector
% Output
%   h: impulse response that gives the desired auto-correlation

function h = spectral_fact(r)

% length of the impulse response sequence
n = length(r);

% over-sampling factor
mult_factor = 100;        % should have mult_factor*(n) >> n 
m = mult_factor*n;

% computation method:
% H(exp(jTw)) = alpha(w) + j*phi(w)
% where alpha(w) = 1/2*ln(R(w)) and phi(w) = Hilbert_trans(alpha(w))

% compute 1/2*ln(R(w))
w = 2*pi*[0:m-1]/m;

%R = [ ones(m,1) 2*cos(kron(w',[1:n-1])) ]*r; %DIKKAT
dum2 = fft([r; zeros(m-2*length(r)+1,1); conj(flipud(r(2:end)))]);
dum2 = real(dum2);
R = dum2; 

alpha = 1/2*log(R);

% find the Hilbert transform 
alphatmp = fft(alpha);
alphatmp(floor(m/2)+1:m) = -alphatmp(floor(m/2)+1:m);
alphatmp(1) = 0;
alphatmp(floor(m/2)+1) = 0;
phi = ifft(j*alphatmp);

% now retrieve the original sampling 
index  = find(rem([0:m-1],mult_factor)==0);
alpha1 = alpha(index);
phi1   = phi(index);

% compute the impulse response (inverse Fourier transform)
h = ifft(exp(alpha1+j*phi1),n);
