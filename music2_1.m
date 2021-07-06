clear all; close all; clc;
[song, sample_rate] = audioread("data/fmt.wav");
sound(song, sample_rate);
plot((1:length(song)) / sample_rate, song);
xlim([0, length(song) / sample_rate]);
xlabel('time / s');  ylabel('amplitude');
title('Sound Wave of fmt.wav');