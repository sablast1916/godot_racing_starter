extends RigidBody2D

export var STEERING=300.0
export var ACCELERATION=50.0
export var FRICTION=2.0
export var DRIFT_FRICTION=0.8
export var DRIFT_STEERING=600.0

func _physics_process(delta):
	input()
	camera()
	sound()
	
func input():
	var steering = Input.get_action_strength("steer_right") - Input.get_action_strength("steer_left")
	if Input.is_action_pressed("drift"):
		apply_torque_impulse(DRIFT_STEERING * steering)
		linear_damp = DRIFT_FRICTION
		$skid.stream_paused = false
		doSkidmark()
	else:
		var acceleration = (Input.get_action_strength("accelerate") - Input.get_action_strength("brake")) * Vector2.UP * ACCELERATION
		apply_central_impulse(acceleration.rotated(rotation))
		apply_torque_impulse(STEERING * steering )
		linear_damp = FRICTION
		$skid.stream_paused = true

func sound():
	$engine.pitch_scale = linear_velocity.length()/1000 + 0.1

func camera():
	var scalefactor = 1.5 + linear_velocity.length()/1000
	$Camera2D.zoom = lerp($Camera2D.zoom, Vector2(scalefactor, scalefactor), 0.01)
	 

const Skidmark = preload("res://skidmark.tscn")

func doSkidmark():
	pass


func _on_player_body_entered(body):
	$crash.play()
