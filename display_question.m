function [] = display_question(w, col, instruct, txtloc, fontSize)

% w = the window you pass into SCREEN; col = color, e.g. WHITE_INDEX, instruct = 1 for 'longer' and 2 for 'shorter', txtloc = x and y location of the text

if instruct == 1	
	Screen(w,'TextSize',fontSize);
	txt = 'Which side is LONGER?';
elseif instruct == 2
	Screen(w,'TextSize',fontSize);
	txt = 'Which side is SHORTER?';	     
end

[x y] = Screen(w, 'DrawText', txt, txtloc(1), txtloc(2), col);
