class_name UpgradeInteractible extends Interactible


@onready var animator: AnimationPlayer = %animator
@onready var prompt: Control = %prompt

var player:Character:
	get:
		if player == null: player = get_tree().get_first_node_in_group("player")
		return player
var count:int = 0
var max_count = 10


func _process(_delta: float) -> void:
	if player != null:
		count += 1
		if count >= max_count:
			if player.global_position.y > global_position.y: z_index = 0
			else: z_index = 2
			count = 0


func _trigger_visuals() -> void:
	super()
	animator.play(&"open")


func _display_interact(_disaply:bool) -> void:
	prompt.visible = _disaply
	
