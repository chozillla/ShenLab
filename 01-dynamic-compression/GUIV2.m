function GUIV2
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




if stateI == 1                          %Updates the gain table in openMHA based on state of the tag
    A = exist('Data1','var');
    if A == 0
    t = now;
    d = datetime(t,'ConvertFrom','datenum'); 
    formatOut = 'HH:MM:SS';
    timestr = string(datestr(d,formatOut));
    set(handles.hslider1.UserData,'UserData',ch1);
    handles.hslider1.Data1 = struct('Gain_ch1',handles.hslider1.UserData,'TimeStamp_ch1',timestr);
    mha_set(openmha,'mha.overlapadd.mhachain.dc.gtdata',gaintable_og);
    else
    t = now;
    d = datetime(t,'ConvertFrom','datenum'); 
    formatOut = 'HH:MM:SS';
    timestr = string(datestr(d,formatOut));
    set(handles.hslider1.UserData,'UserData',ch1);
    handles.hslider1.Data1.Gain_ch1(end+1,1) = ch1;
    handles.hslider1.Data1.TimeStamp_ch1(end+1,1) = timestr;
    mha_set(openmha,'mha.overlapadd.mhachain.dc.gtdata',gaintable_og);
    end
    pause(0.001);
end



if stateI == 2                         %Updates the gain table in openMHA based on state of the tag
    A = exist('Channel2.mat');
    if A == 0
    t = now;
    d = datetime(t,'ConvertFrom','datenum'); 
    formatOut = 'HH:MM:SS';
    timestr = datestr(d,formatOut);
    set(handles.hslider2,'UserData',ch2);
    Data2 = {handles.hslider2.UserData,timestr};
    mha_set(openmha,'mha.overlapadd.mhachain.dc.gtdata',gaintable_og);
    save('Channel2.mat','Data2');
    else
    t = now;
    d = datetime(t,'ConvertFrom','datenum'); 
    formatOut = 'HH:MM:SS';
    timestr = datestr(d,formatOut);
    load('Channel2.mat');
    set(handles.hslider2,'UserData',ch2);
    Data2{end+1,1} = ch2;
    Data2{end,2} = timestr;
    mha_set(openmha,'mha.overlapadd.mhachain.dc.gtdata',gaintable_og);
    save('Channel2.mat','Data2','-append');
    end
    pause(0.001);
end

if stateI == 3                          %Updates the gain table in openMHA based on state of the tag
    A = exist('Channel3.mat');
    if A == 0
    t = now;
    d = datetime(t,'ConvertFrom','datenum'); 
    formatOut = 'HH:MM:SS';
    timestr = datestr(d,formatOut);
    set(handles.hslider3,'UserData',ch3);
    Data3 = {handles.hslider3.UserData,timestr};
    mha_set(openmha,'mha.overlapadd.mhachain.dc.gtdata',gaintable_og);
    save('Channel3.mat','Data3');
    else
    t = now;
    d = datetime(t,'ConvertFrom','datenum'); 
    formatOut = 'HH:MM:SS';
    timestr = datestr(d,formatOut);
    load('Channel3.mat');
    set(handles.hslider3,'UserData',ch3);
    Data3{end+1,1} = ch3;
    Data3{end,2} = timestr;
    mha_set(openmha,'mha.overlapadd.mhachain.dc.gtdata',gaintable_og);
    save('Channel3.mat','Data3','-append');
    end
    pause(0.001);
end

if stateI == 4                          %Updates the gain table in openMHA based on state of the tag
    A = exist('Channel4.mat');
    if A == 0
    t = now;
    d = datetime(t,'ConvertFrom','datenum'); 
    formatOut = 'HH:MM:SS';
    timestr = datestr(d,formatOut);
    set(handles.hslider4,'UserData',ch4);
    Data4 = {handles.hslider4.UserData,timestr};
    mha_set(openmha,'mha.overlapadd.mhachain.dc.gtdata',gaintable_og);
    save('Channel4.mat','Data4');
    else
    t = now;
    d = datetime(t,'ConvertFrom','datenum'); 
    formatOut = 'HH:MM:SS';
    timestr = datestr(d,formatOut);
    load('Channel4.mat');
    set(handles.hslider4,'UserData',ch4);
    Data4{end+1,1} = ch4;
    Data4{end,2} = timestr;
    mha_set(openmha,'mha.overlapadd.mhachain.dc.gtdata',gaintable_og);
    save('Channel4.mat','Data4','-append');
    end
    pause(0.001);
end

