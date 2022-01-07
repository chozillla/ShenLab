function dragpoints_2_v2(xData,yData,xLower,xUpper,yLower,yUpper)
global ax
if nargin == 0 
    xData = 0; 
    yData = 0; 
    xLower = -20; 
    xUpper = 20; 
    yLower = -20; 
    yUpper = 20; 
end
figure('unit','normalized','position',[.1 .1 .8 .8]); 
hbutton1 = uicontrol('style','pushbutton','unit','normalized','innerposition',[0.02 0.55 .08 .08],'fontname','Arial','fontsize',36,'backgroundcolor','green','string','Tag','Tag','1');  

x = xData; 
y = yData;  

ax = axes('xlimmode','manual','ylimmode','manual'); 
ax.XLim = [xLower xUpper]; 
ax.YLim = [yLower yUpper];  %can change the marker size or marker type to make it more visible. %Currently is set to small points at a size of 2 so is not very visible. 
hbutton1.Callback = {@button_callback}; 
hl = line(x,y,'color','r','marker','.','markersize',105,'hittest','on','buttondownfcn',@clickmarker);  %Callback For Start, Stop, Quit Buttons  
end

function button_callback(src,~)
global x 
global y
buttonID = src.Tag; %Sets the tag for the buttons stateII= str2num(buttonID); %Converts the tag to a state  
%Drops the pin when user clicks "Save" 
if stateII == 1 xy = get(ax,'CurrentPoint'); 
    x = xy(1,1); 
    y = xy(1,2); 
    %location = [x y];
    viscircles([x,y], 2); 
end
end

function clickmarker(src,ev) 
    set(ancestor(src,'figure'),'windowbuttonmotionfcn',@dragmarker) 
    set(ancestor(src,'figure'),'windowbuttonupfcn',@stopdragging) 
end

function dragmarker(src,fig,ev)
global ax
global x 
global y
%get current axes and coords 
coords=get(ax,'currentpoint'); %get all x and y data 
%x=hl.XData; y=hl.YData;  %check which data point has the smallest distance to the dragged point 
x_diff=abs(x-coords(1,1,1)); 
y_diff=abs(y-coords(1,2,1)); 
[~, index]=min(x_diff+y_diff);  %create new x and y data and exchange coords for the dragged point 
x_new=x; 
y_new=y; 
x_new(index)=coords(1,1,1); 
y_new(index)=coords(1,2,1);  
%update plot 
set(src,'xdata',x_new,'ydata',y_new); 
end

function stopdragging(fig,ev) 
set(fig,'windowbuttonmotionfcn','') 
set(fig,'windowbuttonupfcn','') 
end