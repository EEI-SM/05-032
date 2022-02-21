%遮断周波数[Hz]
cutfrequency = 0.05
% % LPF = dsp.LowpassFilter('SampleRate',Fs,'DesignForMinimumOrder','true','PassbandFrequency',0.1)
% %LPF = dsp.LowpassFilter
% width = 1.0
% center = 1.75
% target_tilt = 1.3
% 
% cn = dsp.ColoredNoise('InverseFrequencyPower',target_tilt,'SamplesPerFrame',600)
% x1 = cn()
% x1_lowpass = lowpass(x1,cutfrequency,Fs)
% 
% max_x1 = max(x1_lowpass)
% min_x1 = min(x1_lowpass)
% a = width/(max_x1 - min_x1)
% %x2 = a * x_lowpass
% x2 = a * x1_lowpass
% average_x2 = mean(x2)
% x3 = x2 - average_x2 + center
% % x4 = width * x3
% x4 = x3

filename = 'C:\Users\1812043\Documents\課題\卒研\減風実験\クロスフロー\Target\to0.05Hz\No7_to0.05\No7_to0.05.csv'

%サンプリング周波数
Fs = 1
%ファイル読み込み
sheet = readtable(filename,'ReadVariableNames',false)
%timetable化
% signal = sheet(end-599:end,4)
signal = sheet(end-599:end,1)
x4 = table2array(signal)
% x = table2array(signal)

% x4 = -0.0019*x + 2.5071

tiledlayout(2,1)

L = 600
f = (linspace(0,1,L)).'

% nexttile
Y1 = fft(x4)
Y2 = abs(Y1)
% plot(f,Y2)

% nexttile
P1 = Y2/L
P2 = P1(1:L/2+1)
P2(2:end-1) = 2*P2(2:end-1)
f_P2 = (Fs*(0:(L/2))/L).'
% plot(f_P2,P2)

% nexttile
P3 = P2.^2
% plot(log10(f_P2(2:end)),log10(P3(2:end)))

nexttile
hold on
P4 = P3/(0.00166666666666667)
plot(log10(f_P2(2:end)),log10(P4(2:end)))
PSDPink = 1./f_P2(2:end)
plot(log10(f_P2(2:end)),log10(PSDPink),'m','linewidth',2)
xlabel('Frequency (log)[Hz]')
ylabel('PSD (log)[(m/s)^2/ΔHz]')
title('Wind through the cross flow')

Idx = dsearchn(log10(f_P2(2:end)),log10(cutfrequency))
pol_fft = polyfit(log10(f_P2(2:Idx)),log10(P4(2:Idx)),1)
y = polyval(pol_fft,log10(f_P2(2:Idx)))

% str = append('tilt',num2str(pol_fft(1,1)))
% annotation('textbox','String',str)
plot(log10(f_P2(2:Idx)),y,'g','linewidth',2)

legend('PSD','1/f(pink noise)','Linear regression','Location','southwest')

hold off

nexttile
plot(x4)
xlabel('Time [s]')
ylabel('Wind speed [m/s]')
% legend('PSD','Theoretical pink noise PSD')
title('Wind through the cross flow fan(Time)')

% figure(2)
% % rotation = -138.89*(x4.^2) + 73.014*(x4) + 842.71
% rotation = -509.64*x4 + 1281.3
% plot(rotation)
% title('Convert wind speed to rotation')
% xlabel('Time [s]')
% ylabel('Rotation value [rpm]')