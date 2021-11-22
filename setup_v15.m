global x % X coordinate
global y % Y coordinate
global num_pins % number of pins
global pin_count % count of pins 
global data % data structure that holds all the recorded data
global trial_count % number of trials, which is counted when the user clicks the next pin 
global a % intialize random weight
global Glast % the gain in 6 frequency bands of the previous trial 
global fname % file name 

% things to do:
% make sure the number of pins is 2(done) 
% clean up the code for storing the data, make a 2D matrix(done)
% include a prompt for experiment to put in the patient info (done)
% delete unnecessary data storage (done) 
% resume and continue data collection from a preivous session (done)
% fix the current trial number that is being displayed to the user (done)
% dynamically read and do do analysis from patient name, stuck on getting
% (done)
% the file name to a string from a cell(done) 
% set into blocks of 25 not 50 (done)
% add the new noise term 

num_pins = 153;
data = cell(6,num_pins); % two pins for user to select from and the third "pin" used to finalize 
% hence 3 * 50 is 150 plus the intial first 3 total pins 

x = 0;
y = 0;
% preallocating where the column are the gaintable (gt) values and the rows are the trials
a = randn(6,1); % weight for each frequency bands
% here the 3d cell is being created
Glast = zeros(6,1); % previous trial gain values, but this is set to be zero
data{1,1} = a; % weight for each frequency band
data{2,1} = Glast; % previous gain 
data{3,1} = x; % x coordinate
data{4,1} = y; % y coordinate
data{5,1} = 0; % weight
data{6,1} = 0; % noise calculated each trial
num_pins = 0;
trial_count = 0; % Number of trials 
pin_count = 1; % total number of pins used 
assignin('base','data',data);

prompt= 'Please Type In Patient ID: ';
name=input(prompt,'s');
fname=[name,datestr(now, 'dd-mmm-yyyy'),'.mat'];
if isfile(fname)
     dragpoints_2_v15(fname)
     disp("file_found")
else
     dragpoints_2_v15()
     disp("file_not_found")
end