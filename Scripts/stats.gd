extends CanvasLayer

@onready var health_bar = $HealthBar
@onready var stamina_bar = $Stamina

signal no_stamina ()

var stamina_cost
var attack_cost = 10
var block_cost = 0.5
var slide_cost = 20
var run_cost = 0.3

var stamina = 50:
	set(value):
		stamina = value
		if stamina < 1:
			emit_signal("no_stamina")
var max_health = 120
var health:
	set(value):
		health = value
		health_bar.value = health

func _ready():
	health = max_health
	health_bar.max_value = health
	health_bar.value = health

func _process(delta):
	stamina_bar.value = stamina
	if stamina < 100:
		stamina += 10 * delta
		

func stamina_consumption():
	stamina -= stamina_cost
