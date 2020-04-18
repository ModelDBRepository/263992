%
% Two-area (V1-AL) spiking network model from Meijer et al., Cell Reports 2020.
% Computational research, mathematical model and code developed by Jorge Mejias, 2019.
% This code, main2.m, generates Figure 3c (if mu0=5) or 3d (if mu0=12) of the paper.
% For any clarification, please email j.f.mejias@uva.nl.
%

clear all;close all;
format short;clc;
rng(938197);

%parameters:
G=0.1;mu0=5;
par=parameters(G);bringparam(par);
Iext=zeros(n,1);Tpulse=0.3;
Iext(1:n1,1)=mu0;
%run simulation:
[v,calcium]=trial(par,Iext,Tpulse);



figure('Position',[100,100,400,350]);
time=dt:dt:triallength;time=time-transient; %we align with the stimulus onset
F01=mean(calcium(1,transient/dt:(transient+0.9)/dt)); %baseline V1
F02=mean(calcium(2,transient/dt:(transient+0.9)/dt)); %baseline AL
plot(time,(calcium(1,:)-F01)/F01,'LineWidth',2,'Color',[.7 .3 .4]);hold on;
plot(time,(calcium(2,:)-F02)/F02,'LineWidth',2,'Color',[.9 .7 .1]);
xlabel('Time (s)');xlim([0 3]);ylim([0 .4])
ylabel('Modelled response (\DeltaF/F)');set(gca,'box','off')
legend([{'V1','AL'}]);




