function GUI
global openmha

%Setting Up The Correct Directories 

setenv('PATH', [getenv('PATH') ':/usr/local/bin']);         
addpath('/usr/local/lib/openmha/mfiles/')
javaaddpath('/usr/local/lib/openmha/mfiles/mhactl_java.jar')

openmha = mha_start;       %Starts openMHA software
mha_query(openmha,'','read:final_dc_live.cfg'); %Selects the .cfg file to read


%set up the boundaries of the layout
handles.hs = uipanel(figure('unit','normalized',...
    'position',[.1 .1 .8 .8]));

%set up sliders

handles.hslider1 = uicontrol('style','slider', ... %This sets up the slider
    'unit', 'normalized', ...
    'position' , [.25 .25 .02 .6],'Tag','1', ...
    'Value', 0,'min', -20,'max', 20,'SliderStep',[0.025 0.025]); 
label1 = uicontrol('Parent',handles.hs,'Style','text',... %This creates the label for the slider i.e 250 Hz 
    'Position',[300,25,100,725],...
    'String','250 Hz','fontsize',18);
handles.htxtGain1 = uicontrol('style','text', ... %This creates the textbox that shows the current gain value
    'unit', 'points', ...
    'position' , [330,0,40,200], ...
    'String', '0', ...
    'fontsize', 20);

handles.hslider2 = uicontrol('style','slider', ...
    'unit', 'normalized', ...
    'position' , [.35 .25 .02 .6],'Tag','2', ...
    'Value', 0,'min', -20,'max', 20,'SliderStep',[0.025 0.025]); 
label2 = uicontrol('Parent',handles.hs,'Style','text',...
    'Position',[435,25,100,725],...
    'String','500 Hz','fontsize',18);
handles.htxtGain2 = uicontrol('style','text', ...
    'unit', 'points', ...
    'position' , [465,0,40,200], ...
    'String', '0', ...
    'fontsize', 20);

handles.hslider3 = uicontrol('style','slider', ...
    'unit', 'normalized', ...
    'position' , [.45 .25 .02 .6],'Tag','3', ...
    'Value', 0,'min', -20,'max', 20,'SliderStep',[0.025 0.025]); 
label3 = uicontrol('Parent',handles.hs,'Style','text',...
    'Position',[575,25,100,725],...
    'String','1000 Hz','fontsize',18);
handles.htxtGain3 = uicontrol('style','text', ...
    'unit', 'points', ...
    'position' , [605,0,40,200], ...
    'String', '0', ...
    'fontsize', 20);

handles.hslider4 = uicontrol('style','slider', ...
    'unit', 'normalized', ...
    'position' , [.55 .25 .02 .6], 'Tag','4', ...
    'Value', 0,'min', -20,'max', 20,'SliderStep',[0.025 0.025]); 
label4 = uicontrol('Parent',handles.hs,'Style','text',...
    'Position',[700,25,100,725],...
    'String','2000 Hz','fontsize',18);
handles.htxtGain4 = uicontrol('style','text', ...
    'unit', 'points', ...
    'position' , [735,0,40,200], ...
    'String', '0', ...
    'fontsize', 20);

handles.hslider5 = uicontrol('style','slider', ...
    'unit', 'normalized', ...
    'position' , [.65 .25 .02 .6],'Tag','5', ...
    'Value', 0,'min', -20,'max', 20,'SliderStep',[0.025 0.025]); 
label5 = uicontrol('Parent',handles.hs,'Style','text',...
    'Position',[840,25,100,725],...
    'String','6000 Hz','fontsize',18);
handles.htxtGain5 = uicontrol('style','text', ...
    'unit', 'points', ...
    'position' , [870,0,40,200], ...
    'String', '0', ...
    'fontsize', 20);

handles.hslider6 = uicontrol('style','slider', ...
    'unit', 'normalized', ...
    'position' , [.75 .25 .02 .6],'Tag','6', ...
    'Value', 0,'min', -20,'max', 20,'SliderStep',[0.025 0.025]); 
label6 = uicontrol('Parent',handles.hs,'Style','text',...
    'Position',[990,25,100,725],...
    'String','8000 Hz','fontsize',18);
