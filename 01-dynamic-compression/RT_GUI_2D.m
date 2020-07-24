function RT_GUI_2D
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
handles.hfig.WindowButtonMotionFcn = {@scatter_callback, handles};
handles.hbutton1.Callback = {@button_callback, handles};
handles.hbutton2.Callback = {@button_callback, handles};
handles.hbutton3.Callback = {@button_callback, handles};
end

% callback function for the slider
function slider_callback(src, ~, handles)

global openmha
global gaintable_og

% the first two input arguments are required for all callback function and
% the passed through variables start from the third and on. The first 
% variable ("src") is the handle for the source object (in this case the 
% slider). The second variable is rarely used, and one can simply put "~".
% From the third input argument and on, those are the variables passed to 
% the callback function from the main program.

handles.htxt.String = ['(',num2str(handles.hslider1.Value),', ',num2str(handles.hslider2.Value),')'] ;

slopeNoLog = handles.hslider2.Value;
slope = log10(slopeNoLog); %Log Scale

%Still a linear gain though 
M = -circshift(eye(6),1) + eye(6);
M(1,:) = 1/6;
G = M\[handles.hslider1.Value; slope*ones(5,1)];

gaintable_og = [[G(1) G(1) G(1)];[G(2) G(2) G(2)];[G(3) G(3) G(3)];...  %"Mapping"
    [G(4) G(4) G(4)];[G(5) G(5) G(5)];[G(6) G(6) G(6)];...
    [G(1) G(1) G(1)];[G(2) G(2) G(2)];[G(3) G(3) G(3)];...
    [G(4) G(4) G(4)];[G(5) G(5) G(5)];[G(6) G(6) G(6)]];

%Updates the gain table in openMHA based on state of the tag gain
    A = exist('Channel_RT_2D.mat');
    if A == 0
    t = now;
    d = datetime(t,'ConvertFrom','datenum'); 
    formatOut = 'HH:MM:SS';
    timestr = datestr(d,formatOut);
    Data = {G,timestr};
    mha_set(openmha,'mha.overlapadd.mhachain.dc.gtdata',gaintable_og);
    save('Channel_RT_2D.mat','Data');
    pause(0.001)
    else
    t = now;
    d = datetime(t,'ConvertFrom','datenum');
    formatOut = 'HH:MM:SS';
    timestr = datestr(d,formatOut);
    load('Channel_RT_2D.mat');
    Data{end+1,1} = G;
    Data{end,2} = timestr;
    mha_set(openmha,'mha.overlapadd.mhachain.dc.gtdata',gaintable_og);
    save('Channel_RT_2D.mat','Data','-append');
    pause(0.001);
    end
    pause(0.001);
    
% redraw the scatter plot
handles.hscatter.XData = x;
handles.hscatter.YData = y;

end




% callback function for the scatterplot
function scatter_callback(src, ~, handles)
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
end
end

%Callback For Buttons

function button_callback(src, ~,handles)

global openmha

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
    writematrix('Start_Time','DataLog_RT_2D.xlsx','Range','A1'); %Inputs the data
    writematrix(start_time,'DataLog_RT_2D.xlsx','Range','B1'); %Creates the log and label
    writematrix('Volume','DataLog_RT_2D.xlsx','Range','A3');
    writematrix('Timestamp','DataLog_RT.xlsx','Range','B3');
    writematrix('Slope','DataLog_RT_2D.xlsx','Range','C3');
    writematrix('Timestamp','DataLog_RT_2D.xlsx','Range','D3');
    
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
   writematrix('Stop_Time','DataLog_RT_2D.xlsx','Range','A2');
   writematrix(stop_time,'DataLog_RT_2D.xlsx','Range','B2');
   
   %Gain
   load('Channel_RT_2D.mat');
   Gain1 = Data(:,1);
   Time1 = Data(:,2);
   writecell(Gain1,'DataLog_RT_2D.xlsx','Range','A4:A100');
   writecell(Time1,'DataLog_RT_2D.xlsx','Range','B4:B100');
   
   close all;

end

end


