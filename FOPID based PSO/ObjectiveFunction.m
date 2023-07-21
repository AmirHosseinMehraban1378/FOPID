function [ o ] = ObjectiveFunction ( x )
open('oneeffortt.slx')
sim('oneeffortt.slx')
 err=y;
 Jiae=abs(sum(err));
o = Jiae;

end