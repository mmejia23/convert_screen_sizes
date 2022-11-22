function [stim_width_px, stim_width_mm, stim_center_x_px] = deg2px(stim_width_deg, screen_width_px, screen_distance_mm, screen_width_mm, stim_center_deg)
% 
% Arguments:
%           stim_center_deg: 1 x 2 matrix, with x and y degrees (measured
%                            from the center of the screen, 
%                            aka eccentricity of stimulus center in VAD).
% 

% If last argument is not entered, then assume stim is centered:
if nargin<5
    stim_center_x_deg = 0;
else
    stim_center_x_deg = stim_center_deg(1);
end

% Convert px to mm:
px_p_mm = screen_width_px / screen_width_mm;
mm_p_px = 1 / px_p_mm;

% Define the visual angle degrees of both triangles:
ext_triangl_deg = stim_center_x_deg + stim_width_deg/2;
int_triangl_deg = stim_center_x_deg - stim_width_deg/2;

% Convert degrees into radians
ext_triangl_rad = ext_triangl_deg / (180/pi);
int_triangl_rad = int_triangl_deg / (180/pi);

% Convert radians into screen size in mm
ext_triangl_mm = tan(ext_triangl_rad) * screen_distance_mm;
int_triangl_mm = tan(int_triangl_rad) * screen_distance_mm;
stim_width_mm = ext_triangl_mm - int_triangl_mm;

% Convert mm to px:
stim_width_px = stim_width_mm * px_p_mm;

screen_center_x_mm = screen_width_mm/2;
stim_center_x_mm = (ext_triangl_mm + int_triangl_mm)/2 + screen_center_x_mm;
stim_center_x_px = stim_center_x_mm * px_p_mm;

% Checks:
% If stimuli is within screen bounds
assert(stim_center_x_mm + stim_width_mm/2 <= screen_width_mm,...
    "Stimulus subtends outside of screen space (width).")
