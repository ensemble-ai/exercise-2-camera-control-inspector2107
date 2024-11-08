# Peer-Review for Programming Exercise 2 #

<br>

# Solution Assessment #
Feels like a rushed job. On the right track for implementing full functionality but the final push was just not there. 
In my opinion, looking at the code, it seems extremely convoluted for what was expected. The draw_logic() 
function in the CameraControllerBase class was not utilized and the visual toggles are just not working.

## Peer-reviewer Information

* *name:* Huy Vuu
* *email:* hvuu@ucdavis.edu

## Description ##

For assessing the solution, you will be choosing ONE choice from: unsatisfactory, satisfactory, good, great, or perfect.

The break down of each of these labels for the solution assessment.

#### Perfect #### 
    Can't find any flaws with the prompt. Perfectly satisfied all stage objectives.

#### Great ####
    Minor flaws in one or two objectives. 

#### Good #####
    Major flaw and some minor flaws.

#### Satisfactory ####
    Couple of major flaws. Heading towards solution, however did not fully realize solution.

#### Unsatisfactory ####
    Partial work, not converging to a solution. Pervasive Major flaws. Objective largely unmet.


___

## Solution Assessment ##

### Stage 1: Position Lock ###

- [ ] Perfect
- [x] Great
- [ ] Good
- [ ] Satisfactory
- [ ] Unsatisfactory

___
#### Justification ##### 
Camera moves correctly: moves with vessel. Crosshair is drawn but draw logic cannot be toggled.

___
### Stage 2: Auto Scroll ###

- [ ] Perfect
- [ ] Great
- [ ] Good
- [x] Satisfactory
- [ ] Unsatisfactory

___
#### Justification ##### 
Camera moves by itself. No frame border is drawn. Able to leave camera view.

___
### Stage 3: Position lock and lerp ###

- [ ] Perfect
- [ ] Great
- [x] Good
- [ ] Satisfactory
- [ ] Unsatisfactory

___
#### Justification ##### 
Camera moves behind the vessel and catches up (most times). Crosshair is drawn but draw logic cannot be 
toggled. Jittery movement when the vessel reaches the leash edge. Major bug where moving to the leash edge in a 
diagonal way and the vessel stops, the camera does not automatically catch up.

___
### Stage 4: Target focus and lerp ###

- [ ] Perfect
- [ ] Great
- [ ] Good
- [ ] Satisfactory
- [x] Unsatisfactory

___
#### Justification ##### 
Does not focus in the direction the vessel is moving. Seems like the camera follows the logic of Stage 3. Crosshair 
is drawn but draw logic cannot be toggled. Jittery movement at leash edge. Delay to catch up after stopping is 
implemented.

___
### Stage 5: 4-way speed up push zone ###

- [ ] Perfect
- [ ] Great
- [ ] Good
- [ ] Satisfactory
- [x] Unsatisfactory

___
#### Justification ##### 
Confused about what is happening. Able to leave the camera view through the left. Seems to work when moving 
up and right. Seems to just be position lock when moving down. No borders are drawn. 
___

<br>

# Code Style #

#### Style Guide Infractions ####

- [all script files: did not put newlines before and after each method](https://github.com/ensemble-ai/exercise-2-camera-control-inspector2107/blob/c0a842558e0805ae3340a52a9055a9845e17f919/Obscura/scripts/camera_controllers/camera_pos.gd#L7) (too many infractions to list all)

- [scrolling_cam.gd: subclasses should be at the bottom](https://github.com/ensemble-ai/exercise-2-camera-control-inspector2107/blob/c0a842558e0805ae3340a52a9055a9845e17f919/Obscura/scripts/camera_controllers/scrolling_cam.gd#L11)

- [speed_cam.gd: subclasses should be at the bottom](https://github.com/ensemble-ai/exercise-2-camera-control-inspector2107/blob/c0a842558e0805ae3340a52a9055a9845e17f919/Obscura/scripts/camera_controllers/speed_cam.gd#L32)

- [primary_cam.gd: public methods should go before private methods](https://github.com/ensemble-ai/exercise-2-camera-control-inspector2107/blob/c0a842558e0805ae3340a52a9055a9845e17f919/Obscura/scripts/camera_controllers/primary_cam.gd#L93)

- [linear_cam.gd: public methods should go before private methods](https://github.com/ensemble-ai/exercise-2-camera-control-inspector2107/blob/c0a842558e0805ae3340a52a9055a9845e17f919/Obscura/scripts/camera_controllers/linear_cam.gd#L92)

- [linear_cam.gd: built-in virtual methods should go before public and private methods](https://github.com/ensemble-ai/exercise-2-camera-control-inspector2107/blob/c0a842558e0805ae3340a52a9055a9845e17f919/Obscura/scripts/camera_controllers/linear_cam.gd#L50)

- [camera_pos.gd: public methods should go after built-in virtual methods](https://github.com/ensemble-ai/exercise-2-camera-control-inspector2107/blob/c0a842558e0805ae3340a52a9055a9845e17f919/Obscura/scripts/camera_controllers/camera_pos.gd#L37)

- child camera node names are written in snake_case instead of PascalCase

#### Style Guide Exemplars ####
- Used correct formating of variable type declaration. i.e. num: int.
- correct ordering of export variables before normal variables.

___
#### Put style guide infractures ####

___

<br>

# Best Practices #

#### Best Practices Infractions ####

The solution given seems to ignore the example camera framework given (push_box.gd) and loses the abstraction
provided by the CameraControllerBase for zooming and dealing with draw logic toggling. 

- [primary_cam.gd: size parameter shadows property of Camera3D](https://github.com/ensemble-ai/exercise-2-camera-control-inspector2107/blob/c0a842558e0805ae3340a52a9055a9845e17f919/Obscura/scripts/camera_controllers/primary_cam.gd#L41)

- [primary_cam.gd: offset variable is never used](https://github.com/ensemble-ai/exercise-2-camera-control-inspector2107/blob/c0a842558e0805ae3340a52a9055a9845e17f919/Obscura/scripts/camera_controllers/primary_cam.gd#L76)

- [scrolling_cam.gd: tr variable shadows method of Object](https://github.com/ensemble-ai/exercise-2-camera-control-inspector2107/blob/c0a842558e0805ae3340a52a9055a9845e17f919/Obscura/scripts/camera_controllers/scrolling_cam.gd#L93)

- [linear_cam.gd: size parameter shadows property of Camera3D](https://github.com/ensemble-ai/exercise-2-camera-control-inspector2107/blob/c0a842558e0805ae3340a52a9055a9845e17f919/Obscura/scripts/camera_controllers/linear_cam.gd#L39)

- [linear_cam.gd: is_visible parameter shadows method of Node3D](https://github.com/ensemble-ai/exercise-2-camera-control-inspector2107/blob/c0a842558e0805ae3340a52a9055a9845e17f919/Obscura/scripts/camera_controllers/linear_cam.gd#L63)

- naming of classes is very confusing and does not really indicate which camera the script is for

#### Best Practices Exemplars ####
