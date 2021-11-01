global x % X coordinate
global y % Y coordinate
global num_pins % number of pins
global pin_count % count of pins 
global data % data structure that holds all the recorded data
global trial_count % number of trials, which is counted when the user clicks the next pin 
global a % intialize random weight
global Glast % the gain in 6 frequency bands of the previous trial 
global fname

% things to do:
% make sure the number of pins is 2( done) 
% clean up the code for storing the data, make a 2D matrix( done)
% include a prompt for experiment to put in the patient info (done)
% delete unnecessary data storage ( done) 
% resume and continue data collection from a preivous session 

num_trials = 200;
data = cell(5,num_trials); % three pins for user to select from and the fourth "pin" used to finalize 
% hence 4 * 50 is 200 total pins 

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
num_pins = 0;
trial_count = 0; % Number of trials 
pin_count = 1; % total number of pins used 
assignin('base','data',data);

prompt= 'Please Type In Patient ID: ';
name=input(prompt,'s');
fname=[name,datestr(now, 'dd-mmm-yyyy'),'.mat'];
%fname = sprintf('%sData.mat', filename);
if isfile(fname)
     dragpoints_2_v8(fname)
     disp("file_found")
else
     dragpoints_2_v8()
     disp("file_not_found")
end
