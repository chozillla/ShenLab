

function GUI_RT
global openmha

close all;
%Objects
%Setting Up The Correct Directories 

setenv('PATH', [getenv('PATH') ':/usr/local/bin']);         
addpath('/usr/local/lib/openmha/mfiles/')
javaaddpath('/usr/local/lib/openmha/mfiles/mhactl_java.jar')


openmha = mha_start;       %Starts openMHA software
mha_query(openmha,'','read:final_dc_live.cfg'); %Selects the .cfg file to read


%set up the boundaries of the layout
s = uipanel(figure('unit','normalized',...
    'position',[.1 .1 .8 .8]));

%set up sliders

handles.hsliderVolume = uicontrol('style','slider', ... %This sets up the slider
    'unit', 'normalized', ...
    'position' , [.25 .25 .02 .6],'Tag','1', ...
    'Value', 0,'min', -20,'max', 20,'SliderStep',[0.025 0.025]); 
label1 = uicontrol('Parent',s,'Style','text',... %This creates the label for the slider i.e 250 Hz 
    'Position',[300,25,100,725],...
    'String','Volume','fontsize',18);
handles.htxtGain1 = uicontrol('style','text', ... %This creates the textbox that shows the current gain value
    'unit', 'points', ...
    'position' , [330,0,40,200], ...
    'String', '0', ...
    'fontsize', 20);


handles.hsliderSlope = uicontrol('style','slider', ...
    'unit', 'normalized', ...
    'position' , [.35 .25 .02 .6],'Tag','2', ...
    'Value', 5.005,'min',0.01,'max',10,'SliderStep',[0.025 0.025]); 
label2 = uicontrol('Parent',s,'Style','text',...
    'Position',[435,25,100,725],...
    'String','Slope','fontsize',18);
handles.htxtGain2 = uicontrol('style','text', ...
    'unit', 'points', ...
    'position' , [465,0,40,200], ...
    'String', '0', ...
    'fontsize', 20);
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

handles.hsliderVolume.Callback = {@slider_callback, handles};
handles.hsliderSlope.Callback = {@slider_callback, handles};
handles.hbutton1.Callback = {@button_callback, handles};
handles.hbutton2.Callback = {@button_callback, handles};
handles.hbutton3.Callback = {@button_callback, handles};
end

%Callback Sliders

function slider_callback(src, ~,handles)
global openmha
global gaintable_og
volume = handles.hsliderVolume.Value;
slopeNoLog = handles.hsliderSlope.Value;
slope = log10(slopeNoLog); %Log Scale

handles.htxtGain1.String = num2str(volume); %Creates the string that allows the volume value to be shown 
handles.htxtGain2.String = num2str(slopeNoLog);  %Creates the string that allows the slope value to be shown 

x1 = volume;
x2 = slope;
M = -circshift(eye(6),1) + eye(6);
M(1,:) = 1/6;
G = M\[x1; x2*ones(5,1)];


gaintable_og = [[G(1) G(1) G(1)];[G(2) G(2) G(2)];[G(3) G(3) G(3)];...  %"Mapping"
    [G(4) G(4) G(4)];[G(5) G(5) G(5)];[G(6) G(6) G(6)];...
    [G(1) G(1) G(1)];[G(2) G(2) G(2)];[G(3) G(3) G(3)];...
    [G(4) G(4) G(4)];[G(5) G(5) G(5)];[G(6) G(6) G(6)]];

mha_set(openmha,'mha.overlapadd.mhachain.dc.gtdata',gaintable_og);

end


%Callback For Buttons

function button_callback(src, ~,handles)

global openmha
global gaintable_og

buttonID = src.Tag;              %Sets the tag for the buttons 
stateII= str2num(buttonID);      %Converts the tag to a state 

if  stateII == 1
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
   mha_set(openmha,'cmd','stop');       
   mha_set(openmha,'cmd','quit');       %Quits openMHA
   set(handles.hbutton2,'enable','off');
   set(handles.hbutton1,'enable','off');
   set(handles.hbutton3,'enable','on');
   save('Mapping','gaintable_og');
   close all;
end

end



