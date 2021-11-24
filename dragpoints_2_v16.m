function dragpoints_2_v16(fname)
global x % X coordinate
global y % Y coordinate
global pin_count % count of pins 
global data % data structure that holds all the recorded data
global openmha
global trial_num
global file_cont

file_cont = 0; % used to flag if the patient is continuing from a previous session

%Setting Up The Correct Directories

% setenv('PATH', [getenv('PATH') ':/usr/local/bin']); % Make sure to change this to your appropiate directory
% addpath('/usr/local/lib/openmha/mfiles/') % Make sure to change this to your appropiate directory
% javaaddpath('/usr/local/lib/openmha/mfiles/mhactl_java.jar') % Make sure to change this to your appropiate directory

% openmha = mha_start;       % initializes openMHA software
% mha_query(openmha,'','read:final_dc_live.cfg'); % selects the .cfg file to read
% mha_set(openmha,'cmd','start'); % starts openMHA software
addpath('C:\Program Files\openMHA\mfiles')
javaaddpath('C:\Program Files\openmha\mfiles\mhactl_java.jar')

% IP address of mahalia running on PHL when using wireless
openmha.host = '10.0.0.1';
% openMHA default TCP port
openmha.port= 33337;

% mha_query(openmha,'','read:/home/mha/bc_15.cfg');
% mha_set(openmha,'cmd','start'); % starts openMHA software

if nargin == 0 % default input variables
    xData = 0;
    yData = 0;
    xLower = -20;
    xUpper = 20;
    yLower = -20;
    yUpper = 20;
    trial_num = 0;
    disp("default")
end
if nargin == 1
    xData = 0;
    yData = 0;
    xLower = -20;
    xUpper = 20;
    yLower = -20;
    yUpper = 20;
    load(fname,'data','pin_count')
    trial_num = 0;
    file_cont = 1;
end

figure('name','figure1','unit','normalized',...  % creates the MATLAB figure
    'position',[.1 .1 .8 .8]);

handles.hbutton1 = uicontrol('style','pushbutton',...,  % creates the "Pin" button with the various properties
    'unit','normalized',...,
    'innerposition',[0.065 0.55 .15 .15],'fontname','Arial',...
    'fontsize',55,'backgroundcolor','green','string','Pin','Tag','1');
handles.hbutton2 = uicontrol('style','pushbutton',...,  % creates the "Next" button with the various properties
    'unit','normalized',...,
    'innerposition',[0.065 0.25 .15 .15],'fontname','Arial',...
    'fontsize',55,'backgroundcolor','blue','string','Next','Tag','2','Enable','Off');
handles.htxt = uicontrol('style','text', ... % this is the textbox that shows the current trial number
    'unit', 'normalized', ...
    'position' , [.35 .93 .3 .05], ...
    'String', sprintf('Trial %d out of 25',trial_num), ...
    'fontsize', 28);

hObject1 = handles.hbutton1;    % creates the button object
hObject2 = handles.hbutton2;    % creates the button object

guidata(hObject1, handles);
guidata(hObject2, handles);

x = xData;
y = yData;

ax = axes('xlimmode','manual','ylimmode','manual');
ax.XLim = [xLower xUpper];
set(gca,'XTickLabel',[]);
ax.YLim = [yLower yUpper];
set(gca,'YTickLabel',[]);
grid on

handles.hbutton1.Callback = {@button_callback, handles};
handles.hbutton2.Callback = {@button_callback, handles};
axis square
line(x,y,'color','c','marker','.','markersize',105,'hittest','on','buttondownfcn',@clickmarker) %Change this with rectangle that's filled

%Callback For Pin & Next Buttons

function button_callback(src,~,handles)
global x % X coordinate
global y % Y coordinate
global num_pins % number of pins
global pin_count % count of pins 
global data % data structure that holds all the recorded data
global a % intialize random weight
global fname % file name 
global G
global openmha
global trial_num
global file_cont
global noise

buttonID = src.Tag;              %Sets the tag for the buttons
stateII = str2double(buttonID);    %Converts the tag to a state
if (num_pins == 2) % currently this condition fires only when all 3 pins are used, make this
    % so that it is a maximum of 3 pins
    handles.hbutton1.Enable = 'off'; % "Pin" button
    handles.hbutton2.Enable = 'on'; % "Next" button
    xy = get(gca,'CurrentPoint');
    x = xy(1,1);
    y = xy(1,2);
    pin_count = pin_count + 1;
    data{1,pin_count} = a; % saving a values to the data structure
    data{2,pin_count} = G; % saving gain table to the data structure
    data{3,pin_count} = x; % saving x coordinate to the data structure
    data{4,pin_count} = y; % saving y coordinate to the data structure
    data{5,pin_count} = 2; % saving weight when there's a pin dropped
    data{6,pin_count} = noise;
    num_pins = 0; % resets the number of pins back to  at the end of the trial
    %mha_set(openmha,'cmd','stop');
