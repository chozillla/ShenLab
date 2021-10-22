global x % X coordinate
global y % Y coordinate
global num_pins % number of pins
global pin_count % count of pins 
global data % data structure that holds all the recorded data
%global handles % handle structure that stores the "Pin" and "Next" button states 
global trial_count % number of trials, which is counted when the user clicks the next pin 
global a % intialize random weight
global Glast % the gain in 6 frequency bands of the previous trial 
%global openmha

num_trials = 53;
data = cell(5,1,(num_trials));

x = 0;
y = 0;
% preallocating where the column are the gaintable (gt) values and the rows are the trials
a = randn(6,1); % weight for each frequency bands
% here the 3d cell is being created
Glast = zeros(6,1); % previous trial gain values, but this is set to be zero
data{1,1,1} = a; % weight for each frequency band
data{2,1,1} = Glast; % previous gain 
data{3,1,1} = x; % x coordinate
data{4,1,1} = y; % y coordinate
data{5,1,1} = 0; % weight
num_pins = 0;
trial_count = 0; % Number of trials 
pin_count = 1; % total number of pins used 
assignin('base','data',data);

dragpoints_2_v5()