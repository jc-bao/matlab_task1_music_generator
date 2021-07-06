clear all; close all; clc;
load data/Guitar.MAT;

% resample
fs_0 = 8000;
fs_re = fs_0 * 10;
wave_re = resample(realwave, fs_re, fs_0);
len = length(wave_re); 

% get period from auto correlation function
ac = autocorr(wave_re, len - 1);
[pks, locs] = findpeaks(ac);
[maxval, pos] = max(pks);
T = locs(pos) -1;

% get mean of a period
n_T = floor(len/T);
wave_re = wave_re(1:n_T*T);
wave_re = reshape(wave_re, [T, n_T]);
wave_re = mean(wave_re');

% replicate to full length & resample
wave_re = repmat(wave_re, 1, n_T)';
wave_new = resample(wave_re, fs_0, fs_re);

% plot
t = (1:10:n_T*T)/fs_0;
plot(t, wave_new);
ylabel('wave2proc\_m');
title("standard signal");