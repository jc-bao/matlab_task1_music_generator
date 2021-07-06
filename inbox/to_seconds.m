function seconds=to_seconds(tick, bpm, ticks_per_quarter)
    seconds=((tick .* 60) ./ (bpm .* ticks_per_quarter));
end