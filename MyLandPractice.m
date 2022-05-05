
function[behav, timing] = MyLandPractice(design, time, setting, ~, ii )
commandwindow;

% num_shifts needs to be a odd integer if you want to include neutral
% bisection
num_shifts = design.shifts;
if ~mod(num_shifts, 2)
    error('last argument (num_shifts) has to be an odd number')
end

% if ~exist('version', 'var')
%     version = '_'; 
%     warning('(?). missing input argument of task version')
% end
%%%%%%%%%%%%%%%%%%
%     if exist('i', 'var') && i > 1
%         clc;
%         prompt = ["Enter block number: "];
%     answer = input(prompt, 's');
%         
%             if ischar(answer)
%             run = answer;
%             else
%             run = str2double(answer);
%             end
% 
%     else
%     prompt = {'Enter block number: '};
    answer = ii;
%     answer{2} = input(prompt{2}, 's');
%     
%             if ischar(answer{2})
%             run = answer{2};
%             else
%             run = str2double(answer{2});
%             end

%     end

%randomize the seed
rand_init = sum(100*clock);
rand('state',rand_init); 

% log_fname = [ sprintf('%sL', answer{1}) version run '_log.txt'];
% mat_fname = [ sprintf('%sL', answer{1}) version run '.mat'];
% tm_fname = [ sprintf('%sL', answer{1}) version run '_timing.txt'];


behav = zeros(0,8); %initializes the behavioral matrix
timing = zeros(0,7);%initializes a time matrix
% ListenChar(2);%keeps the keyboard responses from being entered in your code
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%stimulus parameters
range_percent = design.range_percent;
n_repstim = design.shifts_rep;
num_trials = design.shifts * design.shifts_rep; %needs to be divisible by the number of repetitions of stim asymmetry
a = time.fix_range; % (1); b = timing.fix_range(2); 
fix_dur = (a(2)-a(1)) .*rand(1,1) + a(1); % amount of time (in sec) that the fixation point is on at beginning of trial
stim_dur = time.stim_dur; % amount of time (in sec) that the transected stimulus is on
iti_dur = time.iti_dur; % amount of time (in sec) between offset of transected stimulus and beginning of trial
KbName('UnifyKeyNames')
button_right = KbName('RightArrow');
% button_neutral = KbName('DownArrow');
button_left = KbName('DownArrow'); 
fontSize = setting.fontSize;
res_x = setting.res(1);%resolution of monitor in x direction
res_y = setting.res(2);%resolution of monitor in y direction
sz = setting.sz;
vdist = setting.vdist;

%VisAng calculates the pixels per degree or degrees per pixel.
[ppd dpp] = VisAng([res_x res_y], sz, vdist);

% define range of VA degree length 
range_deg = (design.llength_deg/100) * range_percent; 
% set linearly spaced eccentricities of line endpoints 
shift_deg = linspace(-range_deg, range_deg, num_shifts);
% repeat for n, i.e. how many trials for each eccentricity              
shift_deg = repmat(shift_deg, [n_repstim, 1]);  
shift_deg = shift_deg(:); 
%randomizes using shuf_idx
shuf_idx = randperm(num_trials);
stim_shift_deg = shift_deg(shuf_idx);
stim_shift_pix = round(stim_shift_deg * ppd(1));%we only take ppd 1 because it's the x value, and we
%are only shifting stimuli in the x direction (i.e., horizontally)

fixVA = .39; % as in Benwell
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


%%%%%%%%%%%%%%%%%%%%%%

BLACK_INDEX	= 0;
WHITE_INDEX = 5;
GRAY_INDEX = 10;
clut = zeros(256, 3);
clut(BLACK_INDEX	+ 1, :) = [0 0 0];
clut(WHITE_INDEX	+ 1, :) = [255 255 255];
%clut (GRAY_INDEX    + 1, :) = [128 128 128];
clut (GRAY_INDEX    + 1, :) = [110 110 110];
Bkcolor	= GRAY_INDEX;	% background color

%%%%%%%%%%%%%%%%%
Priority(2);
commandwindow;
[w, rect] = Screen('OpenWindow', 0, Bkcolor, [0 0 res_x res_y]);	% open main screen
gray=GrayIndex(w,0.3);
gray2 = GrayIndex(w);
white=WhiteIndex(w);
Screen(w,'FillRect',gray)
Screen('Flip', w);

% oldclut = Screen('LoadClut', 0, clut);	% Set the CLUT (color look-up table) with the clut that was created up above
HideCursor;	% Hide the mouse cursor
center = [rect(3) rect(4)]/2;	% center of screen (pixel coordinates)
fix_cord = [center(1)-5 center(2)+5];
%%%%%%%%%%%%%%%%%
if str2double(answer) == 1
    txt = 'Quale lato è il più LUNGO?'; 
elseif str2double(answer) == 2
    txt = 'Quale lato è il più CORTO?'; 
else
    error('intructions ill-specified')
end

Screen('TextSize',w, fontSize);
textbound = Screen('TextBounds', w, txt);
txtloc_top = [center(1) - textbound(3)/2, ... % x
    	       center(2) - 400]; % y      
% tell the subject what to do for the rest of this run
display_question(w, white, str2double(answer), txtloc_top, fontSize); 
Screen('DrawLines', w, allCoords, stimThickness, white, center); 
Screen('TextSize',w, fontSize/2);
textBound = Screen('TextBounds', w, '< Posizionati e premi un tasto per iniziare >');
txtloc_Top = [center(1) - textBound(3)/2, ... % x
    	       center(2) - 250]; % y  
