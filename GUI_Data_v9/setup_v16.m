global x % X coordinate
global y % Y coordinate
global num_pins % number of pins
global pin_count % count of pins
global data % data structure that holds all the recorded data
global trial_count % number of trials, which is counted when the user clicks the next pin
global a % intialize random weight
global Glast % the gain in 6 frequency bands of the previous trial
global noise
global filename
% things to do:
% look into averaging the noise at different trial levels

num_pins = 153;
data = cell(6,num_pins); % two pins for user to select from and the third "pin" used to finalize
% hence 3 * 50 is 150 plus the intial first 3 total pins

x = 0;
y = 0;
% preallocating where the column are the gaintable (gt) values and the rows are the trials
a = randn(6,1); % weight for each frequency bands
noise = 0;
% here the 3d cell is being created
Glast = zeros(6,1); % previous trial gain values, but this is set to be zero
data{1,1} = a; % weight for each frequency band
data{2,1} = Glast; % previous gainc
data{3,1} = x; % x coordinate
data{4,1} = y; % y coordinate
data{5,1} = 0; % weight
data{6,1} = noise; % noise calculated each trial
num_pins = 0;
trial_count = 0; % Number of trials
pin_count = 1; % total number of pins used
assignin('base','data',data);

user_input_gui;
