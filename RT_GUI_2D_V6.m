function RT_GUI_2D_V6
%This version has the iterative process another version of the clicks with guiInput

global openmha gt a D Glast x2max d
x2max = 20;
Glast = zeros(6,1);
a = randn(6,1);
a_val = a;
D = [];
D_vals = D;

formatOut = 31;
d = datestr(now, formatOut);
baseFileName = sprintf('%s, a values', d);
save(baseFileName,'a_val','D_vals');

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
% handles.htxt = uicontrol('style','text', ...
%     'unit', 'normalized', ...
%     'position' , [.35 .88 .3 .05], ...
%     'String', '0', ...
%     'fontsize', 32);

% add a slider 
handles.hslider1 = uicontrol('style','slider', ...
    'unit', 'normalized', ...
    'position' , [.3 .2 .4 .02], ...
    'Value', 0, 'max', 20, 'min', -20);   % "slider_callback" is the name for the callback function, the variable "handles" is passed through to the callback funciton

label1 = uicontrol('Parent',handles.hfig,'Style','text',... %This creates the label for the slider i.e 250 Hz 
    'Position',[300,25,100,725],...
    'String','Gain (dB)','fontsize',18);

% add a second, slider, a slider is automatically
% generated with the width is smaller than height for the property
% "position".

%Y axis slider
handles.hslider2 = uicontrol('style','slider', ...
    'unit', 'normalized', ...
    'position' , [.25 .25 .02 .6], ...
    'Value', 0, 'max', x2max, 'min',-x2max);   % "slider_callback" is the name for the callback function, the variable "handles" is passed through to the callback funciton

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
handles.hfig.ButtonDownFcn = {@scatter_callback, handles};
handles.hbutton1.Callback = {@button_callback, handles};
handles.hbutton2.Callback = {@button_callback, handles};
handles.hbutton3.Callback = {@button_callback, handles};
end

%Callback For Start, Stop, Quit Buttons

function button_callback(src, ~,handles)
global openmha

buttonID = src.Tag;              %Sets the tag for the buttons 
stateII= str2num(buttonID);      %Converts the tag to a state 

if  stateII == 1
    
    t = now;
    d = datetime(t,'ConvertFrom','datenum');
    formatOut = 'HH:MM:SS FFF';
    timestr = string(datestr(d,formatOut));
    startstr = "Start_Time";
    TimeStamp = {startstr timestr};
    save('TimeStamp_2D_V6.mat','TimeStamp');
    
    mha_set(openmha,'cmd','start');     %Starts openMHA
    set(handles.hbutton1,'enable','off');   
    set(handles.hbutton2,'enable','on');
    set(handles.hbutton3,'enable','on');
    
elseif stateII == 2
   mha_set(openmha,'cmd','stop');       %Stops openMHA
   set(handles.hbutton2,'enable','off');
   set(handles.hbutton1,'enable','on');
   set(handles.hbutton3,'enable','on');
   
else stateII == 3
    
    load('TimeStamp_2D_V6.mat');
    t = now;
    d = datetime(t,'ConvertFrom','datenum');
    formatOut = 'HH:MM:SS FFF';
    timestr = string(datestr(d,formatOut));
    stopstr = "Stop_Time";
    TimeStamp{2,1} = stopstr;
    TimeStamp{2,2} = timestr;
    save('TimeStamp_2D_V6.mat','TimeStamp');
    
    mha_set(openmha,'cmd','stop');
    mha_set(openmha,'cmd','quit');       %Quits openMHA
    set(handles.hbutton2,'enable','off');
    set(handles.hbutton1,'enable','off');
    set(handles.hbutton3,'enable','on');
   
   
end
end

% callback function for the sliders
function slider_callback(src, ~, handles)
global openmha a gt Glast D x2max d


% the first two input arguments are required for all callback function and
% the passed through variables start from the third and on. The first 
% variable ("src") is the handle for the source object (in this case the 
% slider). The second variable is rarely used, and one can simply put "~".
% From the third input argument and on, those are the variables passed to 
% the callback function from the main program.

b = get(gcf,'selectiontype');
a_vals = [];