handles.htxtGain6 = uicontrol('style','text', ...
    'unit', 'points', ...
    'position' , [1000,0,40,200], ...
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

%Callback Functions For Sliders
handles.hslider1.Callback = {@slider_callback, handles};
handles.hslider2.Callback = {@slider_callback, handles};
handles.hslider3.Callback = {@slider_callback, handles};
handles.hslider4.Callback = {@slider_callback, handles};
handles.hslider5.Callback = {@slider_callback, handles};
handles.hslider6.Callback = {@slider_callback, handles};
handles.hbutton1.Callback = {@button_callback, handles};
handles.hbutton2.Callback = {@button_callback, handles};
handles.hbutton3.Callback = {@button_callback, handles};

end


%Callback Slider

function slider_callback(src, ~,handles)
global openmha

buttonID = src.Tag;             %Sets the tag for the buttons 
stateI= str2num(buttonID);      %Converts the tag to a state 


ch1 = handles.hslider1.Value;
ch2 = handles.hslider2.Value;
ch3 = handles.hslider3.Value;
ch4 = handles.hslider4.Value;
ch5 = handles.hslider5.Value;
ch6 = handles.hslider6.Value;

handles.htxtGain1.String = num2str(ch1); %Creates the string that allows the gain value to be shown for each frequency band
handles.htxtGain2.String = num2str(ch2);
handles.htxtGain3.String = num2str(ch3);
handles.htxtGain4.String = num2str(ch4);
handles.htxtGain5.String = num2str(ch5);
handles.htxtGain6.String = num2str(ch6);

gaintable_og = [[ch1 ch1 ch1];[ch2 ch2 ch2];[ch3 ch3 ch3];[ch4 ch4 ch4];[ch5 ch5 ch5];[ch6 ch6 ch6];...
    [ch1 ch1 ch1];[ch2 ch2 ch2];[ch3 ch3 ch3];[ch4 ch4 ch4];[ch5 ch5 ch5];[ch6 ch6 ch6]];
%Original gain values i.e Gain = [ch1 ch2 ch3 ch4 ch5 ch6]’ gttable = repmat(Gain, 2, 3) 

% G = ch1:ch6;   
% gaintable_og1 = repmat(G,1,3);    %Creates gaintable based on current gaintable reading channels 1-6
% gaintable_og2 = repmat(G,1,3);    %Creates gaintable based on current gaintable reading channels 7-12
% gaintable_og = cat(1,gaintable_og1,gaintable_og2);

if stateI == 1                          %Updates the gain table in openMHA based on state of the tag
    mha_set(openmha,'mha.overlapadd.mhachain.dc.gtdata',gaintable_og);
    t = now;
    d = datetime(t,'ConvertFrom','datenum'); 
    timestr = datestr(d);
    GainValue = ch1;
    Data1 = {timestr,GainValue};
end

if stateI == 2                         %Updates the gain table in openMHA based on state of the tag
    mha_set(openmha,'mha.overlapadd.mhachain.dc.gtdata',gaintable_og);
end

if stateI == 3                          %Updates the gain table in openMHA based on state of the tag
    mha_set(openmha,'mha.overlapadd.mhachain.dc.gtdata',gaintable_og);
end

if stateI == 4                          %Updates the gain table in openMHA based on state of the tag
    mha_set(openmha,'mha.overlapadd.mhachain.dc.gtdata',gaintable_og);
end

if stateI == 5                          %Updates the gain table in openMHA based on state of the tag
    mha_set(openmha,'mha.overlapadd.mhachain.dc.gtdata',gaintable_og);
end

if stateI == 6                          %Updates the gain table in openMHA based on state of the tag
    mha_set(openmha,'mha.overlapadd.mhachain.dc.gtdata',gaintable_og);
end

  
end

%Callback For Buttons

function button_callback(src, ~,handles)

global openmha
global Data1

buttonID = src.Tag;              %Sets the tag for the buttons 
stateII= str2num(buttonID);      %Converts the tag to a state 

if  stateII == 1
    mha_set(openmha,'cmd','start');     %Starts openMHA
    set(handles.hbutton1,'enable','off');   
    set(handles.hbutton2,'enable','on');
    set(handles.hbutton3,'enable','on');
    t_start = now;    %Time when the GUI was started                                
    starttime = datetime(t_start,'ConvertFrom','datenum');%Converts it 
    writematrix(starttime,'DataLog.xlsx','Range','B1'); %Creates the log and label
    writematrix('Start_Time','DataLog.xlsx','Range','A1'); %Inputs the data
    writematrix('Gain','DataLog.xlsx','Range','D1');
    writematrix('Time Of Change','DataLog.xlsx','Range','C1');
    
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
   writematrix(stopttime,'DataLog.xlsx','Range','B2');
   writematrix('Stop_time','DataLog.xlsx','Range','A2');
   %writecell(Data1,'DataLog.xlsx','Range','C2');
   close all;

end

end