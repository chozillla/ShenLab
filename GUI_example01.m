function GUI_example01()
% an simple example of setting up uicontrols in a GUI

% close all windows
close all;

% creat the main window, for more settings check "Figure Properties".
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
    'Value', 0, 'max', 40, 'min', -40);   % "slider_callback" is the name for the callback function, the variable "handles" is passed through to the callback funciton

% add a second, vertical slider, a verical slider is automatically
% generated with the width is smaller than height for the property
% "position".
handles.hslider2 = uicontrol('style','slider', ...
    'unit', 'normalized', ...
    'position' , [.25 .25 .02 .6], ...
    'Value', 0, 'max', 40, 'min', -40);   % "slider_callback" is the name for the callback function, the variable "handles" is passed through to the callback funciton

% add a graph
handles.hplot = axes('position', [0.3 0.25 0.4 0.6]);
% plot a red dot at the default slider locations
x = handles.hslider1.Value;
y = handles.hslider2.Value;
handles.hscatter = scatter(handles.hplot,x,y,200,'ro','MarkerFaceColor','r');
axis([-40 40 -40 40]);

% define all the callback functions. Note that since all the handles are
% passed to the callback function. These objects (the sliders and the
% scatterplot) need to be defined first.
handles.hslider1.Callback = {@slider_callback, handles};
handles.hslider2.Callback = {@slider_callback, handles};
handles.hfig.WindowButtonMotionFcn = {@scatter_callback, handles};

% callback function for the slider
function slider_callback(src, ~, handles)
% the first two input arguments are required for all callback function and
% the passed through variables start from the third and on. The first 
% variable ("src") is the handle for the source object (in this case the 
% slider). The second variable is rarely used, and one can simply put "~".
% From the third input argument and on, those are the variables passed to 
% the callback function from the main program.

x = handles.hslider1.Value;
y = handles.hslider2.Value;
handles.htxt.String = ['(',num2str(x),', ',num2str(y),')'] ;
% redraw the scatter plot
handles.hscatter.XData = x;
handles.hscatter.YData = y;

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



