function filename = user_input_gui

% Create figure window and components

fig = uifigure('Position',[500 500 430 275]);

label1 = uilabel(fig,...
    'Position',[100 164 100 15],...
    'Text','Patient ID:');

% hbutton1 = uibutton(fig,'push',... % creates the "Pin" button with the various properties
%     'Position',[100 75 175 15],'fontname','Arial',...
%     'fontsize',55,'backgroundcolor','green','string','Pin');

button1 = uibutton(fig,'push',...
    'Position',[100 60 180 20],...
    'Text','Start','Visible','off');

label3 =  uilabel(fig,...
    'Position',[100 200 175 15],...
    'Text','Instructions For User:');

textarea = uitextarea(fig,...
    'Position',[100 100 150 60],...
    'ValueChangedFcn',@(textarea,event) textEntered(textarea, button1));

% Create ValueChangedFcn callback
    function val = textEntered(textarea,button1)
        val = textarea.Value;
        %button1.Text = '';
        % Check each element of text area cell array for text
        for k = 1:length(val)
            if(~isempty(val{k}))
                button1.Visible = 'On';
                break;
            end
        end
        filename = char(val);
        disp(filename)
        if isfile(filename)
            dragpoints_2_v16(filename)
            disp("file_found")
        else
            dragpoints_2_v16()
            disp("file_not_found")
        end
    end

end
