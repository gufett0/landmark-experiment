
function[behav, timing] = MyLandmark(design, time, setting, version, ii)
commandwindow;

% num_shifts needs to be a odd integer if you want to include an equal bisection
num_shifts = design.shifts;
if ~mod(num_shifts, 2)
    error('last argument (num_shifts) has to be an odd number')
end

if ~exist('version', 'var')
    version = '_'; 
    warning('(?). missing input argument of task version')
end

    prompt = {'Enter Subject id: ', ''}; % ,'Enter block number: '};
    answer{1} = input(prompt{1}, 's');
    answer{2} = ii;
    
            if ischar(answer{2})
            run = answer{2};
            else
            run = str2double(answer{2});
            end


%randomize the seed
rand_init = sum(100*clock);
rand('state',rand_init); 
% set up names of outputs to be saved
log_fname = [ sprintf('%sL', answer{1}) version run '_log.txt'];
mat_fname = [ sprintf('%sL', answer{1}) version run '.mat'];
tm_fname = [ sprintf('%sL', answer{1}) version run '_timing.txt'];

if exist(mat_fname, 'file') == 2 || exist(log_fname, 'file') == 2 || exist(tm_fname, 'file') == 2

    warning('File name already existent in the current directory.');
    warning('Do you want to overwrite it?');
    inp = input('Press Y | N : ', 's');
    if strcmp(inp, 'N')
        
        error('Ok, code interrupted. Re-start with a correct subject ID')
    else
        warning('Ok. Saved files will be overwritten...');
    end
end

behav = zeros(0,8); %initializes the behavioral matrix
timing = zeros(0,7);%initializes a time matrix

%% Set stimulus and trial parameters
range_percent = design.range_percent;
n_repstim = design.shifts_rep;
num_trials = design.shifts * design.shifts_rep; %needs to be divisible by the number of repetitions of stim asymmetry
a = time.fix_range; % (1); b = timing.fix_range(2); 
fix_dur = (a(2)-a(1)) .*rand(1,1) + a(1); % amount of time (in sec) that the fixation point is on at beginning of trial
stim_dur = time.stim_dur; % amount of time (in sec) that the transected stimulus is on
iti_dur = time.iti_dur; % amount of time (in sec) between offset of transected stimulus and beginning of trial
KbName('UnifyKeyNames')
button_right = KbName('RightArrow');
button_left = KbName('DownArrow'); % adjacent left and right buttons
fontSize = setting.fontSize;
res_x = setting.res(1);%resolution of monitor in x direction
res_y = setting.res(2);%resolution of monitor in y direction
sz = setting.sz;
vdist = setting.vdist;

%VisAng calculates the pixels per degree or degrees per pixel.
[ppd dpp] = VisAng([res_x res_y], sz, vdist);
% define range of VA degree length 
range_deg = (design.llength_deg/100) * range_percent; 
% define shift increments
increment_deg = range_deg/n_repstim;
% set linearly spaced eccentricities of line endpoints 
shift_deg = linspace(-range_deg, range_deg, num_shifts) ;
% set trials with doubled increment shifts. these will not be counted in the curve fitting
catch_trials = [shift_deg(end) + (increment_deg*2) shift_deg(1) - (increment_deg*2)] ;
shift_deg = [shift_deg catch_trials];
% repeat for n, i.e. how many trials for each eccentricity              
shift_deg = repmat(shift_deg, [n_repstim, 1]);  
shift_deg = shift_deg(:); 
% increase num of trials by adding catch trials
num_trials = num_trials + numel(catch_trials)*n_repstim; 
%randomizes using shuf_idx
shuf_idx = randperm(num_trials);
stim_shift_deg = shift_deg(shuf_idx);
stim_shift_pix = round(stim_shift_deg * ppd(1));%we only take ppd 1 because it's the x value, and we
%are only shifting stimuli in the x direction (i.e., horizontally)

fixVA = .39; 
fixCrossDimPixH = fixVA * ppd(1); % size of the hor arms of our fixation cross
fixCrossDimPixV = fixVA * ppd(2); % size of the vert arms of our fixation cross
% Now we set the coordinates (these are all relative to zero)
mx = [-fixCrossDimPixH fixCrossDimPixV 0 0];
my = [0 0 -fixCrossDimPixH fixCrossDimPixV];
allCoords = [mx; my];

