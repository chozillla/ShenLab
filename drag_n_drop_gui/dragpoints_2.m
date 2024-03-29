function dragpoints_2(xData,yData,xLower,xUpper,yLower,yUpper)
global x
global y
global count 
global point_count 
global points
global area 

% Setting up default constants
if nargin == 0 
  xData = 0;
  yData = 0;
  xLower = -20;
  xUpper = 20;
  yLower = -20;
  yUpper = 20;
end

area = (1/3)*(20*20);
count = 0;
point_count = 0;
points = zeros(1000,2); % First column is x and the second is y 
assignin('base','points',points)
assignin('base','area',area)

%Setting Up The Correct Directories 

setenv('PATH', [getenv('PATH') ':/usr/local/bin']);         
addpath('/usr/local/lib/openmha/mfiles/')
javaaddpath('/usr/local/lib/openmha/mfiles/mhactl_java.jar')

openmha = mha_start;       %Starts openMHA software
mha_query(openmha,'','read:final_dc_live.cfg'); %Selects the .cfg file to read

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

%can change the marker size or marker type to make it more visible.
%Currently is set to small points at a size of 2 so is not very visible.
hbutton1.Callback = {@button_callback, handles.hbutton1};
hbutton2.Callback = {@button_callback, handles.hbutton2};
line(x,y,'color','r','marker','.','markersize',105,'hittest','on','buttondownfcn',@clickmarker)

%Callback For Start, Stop, Quit Buttons

function button_callback(src, handles)
global x
global y
global count
global area_explored
global area

buttonID = src.Tag;              %Sets the tag for the buttons 
stateII= str2num(buttonID);      %Converts the tag to a state 

%Drops the pin when clicks "Save"
if (count == 3 || area_explored > area)
     handles.hbutton1.Enable = 'off';
     handles.hbutton2.Enable = 'on';
     %guidata(hObject1, handles);
     %guidata(hObject2, handles);
else
    if  stateII == 1 % Dropping a pin 
        count = count + 1;
        xy = get(gca,'CurrentPoint');
        x = xy(1,1);
        y = xy(1,2);
        %location = [x y]
        viscircles([x,y], 2); 
    end
end


function clickmarker(src,ev)
set(ancestor(src,'figure'),'windowbuttonmotionfcn',{@dragmarker,src})
set(ancestor(src,'figure'),'windowbuttonupfcn',@stopdragging)

function dragmarker(fig,ev,src)
global x 
global y
global points
global point_count
global area_explored

%This calculates the area explored by the user
x_range = range(points(:,1));
y_range = range(points(:,2));
area_explored = x_range * y_range;

%get current axes and coords
%h2 = findall(groot,'Type','Axes');
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

function stopdragging(fig, ev, ~)
set(fig,'windowbuttonmotionfcn','')
set(fig,'windowbuttonupfcn','')