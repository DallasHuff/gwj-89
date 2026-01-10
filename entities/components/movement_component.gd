class_name MovementComponent
extends Node

@export var character: CharacterBody3D
@export var speed: float

var direction: Vector3


func _physics_process(delta: float) -> void:
	if direction:
		character.velocity.x = direction.x * speed * delta * Engine.physics_ticks_per_second
		character.velocity.z = direction.z * speed * delta * Engine.physics_ticks_per_second
	else:
		character.velocity.x = move_toward(character.velocity.x, 0, speed * delta * Engine.physics_ticks_per_second)
		character.velocity.z = move_toward(character.velocity.z, 0, speed * delta * Engine.physics_ticks_per_second)

	character.move_and_slide()