% define only one line overall length
stim_width_deg = ones(1, num_trials) * design.llength_deg; 
stim_width_pix = round(stim_width_deg * ppd(1));
% set pther parameters
stim_bar_height = fixVA*ppd(2);%height of the transecting bar 
stimThickness = round(0.14*ppd(2)); % pen thickness of the transected stimulus line


GRAY_INDEX = 10;
Bkcolor	= GRAY_INDEX;	% background color

%%%%%%%%%%%%%%%%%
Priority(2);
commandwindow;
[w, rect] = Screen('OpenWindow', 0, Bkcolor, [0 0 res_x res_y]);	% open main screen
% [w, rect] = Screen('OpenWindow', 0, [], [0 0 750 400]);	% open test screen

gray=GrayIndex(w,0.3);
gray2 = GrayIndex(w);
white=WhiteIndex(w);
Screen(w,'FillRect',gray)
Screen('Flip', w);
% FR = Screen(w,'FrameRate')
ifi = Screen('GetFlipInterval', w);
HideCursor;	% Hide the mouse cursor
center = [rect(3) rect(4)]/2;	% center of screen (pixel coordinates)
%%%%%%%%%%%%%%%%%
if str2double(answer{2}) == 1
    txt = 'Which side is LONGER?'; 
elseif str2double(answer{2}) == 2
    txt = 'Which side is SHORTER?'; 
else
    error('intructions ill-specified')
end

Screen('TextSize',w, fontSize);
textbound = Screen('TextBounds', w, txt);
txtloc_top = [center(1) - textbound(3)/2, ... % x
    	       center(2) - 400]; % y      
% tell the subject what to do for the rest of this run
display_question(w, white, str2double(answer{2}), txtloc_top, fontSize); 
Screen('DrawLines', w, allCoords, stimThickness, white, center); 
Screen('TextSize',w, fontSize/2);
textBound = Screen('TextBounds', w, '< Get ready and press any key to start >');
txtloc_Top = [center(1) - textBound(3)/2, ... % x
    	       center(2) - 250]; % y  
Screen(w, 'DrawText', '< Get ready and press any key to start >', txtloc_Top(1), txtloc_Top(2), white);
Screen('Flip', w);
disp(['TOT NUM OF TRIALS: ' num2str(num_trials)]);

FlushEvents('keyDown');
KbWait;

%% Optimize presentation timing with custom function frames_Brescia
[~, press_start_time, ~] = KbCheck; %check response
[ ~, actual_sec(1), ~, ~] = frames_Brescia(0, ifi);
[ ~, actual_sec(2), ~, ~] = frames_Brescia(fix_dur, ifi);
[ ~, actual_sec(3), ~, ~] = frames_Brescia(stim_dur, ifi);

%% Start trial sequence 
for t = 1:num_trials    
% 	disp(['Trial num: ' num2str(t)])
    trial_start_time = GetSecs;

	fix_drawn = 0;
	fix_start_time = trial_start_time;
	fix_end_time   = fix_start_time + fix_dur;
    
    stim_drawn = 0;
	stim_start_time = fix_end_time;
	stim_end_time   = stim_start_time + stim_dur;

    mask_drawn = 0;
	mask_start_time = stim_end_time;
	trial_end_time = trial_start_time + fix_dur + stim_dur + iti_dur;  
    %create full Screen of random noise for the mask (>= .5 causes 1's and 0's)
	mask_mat = (rand(rect(4), rect(3)) >= .50) * gray2;
    texture = Screen('MakeTexture',w, mask_mat);
    instruct = str2double(answer{2});  
    
    while GetSecs < trial_end_time %%start of main while loop for one trial        
    
        % draw fixation cross for 1000ms
              if GetSecs > fix_start_time && GetSecs < fix_end_time && fix_drawn==0
                %actual_fix_start_time = GetSecs;
                Screen('DrawLines', w, allCoords, stimThickness, white, center);	% fixation cross
                actual_fix_start_time = Screen('Flip', w, press_start_time + actual_sec(1));
                fix_drawn = 1;
              end 
        
            % draw line 
              if GetSecs > stim_start_time && GetSecs < stim_end_time && stim_drawn==0
             
                draw_pnline(w,center, stim_width_pix(t), stim_shift_pix(t), white, stimThickness, stim_bar_height);% draw a pseudoneglect stimulus
                actual_stim_start_time = Screen('Flip', w, actual_fix_start_time + actual_sec(2));
                stim_drawn = 1;
                check_resp = 1;
              end % stimulus            
            
              if GetSecs > mask_start_time && GetSecs < trial_end_time && mask_drawn==0
            
                Screen('DrawTexture',w,texture);
                actual_mask_start_time = Screen('Flip', w, actual_stim_start_time + actual_sec(3));
                mask_drawn = 1;
                % wait for keyboard input and hide the mask
              end % mask and ITI

     
