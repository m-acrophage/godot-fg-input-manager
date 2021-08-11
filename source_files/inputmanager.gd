extends Node

#used for demo, can be removed
onready var buffer_label = $BufferLabel
onready var direction_label = $DirectionLabel

var xscale = 1

# recording of all inputs
var button_history = [{"dir":neutral, "A":false ,"B":false ,"C":false ,"D":false ,"frame":0}]
# buttons pressed on current anf previous frames
# use the variables further below to check for buttons, but for directions you can reference this dictionary directly, as it is updated every frame
var buttons = {"dir":neutral, "A":false, "B":false, "C":false, "D":false}
var prev_buttons = {"dir":neutral, "A":false, "B":false, "C":false, "D":false}
# count of current frame
var frames = 0

# command buffer appends with current direction if timer runs out, timer is reset to max value if there is a new direction pressed
var command_buffer = []
const command_buffer_size = 6
const command_buffer_timer_max = 10
var command_buffer_timer = command_buffer_timer_max

const neutral = Vector2(0,0)
const up = Vector2(0,1)
const up_forward = Vector2(1,1)
const forward = Vector2(1,0)
const down_forward = Vector2(1,-1)
const down = Vector2(0,-1)
const down_back = Vector2(-1,-1)
const back = Vector2(-1,0)
const up_back = Vector2(-1,1)


# can set the amout of buffered frames for button inputs as well as force lag, helpful for acieving multiple presses on same frame
const button_lag = 0
const button_buffer = 6

# pressed and held buttons. call these in your player script to check inputs
var buttonA
var buttonB
var buttonC
var buttonD
var buttonA_held
var buttonB_held
var buttonC_held
var buttonD_held

# set the timer for single button presses to remain active
var buttonA_timer = button_lag + button_buffer
var buttonB_timer = button_lag + button_buffer
var buttonC_timer = button_lag + button_buffer
var buttonD_timer = button_lag + button_buffer

# modifies speed of charge motions, keep max charge higher than full charge, smaller difference means tighter input
const full_charge = 30
const max_charge = 45
var bcharge_value = 0
var dcharge_value = 0

# checks for command inputs, call these in player script
var qcf = false
var qcb = false
var dp = false
var rdp = false
var hcf = false
var hcb = false
var dd = false
var cir = false
var fdash = false
var bdash = false
var dcharge = false
var bcharge = false

func _ready():
	# fill the command input array to previously deterimed size
	for _x in range(0,command_buffer_size):
		command_buffer.append(neutral)

func _physics_process(_delta):
	frames += 1
	
# all the functions declared below get slapped on here, be sure to do this under physics process, as the framerate will be consistent, which is pivotal for achieving determinism	
	get_input()
	set_buttons()
	set_held_buttons()
	set_command_buffer()
	get_charge_inputs()
	get_qcf()
	get_qcb()
	get_dp()
	get_rdp()
	get_hcf()
	get_hcb()
	get_dd()
	get_fdash()
	get_bdash()
	set_history()
	
	if Input.is_action_just_pressed("swap"):
		xscale = -xscale
	
	var direction_text
	if xscale == 1:
		direction_text = "RIGHT"
	else:
		direction_text = "LEFT"
	
	direction_label.text = ("Press Enter/Square(PS)/X(XB) to change direction facing. \n \n Current direction: " + direction_text)
	
	# here for demo, can be removed
	buffer_label.text = str(command_buffer)

# collect current player inputs, would be overwritted during replays or rollback simulations by other (nonexistent as of yet) function
# when implementing in a game, be sure to set a conditional if statement based on the direction the character is facing and set the directional x values accordingly
# y directional values do not require any conditional statements based of facing direction of the character
func get_input():
	# checks for opposing directions, and if there are, cancels them out
	if Input.is_action_pressed("ui_up") and !Input.is_action_pressed("ui_down"):
		buttons.dir.y = 1
	elif Input.is_action_pressed("ui_down") and !Input.is_action_pressed("ui_up"):
		buttons.dir.y = -1
	else:
		buttons.dir.y = 0
	
	if Input.is_action_pressed("ui_right") and !Input.is_action_pressed("ui_left"):
		buttons.dir.x = xscale
	elif Input.is_action_pressed("ui_left") and !Input.is_action_pressed("ui_right"):
		buttons.dir.x = -xscale
	else:
		buttons.dir.x = 0
	
	# an example of how to use multi button macros, second qualifier can be removed/modified
	if Input.is_action_pressed("A") or Input.is_action_pressed("macro"):
		buttons.A = true
	else:
		buttons.A = false
	
	if Input.is_action_pressed("B") or Input.is_action_pressed("macro"):
		buttons.B = true
	else:
		buttons.B = false
	
	if Input.is_action_pressed("C"):
		buttons.C = true
	else:
		buttons.C = false
	
	if Input.is_action_pressed("D"):
		buttons.D = true
	else:
		buttons.D = false

# update dictionary array that can be saved for replays/checked during rollback. 
# other functions also check previus values to determine inputs
func set_history():
	if buttons.hash() != prev_buttons.hash():
		button_history.append({"dir":buttons.dir ,"A":buttons.A ,"B":buttons.B ,"C":buttons.C ,"D":buttons.D ,"frame":frames})
	prev_buttons.dir = buttons.dir
	prev_buttons.A = buttons.A
	prev_buttons.B = buttons.B
	prev_buttons.C = buttons.C
	prev_buttons.D = buttons.D

