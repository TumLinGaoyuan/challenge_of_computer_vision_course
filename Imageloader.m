function varargout = Imageloader(varargin)
% IMAGELOADER MATLAB code for Imageloader.fig
%      IMAGELOADER, by itself, creates a new IMAGELOADER or raises the existing
%      singleton*.
%
%      H = IMAGELOADER returns the handle to a new IMAGELOADER or the handle to
%      the existing singleton*.
%
%      IMAGELOADER('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in IMAGELOADER.M with the given input arguments.
%
%      IMAGELOADER('Property','Value',...) creates a new IMAGELOADER or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before Imageloader_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to Imageloader_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help Imageloader

% Last Modified by GUIDE v2.5 11-Jul-2023 17:40:53

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @Imageloader_OpeningFcn, ...
                   'gui_OutputFcn',  @Imageloader_OutputFcn, ...
                   'gui_LayoutFcn',  [] , ...
                   'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT


% --- Executes just before Imageloader is made visible.
function Imageloader_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to Imageloader (see VARARGIN)

% Set a logo
logo = imread('TUM logo.png');  % Read logo image
axes(handles.axes3);  % Set current axes to axes3
imshow(logo);  % Show logo image in current axes

% Set GUI background color to black
set(hObject, 'Color', [0 0 0]);

% Set axes3 background color to none
set(handles.axes3, 'Color', [0 0 0]);

% set slider min,max and value
set(handles.slider1, 'Min', 0);
set(handles.slider1, 'Max', 1);
set(handles.slider1, 'Value', 0.15);

handles.distThreshold = 0.15;

% Set a timer 
handles.timer = timer('StartDelay',0,'Period',1,'TasksToExecute',inf,...
                      'ExecutionMode','fixedRate',...
                      'TimerFcn', @(~,~) updateTimer(hObject));
guidata(hObject, handles);

% Choose default command line output for Imageloader
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);


% UIWAIT makes Imageloader wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = Imageloader_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in pushbutton1.
function pushbutton1_Callback(hObject, eventdata, handles)

% Set the toggle button to "running" state
set(handles.edit9, 'String', 'Loading...');
set(handles.edit9, 'BackgroundColor', 'red');


folder_name = uigetdir;
set(handles.edit1,'String',folder_name); % Display the chosen folder path in edit1

% Add the inputImage function here to import the image and assign the result to imagesOriginal.
imagesOriginal = inputImage(folder_name);

% Save imagesOriginal to GUIData
handles.imagesOriginal = imagesOriginal;
guidata(hObject, handles);  % 更新handles结构

% Get all .jpg files in a folder
image_files = dir(fullfile(folder_name, '*.jpg'));

% Calculate the number of images per line
images_per_row = 4;

% Calculate the number of rows needed
num_rows = ceil(length(image_files) / images_per_row);

% Read the first image
im_first = imread(fullfile(folder_name, image_files(1).name));

% % Initialise an empty large image that will be used to store all the small images
% big_image = repmat(uint8(255), [size(im_first, 1) * num_rows, size(im_first, 2) * images_per_row, 3]);

big_image = zeros(size(im_first, 1) * num_rows, size(im_first, 2) * images_per_row, 3, 'uint8');
big_image(:,:,1) = 222;  % Red channel
big_image(:,:,2) = 212;  % Green channel
big_image(:,:,3) = 74;   % Blue channel

% Loop over all images
for i = 1:length(image_files)
    % Read image
    im = imread(fullfile(folder_name, image_files(i).name));

    % Calculate the position of the current image in the larger image
    row = ceil(i / images_per_row);
    col = mod(i-1, images_per_row) + 1;

    % Adding the current image to a larger image
    big_image((row-1)*size(im_first,1)+1 : row*size(im_first,1), (col-1)*size(im_first,2)+1 : col*size(im_first,2), :) = im;
end

% Display large images
axes(handles.axes1);
imshow(big_image);

