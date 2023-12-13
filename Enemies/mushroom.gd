extends CharacterBody2D

enum {
	IDLE,
	ATTACK,
	CHASE,
	DAMAGE,
	DEATH,
	RECOVER
}

var state: int = 0:
	set(value):
		state = value
		match state:
			IDLE:
				idle_state()
			ATTACK:
				attack_state()
			DAMAGE:
				damage_state()
			DEATH:
				death_state()
			RECOVER:
				recover_state()


@onready var animPlayer = $AnimationPlayer
@onready var sprite = $AnimatedSprite2D
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var player
var direction
var damage = 20


func _ready():
	Signals.connect("player_position_update", Callable(self, "_on_player_position_update"))
	

func _physics_process(delta):
	if not is_on_floor():
		velocity.y += gravity * delta
		
	if state == CHASE:
		chase_state()
	
	move_and_slide()


func _on_player_position_update(player_pos):
	player = player_pos
	

func _on_attack_range_body_entered(body):
	state = ATTACK
	
func idle_state():
	animPlayer.play("Idle")
	state = CHASE
	
func attack_state():
	animPlayer.play("Attack")
	await animPlayer.animation_finished
	state = RECOVER
	
func chase_state():
	direction = (player - self.position).normalized()
	if direction.x < 0:
		sprite.flip_h = true
		$AttackDirection.rotation_degrees = 180
	else:
		sprite.flip_h = false
		$AttackDirection.rotation_degrees = 0


func _on_hit_box_area_entered(area):
	Signals.emit_signal("enemy_attack", damage)
	


func damage_state():
	animPlayer.play("Damage")
	await animPlayer.animation_finished
	state = IDLE
	
func death_state():
	animPlayer.play("Death")
	await animPlayer.animation_finished
	queue_free()

func recover_state():
	animPlayer.play("Recover")
	await animPlayer.animation_finished
	state = IDLE


func _on_mob_health_no_health():
	state = DEATH
	

func _on_mob_health_damage_received():
	state = IDLE
	state = DAMAGE
