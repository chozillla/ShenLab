function hearing_aid_fit
addpath('C:\Program Files\openMHA\mfiles')
javaaddpath('C:\Program Files\openmha\mfiles\mhactl_java.jar')

% IP address of mahalia running on PHL when using wireless
openmha.host = '10.0.0.1';
% openMHA default TCP port
openmha.port= 33337;

prompt = 'Input Gain Values i.e [ 12, 10, 43, 43, 3, 4]: ';
G = input(prompt);

figure('name','figure1','unit','normalized',...  % creates the MATLAB figure
    'position',[.1 .1 .75 .75]);
handles.hbutton1 = uicontrol('style','pushbutton',...,  % creates the "start" button with the various properties
    'unit','normalized',...,
    'innerposition',[0.015 0.55 .10 .10],'fontname','Arial',...
    'fontsize',55,'backgroundcolor','green','string','Start','Tag','1');
handles.hbutton2 = uicontrol('style','pushbutton',...,  % creates the "stop" button with the various properties
    'unit','normalized',...,
    'innerposition',[0.015 0.25 .10 .10],'fontname','Arial',...
    'fontsize',55,'backgroundcolor','red','string','Stop','Tag','2','Enable','Off');
%handles.htxt = uicontrol('style','text', ... % this is the textbox that shows the current trial number
%     'unit', 'normalized', ...
%     'position' , [.35 .93 .3 .05], ...
%     'String', sprintf('%d',G), ...
%     'fontsize', 28);
q = [250, 500, 1000, 2000, 4000, 8000];

plot(q,G,'-or','linewidth',3)
xlabel("Hertz")
%xticklabels({'250', '500', '1000', '2000', '4000', '8000'})
ylabel("dB")
grid on

hObject1 = handles.hbutton1;    % creates the button object
hObject2 = handles.hbutton2;    % creates the button object

guidata(hObject1, handles);
guidata(hObject2, handles);

handles.hbutton1.Callback = {@button_callback, handles};
handles.hbutton2.Callback = {@button_callback, handles};
end


function button_callback(src,~,handles)
buttonID = src.Tag;              %Sets the tag for the buttons
stateII = str2double(buttonID);    %Converts the tag to a state

if  stateII == 1 % Start
    handles.hbutton1.Enable = 'off';
    handles.hbutton2.Enable = 'on';
    %mha_set(openmha,'cmd','start');
else % Stop
    handles.hbutton1.Enable = 'on';
    handles.hbutton2.Enable = 'off';
    %mha_set(openmha,'cmd','stop');
    
end

end
