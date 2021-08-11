extends Label

onready var controller = get_parent()

var state = "start"
var cooldown = 0
const set_cooldown = 10

func _physics_process(_delta):
	match state:
		"start":
			text = "Show me your moves"
		"fdash":
			text = "Forward Dash"
		"bdash":
			text = "Back Dash"
		"bcharge":
			text = "Charge Back to Forward"
		"dcharge":
			text = "Charge Down to Up"
		"qcf":
			text = "Quarter Circle Forward"
		"qcb":
			text = "Quarter Circle Back"
		"dp":
			text = "DP/Shoryuken"
		"rdp":
			text = "Backwards DP"
		"dd":
			text = "Double Down"
		"hcf":
			text = "Half Circle Forward"
		"hcb":
			text = "Half Circle Back"
	
	if cooldown > 0:
		cooldown -= 1
	else:
		get_command_inputs()

func get_command_inputs():
	if controller.fdash:
		state = "fdash"
		cooldown = set_cooldown
	
	if controller.bdash:
		state = "bdash"
		cooldown = set_cooldown
	
	if controller.bcharge and controller.buttonA:
		state = "bcharge"
		cooldown = set_cooldown
	
	if controller.dcharge and controller.buttonA:
		state = "dcharge"
		cooldown = set_cooldown
	
	if controller.qcf and controller.buttonA:
		state = "qcf"
		cooldown = set_cooldown
		
	if controller.qcb and controller.buttonA:
		state = "qcb"
		cooldown = set_cooldown
	
	if controller.dp and controller.buttonA:
		state = "dp"
		cooldown = set_cooldown
	
	if controller.rdp and controller.buttonA:
		state = "rdp"
		cooldown = set_cooldown
	
	if controller.dd and controller.buttonA:
		state = "dd"
		cooldown = set_cooldown
		
	if controller.hcf and controller.buttonA:
		state = "hcf"
		cooldown = set_cooldown
	
	if controller.hcb and controller.buttonA:
		state = "hcb"
		cooldown = set_cooldown
	
