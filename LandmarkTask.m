% Set task parameters
r_percent = 2.8;  % i.e, ±0.56° range. If 17 shift locations, then it's ±0.07° (±.35%) increments   
% r_percent = 3.85;  % i.e, ±0.77° range. If 23 shift locations, then it's ±0.07° (±.35%) increments    

Shifts = 17; % number of shift points including zero (without considering catch trials)
Shifts_rep = 8; % number of trials per shift point (must be even number)
% Create input variable for the landmark task function
Design = struct('llength_deg', 20, 'shifts', [], 'range_percent', [], 'shifts_rep', []);
Setting = struct( 'res', [1920 1080], 'sz', [51 28.8], 'vdist', 56, 'fontSize', 38); 
Timing = struct('stim_dur', 0.15, 'iti_dur', 2, 'fix_range', [2 2.5]);

instr = input('Instruction code  (12 | 21) : ', 's');

% Loop through blocks 
% instr 1: what is longer; instr 2: what is shorter
for i = 1:2
    
in = instr(i);
% run PRACTICE before block
clc; disp('Lets do some PRACTICE!') ; input('(press enter to start)');
Design.range_percent = 4.6; Design.shifts = 5; Design.shifts_rep = 2;
[~, ~] = MyLandPractice(Design, Timing, Setting, [], in);    

% run TASK
disp(['Block ' num2str(i) ' |  Instruction ' in])
Design.range_percent = r_percent;
Design.shifts = Shifts;
Design.shifts_rep = Shifts_rep;
basedir     = 'C:\Users\neuro\Desktop\ccPAS\LandmarkTask\Outputs'; cd(basedir); % labEEG2

[log(:,:,i), tmg] = MyLandmark(Design, Timing, Setting, [], in); 
end