% Set the toggle button to "done" state
set(handles.edit9, 'String', 'Complete');
set(handles.edit9, 'BackgroundColor', 'green');




function edit1_Callback(hObject, eventdata, handles)
% hObject    handle to edit1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit1 as text
%        str2double(get(hObject,'String')) returns contents of edit1 as a double


% --- Executes during object creation, after setting all properties.
function edit1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes during object creation, after setting all properties.
function axes1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to axes1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: place code in OpeningFcn to populate axes1


% --- Executes on button press in pushbutton3. Get Cameraparameter
function pushbutton3_Callback(hObject, eventdata, handles)

[filename, pathname] = uigetfile({'*.txt'}, 'Select a TXT file');
full_file_path = fullfile(pathname, filename);

% Show file paths in edit8
set(handles.edit8, 'String', full_file_path);

% Reading camera parameters from a txt file
intrinsics = getCameraParameter(full_file_path);

% Extracting camera parameters from the parameter line
cameraParameter = [intrinsics.ImageSize(2), intrinsics.ImageSize(1), ...
    intrinsics.FocalLength(1), intrinsics.FocalLength(2), ...
    intrinsics.PrincipalPoint(1), intrinsics.PrincipalPoint(2)];

% Display parameters in the corresponding edit box
set(handles.edit2, 'String', num2str(cameraParameter(1)));  % 
set(handles.edit3, 'String', num2str(cameraParameter(2)));  % 
set(handles.edit4, 'String', num2str(cameraParameter(3)));  % f_x
set(handles.edit5, 'String', num2str(cameraParameter(4)));  % f_y
set(handles.edit6, 'String', num2str(cameraParameter(5)));  % c_x
set(handles.edit7, 'String', num2str(cameraParameter(6)));  % c_y

% save intrinsics to guidata
handles.intrinsics = intrinsics;
guidata(hObject, handles);




function edit2_Callback(hObject, eventdata, handles)
% hObject    handle to edit2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit2 as text
%        str2double(get(hObject,'String')) returns contents of edit2 as a double


% --- Executes during object creation, after setting all properties.
function edit2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit3_Callback(hObject, eventdata, handles)
% hObject    handle to edit3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit3 as text
%        str2double(get(hObject,'String')) returns contents of edit3 as a double


% --- Executes during object creation, after setting all properties.
function edit3_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit4_Callback(hObject, eventdata, handles)
% hObject    handle to edit4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit4 as text
%        str2double(get(hObject,'String')) returns contents of edit4 as a double


% --- Executes during object creation, after setting all properties.
function edit4_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit5_Callback(hObject, eventdata, handles)
% hObject    handle to edit5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit5 as text
%        str2double(get(hObject,'String')) returns contents of edit5 as a double


% --- Executes during object creation, after setting all properties.
function edit5_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit6_Callback(hObject, eventdata, handles)
% hObject    handle to edit6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit6 as text
%        str2double(get(hObject,'String')) returns contents of edit6 as a double


% --- Executes during object creation, after setting all properties.
function edit6_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit7_Callback(hObject, eventdata, handles)
% hObject    handle to edit7 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit7 as text
%        str2double(get(hObject,'String')) returns contents of edit7 as a double


% --- Executes during object creation, after setting all properties.
function edit7_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit7 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit8_Callback(hObject, eventdata, handles)
% hObject    handle to edit8 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit8 as text
%        str2double(get(hObject,'String')) returns contents of edit8 as a double


% --- Executes during object creation, after setting all properties.
function edit8_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit8 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in listbox2.
function listbox2_Callback(hObject, eventdata, handles)
% hObject    handle to listbox2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns listbox2 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from listbox2


% --- Executes during object creation, after setting all properties.
function listbox2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to listbox2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutton4.
function pushbutton4_Callback(hObject, eventdata, handles)

% Start the timer and change background color to red
tic;
set(handles.edit17, 'String', 'Processing');
set(handles.edit17, 'BackgroundColor', 'red');
drawnow;  % Force MATLAB to update the GUI

