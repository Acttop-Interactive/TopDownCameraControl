local TopDownCameraControl = {}

-- Camera settings
local CAMERA_HEIGHT = 30
local CAMERA_SPEED = 50
local CAMERA_SENSITIVITY = 1
local SMOOTHING_FACTOR = 0.7 -- Adjust this value for more or less smoothing
local CAMERA_TILT_ANGLE = -60 -- Angle to keep the camera pointing down

-- Zoom settings
local MIN_ZOOM = 30
local MAX_ZOOM = 90
local zoomLevel = CAMERA_HEIGHT

-- Variables to store camera movement input
local cameraMovement = Vector3.new(0, 0, 0)
local targetCameraPosition = Vector3.new(0, zoomLevel, 0)

-- Variables for rotation/orbiting
local isRotating = false
local lastMousePosition = Vector3.new(0, 0, 0)
local rotationSpeed = 0.5 -- Adjust this value for faster/slower rotation
local targetRotationY = 0 -- Horizontal rotation (orbit around the Y-axis)
local currentRotationX = math.rad(CAMERA_TILT_ANGLE) -- Tilt angle (constant downward look)

local UserInputService = game:GetService("UserInputService")

-- Function to set up camera control
function TopDownCameraControl:init()
	local player = game.Players.LocalPlayer
	local camera : Camera = game.Workspace.CurrentCamera
	camera.FieldOfView = 70

	-- Set initial camera position
	camera.CFrame = CFrame.new(targetCameraPosition) * CFrame.Angles(currentRotationX, 0, 0)

	-- Function to update the camera's position and rotation
	local function updateCamera(deltaTime)
		camera.CameraType = Enum.CameraType.Scriptable

		-- Get camera's forward (look) and right direction
		local cameraForward = camera.CFrame.LookVector * Vector3.new(1, 0, 1) -- Ignore vertical component
		local cameraRight = camera.CFrame.RightVector * Vector3.new(1, 0, 1) -- Ignore vertical component

		-- Calculate the movement vector relative to the camera's facing direction
		local moveVector = (cameraForward * cameraMovement.Z + cameraRight * cameraMovement.X) * CAMERA_SPEED * deltaTime
		targetCameraPosition = targetCameraPosition + moveVector
		targetCameraPosition = Vector3.new(targetCameraPosition.X, zoomLevel, targetCameraPosition.Z) -- Maintain the zoom level

		-- Smoothly interpolate the camera's position
		local currentCameraPosition = camera.CFrame.Position
		local newCameraPosition = currentCameraPosition:Lerp(targetCameraPosition, SMOOTHING_FACTOR)

		-- Smoothly interpolate the camera's rotation (orbiting around the target point)
		local smoothedRotationY = math.rad(targetRotationY)

		-- Orbit the camera around the target position, keeping the camera angled down at -60 degrees
		local distanceFromTarget = (newCameraPosition - targetCameraPosition).Magnitude
		local newCFrame = CFrame.new(targetCameraPosition) * CFrame.Angles(0, smoothedRotationY, 0) * CFrame.new(0, 0, distanceFromTarget)

		-- Apply tilt to always keep the camera pointing downward
		camera.CFrame = newCFrame * CFrame.Angles(currentRotationX, 0, 0)
	end

	-- Capture WASD input for movement
	local function onInputBegan(input)
		if input.KeyCode == Enum.KeyCode.W then
			cameraMovement = cameraMovement + Vector3.new(0, 0, 1)
		elseif input.KeyCode == Enum.KeyCode.S then
			cameraMovement = cameraMovement + Vector3.new(0, 0, -1)
		elseif input.KeyCode == Enum.KeyCode.A then
			cameraMovement = cameraMovement + Vector3.new(-1, 0, 0)
		elseif input.KeyCode == Enum.KeyCode.D then
			cameraMovement = cameraMovement + Vector3.new(1, 0, 0)
		end
	end

	local function onInputEnded(input)
		if input.KeyCode == Enum.KeyCode.W then
			cameraMovement = cameraMovement - Vector3.new(0, 0, 1)
		elseif input.KeyCode == Enum.KeyCode.S then
			cameraMovement = cameraMovement - Vector3.new(0, 0, -1)
		elseif input.KeyCode == Enum.KeyCode.A then
			cameraMovement = cameraMovement - Vector3.new(-1, 0, 0)
		elseif input.KeyCode == Enum.KeyCode.D then
			cameraMovement = cameraMovement - Vector3.new(1, 0, 0)
		end
	end

	-- Capture mouse wheel input for zooming
	local function onMouseWheel(input)
		if input.UserInputType == Enum.UserInputType.MouseWheel then
			zoomLevel = math.clamp(zoomLevel - input.Position.Z * CAMERA_SENSITIVITY, MIN_ZOOM, MAX_ZOOM)
		end
	end

	-- Capture middle mouse button input for orbiting
	local function onMouseButtonBegan(input)
		if input.UserInputType == Enum.UserInputType.MouseButton3 then -- Use MouseButton3 for middle mouse
			isRotating = true
			lastMousePosition = UserInputService:GetMouseLocation()
		end
	end

	local function onMouseButtonEnded(input)
		if input.UserInputType == Enum.UserInputType.MouseButton3 then -- Use MouseButton3 for middle mouse
			isRotating = false
		end
	end

	-- Update camera orbit based on mouse movement
	local function onMouseMoved()
		if isRotating then
			local currentMousePosition = UserInputService:GetMouseLocation()
			local deltaX = currentMousePosition.X - lastMousePosition.X

			-- Accumulate the target horizontal rotation (Y-axis)
			targetRotationY = targetRotationY + (deltaX * rotationSpeed)

			lastMousePosition = currentMousePosition
		end
	end

	-- Connect input events
	UserInputService.InputBegan:Connect(onInputBegan)
	UserInputService.InputEnded:Connect(onInputEnded)
	UserInputService.InputChanged:Connect(onMouseWheel)
	UserInputService.InputBegan:Connect(onMouseButtonBegan)
	UserInputService.InputEnded:Connect(onMouseButtonEnded)
	UserInputService.InputChanged:Connect(onMouseMoved)

	-- Connect to RenderStepped to constantly update camera position and rotation
	game:GetService("RunService").RenderStepped:Connect(function(deltaTime)
		updateCamera(deltaTime)
	end)
end

return TopDownCameraControl
