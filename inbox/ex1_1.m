clear all, close all, clc;

T=readtable('./python/scores/Lemon.csv');
pitches=table2array(T(1:end-1,1))';
velocities=table2array(T(1:end-1,2))';
starts=table2array(T(1:end-1,3))'; 
ends=table2array(T(1:end-1,4))';
ticks_per_quarter = table2array(T(end,1));
bpm = table2array(T(end,2));

sample_rate = 22050;
volumes = 0.5/max(velocities)*velocities;
freqs = 440. * (2 .^ ((pitches - 69) / 12.));
song_time = to_seconds(ends(end),bpm, ticks_per_quarter);
starts_time = to_seconds(starts ,bpm, ticks_per_quarter);
ends_time = to_seconds(ends ,bpm, ticks_per_quarter);

t = linspace(0, song_time, song_time * sample_rate);
song = volumes * (sin(2.*pi.*(freqs'*t)).* (t>=starts_time').*(t<=ends_time'));

sound(song, sample_rate);
audiowrite('Lemon.wav', song, sample_rate);

plot(t, song);
ylim([-1, 1]);
xlabel('time / s');  ylabel('amplitude');
title('Sound Wave of music\_1');


