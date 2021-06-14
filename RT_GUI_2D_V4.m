function RT_GUI_2D_V4
%This version has the iterative process
global openmha

%Setting Up The Correct Directories 

setenv('PATH', [getenv('PATH') ':/usr/local/bin']);         
addpath('/usr/local/lib/openmha/mfiles/')
javaaddpath('/usr/local/lib/openmha/mfiles/mhactl_java.jar')

openmha = mha_start;       %Starts openMHA software
mha_query(openmha,'','read:final_dc_live.cfg'); %Selects the .cfg file to read

% an simple example of setting up uicontrols in a GUI

% close all windows
close all;

% create the main window, for more settings check "Figure Properties".
handles.hfig = figure('unit','normalized',...
    'position',[.1 .1 .8 .8]);

% add a textbox, for more settings check "Uicontrol Properties".
handles.htxt = uicontrol('style','text', ...
    'unit', 'normalized', ...
    'position' , [.35 .88 .3 .05], ...
    'String', '0', ...
    'fontsize', 32);

% add a slider
handles.hslider1 = uicontrol('style','slider', ...
    'unit', 'normalized', ...
    'position' , [.3 .2 .4 .02], ...
    'Value', 0, 'max', 20, 'min', -20);   % "slider_callback" is the name for the callback function, the variable "handles" is passed through to the callback funciton

label1 = uicontrol('Parent',handles.hfig,'Style','text',... %This creates the label for the slider i.e 250 Hz 
    'Position',[300,25,100,725],...
    'String','Gain (dB)','fontsize',18);

% add a second, vertical slider, a verical slider is automatically
% generated with the width is smaller than height for the property
% "position".
handles.hslider2 = uicontrol('style','slider', ...
    'unit', 'normalized', ...
    'position' , [.25 .25 .02 .6], ...
    'Value', 0, 'max', 20, 'min', -20);   % "slider_callback" is the name for the callback function, the variable "handles" is passed through to the callback funciton

label2 = uicontrol('Parent',handles.hfig,'Style','text',...
    'Position',[950,25,100,175],...
    'String','Slope (dB/octave)','fontsize',18);

% add a graph
handles.hplot = axes('position', [0.3 0.25 0.4 0.6]);
% plot a red dot at the default slider locations
x = handles.hslider1.Value;
y = handles.hslider2.Value;
handles.hscatter = scatter(handles.hplot,x,y,200,'ro','MarkerFaceColor','r');
axis([-20 20 -20 20]);

%set up start button

handles.hbutton1 = uicontrol('style','pushbutton',...,
    'unit','normalized',...,
    'innerposition',[0.05 0.05 .15 .15],'fontname','Arial',...
    'fontsize',36,'backgroundcolor','green','string','Start','Tag','1');
    
%set up stop button

handles.hbutton2 = uicontrol('style','pushbutton',...,
    'unit','normalized',...,
    'innerposition',[0.8 0.05 .15 .15],'fontname','Arial',...
        'fontsize',36,'backgroundcolor','red','string','Stop','Tag','2','Enable','Off');

%set up quit button

handles.hbutton3 = uicontrol('style','pushbutton',...,
    'unit','normalized',...,
    'innerposition',[0.45 0.05 .15 .15],'fontname','Arial',...
    'fontsize',36,'backgroundcolor','blue','string','Quit','Tag','3','Enable','Off');

% define all the callback functions. Note that since all the handles are
% passed to the callback function. These objects (the sliders and the
% scatterplot) need to be defined first.
handles.hslider1.Callback = {@slider_callback, handles};
handles.hslider2.Callback = {@slider_callback, handles};
handles.hslider1.Callback = {@cursor_stop, handles};
handles.hslider2.Callback = {@cursor_stop, handles};
handles.hfig.WindowButtonMotionFcn = {@scatter_callback, handles};
handles.hfig.ButtonDownFcn = {@scatter_callback, handles};
handles.hbutton1.Callback = {@button_callback, handles};
handles.hbutton2.Callback = {@button_callback, handles};
handles.hbutton3.Callback = {@button_callback, handles};
end

function cursor_stop(src, ~, handles)
global openmha
global a
global timestra

b = get(gcf,'selectiontype');
xy = get(gca,'CurrentPoint');

x = handles.hslider1.Value;
y = handles.hslider2.Value;

x1 = y;
x2 = x;

