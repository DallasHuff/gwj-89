class_name Trash
extends RigidBody3D

enum TrashType {
	METAL,
	GLASS,
	PLASTIC,
	PAPER,
}

@export var trash_type := TrashType.METAL
