%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Matlab Program made by Sumeet Kumar Sinha %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% (sumeet.kumar507@gmail.com) %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%  sumeetksinha.com %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Function for evaluating elment transformation matrix from local to global coordinates
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function[gamma] = ElementTransformationMatrix_Beam(beta_angle,alpha_x)

	% Transformation Matrix for 3D frame member.
	%   beta_angle = Crossectional-Area of The Beam. 
    %   alpha_x      = Moment of Area of Beam about Izz-Axis.

    R_zero = zeros(3,3); e_y = [0;1;0]; 
    
    % alpha_x = xaxis./sqrt(sum(xaxis.^2));
	% alpha_x = xaxis;
    alpha_x = alpha_x(:);
    if(alpha_x(1)==0 && (alpha_x(2)==1 || alpha_x(2)==-1) && alpha_x(3)==0);
        e_y = [-1;0;0];        
    end
    
    alpha_z = cross(alpha_x,e_y); alpha_z = alpha_z/norm(alpha_z);
    alpha_y = cross(alpha_z,alpha_x); alpha_y = alpha_y/norm(alpha_y);
    
    R_axis = [alpha_x alpha_y alpha_z]';
    R_beta = [	1	,0                  ,0                  ;
                0	,cos(beta_angle)	,sin(beta_angle)    ;
                0	,-sin(beta_angle)	,cos(beta_angle)	];
            
    R = R_beta * R_axis;

    gamma = [	R           ,R_zero     ,R_zero     ,R_zero   ;
    			R_zero      ,R          ,R_zero     ,R_zero   ;
    			R_zero      ,R_zero     ,R          ,R_zero   ;
                R_zero      ,R_zero     ,R_zero     ,R        ;];
end