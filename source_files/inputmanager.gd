extends Node

onready var buffer_label = $BufferLabel
onready var attack_label = $AttackLabel

var button_history = [{"dir":Vector2(0,0), "A":false ,"B":false ,"C":false ,"D":false ,"frame":0}]
var buttons = {"dir":Vector2(0,0), "A":false, "B":false, "C":false, "D":false}
var prev_buttons = {"dir":Vector2(0,0), "A":false, "B":false, "C":false, "D":false}
var frames = 0

var command_buffer = []
const command_buffer_size = 5
const command_buffer_timer_max = 15
var command_buffer_timer = command_buffer_timer_max

const button_lag = 0
const button_buffer = 6

var buttonA
var buttonB
var buttonC
var buttonD
var buttonA_held
var buttonB_held
var buttonC_held
var buttonD_held
var buttonA_timer = button_lag + button_buffer
var buttonB_timer = button_lag + button_buffer
var buttonC_timer = button_lag + button_buffer
var buttonD_timer = button_lag + button_buffer

const full_charge = 30
const max_charge = 45
var bcharge_value = 0
var dcharge_value = 0

var qcf = false
var qcb = false
var dp = false
var rdp = false
var hcf = false
var hcb = false
var dd = false
var fdash = false
var bdash = false
var dcharge = false
var bcharge = false

func _ready():
	for x in range(0,command_buffer_size):
		command_buffer.append(Vector2(0,0))

func _physics_process(_delta):
	frames += 1
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
	
	buffer_label.text = str(command_buffer)

func get_input():
	if Input.is_action_pressed("ui_up") and !Input.is_action_pressed("ui_down"):
		buttons.dir.y = 1
	elif Input.is_action_pressed("ui_down") and !Input.is_action_pressed("ui_up"):
		buttons.dir.y = -1
	else:
		buttons.dir.y = 0
	
	if Input.is_action_pressed("ui_right") and !Input.is_action_pressed("ui_left"):
		buttons.dir.x = 1
	elif Input.is_action_pressed("ui_left") and !Input.is_action_pressed("ui_right"):
		buttons.dir.x = -1
	else:
		buttons.dir.x = 0
	
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

func set_history():
	if buttons.hash() != prev_buttons.hash():
		button_history.append({"dir":buttons.dir ,"A":buttons.A ,"B":buttons.B ,"C":buttons.C ,"D":buttons.D ,"frame":frames})
	prev_buttons.dir = buttons.dir
	prev_buttons.A = buttons.A
	prev_buttons.B = buttons.B
	prev_buttons.C = buttons.C
	prev_buttons.D = buttons.D

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
	var input1 = command_buffer.find(Vector2(0,-1))
	var input2 = command_buffer.find(Vector2(1,-1))
	var input3 = command_buffer.find(Vector2(1,0))
	if input3 < input2 and input2 < input1 and input1 < 4:
		qcf = true
	else:
		qcf = false

func get_qcb():
	var input1 = command_buffer.find(Vector2(0,-1))
	var input2 = command_buffer.find(Vector2(-1,-1))
	var input3 = command_buffer.find(Vector2(-1,0))
	if input3 < input2 and input2 < input1 and input1 < 4:
		qcb = true
	else:
		qcb = false

func get_dp():
	var input1 = command_buffer.find(Vector2(1,0))
	var input2 = command_buffer.find(Vector2(0,-1))
	var input3 = command_buffer.find(Vector2(1,-1))
	if input3 < input2 and input2 < input1:
		dp = true
	else:
		dp = false

func get_rdp():
	var input1 = command_buffer.rfind(Vector2(-1,0))
	var input2 = command_buffer.find(Vector2(0,-1))
	var input3 = command_buffer.find(Vector2(-1,-1))
	if input3 < input2 and input2 < input1:
		rdp = true
	else:
		rdp = false

func get_hcf():
	var input1 = command_buffer.find(Vector2(-1,0))
	var input2 = command_buffer.find(Vector2(-1,-1))
	var input3 = command_buffer.find(Vector2(0,-1))
	var input4 = command_buffer.find(Vector2(1,-1))
	var input5 = command_buffer.find(Vector2(1,0))
	if input5 < input4 and input4 < input3 and input3 < input2 and input2 < input1:
		hcf = true
	else:
		hcf = false

func get_hcb():
	var input1 = command_buffer.find(Vector2(1,0))
	var input2 = command_buffer.find(Vector2(1,-1))
	var input3 = command_buffer.find(Vector2(0,-1))
	var input4 = command_buffer.find(Vector2(-1,-1))
	var input5 = command_buffer.find(Vector2(-1,0))
	if input5 < input4 and input4 < input3 and input3 < input2 and input2 < input1:
		hcb = true
	else:
		hcb = false

func get_dd():
	if command_buffer[0].y == -1 and command_buffer[1].y == 0 and command_buffer[2].y == -1 and command_buffer[3].y == 0:
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
