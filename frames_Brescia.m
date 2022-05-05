function [actual_frames, actual_seconds, nominal_frames, nominal_seconds] = frames_Brescia(secs, ifi)

% first output = numer of frames output already shortened by a 0.5*frames to insert into
% the (Screen('Flip'), VBL)  as waiting

% second output = true seconds to wait for the next flip to happen



% rounds the indicated time to an exact number of frames
nominal_frames = round(secs/ifi);

% subtract half frames in order not to risk an overshoot (longer duration than required)
actual_frames =  nominal_frames - 0.5; 

% true waiting
actual_seconds = actual_frames*ifi;


nominal_seconds = secs;


end