# assigns button booleans based on collected inputs, as well as set buffer timers
func set_buttons():
	if buttons.A and !button_history.back().A:
		buttonA_timer = button_buffer + button_lag
	if buttonA_timer > 0:
		if buttonA_timer <= button_buffer:
			buttonA = true
		buttonA_timer -= 1
	else:
		buttonA = false
	
	if buttons.B and !button_history.back().B:
		buttonB_timer = button_buffer + button_lag
	if buttonB_timer > 0:
		if buttonB_timer <= button_buffer:
			buttonB = true
		buttonB_timer -= 1
	else:
		buttonB = false
	
	if buttons.C and !button_history.back().C:
		buttonC_timer = button_buffer + button_lag
	if buttonC_timer > 0:
		if buttonC_timer <= button_buffer:
			buttonC = true
		buttonC_timer -= 1
	else:
		buttonC = false
	
	if buttons.D and !button_history.back().D:
		buttonD_timer = button_buffer + button_lag
	if buttonD_timer > 0:
		if buttonD_timer <= button_buffer:
			buttonD = true
		buttonD_timer -= 1
	else:
		buttonD = false

# sets the held button variables, based entirely on current frame
func set_held_buttons():
	if buttons.A:
		buttonA_held = true
	else:
		buttonA_held = false
		
	if buttons.B:
		buttonB_held = true
	else:
		buttonB_held = false
		
	if buttons.C:
		buttonC_held = true
	else:
		buttonC_held = false
		
	if buttons.D:
		buttonD_held = true
	else:
		buttonD_held = false

# sets the buffer that is used to determine command inputs by adding new value with each timeout/new direction
# acts as a freference for motion inputs to be detected
func set_command_buffer():
	if buttons.dir != prev_buttons.dir:
		command_buffer.push_front(buttons.dir)
		command_buffer.remove(command_buffer_size)
		command_buffer_timer = command_buffer_timer_max
	else:
		if command_buffer_timer > 0:
			command_buffer_timer -= 1
		else:
			command_buffer.push_front(buttons.dir)
			command_buffer.remove(command_buffer_size)
			command_buffer_timer = command_buffer_timer_max

# everything from here down is to check for command inputs.
# see the AttackLabel object for examples of how to use these to influence a player
# these functions are subject to change, as the method used to determine the commands is admittedly imperfect, relies on small command buffer
# for more complicated inputs,consider modifying the size of the buffer and using different methods to check for successful inputs
func get_charge_inputs():
	if buttons.dir.x == -1 and bcharge_value < max_charge:
		bcharge_value += 1
	elif bcharge_value > 0:
		bcharge_value -= 1
	if bcharge_value >= full_charge and buttons.dir.x == 1:
		bcharge = true
	else:
		bcharge = false
	
	if buttons.dir.y == -1 and dcharge_value < max_charge:
		dcharge_value += 1
	elif dcharge_value > 0:
		dcharge_value -= 1
	if dcharge_value >= full_charge and buttons.dir.y == 1:
		dcharge = true
	else:
		dcharge = false

func get_qcf():
	var input3 = command_buffer.find(forward)
	var input2 = command_buffer.find(down_forward, input3)
	var input1 = command_buffer.find(down, input2)
	if input3 < input2 and input2 < input1 and input1 <= 3:
		qcf = true
	else:
		qcf = false

func get_qcb():
	var input3 = command_buffer.find(back)
	var input2 = command_buffer.find(down_back, input3)
	var input1 = command_buffer.find(down, input2)
	if input3 < input2 and input2 < input1 and input1 <= 3:
		qcb = true
	else:
		qcb = false

func get_dp():
	var input3 = command_buffer.find(down_forward)
	var input2 = command_buffer.find(down, input3)
	var input1 = command_buffer.find(forward, input2)
	if input3 < input2 and input2 < input1 and input1 <= 4:
		dp = true
	else:
		dp = false

func get_rdp():
	var input3 = command_buffer.find(down_back)
	var input2 = command_buffer.find(down, input3)
	var input1 = command_buffer.find(back, input2)
	if input3 < input2 and input2 < input1 and input1 <= 4:
		rdp = true
	else:
		rdp = false

func get_hcf(): 
	var input5 = command_buffer.find(forward)
	var input4 = command_buffer.find(down_forward, input5)
	var input3 = command_buffer.find(down, input4)
	var input2 = command_buffer.find(down_back, input3)
	var input1 = command_buffer.find(back, input2)
	if input5 < input4 and input4 < input3 and input3 < input2 and input2 < input1 and input5 <= 5:
		hcf = true
	else:
		hcf = false

func get_hcb():
	var input5 = command_buffer.find(back)
	var input4 = command_buffer.find(down_back, input5)
	var input3 = command_buffer.find(down, input4)
	var input2 = command_buffer.find(down_forward, input3)
	var input1 = command_buffer.find(forward, input2)
	if input5 < input4 and input4 < input3 and input3 < input2 and input2 < input1 and input5 <= 5:
		hcb = true
	else:
		hcb = false

func get_dd():
	var input4 = command_buffer.find(down)
	var input3 = command_buffer.find(neutral, input4)
	var input2 = command_buffer.find(down, input3)
	var input1 = command_buffer.find(neutral, input2)
	if input4 < input3 and input3 < input2 and input2 < input1 and input1 <= 4:
		dd = true
	else:
		dd = false

func get_fdash():
	if command_buffer[0].x == 1 and command_buffer[1].x == 0 and command_buffer[2].x == 1 and command_buffer[3].x == 0:
		fdash = true
	else:
		fdash = false

func get_bdash():
	if command_buffer[0].x == -1 and command_buffer[1].x == 0 and command_buffer[2].x == -1 and command_buffer[3].x == 0:
		bdash = true
	else:
		bdash = false
