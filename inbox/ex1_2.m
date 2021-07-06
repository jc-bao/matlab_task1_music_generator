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
t_start = to_seconds(starts ,bpm, ticks_per_quarter);
t_end = to_seconds(ends ,bpm, ticks_per_quarter);

t = linspace(0, song_time, song_time * sample_rate);
tt = repmat(t,size(t_start,2) ,1);
t_rise = (0.85*t_start+0.15*t_end);
t_down = (0.7*t_start+0.3*t_end);
t_keep = (0.7*t_start+0.3*t_end);
envelope = (t-t_sta

vmrt)./(t_rise-t_start).*(t>=t_start').*(t<=t_rise') + ...
    ((-0.5).*(t-t_rise)./(t_down-t_rise)+1).*(t>=t_rise').*(t<=t_down') + ...
    0.5.*(t>=t_down').*(t<=t_keep') + ...
    ((-0.5).*(t-t_keep)./(t_end-t_keep)+0.5).*(t>=t_keep').*(t<=t_end');
song = volumes * (sin(2.*pi.*(freqs'*t)).* (t>=t_start').*(t<=t_end'));

sound(song, sample_rate);
audiowrite('Lemon.wav', song, sample_rate);

plot(t, song);
ylim([-1, 1]);
xlabel('time / s');  ylabel('amplitude');
title('Sound Wave of music\_1');


