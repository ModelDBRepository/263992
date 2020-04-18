%
% Two-area (V1-AL) spiking network model from Meijer et al., Cell Reports 2020.
% Computational research, mathematical model and code developed by Jorge Mejias, 2019.
% This code is used to run a single trial simulation of the model.
% For any clarification, please email j.f.mejias@uva.nl.
%

function [v,calcium]=trial(par,Iext,Tpulse)
	

% we rewrite the par structure into local parameters for clarity:
bringparam(par);

%initial conditions:
input0=16*ones(n,1);sigma=3.;
input0(n1+1:n,1)=14; %AL has a smaller background to compensate the extra baseline input from V1
v=zeros(n,round(triallength/dt));x=v;
rasterdots=v;avgrate=zeros(1,n);Cspont=0.3;
calcium=zeros(2,round(triallength/dt)); %first row is for V1, second is for AL

%other new variables:
xi=normrnd(0,1,n,round(triallength/dt));
spikes=zeros(n,1);rest=vrest*ones(n,1);
taumsq=taum.^0.5;refcount=5e-3*ones(n,1); %for later

%first iteration:
v(:,1)=rest;rasterdots(:,1)=zeros(n,1);calcium(1,1)=0;x(:,1)=1;

%Now we start the real simulation:
i=2;
for time=2*dt:dt:triallength
	
    input=input0; %inputs
    t1=transient+1;t2=transient+1+Tpulse;
    if time>t1 && time<=t2
        input=input0+Iext;
    end
    
	%update the variables:
	v(:,i)=v(:,i-1)+dt*(taum(:,1).\(rest(:,1)-v(:,i-1))+taum(:,1).\input(:,1))...
	+taumsq(:,1).\xi(:,i-1)*sqrt(dt)*sigma;
	%add the recurrent input:
	v(:,i)=v(:,i)+J*(x(:,i-1).*spikes);
    %and now, once the spikes are transmitted, we update the STD-synapses:
    x(:,i)=x(:,i-1)+dt*((ones(n,1)-x(:,i-1))./taud(:,1));
    x(:,i)=x(:,i)-Use*x(:,i).*spikes(:,1);
	
	%we hold neurons which are in the refractory period:
	v(refcount(:,1)<tauref,i)=vr;
	
	%spikes and threshold condition:
	spikes=zeros(n,1);
	refcount(v(:,i)>vth,1)=0;
	spikes(v(:,i)>vth,1)=1;
	v(v(:,i)>vth,i)=vpeak;
    
    %calcium signals for V1 and AL:
    numspikes1=length(find(refcount(1:n1,1)<tauref))./n1; % ~normalized #spikes in V1
    numspikes2=length(find(refcount((n1+1):n,1)<tauref))./n2; % ~normalized #spikes in AL
    calcium(1,i)=calcium(1,i-1)+(dt/tauc)*(Cspont-calcium(1,i-1)+numspikes1);
    calcium(2,i)=calcium(2,i-1)+(dt/tauc)*(Cspont-calcium(2,i-1)+numspikes2);
    
	refcount=refcount+dt;
	i=i+1;
end



