extends Node2D

@onready var line: Line2D = $Spring
@onready var pendulum: RigidBody2D = $"5Yen"


func _process(_delta: float) -> void:
	adjust_rope_to_pendulum()


func adjust_rope_to_pendulum() -> void:
	# RigidBody2Dのグローバル位置を取得
	var pendulum_global_position = pendulum.global_position
	# RigidBody2Dのグローバル位置をLine2Dのローカル座標系に変換
	var new_end_point = line.to_local(pendulum_global_position)
	# Line2Dのpoints配列を変更可能な配列にコピー
	var points = line.points.duplicate()
	# 配列の最後の要素（終点）を更新
	points[points.size() - 1] = new_end_point
	# 更新された配列をLine2Dのpointsプロパティに設定
	line.points = points
