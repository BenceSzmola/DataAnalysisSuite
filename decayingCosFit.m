function [decCosFit,gof,fit_tau,fit_theta,fit_time2base,fit_cycles2base] = decayingCosFit(xAx,data,fs)

decayCos = @(tau,theta,x) exp(tau*x).*cos(2*pi*theta*x);
% decayCos = @(offset,tau,tau2,theta,theta2,secAmp,x) exp(tau*x).*cos(2*pi*theta*x) + max(0,x-offset).*exp(tau2*(x-offset)).*(secAmp*cos(2*pi*theta2*x));

[decCosFit,gof,~] = fit((xAx/fs)',data',decayCos,'StartPoint',[-.1,150]);
fit_tau = decCosFit.tau;
fit_theta = decCosFit.theta;
fit_time2base = log(.1)/fit_tau;
fit_cycles2base = (log(.1)/fit_tau)*fit_theta;
fprintf(1,'rsquare for decaying cos fit = %.4f\n',gof.rsquare)
fprintf(1,'tau = %.4f , time2base = %.4f , theta = %.4f , cycles2base = %.2f\n',...
    fit_tau,fit_time2base,fit_theta,fit_cycles2base)