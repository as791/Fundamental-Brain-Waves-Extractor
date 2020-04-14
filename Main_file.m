clc;
close all;
clear;

data  =  load('signal07_EEG.csv');

passband_delta = input('Pass Band Edge Frequency Error from frequecy ranges(Hz): ');
transition_width = input('Transition Width(Hz): ');
Ts = 1/input('Sampling Frequency(Hz): ');
Ap = input('Pass Band Attenuation(dB): ');
As = input('Stop Band Attenuation(dB): ');

TypeOfWave = input('Brainwave to analyze:- Gamma/Beta/Alpha/Theta/Delta/All: ','s');

all=["Gamma","Beta","Alpha","Theta","Delta"];

if TypeOfWave~="All"
    [a,b] = filteroption(TypeOfWave,passband_delta,transition_width,Ap,As,Ts);
    filter_output = filter(real(b),real(a),data);
    i=1;
    while i<6
        if all(i)==TypeOfWave
            break;
        end    
        i=i+1;
    end
    figure;hold on;
    subplot(2,1,1);
    plot(data,'LineWidth',0.5,'MarkerSize',10);
    title('EEG Signal');
     axis('off'); 
    subplot(2,1,2);
    plot(filter_output,'LineWidth',0.5,'MarkerSize',10);
    title(TypeOfWave+ " Wave");
    axis('off'); 
else
    figure;hold on;
    subplot(6,1,1);
    plot(data,'LineWidth',0.5,'MarkerSize',10);
    title('EEG Signal');
    axis('off');
    for i=1:5
        [a,b] = filteroption(all(i),passband_delta,transition_width,Ap,As,Ts);
        filter_output = filter(real(b),real(a),data);
        subplot(6,1,i+1);
        plot(filter_output,'LineWidth',0.5,'MarkerSize',10);
        title(all(i)+" Wave");
        axis('off');
    end   
end
