% Takes input as an arbitrary string of hex numbers (even length) and
% returns an M-ary binary representation with the given amplitude and
% bit level. This is inverted on the dash, so 00 = level 4, 11 = level 1.
close all;
clear all;

InputChar = '*'; %single char input
%I'm stuck using this because of my version of MATLAB/toolbox selection.
Input = dec2hex(uint8(InputChar));

BitTime = 4; % Bit time, in ms
%Input = '0A'; %the input hex, not beginning with '0x'.

%break up each hex no. into a set of 2 bits 
binRep = dec2bin(hex2dec(Input), 4*length(Input));

%break into ASK level representation and create levelsRep[].
for x=1:length(binRep)
   if mod(x,2) == 0 %number is even, so skip this iteration
       continue
   end
   
   if binRep(x) == '0' && binRep(x+1) == '0' %00 --> level 4
       LevelsRep((x+1)/2) = 4;
   elseif binRep(x) == '0' && binRep(x+1) == '1' %01 --> level 3
       LevelsRep((x+1)/2) = 3;
   elseif binRep(x) == '1' && binRep(x+1) == '0' %10 --> level 2
       LevelsRep((x+1)/2) = 2;
   else %11 --> level 1
       LevelsRep((x+1)/2) = 1;
   end
end

LevelsRep = fliplr(LevelsRep); %to deal with the backward endian-ness.

t = 0:0.01:BitTime;
y = cos(pi/(BitTime/2)*t - pi) + 1;

%Make an empty output array
X = [];

%create the psuedo-ASK representation
for x=1:length(LevelsRep)
    out = LevelsRep(x).*y;
    X = horzcat(X,out);
end
%show what the ASK should look like
plot(X, 'r')
titleStr = strcat('Psuedo ASK Representation of ', ' "', InputChar, '" ');
title(titleStr);
ylabel('Amplitude');
xlabel('Time in uS');