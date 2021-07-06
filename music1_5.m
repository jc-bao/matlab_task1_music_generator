clear all, close all,  clc;

name = 'liszt';
T=readtable(['./python/scores/',name,'.csv']);
num_note = size(T,1)-1;
ticks_per_quarter = table2array(T(end,1));
bpm = table2array(T(end,2));
batchsize = 10; % mini batch size, to parallelly deal with 50 notes
sample_rate = 16000; % sample rate
song_time = tick2second(table2array(T(end-1, 4)), bpm, ticks_per_quarter);
song = zeros(1, floor(song_time*sample_rate)+1);
for i = 0 : (num_note/batchsize)
    disp(['batch: ',num2str(i)]) ;
    % start-end point
    head = i * batchsize + 1;
    tail = min((i + 1) * batchsize, num_note);
    % parameters to gernerate music
    pitches=table2array(T(head:tail,1))';
    velocities=table2array(T(head:tail,2))';
    starts=table2array(T(head:tail,3))';
    ends=table2array(T(head:tail,4))';
    index_start=tick2index(starts(1), bpm, ticks_per_quarter, sample_rate);
    index_end=tick2index(ends(end), bpm, ticks_per_quarter, sample_rate);
    % generate all notes at a time and add to song
    freqs = pitch2freq(pitches);
    volumes = (0.15/max(velocities))*velocities;
    index_starts = tick2index(starts, bpm, ticks_per_quarter, sample_rate)-index_start;
    index_ends = tick2index(ends, bpm, ticks_per_quarter, sample_rate)-index_start;
    index = 1:(index_ends(end)-index_starts(1)+1);
    wave = volumes * (( ...
        sin(2.*pi.*(freqs'* index./sample_rate)) + ...
        0.2 * sin(2 * 2.*pi.*(freqs'* index./sample_rate)) + ...
        0.3 * sin(3 * 2.*pi.*(freqs'* index./sample_rate))) ... 
        .* exp_envelope(index, index_starts, index_ends, 0.1));
    song(index_start:index_end)=song(index_start:index_end)+wave;
end

audiowrite(['music/',name,'5.wav'], song, sample_rate);
sound(song, sample_rate);

plot(song);
ylim([-1, 1]);
xlabel('time / s');  ylabel('amplitude');
title([name, "波形图"]);


function freq = pitch2freq(note)
    freq = 440. * (2 .^ ((note - 69) / 12.));
end

function seconds=tick2second(tick, bpm, ticks_per_quarter)
    seconds=((tick .* 60) ./ (bpm .* ticks_per_quarter));
end

function index=tick2index(tick, bpm, ticks_per_quarter, sample_rate)
    index=floor(tick2second(tick, bpm, ticks_per_quarter)*sample_rate)+1;
end

function envelope=exp_envelope(index, index_starts, index_ends, k)
    duration = index_ends - index_starts;
    index_mids = index_starts * (1-k) + index_ends * k;
    envelope=(1/(1-exp(-2))).*(1-exp(-2/k*((index-index_starts')./duration'))).* (index>=index_starts').*(index<=index_mids')...
        +exp((-2/(1-k)*(index-index_mids')./duration')).* (index>=index_mids').*(index<=index_ends');
end