% Get imagesOriginal and intrinsics from guidata
imagesOriginal = handles.imagesOriginal;
intrinsics = handles.intrinsics;
CameraPosition = handles.CameraPosition;
sliderValue = handles.distThreshold;

% Set indicator to 0 for basic version
indicator = 0;

% Convert images to gray scale
images = imageToGray(imagesOriginal);

% Remove image distortion
images = imagesUnDistort(images, intrinsics);

% Get 3D points and camera poses
[xyzPoints,camPoses,reprojectionErrors] = getMatchingRelationshipAnd3dPointBasic_CamPose(images,intrinsics,CameraPosition);

% Plot 3D points and camera positions
xyzPoints = Plot3dPoints(xyzPoints, reprojectionErrors, camPoses, handles.axes2);

% Calibrate 3D points
xyzPoints = pointCloud(xyzPoints);

% Plot point cloud with boxes
plotPointCloudWithBoxes(xyzPoints,handles,handles.axes2);

% After all the computation, stop the timer and change background color to green
elapsedTime = toc;  % Get the elapsed time from the timer
set(handles.edit17, 'String', sprintf('%.2f seconds', elapsedTime));
set(handles.edit17, 'BackgroundColor', 'green');
drawnow;  % Force MATLAB to update the GUI again

% Save the handles structure
guidata(hObject, handles);


% Here is where you put the new function updateTimer
function updateTimer(hObject)
handles = guidata(hObject);
current_time = str2double(get(handles.edit17, 'String'));
set(handles.edit17, 'String', num2str(current_time + 1));
guidata(hObject, handles);

function edit9_Callback(hObject, eventdata, handles)
% hObject    handle to edit9 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit9 as text
%        str2double(get(hObject,'String')) returns contents of edit9 as a double


% --- Executes during object creation, after setting all properties.
function edit9_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit9 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutton5.
% Reset Button
function pushbutton5_Callback(hObject, eventdata, handles)

cla(handles.axes1);  % 
cla(handles.axes2);  % 
set(handles.listbox1, 'String', '');

% set(handles.axes1, 'Color', [222, 212, 74]);
% set(handles.axes2, 'Color', [222, 212, 74]);

set(handles.edit1, 'String', '');  %
set(handles.edit2, 'String', '');  % 
set(handles.edit3, 'String', '');  
set(handles.edit4, 'String', '');
set(handles.edit5, 'String', '');
set(handles.edit6, 'String', '');  
set(handles.edit7, 'String', '');
set(handles.edit8, 'String', '');
set(handles.edit9, 'String', '');
set(handles.edit17, 'String', '');
set(handles.edit18, 'String', '');
set(handles.edit19, 'String', '');

% Updating the handles structure
guidata(hObject, handles);



function edit17_Callback(hObject, eventdata, handles)
% hObject    handle to edit17 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit17 as text
%        str2double(get(hObject,'String')) returns contents of edit17 as a double


% --- Executes during object creation, after setting all properties.
function edit17_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit17 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutton6.
function pushbutton6_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Create a question dialog box
choice = questdlg(['The professional version may consume substantial resources and take considerable time.' ...
    ' Do you want to continue?'], ...
    'Continue Confirmation', ...
    'Yes','No','No');