G = x1 + diag(a).*[x2;x2;x2;x2;x2;x2];
gaintable_og = [ [G(1) G(1) G(1)];[G(2) G(2) G(2)];[G(3) G(3) G(3)];...  %"Mapping"
    [G(4) G(4) G(4)];[G(5) G(5) G(5)];[G(6) G(6) G(6)];...
    [G(1) G(1) G(1)];[G(2) G(2) G(2)];[G(3) G(3) G(3)];...
    [G(4) G(4) G(4)];[G(5) G(5) G(5)];[G(6) G(6) G(6)]];
mha_set(openmha,'mha.overlapadd.mhachain.dc.gtdata',gaintable_og);


if strcmpi(b,'normal')
    %Left click
    mha_set(openmha,'cmd','stop');
    load('Gain_2D_V4.mat');
    a = randn(6,1);
    a = a/sqrt(sum(a.^2));
    t = now;
    d = datetime(t,'ConvertFrom','datenum'); 
    formatOut = 'HH:MM:SS FFF';
    timestra = string(datestr(d,formatOut));
    T_aValue = timestra;
    A_value = a;
    save('Gain_2D_V4.mat','A_value','T_aValue');
    
    
elseif strcmpi(b,'alt')
    %Right click
    mha_set(openmha,'cmd','start');
    mha_set(openmha,'mha.overlapadd.mhachain.dc.gtdata',gaintable_og);
    
else
    % Middle click
    mha_set(openmha,'cmd','quit');
    load('Gain_2D_V4.mat');
    Gain = UserData(:,1);
    Time = UserData(:,2);
    Slope = UserData(:,3);
    writematrix(Gain,'DataLog_RT_2D_V4.xlsx','Range','A4:A1000');
    writematrix(Slope,'DataLog_RT_2D_V4.xlsx','Range','B4:B1000');
    writematrix(Time,'DataLog_RT_2D_V4.xlsx','Range','C4:C1000');
    close all;
    
end
   
end

% callback function for the sliders
function slider_callback(src, ~, handles)

% the first two input arguments are required for all callback function and
% the passed through variables start from the third and on. The first 
% variable ("src") is the handle for the source object (in this case the 
% slider). The second variable is rarely used, and one can simply put "~".
% From the third input argument and on, those are the variables passed to 
% the callback function from the main program.

%slope = log10(slopeNoLog); %Log Scale

x = handles.hslider1.Value;
y = handles.hslider2.Value;
handles.htxt.String = ['(',num2str(x),', ',num2str(y),')'] ;
    
% redraw the scatter plot
handles.hscatter.XData = x;
handles.hscatter.YData = y;
end

% callback function for the scatterplot
function scatter_callback(src, ~, handles)
global openmha
global a
global timestra

% check whether the current mouse position is within the plot
if src.CurrentPoint(1) >= 0.3 & src.CurrentPoint(1) <= 0.7 & ...
    src.CurrentPoint(2) >= 0.25 & src.CurrentPoint(2) <= 0.85
    pt_pos = handles.hplot.CurrentPoint;    % get the current coordinates
    x = pt_pos(1,1);
    y = pt_pos(1,2);
    handles.htxt.String = ['(',num2str(x),', ',num2str(y),')'] ;
    
    % redraw the scatter plot
    handles.hscatter.XData = x;
    handles.hscatter.YData = y;
    % update the slider positions
    handles.hslider1.Value = x;
    handles.hslider2.Value = y;
    set(handles.hscatter,'buttondownfcn',@cursor_stop);
% M = -circshift(eye(6),1) + eye(6);
% M(1,:) = 1/6;
% G = M\[y; slopeNoLog*ones(5,1)];

x1 = y;
x2 = x;

% G(1) = x1 + a(1)*x2;   %This is what G equation looks like
% G(2) = x1 + a(2)*x2 ;
% G(3) = x1 + a(3)*x2;
% G(4) = x1 + a(4)*x2;
% G(5) = x1 + a(5)*x2;
% G(6) = x1 + a(6)*x2;

G = x1 + diag(a).*[x2;x2;x2;x2;x2;x2];
%G = G_last + x1 + diag(a).*[x2;x2;x2;x2;x2;x2];

gaintable_og = [ [G(1) G(1) G(1)];[G(2) G(2) G(2)];[G(3) G(3) G(3)];...  %"Mapping"
    [G(4) G(4) G(4)];[G(5) G(5) G(5)];[G(6) G(6) G(6)];...
    [G(1) G(1) G(1)];[G(2) G(2) G(2)];[G(3) G(3) G(3)];...
    [G(4) G(4) G(4)];[G(5) G(5) G(5)];[G(6) G(6) G(6)]];
mha_set(openmha,'mha.overlapadd.mhachain.dc.gtdata',gaintable_og);

