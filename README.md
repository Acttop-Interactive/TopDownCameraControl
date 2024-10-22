# TopDownCameraControl

## Overview

`TopDownCameraControl` is a Lua module designed for use in Roblox games. It provides a top-down camera control system that allows for a quick setup of an advanced editor style (the sims) camera.

## Features

- **Camera Movement**: Navigate the camera using the WASD.
- **Camera Zooming**: Zoom in and out using the mouse wheel, with adjustable minimum and maximum zoom levels.
- **Camera Rotation**: Orbit around a target point by clicking and dragging the middle mouse button.
- **Adjustable Parameters**: Easily tweak camera height, speed, sensitivity, and tilt angle by modifying predefined constants.

## Installation

To use the `TopDownCameraControl` module, follow these steps:

1. Copy the script into your Roblox Studio project.
2. Require the module in a LocalScript:
   ```lua
   local TopDownCameraControl = require(path.to.TopDownCameraControl)
   ```
3. Initialize the camera control:
   ```lua
   TopDownCameraControl:init()
   ```

## Configuration

You can customize the following parameters at the beginning of the script:

- `CAMERA_HEIGHT`: Height of the camera from the ground (default: 30).
- `CAMERA_SPEED`: Speed at which the camera moves (default: 50).
- `CAMERA_SENSITIVITY`: Sensitivity of zooming with the mouse wheel (default: 1).
- `SMOOTHING_FACTOR`: Smoothing factor for camera movement (default: 0.7).
- `CAMERA_TILT_ANGLE`: The angle at which the camera points down (default: -60).
- `MIN_ZOOM`: Minimum zoom level (default: 30).
- `MAX_ZOOM`: Maximum zoom level (default: 90).