if strcmpi(b,'normal')
    xy = get(gca,'CurrentPoint');
    %Left click
    h = findobj('Type','Text');
    delete(h)
    text(xy(1,1),xy(1,2),'Stop!');
    mha_set(openmha,'cmd','stop');
    baseFileName = sprintf('%s, a values', d);
    load(baseFileName,'a_vals','D_vals');

    Glast = gt{end,2};
    D = [D;Glast'];
    a = a_value(D);
    a_vals(:,end+1) = a;
    D_vals = D;
    x2max = GUI2D_safetylim(Glast,a);
    save(baseFileName,'a_vals','D_vals');

    
elseif strcmpi(b,'alt')
    xy = get(gca,'CurrentPoint');
    % Right click
    h = findobj('Type','Text');
    delete(h)
    text(xy(1,1),xy(1,2),'Sound On!');
    mha_set(openmha,'cmd','start');
    
else
    xy = get(gca,'CurrentPoint');
    
    % Middle click
    xy = get(gca,'CurrentPoint');
    text(xy(1,1),xy(1,2),'Quit') % Middle click
    mha_set(openmha,'cmd','quit');
    
    close all;
    
end
end

% callback function for the scatterplot

function scatter_callback(src, ~, handles)
global openmha a gt Glast d


% check whether the current mouse position is within the plot
if src.CurrentPoint(1) >= 0.3 & src.CurrentPoint(1) <= 0.7 & ...
    src.CurrentPoint(2) >= 0.25 & src.CurrentPoint(2) <= 0.85
    pt_pos = handles.hplot.CurrentPoint;    % get the current coordinates
    x = pt_pos(1,1);
    y = pt_pos(1,2);
    %handles.htxt.String = ['(',num2str(x),', ',num2str(y),')'] ;
    
    % redraw the scatter plot
    handles.hscatter.XData = x;
    handles.hscatter.YData = y;
    % update the slider positions
    handles.hslider1.Value = x;
    handles.hslider2.Value = y;
    set(handles.hscatter,'buttondownfcn',@slider_callback);
    
%     roi = drawcrosshair();
%     Hmatch = findobj(handles.hfig);
    
    x2 = handles.hslider1.Value;
    x1 = handles.hslider2.Value;
   
    
    B = exist("gaintable.mat");
    
    if B == 0
        
        trial = 0;
        G = Glast + x1 + x2*a;
        
        if any(G(:,1) > 30)
            mha_set(openmha,'cmd','stop');
            warning("Gain Too High")
        end
        
        gaintable_og = [ [G(1) G(1) G(1)];[G(2) G(2) G(2)];[G(3) G(3) G(3)];...  %"Mapping"
            [G(4) G(4) G(4)];[G(5) G(5) G(5)];[G(6) G(6) G(6)];...
            [G(1) G(1) G(1)];[G(2) G(2) G(2)];[G(3) G(3) G(3)];...
            [G(4) G(4) G(4)];[G(5) G(5) G(5)];[G(6) G(6) G(6)]];
        mha_set(openmha,'mha.overlapadd.mhachain.dc.gtdata',gaintable_og);
        gt = { trial G};
        save("gaintable.mat",'gt');
        
    else

        load("gaintable.mat",'gt');
        
        [trial,~] = size(gt);
        
        
        G = Glast + x1 + x2*a;
        
        if any(G(:,1) > 30)
            mha_set(openmha,'cmd','stop');
            warning("Gain Too High")
        end
        
        gaintable_og = [ [G(1) G(1) G(1)];[G(2) G(2) G(2)];[G(3) G(3) G(3)];...  %"Mapping"
            [G(4) G(4) G(4)];[G(5) G(5) G(5)];[G(6) G(6) G(6)];...
            [G(1) G(1) G(1)];[G(2) G(2) G(2)];[G(3) G(3) G(3)];...
            [G(4) G(4) G(4)];[G(5) G(5) G(5)];[G(6) G(6) G(6)]];
        mha_set(openmha,'mha.overlapadd.mhachain.dc.gtdata',gaintable_og);
        
        gt{end+1,2} = G;
        gt{end,1} = trial;
        save("gaintable.mat",'gt');
        
    end
    
end
end



