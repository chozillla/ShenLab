function dragpoints_2_v3(xData,yData,xLower,xUpper,yLower,yUpper)
global openmha
global x
global y
global point_count % Number of datapoints from the cursor 
global points
global area 
global handles
global trial_count 

area = (1/3)*(20*20); % Total area of the screen
assignin('base','points',points)
handles.num_pins = 0;
point_count = 0;
points = zeros(1000,3); % First column is x and the second is y third column is the weight
trial_count = 0; % Number of trials 

%Setting Up The Correct Directories 

setenv('PATH', [getenv('PATH') ':/usr/local/bin']);         
addpath('/usr/local/lib/openmha/mfiles/')
javaaddpath('/usr/local/lib/openmha/mfiles/mhactl_java.jar')

openmha = mha_start;       %Starts openMHA software
mha_query(openmha,'','read:final_dc_live.cfg'); %Selects the .cfg file to read

if nargin == 0 
  xData = 0;
  yData = 0;
  xLower = -20;
  xUpper = 20;
  yLower = -20;
  yUpper = 20;
end

figure('unit','normalized',...
    'position',[.1 .1 .8 .8]);

handles.hbutton1 = uicontrol('style','pushbutton',...,
    'unit','normalized',...,
    'innerposition',[0.02 0.55 .08 .08],'fontname','Arial',...
    'fontsize',36,'backgroundcolor','green','string','Pin','Tag','1');
handles.hbutton2 = uicontrol('style','pushbutton',...,
    'unit','normalized',...,
    'innerposition',[0.02 0.25 .08 .08],'fontname','Arial',...
    'fontsize',36,'backgroundcolor','blue','string','Next','Tag','2','Enable','Off');

hObject1 = handles.hbutton1;
hObject2 = handles.hbutton2;

guidata(hObject1, handles);
guidata(hObject2, handles);

x = xData;
y = yData;

ax = axes('xlimmode','manual','ylimmode','manual');
ax.XLim = [xLower xUpper];
ax.YLim = [yLower yUpper];

handles.hbutton1.Callback = {@button_callback, handles};
handles.hbutton2.Callback = {@button_callback, handles};
line(x,y,'color','c','marker','.','markersize',105,'hittest','on','buttondownfcn',@clickmarker) %Change this with rectangle that's filled 

function area_explored = dragmarker(fig,ev,src)
global x 
global y
global points
global point_count

%This calculates the area explored by the user
x_range = range(points(:,1));
y_range = range(points(:,2));
area_explored = x_range * y_range;

%get current axes and coords
%h2 = findall(groot,'Type','Axes');
buttonID = src.Tag;              %Sets the tag for the buttons 
stateII= str2num(buttonID);      %Converts the tag to a state 
if  stateII == 1
    %disp("pin1")
    h1 = gco;
    x = h1.XData;
    y = h1.YData;
end
try
    h1 = gca;
    x = h1.Children.XData;
    y = h1.Children.YData;
    %disp("pin2")
catch
    try
        x = h1.Children(2).XData;
        y = h1.Children(2).YData;
        %disp("pin3")
    catch
    end
end
%coords=get(h1,'currentpoint');
xy = get(gca,'CurrentPoint');
x_curr = xy(1,1);
y_curr = xy(1,2);
%get all x and y data 

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

%Callback For Pin & Next Buttons

function button_callback(src,~,handles,area_explored)
global x
global y
global area
global points
global point_count
global trial_count


buttonID = src.Tag;              %Sets the tag for the buttons 
stateII = str2num(buttonID);    %Converts the tag to a state 

if (handles.num_pins == 3) || (area_explored > area)
     h = findall(gca,'Type','rectangle'); % use a tag to search for each pin 
     delete(h) % Removes all the pins
     handles.hbutton1.Enable = 'off';
     handles.hbutton2.Enable = 'on';
     pause(5/1000)
     points(point_count,3) = 2;
     trial_count = trial_count +1;
     handles.num_pins = 0;
     handles.area_explored = 0;
else
    if  stateII == 1 % Dropping a pin 
        xy = get(gca,'CurrentPoint');
        x = xy(1,1);
        y = xy(1,2);
        handles.num_pins = handles.num_pins + 1;
        %radius
        r = 1;
        c = [x y];
        pos = [c-r 2*r 2*r];
        rectangle('Position',pos,'Curvature',[1 1],'EdgeColor','r')
        x_curr = xy(1,1);
        y_curr = xy(1,2);
        point_count = point_count + 1;
        points(point_count,1) = x_curr; 
        points(point_count,2) = y_curr;
        points(point_count,3) = 1;
        drawnow limitrate
    elseif stateII == 2 % Next button
        handles.hbutton1.Enable = 'on';
        handles.hbutton2.Enable = 'off';
        handles.num_pins = 0;
        Y = [num_pins 'Next_button'];
        disp(Y)
    end
    drawnow
end




function clickmarker(src,ev)
set(ancestor(src,'figure'),'windowbuttonmotionfcn',{@dragmarker,src})
set(ancestor(src,'figure'),'windowbuttonupfcn',@stopdragging)

function stopdragging(fig,ev)
set(fig,'windowbuttonmotionfcn','')
set(fig,'windowbuttonupfcn','')