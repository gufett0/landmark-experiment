# Landmark task


The following is a Matlab/Octave program of a classic behavioural task that I made for a research project about visuospatial bias in human subjects.
This was utilized in a pilot experiment conducted during summer 2021 at this [lab](http://www.cognitiveneuroscience.it/?lang=en) in Brescia, Italy.

**This work helped me improve my coding and debugging skills for high efficiency and milliseconds timing precision.**  

  ## Brief background notes
The aim of this task is to evaluate the degree of bias while making a judgment on the length of two segments in a line bisected at different shift points. The following is a graphical representation of the task sequence in one trial: the lines will stay on screen for a brief moment after which participants will give a response within a limited interval. 

![taskprocedure](https://user-images.githubusercontent.com/104091627/164989059-44f4b481-d0e3-48aa-b3ee-d0be6ecd4912.png)

Before starting the task, participants will be instructed like this: *"Welcome! Depending on the instruction that will appear on screen, you'll have to indicate which side of the line, compared to the center, is either shorter or longer. Use the right or left keys accordingly to give your response"*

Correct responses will be collected for each bisection shift and a point of subjective equality ([PSE](https://dictionary.apa.org/point-of-subjective-equality)) will be computed to quantify the tendency in making biased perceptual judgement either to the left (negative values) or to the right (positive values). 
Below is an example of data collected from a subject with a leftward bias:

![testsubj](https://user-images.githubusercontent.com/104091627/165067906-afe0ce7d-abbb-4971-ad0e-4e8cce617244.png)


## Requirements
  Matlab 2019b/Octave GNU and Psychophysics Toolbox Version 3 (PTB-3) (instruction for download [here](http://psychtoolbox.org/download.html))

  #### Customized functions:
  [VisAng.m](https://github.com/gufett0/landmark-experiment/blob/main/VisAng.m) to calculate the pixels per degree or degrees per pixel
  
  [frames_Brescia.m](https://github.com/gufett0/landmark-experiment/blob/main/frames_Brescia.m) to optimize stimuli presentation timing 
  
  [display_question.m](https://github.com/gufett0/landmark-experiment/blob/main/display_question.m) to print instructions on screen
  
  [draw_pnline.m](https://github.com/gufett0/landmark-experiment/blob/main/draw_pnline.m) to draw the horizontal bisected line

## How to run the program

Open the LandmarkTask.m file in the editor.
If you haven't already set the current Matlab search path do so by typing in the command window
```
addpath 'C:\Users\AddYourOwnPath'; 
```
This is also where the three output files will be saved (.mat, _log.txt, _timing.txt), unless you specify otherwise.

If you want to modify the parameters of the task you can change any field of these structure variables (check comments in the code to learn about these):

```
Design = struct('llength_deg', 20, 'shifts', [], 'range_percent', [], 'shifts_rep', []);
Setting = struct( 'res', [1920 1080], 'sz', [51 28.8], 'vdist', 56, 'fontSize', 38); 
Timing = struct('stim_dur', 0.15, 'iti_dur', 2, 'fix_range', [2 2.5]);
```

Now run the file. The command window will ask you which instruciton order you want to start with: "Which side is longer" and then "Which side is shorter" (option 12) or viceversa (option 21)

```
Instruction code  (12 | 21) :
```

Now you are ready to get familiar with the task. Follow the instruction

```
Lets do some PRACTICE!
(press enter to start)
```
If you haven't installed Psychtoolbox the program will stop at this point.
The pracrice task will call the MyLandPractice.m function, virtually identical to the following main task function MyLandmark.m, except for some design parameters. 

Once MyLandmark.m gets called the command window will ask you to provide a name for the output files
```
Enter Subject id: 
```
If the file name already exists it'll output a warning and ask you to overwrite.
The whole task sequence is set to run for two blocks so as to cover both instructions.






