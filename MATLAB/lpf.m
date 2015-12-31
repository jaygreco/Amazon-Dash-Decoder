function y = lpf(x)
%LPF Filters input x and returns output y.

persistent Hd;

if isempty(Hd)
    
    Fpass = 9000;   % Passband Frequency
    Fstop = 12000;  % Stopband Frequency
    Apass = 1;      % Passband Ripple (dB)
    Astop = 60;     % Stopband Attenuation (dB)
    Fs    = 96000;  % Sampling Frequency
    
    h = fdesign.lowpass('fp,fst,ap,ast', Fpass, Fstop, Apass, Astop, Fs);
    
    Hd = design(h, 'equiripple', ...
        'MinOrder', 'any', ...
        'StopbandShape', 'flat');
    
    
    
    set(Hd,'PersistentMemory',true);
    
end

y = filter(Hd,x);


