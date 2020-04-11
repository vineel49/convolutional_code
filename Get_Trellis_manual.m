% Get trellis for G(D) = [1 (1+D^2)/(1+D+D^2)]

function [P_State,P_Ip,Ga_Inx]= Get_Trellis_manual()
P_State = [1,2; 4,3; 2,1 ;3,4]; % previous state
P_Ip = [1,2; 1,2; 1,2; 1,2]; % previous ip
Ga_Inx = [1,4; 2,3; 1,4; 2,3]; % branch indices
end
