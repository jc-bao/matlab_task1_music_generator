clear all; close all; clc;
load data/guitar.mat;

% calculate orignal signal FFT
fs = 8000;
len_1 = length(realwave);
FFT_1 = fftshift(abs(fft(realwave)));
freq_1 = linspace(-fs / 2, fs / 2 - fs / len_1, len_1);
freq_1p = freq_1(freq_1 >= 0);
FFT_1p = FFT_1(freq_1 >= 0) / max(FFT_1);
% get peaks
[pks_1, locs_1] = findpeaks(FFT_1p, 'MinPeakProminence', 0.02);
freq_1pks = freq_1p(locs_1);
% plot1
subplot(1, 2, 1);
plot(freq_1p, FFT_1p);
hold on;
plot(freq_1pks, pks_1, 'ro');
text(freq_1pks' - 200, pks_1 + 0.025, num2str(roundn(freq_1pks, -2)'));
ylim([0, 1.05]);
xlabel('Frequency (Hz)');
ylabel('Relative Amplitude');
title('orignal FFT');

% calculate orignal signal FFT
fs = 8000;
extwave = repmat(realwave, 2000, 1);
len_2 = length(extwave);
FFT_2 = fftshift(abs(fft(extwave)));
freq_2 = linspace(-fs / 2, fs / 2 - fs / len_2, len_2);
freq_2p = freq_2(freq_2 >= 0);
FFT_2p = FFT_2(freq_2 >= 0) / max(FFT_2);
% get peaks
[pks_2, locs_2] = findpeaks(FFT_2p, 'MinPeakProminence', 0.02);
freq_2pks = freq_2p(locs_2);
% compare with base frequency
note_2pks = 12 .* log2(freq_2pks./440) + 69;
base_2pks = 440.*(2.^((round(note_2pks) - 69)./12.));
err = 0.02;
index_2pks = abs(freq_2pks-base_2pks)<(err*freq_2pks);
note_2pks = note_2pks(index_2pks);
freq_2pks = freq_2pks(index_2pks);
pks_2 = pks_2(index_2pks);
% find base frequency
index_base = find(pks_2 > (max(pks_2)*0.5), 1);
freq_base = freq_2pks(index_base);
% get other frequency
index_2pks = abs(freq_2pks/freq_base-round(freq_2pks/freq_base))<err;
freq_2pks = freq_2pks(index_2pks);
pks_2 = pks_2(index_2pks);
% plot2
subplot(1, 2, 2);
plot(freq_2p, FFT_2p);
hold on;
plot(freq_2pks, pks_2, 'ro');
text(freq_2pks' - 200, pks_2 + 0.025, num2str(roundn(freq_2pks, -2)'));
ylim([0, 1.05]);
xlabel('Frequency (Hz)');
ylabel('Relative Amplitude');
title('Extend Signal FFT');




