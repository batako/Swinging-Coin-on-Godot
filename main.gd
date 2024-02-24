extends Node2D

@onready var spring: Line2D = $Spring
@onready var pendulum: RigidBody2D = $"5Yen"

@onready var green_left: Line2D = $GreenLeft
@onready var green_right: Line2D = $GreenRight
@onready var yellow_left: Line2D = $YellowLeft
@onready var yellow_right: Line2D = $YellowRight
@onready var red: Line2D = $Red

@onready var animation_player: AnimationPlayer = $AnimationPlayer


func _physics_process(_delta: float) -> void:
	var pendulum_position = pendulum.position
	
	adjust_rope_to_pendulum(pendulum_position)
	
	if Input.is_action_just_pressed("ui_right"):
		var group_name = get_line_group(pendulum_position.x)
		impulse(group_name, 100)
	
	elif Input.is_action_just_pressed("ui_left"):
		var group_name = get_line_group(pendulum_position.x)
		impulse(group_name, -100)
	
	elif Input.is_action_just_pressed("ui_accept"):
		print("pendulum_position.x = " + str(pendulum_position.x))


# ロープの位置更新
func adjust_rope_to_pendulum(pendulum_position: Vector2) -> void:
	# RigidBody2Dのグローバル位置をLine2Dのローカル座標系に変換
	var new_end_point = spring.to_local(pendulum_position)
	# Line2Dのpoints配列を変更可能な配列にコピー
	var points = spring.points.duplicate()
	# 配列の最後の要素（終点）を更新
	points[points.size() - 1] = new_end_point
	# 更新された配列をLine2Dのpointsプロパティに設定
	spring.points = points


# x座標に基づいて、どのLine2D上にあるかを判定し、Line2Dが所属するグループ名を返す関数
func get_line_group(x_position: float) -> String:
	for line in [green_left, green_right, yellow_left, yellow_right, red]:
		var line_x_position = line.position.x + line.points[0].x
		var width_half = line.width / 2.0
		if x_position >= (line_x_position - width_half) and x_position <= (line_x_position + width_half):
			if "GREEN" in line.get_groups():
				return "GREEN"
			elif "YELLOW" in line.get_groups():
				return "YELLOW"
			elif "RED" in line.get_groups():
				return "RED"
	
	return ""


func impulse(group_name: String, initial_force: float = 0) -> void:
	var applied_force: float
	
	match group_name:
		"GREEN":
			applied_force = initial_force
		"YELLOW":
			applied_force = initial_force * 3
		"RED":
			applied_force = initial_force * 5
		_:
			return
	
	animation_player.play("RESET")
	animation_player.play(group_name)
	pendulum.apply_central_impulse(Vector2(applied_force, 0))
