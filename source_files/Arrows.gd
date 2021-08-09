extends Node

onready var controller = get_parent()

onready var u_arrow = $Up
onready var ur_arrow = $UpRight
onready var r_arrow = $Right
onready var dr_arrow = $DownRight
onready var d_arrow = $Down
onready var dl_arrow = $DownLeft
onready var l_arrow = $Left
onready var ul_arrow = $UpLeft

func _physics_process(delta):
	if controller.buttons.dir == Vector2(0,1):
		u_arrow.modulate = Color(1,0,0)
	else:
		u_arrow.modulate = Color(1,1,1)
	if controller.buttons.dir == Vector2(1,1):
		ur_arrow.modulate = Color(1,0,0)
	else:
		ur_arrow.modulate = Color(1,1,1)
	if controller.buttons.dir == Vector2(1,0):
		r_arrow.modulate = Color(1,0,0)
	else:
		r_arrow.modulate = Color(1,1,1)
	if controller.buttons.dir == Vector2(1,-1):
		dr_arrow.modulate = Color(1,0,0)
	else:
		dr_arrow.modulate = Color(1,1,1)
	if controller.buttons.dir == Vector2(0,-1):
		d_arrow.modulate = Color(1,0,0)
	else:
		d_arrow.modulate = Color(1,1,1)
	if controller.buttons.dir == Vector2(-1,-1):
		dl_arrow.modulate = Color(1,0,0)
	else:
		dl_arrow.modulate = Color(1,1,1)
	if controller.buttons.dir == Vector2(-1,0):
		l_arrow.modulate = Color(1,0,0)
	else:
		l_arrow.modulate = Color(1,1,1)
	if controller.buttons.dir == Vector2(-1,1):
		ul_arrow.modulate = Color(1,0,0)
	else:
		ul_arrow.modulate = Color(1,1,1)
