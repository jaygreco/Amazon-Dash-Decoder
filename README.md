# Amazon-Dash-Decoder
A MATLAB implementation for decoding of configuration packets for the iOS Amazon Dash Button setup. 
To use, start with RecordWaveform.m. You can either live record audio if you've got a good microphone, or load up the sample data located in test_data.mat. You'll probably need to change your input device (see the audiorecorder help on how to do so) and possibly tweak the detection levels for each level of peaks. The final output ouf a successful run will be contained in Dash_Decoded.csv.
