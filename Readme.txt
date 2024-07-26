This Readme contains GUI and main two parts: the first part is GUI, and the second part is main function.

=============================================================================

To run this software, you need to open "Imageloader.m" first. Then click Run, and the GUI interface will appear, and then operate in the following order.

=========================  GUI  ======================================

## Introduction

This project is a part of a larger 3D reconstruction project. This specific part focuses on the creation of a Graphical User Interface (GUI) for user interaction and visualization of the 3D reconstruction process.

## Interface Description

The GUI is divided into several parts:

1. **Image Import:** On the left side, there is a button for importing images. Next to it is a text box that displays the file path of the imported images. There is also an indicator light that shows the status of the image import process.

2. **Camera Parameters Import:** Also on the left side, there is a button for importing camera parameters with a corresponding text box for the file path.

3. **Camera Position Import:** On the right side, there is a button for importing camera positions with a corresponding text box for the file path.

4. **Run 3D Reconstruction:** In the middle, there is a button for running the 3D reconstruction process. This button is only active when all the required data (images, camera parameters, and camera positions) have been imported. The 3D reconstruction result is displayed in the middle of the GUI.

5. **Professional Version:** On the right side, there is a button for running a more advanced version of the 3D reconstruction process. This version includes an image sorting algorithm that sorts the images based on their correlations. This process can provide more accurate 3D reconstruction results but can be quite resource-intensive and time-consuming.

6. **Objects Show Density Adjustment:** At the bottom right of the GUI, there is a slider for adjusting the 'Objects Show Density'. This parameter can affect the accuracy of the 3D reconstruction. According to our tests, the optimal range is between 0.15 and 0.3.

7. **Reset:** There is a red 'Reset' button for clearing all the data and resetting the GUI to its initial state.

## Usage

To use the GUI, follow these steps:

1. Import the required data by using the 'Import' buttons and select the files in the file dialog.
2. After all the data have been imported, click the 'Run 3D Reconstruction' button to start the 3D reconstruction process.
3. If you want to use the advanced version, click the 'Professional Version' button after importing all the data.
4. You can adjust the 'Objects Show Density' by using the slider at the bottom right of the GUI.
5. If you want to import new data, click the 'Reset' button to clear all the data and reset the GUI.

Please note that the 'Professional Version' can be quite resource-intensive and time-consuming.


============================== main ====================================

The main function appears to be a script for performing computer vision tasks related to a delivery area challenge. Here's a breakdown of the steps it performs:

Load Images: The script starts by specifying the directory (imageDir) where the original images are located and calls the inputImage function to load the images into the imagesOriginal variable.

Image Preprocessing: The script converts the original color images to grayscale using the imageToGray function, which takes imagesOriginal as input and returns the grayscale images in the images variable.

Get Camera Parameters: The script specifies the directory (cameraParameterDir) where the camera parameters are stored and calls the getCameraParameter function to retrieve the camera intrinsics. The camera intrinsics are stored in the intrinsics variable.

Remove Distortion: The script calls the imagesUnDistort function to remove distortion from the images using the camera intrinsics. The undistorted images are stored back in the images variable.

GUI Version: The script checks the value of the indicator variable. If it's set to 1, it enters the GUI version, otherwise, it goes to the basic version.

GUI Version - Find Matched Image Pair: In the GUI version, the script calls the findMatchedImagePaar function to find pairs of matched images based on visual similarity.

GUI Version - Find Image Sequence: The script calls the findImageSequence function to determine the best image sequence based on the matched image pairs.

GUI Version - Generate Best Matching Images: The script calls the findBestMatchedImage function to generate the best matching image for each image based on the new image order.

GUI Version - Get Matching Relationship and 3D Points: The script calls the getMatchingRelationshipAnd3dPointSpec function to obtain the matching relationships and corresponding 3D points for the images. The camera poses and reprojection errors are also returned.

Basic Version - Get Matching Relationship and 3D Points: If the indicator is not set to 1, the script calls the getMatchingRelationshipAnd3dPointBasic function to obtain the matching relationships and corresponding 3D points for the images in a basic version.

Plot 3D Points and Camera Positions: The script calls the Plot3dPoints function to visualize the 3D points, reprojection errors, and camera positions.

3D Point Calibration: The script calls the xyzPointCalibrite function to calibrate the 3D points.

Get Box: Finally, the script calls the plotPointCloudWithBoxes function to plot the point cloud with boxes.

Timer: The script uses the tic and toc functions to measure the execution time of the main function.

This is a general overview of the main function's steps and their purpose. However, without access to the specific implementations of the functions called within the script, it's not possible to provide a detailed explanation of each function's functionality.