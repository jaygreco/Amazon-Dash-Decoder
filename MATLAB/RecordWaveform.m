%% RecordWaveform.m
% Records one second of audio data coming from the Amazon Dash button.
% It then parses for the audio peaks and decodes the transmitted data.
% The final output is contained in DataTable.
clear all
close all

%for testing, load an example waveform. Saves time.
load('test_data.mat');

% %record 1 second of hi-res audio (96kSas)
% recorder1 = audiorecorder(96000,24,1,1);
% recordblocking(recorder1, 1);
% y = getaudiodata(recorder1);
% 
% % normalize y first, since the input can be rather quiet.
% M = max(y);
% y = y*(1/M);
% plot(y)
% 
% %take the bounds to trim
% cut1 = input('Enter the lower bound...');
% cut2 = input('Enter the upper bound...');

% y1 = y(cut1:cut2);

%use a low-pass filter to remove noise.
f_y = lpf(y1);
f_y = lpf(f_y);
y1 = y1-f_y;

%this is a simple envelope detector. It de-modulates the audio
%sent by the iOS app into the raw peaks. It's using a hilbert xform,
%a commmon digital demodulation tool.
envelope = abs(hilbert(y1));
smoothData = smooth(envelope, 77, 'sgolay');
smoothData = lpf(smoothData);

%normalize to 1 once more for consistent peak detection results.
M = max(smoothData);
smoothData = smoothData*(1/M);

plot(smoothData)
hold on

%split the peaks based on their thresholds. This is finnicky at best
%but I'm lazy and it works well enough. 
%Peaks above 0.6
[~,locs_4] = findpeaks(smoothData,'MinPeakHeight',0.6,...
                                    'MinPeakDistance',300);
plot(locs_4,smoothData(locs_4),'rv','MarkerFaceColor','r');
[~,locs_temp] = findpeaks(smoothData,'MinPeakDistance',300);

% Peaks between 0.25 and 0.5
locs_3 = locs_temp(smoothData(locs_temp)>0.4 & smoothData(locs_temp)<0.6);
plot(locs_3,smoothData(locs_3),'rs','MarkerFaceColor','g');

[~,locs_temp] = findpeaks(smoothData,'MinPeakDistance',300);

% Peaks between 0.125 and 0.25
locs_2 = locs_temp(smoothData(locs_temp)>0.2 & smoothData(locs_temp)<0.35);
plot(locs_2,smoothData(locs_2),'rs','MarkerFaceColor','b');

[~,locs_temp] = findpeaks(smoothData,'MinPeakDistance',300);

% Peaks less than 0.125
locs_1 = locs_temp(smoothData(locs_temp)>0.05 & smoothData(locs_temp)<0.2);
plot(locs_1,smoothData(locs_1),'rv','MarkerFaceColor','y');

%give each peak index a peak label
locs_4(1:length(locs_4),2) = 4;
locs_3(1:length(locs_3),2) = 3;
locs_2(1:length(locs_2),2) = 2;
locs_1(1:length(locs_1),2) = 1;

%make a master peaks array and sort it by time
peaks = horzcat(locs_4', locs_3', locs_2', locs_1');
peaks = sortrows(peaks.',1).' ;

%parse the audio data beginning at peak 11, since 1-10 belong to the
%calibration sequence. The next 4 peaks define how long the remaining
%data is. THIS MIGHT NOT ALWAYS WORK! 
[dec,hex,ascii]=LevelsToHex(peaks(2,11:14));
dataLength = dec*4;

%use the remaining data length to parse the actual bitstream
%append 2 of 0xF to keep the data aligned with what we're used to.
rawData = reshape(peaks(2,11:(dataLength + 10)),4,[])';
rawData = vertcat([0,0,0,0;0,0,0,0], rawData);

%boom. pwned.
DataTable = Decoder(rawData);
writetable(DataTable, 'Dash_Decoded.csv');