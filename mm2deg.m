function [stim_width_deg] = mm2deg(stim_width_mm, screen_distance_mm, screen_width_mm, stim_center_x_mm)

% Checks:
% If stimuli is within screen bounds
assert(stim_center_x_mm + stim_width_mm/2 <= screen_width_mm,...
    "Stimulus subtends outside of screen space (width).")

% Off-centered stimuli (width)

% Convert stim width from mm to rads/degrees:
% center is the distance from left edge of screen
% Get relative distances in mm between stim and screen center:
screen_center_x_mm = screen_width_mm/2;
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

