function RT_GUI_2D_V5
%This version has the iterative process another version of the clicks
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
    'Value', 0, 'max', 5, 'min', -5);   % "slider_callback" is the name for the callback function, the variable "handles" is passed through to the callback funciton

label1 = uicontrol('Parent',handles.hfig,'Style','text',... %This creates the label for the slider i.e 250 Hz 
    'Position',[300,25,100,725],...
    'String','Gain (dB)','fontsize',18);

% add a second, vertical slider, a verical slider is automatically
% generated with the width is smaller than height for the property
% "position".
handles.hslider2 = uicontrol('style','slider', ...
    'unit', 'normalized', ...
    'position' , [.25 .25 .02 .6], ...
    'Value', 0, 'max', 5, 'min', -5);   % "slider_callback" is the name for the callback function, the variable "handles" is passed through to the callback funciton

label2 = uicontrol('Parent',handles.hfig,'Style','text',...
    'Position',[950,25,100,175],...
    'String','Slope (dB/octave)','fontsize',18);

% add a graph
handles.hplot = axes('position', [0.3 0.25 0.4 0.6]);
% plot a red dot at the default slider locations
x = handles.hslider1.Value;
y = handles.hslider2.Value;
handles.hscatter = scatter(handles.hplot,x,y,200,'ro','MarkerFaceColor','r');
axis([-5 5 -5 5]);

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

%Callback For Buttons

function button_callback(src, ~,handles)
global openmha

buttonID = src.Tag;              %Sets the tag for the buttons 
stateII= str2num(buttonID);      %Converts the tag to a state 

if  stateII == 1
    
    t = now;
    d = datetime(t,'ConvertFrom','datenum');
    formatOut = 'HH:MM:SS FFF';
    timestr = string(datestr(d,formatOut));
    a = randn(6,1);
    a = a/sqrt(sum(a.^2));
    a = { a timestr };
    save('a_2D_V5.mat','a');
    
    mha_set(openmha,'cmd','start');     %Starts openMHA
    set(handles.hbutton1,'enable','off');   
    set(handles.hbutton2,'enable','on');
    set(handles.hbutton3,'enable','on');
    
    writematrix('Start Time','DataLog_RT_2D_V5.xlsx','Range','A1'); %Inputs the data
    writematrix(timestr,'DataLog_RT_2D_V5.xlsx','Range','B1'); %Creates the log and label
    writematrix('Volume','DataLog_RT_2D_V5.xlsx','Range','A3');
    writematrix('Slope','DataLog_RT_2D_V5.xlsx','Range','B3');
    writematrix('Time','DataLog_RT_2D_V5.xlsx','Range','C3');
    writematrix('a value','DataLog_RT_2D_V5.xlsx','Range','D1');
    writecell(a,'DataLog_RT_2D_V5.xlsx','Range','D2');
   
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
   
%    t = now;
%    d = datetime(t,'ConvertFrom','datenum');
%    formatOut = 'HH:MM:SS FFF';
%    timestop = string(datestr(d,formatOut));
%    writematrix('Stop Time','DataLog_RT_2D_V5.xlsx','Range','A2');
%    writematrix(timestop,'DataLog_RT_2D_V5.xlsx','Range','B2');
   
   %Final Save
%    load('Gain_2D_V5.mat');
%    Gain = UserData(:,1);
%    Time = UserData(:,2);
%    Slope = UserData(:,3);
%    writematrix(Gain,'DataLog_RT_2D_V5.xlsx','Range','A4:A1000');
%    writematrix(Slope,'DataLog_RT_2D_V5.xlsx','Range','B4:B1000');
%    writematrix(Time,'DataLog_RT_2D_V5.xlsx','Range','C4:C1000');
%    close all;

end
end

% callback function for the sliders
function slider_callback(src, ~, handles)
global openmha

% the first two input arguments are required for all callback function and
% the passed through variables start from the third and on. The first 
% variable ("src") is the handle for the source object (in this case the 
% slider). The second variable is rarely used, and one can simply put "~".
% From the third input argument and on, those are the variables passed to 
% the callback function from the main program.

