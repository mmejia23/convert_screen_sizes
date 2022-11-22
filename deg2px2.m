function [stim_size_px, stim_size_mm, stim_center_px] =...
    deg2px2(stim_size_deg, screen_size_px, screen_distance_mm, screen_size_mm, stim_center_deg)
% 
% Arguments:
%           stim_center_deg: 1 x 2 matrix, with x and y degrees (measured
%                            from the center of the screen, 
%                            aka eccentricity of stimulus center in VAD).
% 

% If last argument is not entered, then assume stim is centered:
if nargin<5
    stim_center_deg = zeros(1, length(stim_size_deg));
end

% Convert px to mm:
px_p_mm = screen_size_px ./ screen_size_mm;
mm_p_px = 1 ./ px_p_mm;

% Define the visual angle degrees of both triangles:
ext_triangl_deg = stim_center_deg + stim_size_deg./2;
int_triangl_deg = stim_center_deg - stim_size_deg./2;

% Convert degrees into radians
ext_triangl_rad = ext_triangl_deg ./ (180/pi);
int_triangl_rad = int_triangl_deg ./ (180/pi);

% Get new eye-to-screen distance if stimulus is not centered:
stim_center_rad = stim_center_deg ./ (180/pi);
eye2stimcenter_distance_mm = sec(stim_center_rad).*screen_distance_mm;

% Convert radians into screen size in mm
ext_triangl_mm = tan(ext_triangl_rad) .* flip(eye2stimcenter_distance_mm);
int_triangl_mm = tan(int_triangl_rad) .* flip(eye2stimcenter_distance_mm);
stim_size_mm = ext_triangl_mm - int_triangl_mm;

% Convert mm to px:
stim_size_px = stim_size_mm .* px_p_mm;

screen_center_mm = screen_size_mm./2;
stim_center_mm = (ext_triangl_mm + int_triangl_mm)./2 + screen_center_mm;
stim_center_px = stim_center_mm .* px_p_mm;


% Checks:
% If stimuli is within screen bounds
if length(stim_size_px) == 1
    assert(stim_center_mm + stim_size_mm/2 <= screen_size_mm,...
        "Stimulus subtends outside of screen space.")
    fprintf("\nmm_p_px: %f \n", mm_p_px);
    fprintf("\neye2stimcenter_distance_mm: %f \n", eye2stimcenter_distance_mm);
else
    assert(stim_center_mm(1) + stim_size_mm(1)/2 <= screen_size_mm(1),...
        "Stimulus subtends outside of screen space (width).")
    assert(stim_center_mm(2) + stim_size_mm(2)/2 <= screen_size_mm(2),...
        "Stimulus subtends outside of screen space (height).")
    fprintf("\nmm_p_px: x = %f | y = %f\n", mm_p_px);
    fprintf("\neye2stimcenter_distance_mm: x = %f | y = %f\n", eye2stimcenter_distance_mm);
end