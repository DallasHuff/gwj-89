class_name Spawner
extends Node3D

# @export var trash_type := Trash.TrashType.PLASTIC
@export var spawn_timer_range_min := 3.0
@export var spawn_timer_range_max := 7.0
@export var spawn_timer_start_delay := 3.0

@export_category("Spawn Rates")
	# METAL,
	# GLASS,
	# PLASTIC,
	# PAPER,
	# BODY,
@export_range(0, 1) var metal_chance := 0.0
@export_range(0, 1) var glass_chance := 0.0
@export_range(0, 1) var plastic_chance := 0.0
@export_range(0, 1) var paper_chance := 0.0
## be careful setting this number too high, because before the delay is hit
## it will just not spawn any trash if it chooses body
@export_range(0, 1) var body_chance := 0.0 
# delays spawning of the body for this amount of time,
# then uses the body_chance above
@export var body_spawn_delay_sec := 0.0
var body_spawn_delay_reached := false

var spawn_bounds_width := 0.3
var spawn_timer: Timer
var body_spawn_delay_timer: Timer

var warning_pushed := false

@onready var trash_scene := preload("uid://b6pgrrfecfoqx")

func _ready() -> void:
	# timer between trash
	spawn_timer = Timer.new()
	add_child(spawn_timer)
	spawn_timer.wait_time = spawn_timer_start_delay
	spawn_timer.one_shot = true
	spawn_timer.timeout.connect(_on_spawn_timer_timeout)
	spawn_timer.start()

	# timer to spawn delay
	if not is_equal_approx(0, body_spawn_delay_sec):
		body_spawn_delay_timer = Timer.new()
		add_child(body_spawn_delay_timer)
		body_spawn_delay_timer.wait_time = body_spawn_delay_sec
		body_spawn_delay_timer.one_shot = true
		body_spawn_delay_timer.timeout.connect(_on_body_spawn_delay_timeout)
		body_spawn_delay_timer.start()

func _on_body_spawn_delay_timeout() -> void:
	print("spawn delay timer timed out")
	body_spawn_delay_reached = true

func _on_spawn_timer_timeout() -> void:
	spawn_trash()

	var rand_wait := randf_range(spawn_timer_range_min, spawn_timer_range_max)
	# print("waiting: ", rand_wait)
	spawn_timer.wait_time = rand_wait
	spawn_timer.start()

func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("debug1"):
		print("debug1")
		spawn_trash()

func spawn_trash() -> void:

	# select random trash type
	var sum_chances := metal_chance + glass_chance + plastic_chance + paper_chance + body_chance

	if is_equal_approx(0, sum_chances):
		if not warning_pushed:
			push_warning("no trash type chances allotted, not spawning")
			warning_pushed = true
		return

	var choice := randf_range(0, sum_chances)

	var trash_type := Trash.TrashType.METAL

	if choice > sum_chances - body_chance:
		# print("choosing body")
		if not body_spawn_delay_reached:
			return
		trash_type = Trash.TrashType.BODY
	elif choice > sum_chances - body_chance - paper_chance:
		# print("choosing paper")
		trash_type = Trash.TrashType.PAPER
	elif choice > sum_chances - body_chance - paper_chance - plastic_chance:
		# print("choosing plastic")
		trash_type = Trash.TrashType.PLASTIC
	elif choice > sum_chances - body_chance - paper_chance - plastic_chance - glass_chance:
		# print("choosing glass")
		trash_type = Trash.TrashType.GLASS
	elif choice > sum_chances - body_chance - paper_chance - plastic_chance - glass_chance - metal_chance:
		# print("choosing metal")
		trash_type = Trash.TrashType.METAL

	var random_pos_offset := Vector3.ZERO

	random_pos_offset.x += randf_range(-spawn_bounds_width, spawn_bounds_width)
	random_pos_offset.z += randf_range(-spawn_bounds_width, spawn_bounds_width)

	var t: Trash = trash_scene.instantiate()
	get_tree().root.add_child(t)
	t.trash_type = trash_type
	t.global_position = global_position + random_pos_offset
