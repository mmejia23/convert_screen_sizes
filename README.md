# Functions to convert screen sizes

In visual experiments, a very common conversion is done between stimuli sizes.
There are three ways to measure the stimuli size: pixels, millimeters, and visual angle degrees.
While we need to set the pixels of any stimuli on screen when programming the experiment,
we need to report the visual angle degrees, which depend also on the screen distance.

The function `px2deg2()` converts pixels into visual angle degrees. 
It can take a vector of the width and height (in that order) of the stimulus of interest,
or only take a single value (not assuming either width or height).

## Usage example:

```
stim_size_px = [100, 133]; 		% width: 100px, height: 133px
screen_size_px = [800, 600]; 	% width: 800px, height: 600px
screen_distance_mm = [635]; 	% eye to center of screen distance: 635 mm.
screen_size_mm = [320, 240]; 	% width: 320mm, height: 240mm.
stim_center_px = [400, 300]; 	% The center of the stimuli matches the center of the screen: 800/2, 600/2px
[stim_size_deg, stim_size_mm] = px2deg2(stim_size_px, screen_size_px, screen_distance_mm, screen_size_mm, stim_center_px)
```

`stim_size_deg` is a 1-by-2 vector with the width and height of the stimulus in visual angle degrees.

`stim_size_mm` is a 1-by-2 vector with the width and height of the stimulus in millimeters.


## Correction of visual angle degrees

This function corrects for the position of the stimulus, if the stimulus is not centered.
I took the principles from here: https://www.sr-research.com/eye-tracking-blog/background/visual-angle/

