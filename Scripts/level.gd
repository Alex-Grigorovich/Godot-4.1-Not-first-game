extends Node2D

@onready var light = $Light/DirectionalLight2D
@onready var point_light = $Light/PointLight2D
@onready var point_light2 = $Light/PointLight2D2
@onready var day_text = $CanvasLayer/DayText
@onready var anim_player = $CanvasLayer/AnimationPlayer
@onready var health_bar = $CanvasLayer/HealthBar
@onready var player = $Player/Player


enum {
	MORNING,
	DAY,
	EVENING,
	NIGHT
}

var state = MORNING
var day_count: int

func _ready():
	health_bar.max_value = player.max_health
	health_bar.value = health_bar.max_value
	light.enabled = true
	day_count = 1
	set_day_text()
	date_text_fade()

func morning_state():
	var tween = get_tree().create_tween()
	tween.tween_property(light, "energy", 0.2, 20)
	
	var tween1 = get_tree().create_tween()
	tween1.tween_property(point_light, "energy", 0, 20)
	
	var tween2 = get_tree().create_tween()
	tween2.tween_property(point_light2, "energy", 0, 20)
	
	
	
func evening_state():
	var tween = get_tree().create_tween()
	tween.tween_property(light, "energy", 0.95, 20)
	
	var tween1 = get_tree().create_tween()
	tween1.tween_property(point_light, "energy", 1.5, 20)
	
	var tween2 = get_tree().create_tween()
	tween2.tween_property(point_light2, "energy", 1.5, 20)

func _on_day_night_timeout():
	match state:
		MORNING:
			morning_state()
		EVENING:
			evening_state()
	
	if state < 3:
		state += 1
	else:
		state = MORNING
		day_count += 1
		set_day_text()
		date_text_fade()

func date_text_fade():
	anim_player.play("day_text_fade_in")
	await get_tree().create_timer(3).timeout
	anim_player.play("day_text_fade_out")
	
	
		
func set_day_text():
	day_text.text = "DAY " + str(day_count)


func _on_player_health_changed(new_health):
	health_bar.value = new_health
