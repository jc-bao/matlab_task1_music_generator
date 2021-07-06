function freq = get_freq(note)
    freq = 440. * (2 ^ ((note - 69) / 12.));
end