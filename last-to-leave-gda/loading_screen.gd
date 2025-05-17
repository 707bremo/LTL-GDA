extends CanvasLayer

@export_file("*. tscn") var next_scene_path: String  # Determines which scene to load
@onready var loading_label: AnimationPlayer = $loading_label
@onready var loading_rods: AnimationPlayer = $elements/loading_rods
@onready var advice_title_player: AnimationPlayer = $game_tips/advice_title_player
@onready var text_animations: AnimationPlayer = $game_tips/text_animations


func _ready():
	ResourceLoader.load_threaded_request(next_scene_path)
	loading_label.play("loading_text")
	loading_rods.play("load_opening")
	advice_title_player.play("cover_move")
	

func _process(delta):
	if ResourceLoader.load_threaded_get_status(next_scene_path) == ResourceLoader.THREAD_LOAD_LOADED:
		set_process(false)
		await get_tree().create_timer(15).timeout
		var new_scene: PackedScene = ResourceLoader.load_threaded_get(next_scene_path)
		get_tree().change_scene_to_packed(new_scene)
	

func _on_loading_rods_animation_finished(anim_name: StringName) -> void:
	if anim_name == "load_opening":
		loading_rods.play("looped_elements")

func _on_advice_title_player_animation_finished(anim_name: StringName) -> void:
	if anim_name == "cover_move":
		text_animations.play("text_scrolling")
