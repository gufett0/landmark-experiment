# Landmark task


The following is a Matlab/Octave program of a classic behavioural task that I made for a research project about visuospatial bias in human subjects.
This was utilized in a pilot experiment conducted during summer 2021 at this [lab](http://www.cognitiveneuroscience.it/?lang=en) in Brescia, Italy.


### Brief background notes
The aim of this task is to evaluate the degree of bias while making a judgment on the length of two segments in a line bisected at different shift points. The following is a graphical representation of the task sequence in one trial: the lines will stay on screen for a brief moment after which participants will give a response within 2 seconds. 

![taskprocedure](https://user-images.githubusercontent.com/104091627/164989059-44f4b481-d0e3-48aa-b3ee-d0be6ecd4912.png)

During task completion, correct responses will be collected for each shift point of line bisection and a point of subjective equality ([PSE](https://dictionary.apa.org/point-of-subjective-equality)) will be computed to quantify the tendency in making biased perceptual jedgement either to the left (negative values) or to the right (positive values). Below an example of data collected from a subject with a leftward bias

![testsubj](https://user-images.githubusercontent.com/104091627/165067906-afe0ce7d-abbb-4971-ad0e-4e8cce617244.png)



### Requirements
Octave GNU and Psychophysics Toolbox Version 3 (PTB-3) (instruction for dowload [here](http://psychtoolbox.org/download.html))

### How to run the program

Open and run the Landmark.m file. The command window will ask you which instruciton order you want to start with: "Which side is longer" and then "Which side is shorter" (option 12) or viceversa (option 21)

```
Instruction code  (12 | 21) :
```

Now you are ready to get familiar with the task. Follow the instruction

```
Lets do some PRACTICE!
(press enter to start)
```
If you haven't installed Psychtoolbox the program will stop at this point.




