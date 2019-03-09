%% Formant Estimation
% Read clean speech
 [speech,fs]=audioread('cleanspeech.wav');
% Calculate the size of speech data
 s1=size(speech);
% Set frame size (in samples)
 N=256;
% Find no. of frames
 m=s1(1);
 k=fix(m/N);
% Filter parameters for pre-emphasis
 preemph=[1,0.63];

% Initialize vector for storing formants
 form1 = [];
 form2 = [];
% Loop for each frame
% Overlap windows
for i=1:(2*k-1)
 % Find indices of next frame
 n =(1:N)+(N*(i-1)/2);
 % Extract speech from current frame indices
 x1=speech(n);
 % Use Hamming window
 x=hamming(N).*x1;
 % Perform pre-emphasis filtering
 x=filter(1,preemph,x);
 % Compute FFT
 X=fft(x);
 % LPC Analysis
 [a,e]=lpc(x,10);
 % Plot formant structure
 Xlpc=freqz(1,a);
 % Determines roots of formant structure
 rr=roots(a);
 % Convert roots to radians
 norm_freq=angle(rr);
 % Convert roots to Hz
 freq_Hz=(norm_freq*fs)/(2*pi);

 % Find all formants
 forms = freq_Hz(freq_Hz>0);
 % Extract the first formant
 f1_current = min(forms);
 % Extract second formant
 f2_current = min(forms(forms~=f1_current));
 % Concatenate formant vectors
 form1 = [form1,f1_current];
 form2 = [form2,f2_current];

 pause

 subplot(2,2,1);plot(20*log10(abs(X(1:N/2)))) % FFT plot
 subplot(2,2,2);plot(20*log10(abs(Xlpc))) % LPC Plot
 subplot(2,2,3);plot(x); % time-domain Plot
 subplot(2,2,4);zplane(1,a); % pole-zero Plot

 pause
end
