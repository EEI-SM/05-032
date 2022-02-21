% 遮断周波数
cutfrequency = 0.05
% サンプリング周波数
Fs = 1
% データ数
L = 600
% 風速最大幅
width = 1.0
% 直流成分
center = 1.75
% パワースペクトルの傾きを1/fの何乗にするか
target_tilt = 1.3

% ゆらぎデータ生成
cn = dsp.ColoredNoise('InverseFrequencyPower',target_tilt,'SamplesPerFrame',600)
x1 = cn()

% 生成データをローパスフィルターにかける
x1_lowpass = lowpass(x1,cutfrequency,Fs)
% 生成データの直流成分を1.75にする処理
max_x1 = max(x1_lowpass)
min_x1 = min(x1_lowpass)
a = width/(max_x1 - min_x1)
x2 = a * x1_lowpass
average_x2 = mean(x2)
x4 = x2 - average_x2 + center

% パワースペクトル表示処理
f = (linspace(0,1,L)).'
Y1 = fft(x4)
Y2 = abs(Y1)
P1 = Y2/L
P2 = P1(1:L/2+1)
P2(2:end-1) = 2*P2(2:end-1)
f_P2 = (Fs*(0:(L/2))/L).'
P3 = P2.^2
P4 = P3/([0.00166666666666667])

% 比較用の1/fプロット
PSDPink = 1./f_P2(2:end)

% スペクトル傾き算出処理
Idx = dsearchn(log10(f_P2(2:end)),log10(cutfrequency))
pol_fft = polyfit(log10(f_P2(2:Idx)),log10(P4(2:Idx)),1)
y = polyval(pol_fft,log10(F(2:Idx)))

% 回転数に変換[rpm]
rotation = -509.64*x4 + 1281.3

% グラフ化処理
figure(1)
tiledlayout(2,1)
nexttile
hold on
plot(log10(f_P2(2:end)),log10(P4(2:end)))
plot(log10(f_P2(2:end)),log10(PSDPink),'m','linewidth',2)
xlabel('Frequency (log)[Hz]')
ylabel('PSD (log)[(m/s)^2/ΔHz]')
title('Reproduction of wind(Frequency)')
plot(log10(f_P2(2:Idx)),y,'g','linewidth',2)
legend('PSD','1/f(pink noise)','Linear regression','Location','southwest')
hold off

nexttile
plot(x4)
xlabel('Time [s]')
ylabel('Wind speed [m/s]')
title('Reproduction of wind(Time)')

figure(2)
plot(rotation)
title('Convert wind speed to rotation')
xlabel('Time [s]')
ylabel('Rotation value [rpm]')