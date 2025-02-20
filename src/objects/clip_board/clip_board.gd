class_name ClipBoard extends RigidBody3D
@onready var label: Label = $SubViewport/Label
@onready var check_box: CheckBox = $SubViewport/CheckBox
@onready var board_clip: MeshInstance3D = $clip_board/BoardClip
const OBJECT_OUTLINER = preload("res://models/textures/object_outliner.tres")

var taskID : int

func complete_task() -> void:
	check_box.button_pressed = true

func show_outline() -> void:
	board_clip.material_overlay = OBJECT_OUTLINER

func remove_outline() -> void:
	board_clip.material_overlay = null
