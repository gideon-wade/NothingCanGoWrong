class_name ClipBoard extends RigidBody3D
@onready var label: Label = $SubViewport/Label
@onready var board_clip: MeshInstance3D = $clip_board/BoardClip
const OBJECT_OUTLINER = preload("res://models/textures/object_outliner.tres")

@export var text := "lorem ipsum"
@export var clipboard_number : String
@export var total_clipboard_number : String

var safe_pos

func _ready():
	#if text and total_clipboard_number != "":
		#label.text = clipboard_number + "/" + total_clipboard_number + "\n" + text
	#else:
	label.text = text
	safe_pos = global_position

func _process(_delta: float) -> void:
	if global_position.y < 10:
		global_position = safe_pos

func show_outline() -> void:
	board_clip.material_overlay = OBJECT_OUTLINER

func remove_outline() -> void:
	board_clip.material_overlay = null
