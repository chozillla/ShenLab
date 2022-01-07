function dragpoints_2_v6(xData,yData,xLower,xUpper,yLower,yUpper)
global openmha
global trial_num

%Setting Up The Correct Directories 

% setenv('PATH', [getenv('PATH') ':/usr/local/bin']); % Make sure to change this to your appropiate directory        
% addpath('/usr/local/lib/openmha/mfiles/') % Make sure to change this to your appropiate directory        
% javaaddpath('/usr/local/lib/openmha/mfiles/mhactl_java.jar') % Make sure to change this to your appropiate directory        
% 
% openmha = mha_start;       % initializes openMHA software
% mha_query(openmha,'','read:final_dc_live.cfg'); % selects the .cfg file to read
% mha_set(openmha,'cmd','start'); % starts openMHA software

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
    'innerposition',[0.065 0.55 .15 .15],'fontname','Arial',...
    'fontsize',55,'backgroundcolor','green','string','Pin','Tag','1');
handles.hbutton2 = uicontrol('style','pushbutton',...,  % creates the "Next" button with the various properties
    'unit','normalized',...,
    'innerposition',[0.065 0.25 .15 .15],'fontname','Arial',...
    'fontsize',55,'backgroundcolor','blue','string','Next','Tag','2','Enable','Off');
% add a textbox, for more settings check "Uicontrol Properties".
handles.htxt = uicontrol('style','text', ...
    'unit', 'normalized', ...
    'position' , [.35 .93 .3 .05], ...
    'String', 'Trial 0 out of 50', ...
    'fontsize', 28);

hObject1 = handles.hbutton1;    % creates the button object
hObject2 = handles.hbutton2;    % creates the button object

guidata(hObject1, handles);     
guidata(hObject2, handles);

x = xData;
y = yData;

ax = axes('xlimmode','manual','ylimmode','manual');
ax.XLim = [xLower xUpper];
ax.YLim = [yLower yUpper];

handles.hbutton1.Callback = {@button_callback, handles}; 
handles.hbutton2.Callback = {@button_callback, handles};
axis square
line(x,y,'color','c','marker','.','markersize',105,'hittest','on','buttondownfcn',@clickmarker) %Change this with rectangle that's filled 

%Callback For Pin & Next Buttons

function button_callback(src,~,handles)
global a
global x
global y
global G
global num_pins
global openmha
global data
global pin_count
global next
global trial_num

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
     data{2,1,pin_count} = G; % saving gain table to the data structure
     data{3,1,pin_count} = x; % saving x coordinate to the data structure
     data{4,1,pin_count} = y; % saving y coordinate to the data structure
     data{5,1,pin_count} = 2; % saving weight when there's a pin dropped
     num_pins = 0; % resets the number of pins back to  at the end of the trial
%      mha_set(openmha,'cmd','stop');
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
        trial_num = length(index);
        if trial_num > 50
            close all
        end
        handles.htxt.String = sprintf('Trial %d out of 50',trial_num);
        next = data(:,:,index(end,1));
        % moves the cursor to the origin
        h = findall(gca,'Type','line'); %this is the cursor 
        set(h,'XData',0)    % setting the x coordinate to 0
        set(h,'Ydata',0)    % setting the y coordinate to 0 
%         mha_set(openmha,'cmd','start');
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
global data
global G
global pin_count

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
    
    if pin_count < 5
        G = Glast + x1 + x2*a; % this is the formula that creates the gains
        if any(G(:,1) > 30)
            g_new_idx = G > 30;
            G(g_new_idx,1) = 20; % set to 20 dB max
            warning("Gain Too High")
        end
        gaintable_og = [ [G(1) G(1) G(1)];[G(2) G(2) G(2)];[G(3) G(3) G(3)];...  %"Mapping"
                    [G(4) G(4) G(4)];[G(5) G(5) G(5)];[G(6) G(6) G(6)];...
                    [G(1) G(1) G(1)];[G(2) G(2) G(2)];[G(3) G(3) G(3)];...
                    [G(4) G(4) G(4)];[G(5) G(5) G(5)];[G(6) G(6) G(6)]];
%         mha_set(openmha,'mha.overlapadd.mhachain.dc.gtdata',gaintable_og);
    else
        flag = cell2mat(data(5,1,:));
        index = find(flag == 2);
        w = data(:,:,index(end,1));
        Glast = w(2,1);
        G = cell2mat(Glast) + x1 + x2*a;
        if any(G(:,1) > 30)
            g_new_idx = G > 30;
            G(g_new_idx,1) = 20; % set to 20 dB max
            warning("Gain Too High")
        end
        gaintable_og = [ [G(1) G(1) G(1)];[G(2) G(2) G(2)];[G(3) G(3) G(3)];...  %"Mapping"
                    [G(4) G(4) G(4)];[G(5) G(5) G(5)];[G(6) G(6) G(6)];...
                    [G(1) G(1) G(1)];[G(2) G(2) G(2)];[G(3) G(3) G(3)];...
                    [G(4) G(4) G(4)];[G(5) G(5) G(5)];[G(6) G(6) G(6)]];
%         mha_set(openmha,'mha.overlapadd.mhachain.dc.gtdata',gaintable_og);
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