% Handle response
switch choice
    case 'Yes'
        % User clicked "Yes", so continue executing the code
        tic;
        set(handles.edit17, 'String', 'Processing');
        set(handles.edit17, 'BackgroundColor', 'red');
        drawnow;

        imagesOriginal = handles.imagesOriginal;
        intrinsics = handles.intrinsics;
        CameraPosition = handles.CameraPosition;
        sliderValue = handles.distThreshold;

        % Set indicator to 1 for professional version
        indicator = 1;

        images = imageToGray(imagesOriginal);
        images = imagesUnDistort(images, intrinsics);

        % find Matched Image Paar
        matchedImagePaar = findMatchedImagePaar(images);
        % Find the Image sequence
        resultArray = findImageSequence(matchedImagePaar);
        % Generate the best matching image for each image based on the new image order
        matchPaarset = findBestMatchedImage(matchedImagePaar, resultArray);
        % Get the 3D position corresponding to the matching point of the picture.
        [xyzPoints,camPoses,reprojectionErrors] = getMatchingRelationshipAnd3dPointSpec_CamPose(images,resultArray,matchPaarset,intrinsics,CameraPosition);

        xyzPoints = Plot3dPoints(xyzPoints, reprojectionErrors, camPoses,handles.axes2);
        xyzPoints = pointCloud(xyzPoints);
        plotPointCloudWithBoxes(xyzPoints,handles,handles.axes2);

        elapsedTime = toc;
        set(handles.edit17, 'String', sprintf('%.2f seconds', elapsedTime));
        set(handles.edit17, 'BackgroundColor', 'green');
        drawnow;
    case 'No'
        % User clicked "No" or closed the dialog box, so do nothing
        % Nothing to do here
end

% Save the handles structure
guidata(hObject, handles);


% --- Executes during object creation, after setting all properties.
function axes3_CreateFcn(hObject, eventdata, handles)
% hObject    handle to axes3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: place code in OpeningFcn to populate axes3


% --- Executes on button press in pushbutton7.
function pushbutton7_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton7 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Let the user choose the file
[filename, pathname] = uigetfile({'*.txt'}, 'select a TXT file');
full_file_path = fullfile(pathname, filename);

% Show file paths in edit18
set(handles.edit18, 'String', full_file_path);

% Using the getCameraPosition_forWork function to process files
CameraPosition = getCameraPosition_forWork(full_file_path);

% Converts data into a list of cell arrays
dataList = cell(size(CameraPosition, 1), 1);
for i = 1:size(CameraPosition, 1)
    dataList{i} = sprintf('%.0f %.5f %.5f %.5f %.0f %s', CameraPosition{i, :});
end

% Display data in listbox1
set(handles.listbox1, 'String', dataList);

% update GUI data
handles.CameraPosition = CameraPosition;
guidata(hObject, handles);


function edit18_Callback(hObject, eventdata, handles)
% hObject    handle to edit18 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit18 as text
%        str2double(get(hObject,'String')) returns contents of edit18 as a double


% --- Executes during object creation, after setting all properties.
function edit18_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit18 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes when entered data in editable cell(s) in uitable1.
function uitable1_CellEditCallback(hObject, eventdata, handles)
% hObject    handle to uitable1 (see GCBO)
% eventdata  structure with the following fields (see MATLAB.UI.CONTROL.TABLE)
%	Indices: row and column indices of the cell(s) edited
%	PreviousData: previous data for the cell(s) edited
%	EditData: string(s) entered by the user
%	NewData: EditData or its converted form set on the Data property. Empty if Data was not changed
%	Error: error string when failed to convert EditData to appropriate value for Data
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on selection change in listbox1.
function listbox1_Callback(hObject, eventdata, handles)
% hObject    handle to listbox1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns listbox1 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from listbox1


% --- Executes during object creation, after setting all properties.
function listbox1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to listbox1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on slider movement.
function slider1_Callback(hObject, eventdata, handles)
% hObject    handle to slider1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get current value 
sliderValue = get(hObject, 'Value');

% Displaying the current value of a slider in edit19
set(handles.edit19, 'String', sprintf('%.2f', sliderValue));

% Save distThreshold to the handles structure.
handles.distThreshold = sliderValue;

% Save handles structure
guidata(hObject, handles);

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider


% --- Executes during object creation, after setting all properties.
function slider1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[0.65, 0.16, 0.16]);
end



function edit19_Callback(hObject, eventdata, handles)
% hObject    handle to edit19 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit19 as text
%        str2double(get(hObject,'String')) returns contents of edit19 as a double


% --- Executes during object creation, after setting all properties.
function edit19_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit19 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
