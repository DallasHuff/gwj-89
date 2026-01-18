extends Node

signal trash_grinded(type: Trash.TrashType, correct_type: bool)
signal goal_met(durability_left: int, trash_type: Trash.TrashType)
signal hopper_destroyed()

