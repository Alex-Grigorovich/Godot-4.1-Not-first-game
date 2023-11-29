extends Node2D

@onready var light = $DirectionalLight2D

enum {
	MORNING,
	DAY,
	EVENING,
	NIGHT
}

var state = MORNING

func _ready():
	light.enabled = true

func _process(delta):
	match state:
		MORNING:
			morning_state()
		EVENING:
			evening_state()

func morning_state():
	var tween = get_tree().create_tween()
	tween.tween_property(light, "energy", 0.2, 20)
	
func evening_state():
	var tween = get_tree().create_tween()
	tween.tween_property(light, "energy", 0.95, 20)

func _on_day_night_timeout():
	if state < 3:
		state += 1
	else:
		state = MORNING
