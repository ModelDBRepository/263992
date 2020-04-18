%
% Two-area (V1-AL) spiking network model from Meijer et al., Cell Reports 2020.
% Computational research, mathematical model and code developed by Jorge Mejias, 2019.
% This code is used to set the parameters of the model.
% For any clarification, please email j.f.mejias@uva.nl.
%

function [par]=parameters(G)


% We put all the relevant parameters in the parameter structure "par":

par.n=500; % total number of neurons
par.n1=400; %in V1
par.n2=100; %in AL
par.dt=0.5e-3; %time constants, in seconds:
par.triallength=8.;par.transient=2;
par.tauref=5.0e-3;par.taum=0.02*ones(par.n,1);
par.tauc=0.5; %Ca2+ imaging time constant
par.vr=-55.;par.vrest=-65.; % neuron parameters, in mV:
par.vth=-45.;par.vpeak=15.;
par.sigma=0.3; %noise, sigma=3
par.taud=0.7*ones(par.n,1);par.Use=0.15; %parameters for short-term depression (STD)
par.J=zeros(par.n,par.n); %synaptic strengths, in mV
par.J(1:par.n1,1:par.n1)=0; %recurrent V1
par.J((par.n1+1):par.n,(par.n1+1):par.n)=0; %recurrent AL
par.J((par.n1+1):par.n,1:par.n1)=G; %FF weight