%slope = log10(slopeNoLog); %Log Scale

% x = handles.hslider1.Value;
% y = handles.hslider2.Value;
% handles.htxt.String = ['(',num2str(x),', ',num2str(y),')'] ;
    
% redraw the scatter plot
% handles.hscatter.XData = x;
% handles.hscatter.YData = y;

b = get(gcf,'selectiontype');
if strcmpi(b,'normal')
xy = get(gca,'CurrentPoint');

    %Left click
    text(xy(1,1),xy(1,2),'Stop') %Left click
    mha_set(openmha,'cmd','stop');
    t = now;
    d = datetime(t,'ConvertFrom','datenum');
    formatOut = 'HH:MM:SS FFF';
    timestr = string(datestr(d,formatOut));
    load('a_2D_V5.mat');
    [x,~] = size(a);
    w = randn(6,1);
    w = w/sqrt(sum(w.^2));
    a{x+1,1} = w;
    a{x+1,2} = timestr;
    save('a_2D_V5.mat','a');
    
elseif strcmpi(b,'alt')
    xy = get(gca,'CurrentPoint');
    text(xy(1,1),xy(1,2),'Start') %Right click
    mha_set(openmha,'cmd','start');

else
    xy = get(gca,'CurrentPoint');
    text(xy(1,1),xy(1,2),'Quit') % Middle click
    mha_set(openmha,'cmd','quit');
    close all;
    
end
end
% callback function for the scatterplot

function scatter_callback(src, ~, handles)
global openmha

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
    set(handles.hscatter,'buttondownfcn',@slider_callback);
% M = -circshift(eye(6),1) + eye(6);
% M(1,:) = 1/6;
% G = M\[y; slopeNoLog*ones(5,1)];

x1 = y;
x2 = x;

B = exist('gaintable.mat');
if B == 0
    trial = 0;
    G0 = zeros(6,1);
    load('a_2D_V5.mat');
    [x,~] = size(a);
    a = a{x,1};
    G = G0;
    gaintable_og = [ [G(1) G(1) G(1)];[G(2) G(2) G(2)];[G(3) G(3) G(3)];...  %"Mapping"
        [G(4) G(4) G(4)];[G(5) G(5) G(5)];[G(6) G(6) G(6)];...
        [G(1) G(1) G(1)];[G(2) G(2) G(2)];[G(3) G(3) G(3)];...
        [G(4) G(4) G(4)];[G(5) G(5) G(5)];[G(6) G(6) G(6)]];
    mha_set(openmha,'mha.overlapadd.mhachain.dc.gtdata',gaintable_og);
    gt = { trial G};
    save('gaintable.mat','gt');
else
    load('gaintable.mat');
    [trial,~] = size(gt);
    load('a_2D_V5.mat');
    [x,~] = size(a);
    a = a{x,1};
    G_Last = gt(end,2);
    G_Last_M = cell2mat(G_Last);
    G = G_Last_M + x1 + a*x2;
    gaintable_og = [ [G(1) G(1) G(1)];[G(2) G(2) G(2)];[G(3) G(3) G(3)];...  %"Mapping"
        [G(4) G(4) G(4)];[G(5) G(5) G(5)];[G(6) G(6) G(6)];...
        [G(1) G(1) G(1)];[G(2) G(2) G(2)];[G(3) G(3) G(3)];...
        [G(4) G(4) G(4)];[G(5) G(5) G(5)];[G(6) G(6) G(6)]];
    mha_set(openmha,'mha.overlapadd.mhachain.dc.gtdata',gaintable_og);
    gt{end+1,2} = G;
    gt{end,1} = trial;
    save('gaintable.mat','gt');
end