if stateI == 5                          %Updates the gain table in openMHA based on state of the tag
    A = exist('Channel5.mat');
    if A == 0
    t = now;
    d = datetime(t,'ConvertFrom','datenum'); 
    formatOut = 'HH:MM:SS';
    timestr = datestr(d,formatOut);
    set(handles.hslider5,'UserData',ch5);
    Data5 = {handles.hslider5.UserData,timestr};
    mha_set(openmha,'mha.overlapadd.mhachain.dc.gtdata',gaintable_og);
    save('Channel5.mat','Data5');
    else
    t = now;
    d = datetime(t,'ConvertFrom','datenum'); 
    formatOut = 'HH:MM:SS';
    timestr = datestr(d,formatOut);
    load('Channel5.mat');
    set(handles.hslider5,'UserData',ch5);
    Data5{end+1,1} = ch5;
    Data5{end,2} = timestr;
    mha_set(openmha,'mha.overlapadd.mhachain.dc.gtdata',gaintable_og);
    save('Channel5.mat','Data5','-append');
    end
    pause(0.001);
end

if stateI == 6                          %Updates the gain table in openMHA based on state of the tag
    A = exist('Channel6.mat');
    if A == 0
    t = now;
    d = datetime(t,'ConvertFrom','datenum'); 
    formatOut = 'HH:MM:SS';
    timestr = datestr(d,formatOut);
    set(handles.hslider5,'UserData',ch6);
    Data6 = {handles.hslider6.UserData,timestr};
    mha_set(openmha,'mha.overlapadd.mhachain.dc.gtdata',gaintable_og);
    save('Channel6.mat','Data6');
    else
    t = now;
    d = datetime(t,'ConvertFrom','datenum'); 
    formatOut = 'HH:MM:SS';
    timestr = datestr(d,formatOut);
    load('Channel6.mat');
    set(handles.hslider6,'UserData',ch6);
    Data6{end+1,1} = ch6;
    Data6{end,2} = timestr;
    mha_set(openmha,'mha.overlapadd.mhachain.dc.gtdata',gaintable_og);
    save('Channel6.mat','Data6','-append');
    end
    pause(0.001);
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
    writematrix('Start_Time','DataLog.xlsx','Range','A1'); %Inputs the data
    writematrix(start_time,'DataLog.xlsx','Range','B1'); %Creates the log and label
    writematrix('Channel 1','DataLog.xlsx','Range','A3');
    writematrix('Timestamp','DataLog.xlsx','Range','B3');
    writematrix('Channel 2','DataLog.xlsx','Range','C3');
    writematrix('Timestamp','DataLog.xlsx','Range','D3');
    writematrix('Channel 3','DataLog.xlsx','Range','E3');
    writematrix('Timestamp','DataLog.xlsx','Range','F3');
    writematrix('Channel 4','DataLog.xlsx','Range','G3');
    writematrix('Timestamp','DataLog.xlsx','Range','H3');
    writematrix('Channel 5','DataLog.xlsx','Range','I3');
    writematrix('Timestamp','DataLog.xlsx','Range','J3');
    writematrix('Channel 6','DataLog.xlsx','Range','K3');
    writematrix('Timestamp','DataLog.xlsx','Range','L3');
    
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
   writematrix('Stop_Time','DataLog.xlsx','Range','A2');
   writematrix(stop_time,'DataLog.xlsx','Range','B2');
   
   %Channel 1
   
   Gain1 = handles.hslider1.Data1.Gain_ch1(:,1);
   Time1 = handles.hslider1.Data1.TimeStamp_ch1(:,2);
   writecell(Gain1,'DataLog.xlsx','Range','A4:A100');
   writecell(Time1,'DataLog.xlsx','Range','B4:B100');
   
   %Channel 2
   load('Channel2.mat');
   Gain2 = Data2(:,1);
   Time2 = Data2(:,2);
   writecell(Gain2,'DataLog.xlsx','Range','C4:C100');
   writecell(Time2,'DataLog.xlsx','Range','D4:D100');
   
   %Channel 3
   load('Channel3.mat');
   Gain3 = Data3(:,1);
   Time3 = Data3(:,2);
   writecell(Gain3,'DataLog.xlsx','Range','E4:E100');
   writecell(Time3,'DataLog.xlsx','Range','F4:F100');
   
   %Channel 4
   load('Channel4.mat');
   Gain4 = Data4(:,1);
   Time4 = Data4(:,2);
   writecell(Gain4,'DataLog.xlsx','Range','G4:G100');
   writecell(Time4,'DataLog.xlsx','Range','H4:H100');
   
   %Channel 5
   load('Channel5.mat');
   Gain5 = Data5(:,1);
   Time5 = Data5(:,2);
   writecell(Gain5,'DataLog.xlsx','Range','I4:I100');
   writecell(Time5,'DataLog.xlsx','Range','J4:J100');
   
   %Channel 6
   load('Channel6.mat');
   Gain6 = Data6(:,1);
   Time6 = Data6(:,2);
   writecell(Gain6,'DataLog.xlsx','Range','K4:K100');
   writecell(Time6,'DataLog.xlsx','Range','L4:L100');
   
   
   close all;

end

end