%Updates the gain table in openMHA based on state of the tag gain
    countt = 0;
    count = 0;
    if countt == 0
    load('Gain_2D_V4.mat');
    t = now;
    d = datetime(t,'ConvertFrom','datenum'); 
    formatOut = 'HH:MM:SS FFF';
    timestr = string(datestr(d,formatOut));
    UserData = [y timestr x];
    mha_set(openmha,'mha.overlapadd.mhachain.dc.gtdata',gaintable_og);
    A_value = a;
    T_aValue = timestra;
    save('Gain_2D_V4.mat','UserData','A_value','T_aValue','-append');
    countt = count + 1;
    
    else
    load('Gain_2D_V4.mat');
    t = now;
    d = datetime(t,'ConvertFrom','datenum'); 
    formatOut = 'HH:MM:SS FFF';
    timestr = string(datestr(d,formatOut));
    UserData(end+1,1) = y; %Gain
    UserData(end,2) = timestr; %Timestamp
    UserData(end,3) = x; %Slope
    A_value = a;
    t = now;
    d = datetime(t,'ConvertFrom','datenum'); 
    formatOut = 'HH:MM:SS FFF';
    timestra = string(datestr(d,formatOut));
    T_aValue(end+1,1) = timestra;
    mha_set(openmha,'mha.overlapadd.mhachain.dc.gtdata',gaintable_og);
    save('Gain_2D_V4.mat','UserData','A_value','T_aValue','-append');
    end
end
end

%Callback For Buttons

function button_callback(src, ~,handles)
global openmha
global a 
global timestra

buttonID = src.Tag;              %Sets the tag for the buttons 
stateII= str2num(buttonID);      %Converts the tag to a state 

if  stateII == 1
    
    mha_set(openmha,'cmd','start');     %Starts openMHA
    set(handles.hbutton1,'enable','off');   
    set(handles.hbutton2,'enable','on');
    set(handles.hbutton3,'enable','on');
    
    t_start = now;    %Time when the GUI was started                                
    starttime = datetime(t_start,'ConvertFrom','datenum');
    formatOut = 'HH:MM:SS';
    start_time = datestr(starttime,formatOut);%Converts it 
    writematrix('Start_Time','DataLog_RT_2D_V4.xlsx','Range','A1'); %Inputs the data
    writematrix(start_time,'DataLog_RT_2D_V4.xlsx','Range','B1'); %Creates the log and label
    writematrix('Volume','DataLog_RT_2D_V4.xlsx','Range','A3');
    writematrix('Slope','DataLog_RT_2D_V4.xlsx','Range','B3');
    writematrix('Time','DataLog_RT_2D_V4.xlsx','Range','C3');
    writematrix('a value','DataLog_RT_2D_V4.xlsx','Range','D1');
    writematrix(a,'DataLog_RT_2D_V4.xlsx','Range','D2');
    
    a = randn(6,1);
    a = (a)/sqrt(sum(a.^2));
    A_value = a;
    timestra = starttime;
    y = 0;
    x = 0;
    t = now;
    d = datetime(t,'ConvertFrom','datenum'); 
    formatOut = 'HH:MM:SS FFF';
    timestr = string(datestr(d,formatOut));
    UserData = [y timestr x];
    save('Gain_2D_V4.mat','UserData','A_value','starttime');
    
elseif stateII == 2
   mha_set(openmha,'cmd','stop');       %Stops openMHA
   set(handles.hbutton2,'enable','off');
   set(handles.hbutton1,'enable','on');
   set(handles.hbutton3,'enable','on');
   
else stateII == 3
   mha_set(openmha,'cmd','stop');       
   mha_set(openmha,'cmd','quit');       %Quits openMHA
   set(handles.hbutton2,'enable','off');
   set(handles.hbutton1,'enable','off');
   set(handles.hbutton3,'enable','on');
   
   t_quit = now;
   stopttime = datetime(t_quit,'ConvertFrom','datenum');
   formatOut = 'HH:MM:SS';
   stop_time = datestr(stopttime,formatOut);
   writematrix('Stop_Time','DataLog_RT_2D_V4.xlsx','Range','A2');
   writematrix(stop_time,'DataLog_RT_2D_V4.xlsx','Range','B2');
   
   %Final Save
   load('Gain_2D_V4.mat');
   Gain = UserData(:,1);
   Time = UserData(:,2);
   Slope = UserData(:,3);
   writematrix(Gain,'DataLog_RT_2D_V4.xlsx','Range','A4:A1000');
   writematrix(Slope,'DataLog_RT_2D_V4.xlsx','Range','B4:B1000');
   writematrix(Time,'DataLog_RT_2D_V4.xlsx','Range','C4:C1000');
   close all;

end
end
