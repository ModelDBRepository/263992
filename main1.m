%
% Two-area (V1-AL) spiking network model from Meijer et al., Cell Reports 2020.
% Computational research, mathematical model and code developed by Jorge Mejias, 2019.
% This code, main1.m, automatically generates Figure 3b of the paper.
% For any clarification, please email j.f.mejias@uva.nl.
%

clear all;close all;
format short;clc;
rng(938197);

%parameters:
statistics=10;G=0.1;
par=parameters(G);bringparam(par);

j=1;
for jj=-0.7:0.2:1.5 %this loop is for the different inputs (i.e. contrast levels)

    mu(j)=10^(jj);mu0=mu(j); %that way, mu0 is uniformly covering two decades.
    z1=0;z2=0;
    for k=1:statistics %we average over 10 trials for each contrast level
        %initial conditions and input:
        Iext=zeros(n,1);Tpulse=0.3;
        Iext(1:n1,1)=mu0; %external input
        [v,calcium]=trial(par,Iext,Tpulse); %run simulation

        %compute the calcium signals:
        F01=mean(calcium(1,transient/dt:(transient+0.9)/dt)); %baseline V1
        F02=mean(calcium(2,transient/dt:(transient+0.9)/dt)); %baseline AL
        z1=z1+(max(calcium(1,transient/dt:(transient+3)/dt)-F01)/F01);
        z2=z2+(max(calcium(2,transient/dt:(transient+3)/dt)-F02)/F02);
    end
    response(1,j)=z1/statistics;
    response(2,j)=z2/statistics;
    j=j+1;

end


figure('Position',[100,100,400,350]);
plot(mu,response(1,:),'-o','Color',[.7 .3 .4],'LineWidth',4);hold on;
plot(mu,response(2,:),'-o','Color',[.9 .7 .1],'LineWidth',4);
legend([{'V1','AL'}],'Location','southeast');set(gca,'box','off');xlim([0.2 13]);
xlabel('Input (mV)');ylabel('Modelled response (\DeltaF/F)');



