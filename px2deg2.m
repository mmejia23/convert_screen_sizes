function [stim_size_deg, stim_size_mm] = px2deg2(stim_size_px, screen_size_px, screen_distance_mm, screen_size_mm, stim_center_px)
% 
% Arguments:
%           stim_center_px : 1 x 2 matrix, with x and y pixels (measured
%                            from left edge of the screen).
% 
% Based on the observation that pixels that are more eccentric, would
% subtend in less visual angle degrees than pixels more foveally.
% Inspired from https://www.sr-research.com/eye-tracking-blog/background/visual-angle/
% 
% Sources:
% https://imaging.mrc-cbu.cam.ac.uk/imaging/TransformingVisualAngleAndPixelSize
% https://www.sr-research.com/visual-angle-calculator/
% https://www.sr-research.com/eye-tracking-blog/background/visual-angle/
% https://osdoc.cogsci.nl/3.3/visualangle/
%

stim_size_mm = nan(1,length(stim_size_px));
stim_size_deg = nan(1,length(stim_size_px));

% Get screen center:
screen_center_mm = screen_size_mm./2;

% If last argument is not entered, then assume stim is centered:
if nargin<5
    stim_center_px = screen_size_px./2;
end

% Convert px to mm:
px_p_mm = screen_size_px ./ screen_size_mm;
mm_p_px = 1 ./ px_p_mm;

% Convert px to mm:
stim_size_mm = stim_size_px .* mm_p_px;
stim_center_mm = stim_center_px .* mm_p_px;

% Get new eye-to-screen distance if stimulus is not centered:
eye2stimcenter_distance_mm = sqrt(screen_distance_mm^2 + abs(stim_center_mm - screen_center_mm).^2);

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

% Convert stim width from mm to rads/degrees:
% center is the distance from left edge of screen
% Get relative distances in mm between stim and screen center:
ext_triangl_mm = abs(stim_center_mm - stim_center_mm) + stim_size_mm./2;
int_triangl_mm = abs(stim_center_mm - stim_center_mm) - stim_size_mm./2;

% Convert both triangles from mm to radians:
% eye2stimcenter_distance_mm is flipped because:
% the x distance now is the hypothenusa of the vertical triangle (y)
% the y distance now is the hypothenusa of the horizontal triangle (x)
ext_triangl_rad = atan(ext_triangl_mm ./ flip(eye2stimcenter_distance_mm));
int_triangl_rad = atan(int_triangl_mm ./ flip(eye2stimcenter_distance_mm));

% Convert radians into degrees
ext_triangl_deg = ext_triangl_rad .* (180/pi);
int_triangl_deg = int_triangl_rad .* (180/pi);

% Get angle size of stimulus:
stim_width_rad = ext_triangl_rad - int_triangl_rad;
stim_size_deg = ext_triangl_deg - int_triangl_deg;

