function [pixperdeg, degperpix]=VisAng(res,sz,vdist) 

%     res - the resolution of the monitor 
%     sz - the size of the monitor in cm 

pix=sz./res; %calculates the size of a pixel in cm 
degperpix=(2*atan(pix./(2*vdist))).*(180/pi); 
pixperdeg=1./degperpix; 