Screen(w, 'DrawText', '< Posizionati e premi un tasto per iniziare >', txtloc_Top(1), txtloc_Top(2), white);
Screen('Flip', w);
disp(['TOT NUM OF TRIALS: ' num2str(num_trials)]);

FlushEvents('keyDown');
% % get a list of recognized keyboards
% % [keyboardIndices, productNames, allInfos] = GetKeyboardIndices;
% % choose the external keyboard as the one I want to use
% kbPointer = keyboardIndices(end);
% KbWait(kbPointer);
KbWait;
%%%%%%%%%%%%%

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
    instruct = str2double(answer);    
    while GetSecs < trial_end_time %%start of main while loop for one trial        
    
        % draw fixation cross for 1000ms
            if GetSecs > fix_start_time && GetSecs < fix_end_time && fix_drawn==0
                % actual_fix_start_time = GetSecs;
                Screen('DrawLines', w, allCoords, stimThickness, white, center);	% fixation cross
                actual_fix_start_time = Screen('Flip', w);
                fix_drawn = 1;
            end 
        
            % draw line 
            if GetSecs > stim_start_time && GetSecs < stim_end_time && stim_drawn==0
               % Screen(w,'FillRect',Bkcolor);
                % display_question(w,WHITE_INDEX,instruct,txtloc_top);
                % actual_stim_start_time = GetSecs;
                draw_pnline(w,center, stim_width_pix(t), stim_shift_pix(t), white, stimThickness, stim_bar_height);% draw a pseudoneglect stimulus
                actual_stim_start_time = Screen('Flip', w);
                stim_drawn = 1;
                check_resp = 1;
            end % stimulus
            
            
            if GetSecs > mask_start_time && GetSecs < trial_end_time && mask_drawn==0
                % draw the mask
                % actual_mask_start_time = GetSecs;
                % draw_pnline(w,center,mask_width_pix,0,WHITE_INDEX,maskThickness, mask_bar_height);
                Screen('DrawTexture',w,texture);
                actual_mask_start_time = Screen('Flip', w);
                mask_drawn = 1;
                % wait for keyboard input and hide the mask
            end % mask and ITI
            
%%%%%% *** check reponses *** %%%%%%

                if GetSecs > mask_start_time && check_resp == 1
                    [keyIsDown, actual_response_time, keycode] = KbCheck; %check response
                    
                    if find(keycode(button_right))% pressed the RIGHT button
                        button_press = 1;
                        check_resp=0;
                        % display_question(w,WHITE_INDEX,instruct,txtloc_top)
                        RT = actual_response_time - stim_start_time;
                       
                        if instruct == 1 && stim_shift_pix(t) < 0, correct = 0;%what is longer & stimulus is to the left
                        elseif instruct == 1 && stim_shift_pix(t) > 0, correct = 1;%what is longer & stimulus is to the right
                        elseif instruct == 2 && stim_shift_pix(t) < 0, correct = 1;%what is shorter & stimulus is to the left
                        elseif instruct == 2 && stim_shift_pix(t) > 0, correct = 0;%what is shorter & stimulus is to the right
                        elseif stim_shift_pix(t) == 0, correct = -1; % no shift, no right or wrong answer
                        else
                            error('Unknown condition')
                        end
                        behav(t, :) = [t, instruct, stim_shift_pix(t),stim_shift_deg(t), stim_width_pix(t) ...
						button_press, correct, RT]
                                    
                                    WaitSecs(.25);
                                    break % Exit the while loop when either buttons are pressed 
                                    
                    elseif find(keycode(button_left))% pressed the LEFT button
                        button_press = 2;
                        check_resp=0;
                        % display_question(w,WHITE_INDEX,instruct,txtloc_top)
                        RT = actual_response_time - stim_start_time;
                        
                        if instruct == 1 && stim_shift_pix(t) < 0, correct = 1;%what is longer & stimulus is to the left
                        elseif instruct == 1 && stim_shift_pix(t) > 0, correct = 0;%what is longer & stimulus is to the right
                        elseif instruct == 2 && stim_shift_pix(t) < 0, correct = 0;%what is shorter & stimulus is to the left
                        elseif instruct == 2 && stim_shift_pix(t) > 0, correct = 1;%what is shorter & stimulus is to the right
                        elseif stim_shift_pix(t) == 0, correct = -1; % no shift, no right or wrong answer
                        else
                            error('Unknown condition')
                        end
                        behav(t,:) = [t, instruct, stim_shift_pix(t),stim_shift_deg(t), stim_width_pix(t) ...
						button_press, correct, RT]
                                   
                                    WaitSecs(.25);
                                    break % Exit the while loop when either buttons are pressed
                    end
                end
                           
              
    end % while loop
    

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
                                
                
%     tic            
%     save(log_fname,'behav','-ascii','-tabs');
%     save(tm_fname,'timing','-ascii','-tabs');
%     save(mat_fname, 'behav', 'timing', 't');            
%     toc 
    Screen('Close', texture)
    
end % for loop
    
Screen(w, 'DrawText', '             Training finito! Grazie!', txtloc_Top(1), txtloc_Top(2), white);
Screen('Flip', w);

    WaitSecs(1.5)
%     Screen('LoadCLUT', 0, oldclut);
    ListenChar(0);%sets the keyboard back to taking responses   
    Screen('CloseAll'); 
    ShowCursor; commandwindow;
 clc; disp(['T_Acc: ' num2str( sum(behav(:, 7) == 1) / length(behav(:, 7)))])


