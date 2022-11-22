function [stim_width_deg, stim_width_mm] = px2deg(stim_width_px, screen_width_px, screen_distance_mm, screen_width_mm, stim_center_x_px)

% If last argument is not entered, then assume stim is centered:
if nargin<5
    stim_center_x_px = screen_width_px/2;
end
screen_center_x_mm = screen_width_mm/2;

% Convert px to mm:
px_p_mm = screen_width_px / screen_width_mm;
mm_p_px = 1 / px_p_mm;

% Convert px to mm:
stim_width_mm = stim_width_px * mm_p_px;
stim_center_x_mm = stim_center_x_px * mm_p_px;

% Get new eye-to-screen distance if stimulus is not centered:
eye2stimcenter_distance_x_mm = sqrt(screen_distance_mm^2 + abs(stim_center_x_mm - screen_center_x_mm)^2);
fprintf("\neye2stimcenter_distance_x_mm = %f\n", eye2stimcenter_distance_x_mm);

% Checks:
% If stimuli is within screen bounds
assert(stim_center_x_mm + stim_width_mm/2 <= screen_width_mm,...
    "Stimulus subtends outside of screen space (width).")

% Off-centered stimuli (width)

% Convert stim width from mm to rads/degrees:
% center is the distance from left edge of screen
% Get relative distances in mm between stim and screen center:
ext_triangl_mm = abs(stim_center_x_mm - screen_center_x_mm) + stim_width_mm/2;
int_triangl_mm = abs(stim_center_x_mm - screen_center_x_mm) - stim_width_mm/2;

% Convert both triangles from mm to radians:
ext_triangl_rad = atan(ext_triangl_mm / screen_distance_mm);
int_triangl_rad = atan(int_triangl_mm / screen_distance_mm);

% Convert radians into degrees
ext_triangl_deg = ext_triangl_rad * (180/pi);
int_triangl_deg = int_triangl_rad * (180/pi);

% Get angle size of stimulus:
stim_width_rad = ext_triangl_rad - int_triangl_rad;
stim_width_deg = ext_triangl_deg - int_triangl_deg;

