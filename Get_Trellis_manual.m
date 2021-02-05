% Get trellis for G(D) = [1 (1+D^2)/(1+D+D^2)]

function [Prev_State,Prev_Ip,Outputs_prev]= Get_Trellis_manual()
Prev_State = [1,2; 4,3; 2,1 ;3,4]; % previous state
Prev_Ip = [1,2; 1,2; 1,2; 1,2]; % previous ip
Outputs_prev = [1,4; 2,3; 1,4; 2,3]; % branch indices
end
