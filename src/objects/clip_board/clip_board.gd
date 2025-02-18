class_name ClipBoard extends RigidBody3D
@onready var label: Label = $SubViewport/Label
@onready var check_box: CheckBox = $SubViewport/CheckBox
var taskID : int

func complete_task() -> void:
	check_box.button_pressed = true