else
    if  stateII == 1 % Dropping a pin
        xy = get(gca,'CurrentPoint');
        x = xy(1,1);
        y = xy(1,2);
        %         if pin_count < 5
        %             Glast = zeros(6,1);
        %             G = Glast + x + y*a;
        %         else
        %             flag = data{5,pin_count-1};
        %             if flag == 2
        %                 index = find(flag == 2);
        %                 Glast = cell2mat(data(2,index(end)));
        %                 Grnd = 2;
        %                 noise = Grnd*randn(6,1);
        %                 G = Glast + x + y*a + noise;
        %             else
        %                 index = find(flag == 2);
        %                 Glast = cell2mat(data(2,index(end)));
        %                 G = Glast + x + y*a;
        %             end
        %
        %         end
        pin_count = pin_count + 1;
        r = 2;
        c = [x y];
        pos = [c-r 2*r 2*r];
        rectangle('Position',pos,'Curvature',[1 1],'EdgeColor','r') % creating the pin using the rectangle function
        num_pins = num_pins + 1;
        data{1,pin_count} = a; % saving a values to the data structure
        data{2,pin_count} = G; % saving gain table to the data structure
        data{3,pin_count} = x; % saving x coordinate to the data structure
        data{4,pin_count} = y; % saving y coordinate to the data structure
        data{5,pin_count} = 1; % saving weight when there's a pin dropped

    elseif stateII == 2 % Next button
        h = findall(gca,'Type','rectangle'); % finds the pins, which are created using the rectangle function
        delete(h) % Removes all the pins
        handles.hbutton1.Enable = 'on'; % "Pin" button set to on
        handles.hbutton2.Enable = 'off'; % "Next" button set to off
        num_pins = 0;
        a = randn(6,1); % generates new a values
        % get coordinates for the new origins
        if file_cont == 1
            disp("file_exists")
            flag = cell2mat(data(5,:));
            index = find(flag == 2);
            trial_num = (length(index) - 25);
            handles.htxt.String = sprintf('Trial %d out of 25',(trial_num));
        else
            flag = cell2mat(data(5,:));
            index = find(flag == 2);
            trial_num = length(index);
        end
        handles.htxt.String = sprintf('Trial %d out of 25',(trial_num));
        % moves the cursor to the origin
        h = findall(gca,'Type','line'); %this is the cursor
        set(h,'XData',0)    % setting the x coordinate to 0
        set(h,'Ydata',0)    % setting the y coordinate to 0
%         mha_set(openmha,'cmd','start');
        if file_cont == 0
            if pin_count >= 78
                %mha_set(openmha,'cmd','stop');
                save(fname)
                close all
            end
        else
            if pin_count >= 153
%                 mha_set(openmha,'cmd','quit');
                save(fname)
                close all
            end
        end
    end
end

function clickmarker(src,ev)
set(ancestor(src,'figure'),'windowbuttonmotionfcn',{@dragmarker,src})
set(ancestor(src,'figure'),'windowbuttonupfcn',@stopdragging)

function dragmarker(fig,ev,src)
global points
global point_count
global a
global Glast
global openmha
global data
global G
global pin_count
global noise
global x % X coordinate
global y % Y coordinate

buttonID = src.Tag;              %Sets the tag for the buttons
stateII= str2num(buttonID);      %Converts the tag to a state
if  stateII == 1
    h1 = gco;
    x = h1.XData;
    y = h1.YData;
end
try
    h1 = gca;
    x = h1.Children.XData;
    y = h1.Children.YData;
end
xy = get(gca,'CurrentPoint');
x_curr = xy(1,1);
y_curr = xy(1,2);

%get all x and y data
x1 = y_curr;
x2 = x_curr;

if pin_count < 16 % after five trials 
    G = Glast + x1 + x2*a; % this is the formula that creates the gains
else
    flag = data{5,pin_count};
    if flag == 2
        gt = cell2mat(data(2,:));
        variance = std(gt,0,2);
        if any(variance < 3)
            Glast = cell2mat(data(2,(pin_count - 1)));
            Grnd = 3; % 3 dB noise 
            noise = Grnd*randn(6,1);
            G = Glast + x1 + x2*a + noise;
            data{6,pin_count} = noise; % saving noise
            disp(noise)
        else
            Glast = cell2mat(data(2,pin_count));
            G = Glast + x1 + x2*a;
            disp("no noise added")
        end
    end
end

if any(G(:,1) > 30)
    g_new_idx = G > 30;
    G(g_new_idx,1) = 20; % set to 20 dB max
    %warning("Gain Too High")
end
gaintable_og = [ [G(1) G(1) G(1)];[G(2) G(2) G(2)];[G(3) G(3) G(3)];...  %"Mapping"
    [G(4) G(4) G(4)];[G(5) G(5) G(5)];[G(6) G(6) G(6)];...
    [G(1) G(1) G(1)];[G(2) G(2) G(2)];[G(3) G(3) G(3)];...
    [G(4) G(4) G(4)];[G(5) G(5) G(5)];[G(6) G(6) G(6)]];
% mha_set(openmha,'mha.overlapadd.mhachain.dc.gtdata',gaintable_og);

%check which data point has the smallest distance to the dragged point
x_diff=abs(x-x_curr);
y_diff=abs(y-y_curr);
[~, index]=min(x_diff+y_diff);

%create new x and y data and exchange coords for the dragged point
x_new=x;
y_new=y;
x_new(index)=x_curr;
y_new(index)=y_curr;

point_count = point_count + 1;
points(point_count,1) = x_curr;
points(point_count,2) = y_curr;

%update plot
set(src,'xdata',x_new,'ydata',y_new);

function stopdragging(fig,ev)
set(fig,'windowbuttonmotionfcn','')
set(fig,'windowbuttonupfcn','')