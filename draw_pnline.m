function [] = draw_pnline(w,center,line_w, line_rightshift,col, penThickness, line_h)

% draw a horizontal line of length LINE_W, 
% shifted upwards by LINE_UPSHIFT and 
% shifted rightwards by LINE_RIGHTSHIFT
% penThickness = 2;%thickness of the line
% line_w = 500;%width in the number of pixels
% line_rightshift = 0;
    line_upshift = 0;
%draw line parameters
fromH1 = center(1) - line_w/2 + line_rightshift; %beginning x of line
fromV1 = center(2) + line_upshift; %beginning y of line
toH1 = center(1) + line_w/2 + line_rightshift; %end x coordinate of line
toV1 = center(2) + line_upshift; %end y coordinate of line
% DrawLine parameters: color, fromH, fromV, toH, toV, penWidth, penHeight
Screen('DrawLine', w ,col,fromH1,fromV1, ...
				        toH1,toV1, ...
					    penThickness);

% draw a horizontally-centered, vertical line of length LINE_H shifted upwards by LINE_UPSHIFT
%line_h = 24;%line_h = height of the line in pixels
fromH2 = center(1);
fromV2 = center(2)+line_h;
toH2 = center(1);
toV2 = center(2)-line_h;
Screen('DrawLine', w, col,fromH2,fromV2, ...
					    toH2,toV2, ...
						penThickness);
                    
                    
                    
                    

