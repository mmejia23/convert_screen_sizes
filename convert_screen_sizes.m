% Codes for px vs mm vs visual angle degress

%% Inspired from https://www.sr-research.com/eye-tracking-blog/background/visual-angle/

%% Test px2deg function with exp04 settings:
screenX = 640;
screenY = 480;
screenXmm = 320; 
screenYmm = 240;
stimuli_width = 55; % 55px = 2.5°
stimuli_height = 81.4; % 81.4px = 3.7° ??
screen_distance = 635;

[stim_degrees, stim_mm] = px2deg(stimuli_width, screenX, screen_distance, screenXmm)
[stim_degrees, stim_mm] = px2deg(stimuli_height, screenX, screen_distance, screenXmm)


%% Test px2deg function with exp05 settings:
screenX = 800;
screenY = 600;
screenXmm = 320; 
screenYmm = 240;
stimuli_width = 100; % 100px = 3.1151° ~ 3.1°??
stimuli_height = 133; % 133px = 4.1° ??
screen_distance = 635;

[stim_degrees, stim_mm] = px2deg(stimuli_width, screenX, screen_distance, screenXmm)
[stim_degrees, stim_mm] = px2deg(stimuli_height, screenX, screen_distance, screenXmm)
% Apparently, correct values are: 100px = 3.6080°, and 133px = 4.7974°

%% Test px2deg2 function with exp05 settings:
stim_size_px = [100, 133];
screen_size_px = [800, 600];
screen_distance_mm = [635];
screen_size_mm = [320, 240];
stim_center_px = [400, 300];
[stim_size_deg, stim_size_mm] = px2deg2(stim_size_px, screen_size_px, screen_distance_mm, screen_size_mm, stim_center_px)





%% Notes: %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% First versions
stim_width_mm = 400; %mm
screen_distance_mm = 700; %mm
screen_width_mm = 1000; %mm
stim_center_x_mm = 500;

% Convert px to mm:
stim_width_px = 800; %px
screen_width_px = 2000; %px
px_p_mm = screen_width_px / screen_width_mm;
mm_p_px = 1 / px_p_mm;
stim_width_mm = stim_width_px * mm_p_px;

% One-sided stimuli
% Convert stim width from mm to rads/degrees:
stim_width_rad = atan(stim_width_mm / screen_distance_mm);
stim_width_deg = stim_width_rad * (180/pi);

% Centered stimuli
% Convert stim width from mm to rads/degrees:
stim_width_rad = 2 * atan((stim_width_mm/2) / screen_distance_mm);
stim_width_deg = stim_width_rad * (180/pi);

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



%% From fixPRF5.m from CNV lab
%{
%%%% layout
params.grid = 5;                        % number of grid elements
params.gridSpaceDeg = 1.5;              % center to center spacing of the grid
params.faceSizeDeg = 3.2;               % size of each face (diam)
params.fixRadDeg =  .2;                 % in degrees, the size of the biggest white dot in the fixation
params.cuePix = 2;                      % in pixels, the thickness of the cue ring. now draws *inside* fixRadDeg, so that the cue is not made bigger by increasing this param

%%%% screen
%params.backgroundColor = [128 128 128]; % color - set later from sample image
params.textColor = [255 255 255];
scan.screenWidth = 104;                  % in cm; % laptop=27.5, office=43, CNI = 104cm at both 16ch and 32ch
if scan.coil == 32
    scan.viewingDist = 272;
else                                     % in cm; CNI = 270-273cm at 32ch, 265 at 16ch;
    scan.viewingDist = 265; end

%%%% scale the stims for the screen
scan.ppd = pi* rect(3) / (atan(scan.screenWidth/scan.viewingDist/2)) / 360;
scan.faceSize = round(params.faceSizeDeg*scan.ppd);                 % in degrees, the size of our faces
scan.fixRad = round(params.fixRadDeg*scan.ppd);
scan.littleFix = round(scan.fixRad*.25);
%scan.fixImRad = round(params.fixImDeg*scan.ppd);
%}

%% From AllenSDK (python code)
%{
    @property
    def pixel_size(self):
        return float(self.width)/self.n_pixels_c

    def pixels_to_visual_degrees(self, n, distance_from_monitor, small_angle_approximation=True):


        if small_angle_approximation == True:
            return n*self.pixel_size/distance_from_monitor*RADIANS_TO_DEGREES # radians to degrees
        else:
            return 2*np.arctan(n*1./2*self.pixel_size / distance_from_monitor) * RADIANS_TO_DEGREES  # radians to degrees

    def visual_degrees_to_pixels(self, vd, distance_from_monitor, small_angle_approximation=True):

        if small_angle_approximation == True:
            return vd*(distance_from_monitor/self.pixel_size/RADIANS_TO_DEGREES)
        else:
            raise NotImplementedError
%}            

%% From MRC Unit
% https://imaging.mrc-cbu.cam.ac.uk/imaging/TransformingVisualAngleAndPixelSize

% Visual angle to stimulus size

% Provides x,y size in pixels to produce a given size in visual angle. 
% If the screen and distance parameters are undefined, we use the CBU
% scanner settings (see 
% http://imaging.mrc-cbu.cam.ac.uk/mri/CbuStimulusDelivery). If using default
% CBU scanner parameters, the sizey input is also optional.
% use: [sizex,sizey] = visangle2stimsize(visanglex,[visangley],[totdistmm],[screenwidthmm],[screenres])
% 25/9/2009 J Carlin

function [sizex,sizey] = visangle2stimsize(visanglex,visangley,totdist,screenwidth,screenres)

if nargin < 3
        % mm
        distscreenmirror=823;
        distmirroreyes=90;
        totdist=distscreenmirror+distmirroreyes;
        screenwidth=268;

        % pixels
        screenres=1024;
end

visang_rad = 2 * atan(screenwidth/2/totdist);
visang_deg = visang_rad * (180/pi);

pix_pervisang = screenres / visang_deg;

sizex = round(visanglex * pix_pervisang);

if nargin > 1
        sizey = round(visangley * pix_pervisang);
end
end


% Stimulus size to visual angle

% Quick convenience function to convert stimulus size in pixels to degrees
% visual angle. If the screen and distance parameters are undefined, we use
% the CBU scanner settings (see 
% http://imaging.mrc-cbu.cam.ac.uk/mri/CbuStimulusDelivery). If using default
% CBU scanner parameters, the sizey input is also optional.
% use: [visanglex,visangley] = stimsize2visangle(sizex,[sizey],[totdistmm],[screenwidthmm],[screenres])
% 25/9/2009 J Carlin

function [visanglex,visangley] = stimsize2visangle(sizex,sizey,totdist,screenwidth,screenres)

if nargin < 3
        % mm
        distscreenmirror=823;
        distmirroreyes=90;
        totdist=distscreenmirror+distmirroreyes;
        screenwidth=268;

        % pixels
        screenres=1024;
end

visang_rad = 2 * atan(screenwidth/2/totdist);
visang_deg = visang_rad * (180/pi);

visang_perpix = visang_deg / screenres;

visanglex = sizex * visang_perpix;

if nargin > 1
        visangley = sizey * visang_perpix;
end
end