%Updates the gain table in openMHA based on state of the tag gain

    A = exist('Gain_2D_V2.mat');
    if A == 0
    t = now;
    d = datetime(t,'ConvertFrom','datenum'); 
    formatOut = 'HH:MM:SS FFF';
    timestr = string(datestr(d,formatOut));
    UserData = [y timestr x];
    mha_set(openmha,'mha.overlapadd.mhachain.dc.gtdata',gaintable_og);
    save('Gain_2D_V2.mat','UserData');
    else
    t = now;
    d = datetime(t,'ConvertFrom','datenum');
    formatOut = 'HH:MM:SS FFF';
    timestr = string(datestr(d,formatOut));
    load('Gain_2D_V2.mat');
    UserData(end+1,1) = y;
    UserData(end,2) = timestr;
    UserData(end,3) = x;
    mha_set(openmha,'mha.overlapadd.mhachain.dc.gtdata',gaintable_og);
    save('Gain_2D_V2.mat','UserData','-append');
    end
end
end

% % callback function for the scatterplot
% function scatter_callback(src, ~, handles)
% global openmha
% 
%     
% % check whether the current mouse position is within the plot
% if src.CurrentPoint(1) >= 0.3 & src.CurrentPoint(1) <= 0.7 & ...
%     src.CurrentPoint(2) >= 0.25 & src.CurrentPoint(2) <= 0.85
%     pt_pos = handles.hplot.CurrentPoint;    % get the current coordinates
%     x = pt_pos(1,1);
%     y = pt_pos(1,2);
%     handles.htxt.String = ['(',num2str(x),', ',num2str(y),')'] ;
%     
%     % redraw the scatter plot
%     handles.hscatter.XData = x;
%     handles.hscatter.YData = y;
%     % update the slider positions
%     handles.hslider1.Value = x;
%     handles.hslider2.Value = y;
%     set(handles.hscatter,'buttondownfcn',@scatter_callback);
% % M = -circshift(eye(6),1) + eye(6);
% % M(1,:) = 1/6;
% % G = M\[y; slopeNoLog*ones(5,1)];
% 
% 
% x1 = y;
% x2 = x; 
% load('a_2D_V5.mat');
% [x,~] = size(a);
% a = a{x,1};
% 
% % G(1) = x1 + a(1)*x2;   %This is what G equation looks like
% % G(2) = x1 + a(2)*x2 ;
% % G(3) = x1 + a(3)*x2;
% % G(4) = x1 + a(4)*x2;
% % G(5) = x1 + a(5)*x2;
% % G(6) = x1 + a(6)*x2;
% 
% G = x1 + diag(a).*[x2;x2;x2;x2;x2;x2];
% %G = G_last + x1 + diag(a).*[x2;x2;x2;x2;x2;x2];
% 
% gaintable_og = [ [G(1) G(1) G(1)];[G(2) G(2) G(2)];[G(3) G(3) G(3)];...  %"Mapping"
%     [G(4) G(4) G(4)];[G(5) G(5) G(5)];[G(6) G(6) G(6)];...
%     [G(1) G(1) G(1)];[G(2) G(2) G(2)];[G(3) G(3) G(3)];...
%     [G(4) G(4) G(4)];[G(5) G(5) G(5)];[G(6) G(6) G(6)]];
% mha_set(openmha,'mha.overlapadd.mhachain.dc.gtdata',gaintable_og);
% 
% %Updates the gain table in openMHA based on state of the tag gain
%     A = exist('Gain_2D_V5.mat');
%     if A == 0
%     t = now;
%     d = datetime(t,'ConvertFrom','datenum'); 
%     formatOut = 'HH:MM:SS FFF';
%     timestr = string(datestr(d,formatOut));
%     UserData = [y timestr x];
%     save('Gain_2D_V5.mat','UserData');
%     else
%     load('Gain_2D_V5.mat','UserData');
%     t = now;
%     d = datetime(t,'ConvertFrom','datenum');
%     formatOut = 'HH:MM:SS FFF';
%     timestr = string(datestr(d,formatOut));
%     UserData(end+1,1) = y;
%     UserData(end,2) = timestr;
%     UserData(end,3) = x;
%     save('Gain_2D_V5.mat','UserData','-append');
%     
%     end
% end
%     
% end


