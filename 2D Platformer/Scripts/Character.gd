extends KinematicBody2D

class_name Character # now it is available in extends

export var gravity: int = 1000
export var max_horizontal_speed: int = 140
export var jump_speed: int = 305
export var horizontal_acceleration: int = 1500
export var horizontal_deacceleration_per_frame: int = 50
export var jump_termination_multiplier: int = 4
export var max_dash_speed: int = 500
export var min_dash_speed: int = 200

enum FACING_DIRECTION { RIGHT, LEFT }
export (FACING_DIRECTION) var initial_direction

var velocity: Vector2 = Vector2.ZERO

