function dragpoints_2_v5(xData,yData,xLower,xUpper,yLower,yUpper)
global openmha

%Setting Up The Correct Directories 
% 
setenv('PATH', [getenv('PATH') ':/usr/local/bin']); % Make sure to change this to your appropiate directory        
addpath('/usr/local/lib/openmha/mfiles/') % Make sure to change this to your appropiate directory        
javaaddpath('/usr/local/lib/openmha/mfiles/mhactl_java.jar') % Make sure to change this to your appropiate directory        

openmha = mha_start;       % initializes openMHA software
mha_query(openmha,'','read:final_dc_live.cfg'); % selects the .cfg file to read
mha_set(openmha,'cmd','start'); % starts openMHA software

if nargin == 0 % default input variables
  xData = 0;
  yData = 0;
  xLower = -20;
  xUpper = 20;
  yLower = -20;
  yUpper = 20;
end

figure('unit','normalized',...  % creates the MATLAB figure
    'position',[.1 .1 .8 .8]);

handles.hbutton1 = uicontrol('style','pushbutton',...,  % creates the "Pin" button with the various properties
    'unit','normalized',...,
    'innerposition',[0.02 0.55 .08 .08],'fontname','Arial',...
    'fontsize',36,'backgroundcolor','green','string','Pin','Tag','1');
handles.hbutton2 = uicontrol('style','pushbutton',...,  % creates the "Next" button with the various properties
    'unit','normalized',...,
    'innerposition',[0.02 0.25 .08 .08],'fontname','Arial',...
    'fontsize',36,'backgroundcolor','blue','string','Next','Tag','2','Enable','Off');

hObject1 = handles.hbutton1;    % creates the button object
hObject2 = handles.hbutton2;    % creates the button object

guidata(hObject1, handles);     
guidata(hObject2, handles);

x = xData;
y = yData;

ax = axes('xlimmode','manual','ylimmode','manual');
ax.XLim = [xLower xUpper];
ax.YLim = [yLower yUpper];

% formatOut = 31;
% d = datestr(now, formatOut);
% baseFileName = sprintf('%s, a values', d);  %Kinda useless?? Fix this 
% save(baseFileName,'a_val','D_vals');

handles.hbutton1.Callback = {@button_callback, handles}; 
handles.hbutton2.Callback = {@button_callback, handles};
axis square
line(x,y,'color','c','marker','.','markersize',105,'hittest','on','buttondownfcn',@clickmarker) %Change this with rectangle that's filled 

%Callback For Pin & Next Buttons

function button_callback(src,~,handles)
global a
global x
global y
global num_pins
global openmha
global data
global pin_count
global x_new
global y_new
%This calculates the area explored by the user
% x_range = range(points(:,1));   
% y_range = range(points(:,2));
% area_explored = x_range * y_range;  % area explored by the user
buttonID = src.Tag;              %Sets the tag for the buttons 
stateII = str2double(buttonID);    %Converts the tag to a state 
if (num_pins == 3) % currently this condition fires only when all 3 pins are used, make this 
                   % so that it is a maximum of 3 pins
     handles.hbutton1.Enable = 'off'; % "Pin" button
     handles.hbutton2.Enable = 'on'; % "Next" button
     xy = get(gca,'CurrentPoint');
     x = xy(1,1);
     y = xy(1,2);
     pin_count = pin_count + 1;
     data{1,1,pin_count} = a; % saving a values to the data structure
     data{3,1,pin_count} = x; % saving x coordinate to the data structure
     data{4,1,pin_count} = y; % saving y coordinate to the data structure
     data{5,1,pin_count} = 2; % saving weight when there's a pin dropped
     num_pins = 0; % resets the number of pins back to  at the end of the trial
     mha_set(openmha,'cmd','stop');