%%%%%% *** check reponses *** %%%%%%

                  if GetSecs > mask_start_time && check_resp == 1
                    [~, actual_response_time, keycode] = KbCheck; %check response
                    
                    if find(keycode(button_right))% pressed the RIGHT button
                        button_press = 1;
                        check_resp=0;
                        % display_question(w,WHITE_INDEX,instruct,txtloc_top)
                        RT = actual_response_time - actual_stim_start_time;
                    
                        if instruct == 1 && stim_shift_pix(t) < 0, correct = 0;%what is longer & stimulus is to the left
                        elseif instruct == 1 && stim_shift_pix(t) > 0, correct = 1;%what is longer & stimulus is to the right
                        elseif instruct == 2 && stim_shift_pix(t) < 0, correct = 1;%what is shorter & stimulus is to the left
                        elseif instruct == 2 && stim_shift_pix(t) > 0, correct = 0;%what is shorter & stimulus is to the right
                        elseif stim_shift_pix(t) == 0, correct = -1; % no shift, no right or wrong answer
                        else
                            error('Unknown condition')
                        end
                        behav(t, :) = [t, instruct, stim_shift_pix(t),stim_shift_deg(t), stim_width_pix(t) ...
						button_press, correct, RT];
                                    
                                    WaitSecs(.25);
                                    break % Exit the while loop when either buttons are pressed 
                                    
                    elseif find(keycode(button_left))% pressed the LEFT button
                        button_press = 2;
                        check_resp=0;
                        % display_question(w,WHITE_INDEX,instruct,txtloc_top)
                        RT = actual_response_time - actual_stim_start_time;
                        
                        if instruct == 1 && stim_shift_pix(t) < 0, correct = 1;%what is longer & stimulus is to the left
                        elseif instruct == 1 && stim_shift_pix(t) > 0, correct = 0;%what is longer & stimulus is to the right
                        elseif instruct == 2 && stim_shift_pix(t) < 0, correct = 0;%what is shorter & stimulus is to the left
                        elseif instruct == 2 && stim_shift_pix(t) > 0, correct = 1;%what is shorter & stimulus is to the right
                        elseif stim_shift_pix(t) == 0, correct = -1; % no shift, no right or wrong answer
                        else
                            error('Unknown condition')
                        end
                        behav(t,:) = [t, instruct, stim_shift_pix(t),stim_shift_deg(t), stim_width_pix(t) ...
						button_press, correct, RT];
                                   
                                    WaitSecs(.25);
                                    break % Exit the while loop when either buttons are pressed
                    end
                  end
                           
              
    end % of while loop
    

                    actual_trial_end_time = GetSecs;
                if check_resp == 1 % it means no button was pressed
                    button_press = -1;
                    correct = 0; % count no-press as wrong
                    RT = -1; %count reaction time as negative
                    actual_response_time = -1;
                    behav(t, :) = [t, instruct, stim_shift_pix(t), stim_shift_deg(t), stim_width_pix(t) ...
                        button_press, correct, RT];
                end
                
                timing(t,:) = [t, trial_start_time, actual_fix_start_time, ...
                    actual_stim_start_time, actual_mask_start_time, actual_response_time, ...
                    actual_trial_end_time];
                                
                
    tic            
    save(log_fname,'behav','-ascii','-tabs');
    save(tm_fname,'timing','-ascii','-tabs');
    save(mat_fname, 'behav', 'timing', 't');            
    toc 
    Screen('Close', texture)
    
end % for loop
    
Screen(w, 'DrawText', '                       This block is completed! Thanks!', txtloc_Top(1), txtloc_Top(2), white);
Screen('Flip', w);

    
    WaitSecs(2.5)
%     Screen('LoadCLUT', 0, oldclut);
    ListenChar(0);%sets the keyboard back to taking responses   
    Screen('CloseAll'); 
    ShowCursor; commandwindow;

clc; disp(['Block ' num2str(run) ' completed!']);
%      disp(['Block Accuracy: ' num2str( sum(behav(:, 7) == 1) / length(behav(:, 7)))]);