else
    if  stateII == 1 % Dropping a pin 
        xy = get(gca,'CurrentPoint');
        x = xy(1,1);
        y = xy(1,2);
        pin_count = pin_count + 1;
        r = 2;
        c = [x y];
        pos = [c-r 2*r 2*r];
        rectangle('Position',pos,'Curvature',[1 1],'EdgeColor','r') % creating the pin using the rectangle function
        num_pins = num_pins + 1;
        data{1,1,pin_count} = a; % saving a values to the data structure
        data{3,1,pin_count} = x; % saving x coordinate to the data structure
        data{4,1,pin_count} = y; % saving y coordinate to the data structure
        data{5,1,pin_count} = 1; % saving weight when there's a pin dropped
    elseif stateII == 2 % Next button
        h = findall(gca,'Type','rectangle'); % finds the pins, which are created using the rectangle function 
        delete(h) % Removes all the pins
        handles.hbutton1.Enable = 'on'; % "Pin" button set to on 
        handles.hbutton2.Enable = 'off'; % "Next" button set to off
        num_pins = 0;
        a = randn(6,1); % generates new a values
        % get coordinates for the new origins
        flag = cell2mat(data(5,1,:));
        index = find(flag == 2);
        new_origin = data(:,:,index(end,1));
        x_new = cell2mat(new_origin(3,1))
        y_new = cell2mat(new_origin(4,1))
        xlim([(x_new - 20) (x_new + 20)]);
        ylim([(y_new - 20) (y_new + 20)]);
        % moves the cursor to the origin
        h = findall(gca,'Type','line'); %this is the cursor 
        set(h,'XData',x_new)    % setting the x coordinate to 0
        set(h,'Ydata',y_new)    % setting the y coordinate to 0 
        mha_set(openmha,'cmd','start');
    end
    drawnow
end

function clickmarker(src,ev)
set(ancestor(src,'figure'),'windowbuttonmotionfcn',{@dragmarker,src})
set(ancestor(src,'figure'),'windowbuttonupfcn',@stopdragging)

function dragmarker(fig,ev,src)
global x 
global y
global points
global point_count
global a 
global Glast
global openmha
global gt
global x_new
global y_new
global data

trial_num = 1; % number of trials for recording gt 
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
catch
    try
        x = h1.Children(2).XData;
        y = h1.Children(2).YData;
    catch
    end
end
xy = get(gca,'CurrentPoint');
x_curr = xy(1,1);
y_curr = xy(1,2);

%get all x and y data 
x1 = y_curr;
x2 = x_curr;

B = isempty(data);
    
    if B == 0
        G = Glast + x1 + x2*a; % this is the formula that creates the gains 
        gaintable_og = [ [G(1) G(1) G(1)];[G(2) G(2) G(2)];[G(3) G(3) G(3)];...  %"Mapping"
                    [G(4) G(4) G(4)];[G(5) G(5) G(5)];[G(6) G(6) G(6)];...
                    [G(1) G(1) G(1)];[G(2) G(2) G(2)];[G(3) G(3) G(3)];...
                    [G(4) G(4) G(4)];[G(5) G(5) G(5)];[G(6) G(6) G(6)]];
        mha_set(openmha,'mha.overlapadd.mhachain.dc.gtdata',gaintable_og);
    else
        [~,~,trial_number] = size(gt);
        x1_last = data(3,1,trial_number);
        x2_last = data(4,1,trial_number);
        a_last = data(1,1,trial_number);
        Glast = x1_last + x2_last*a_last;
        G = Glast + x_new + y_new*a; % this is the formula that creates the gains
        gaintable_og = [ [G(1) G(1) G(1)];[G(2) G(2) G(2)];[G(3) G(3) G(3)];...  %"Mapping"
                    [G(4) G(4) G(4)];[G(5) G(5) G(5)];[G(6) G(6) G(6)];...
                    [G(1) G(1) G(1)];[G(2) G(2) G(2)];[G(3) G(3) G(3)];...
                    [G(4) G(4) G(4)];[G(5) G(5) G(5)];[G(6) G(6) G(6)]];
        mha_set(openmha,'mha.overlapadd.mhachain.dc.gtdata',gaintable_og);
    end
    
%check which data point has the smallest distance to the dragged point
x_diff=abs(x-x_curr);
y_diff=abs(y-y_curr);
[~, index]=min(x_diff+y_diff);

%create new x and y data and excchange coords for the dragged point
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