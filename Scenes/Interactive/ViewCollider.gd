extends Area
class_name ViewCollider
# even if debugger prints warning signals defined but not emited, they are, do not delete !
# these signals are emited from the PlayerController when the LookingAtRaycast collide with this ViewCollider
signal looked_at
signal stop_looked_at
signal interacted

enum Type {RED, GREEN, BLUE, CYAN, YELLOW, PURPLE, PINK, MUSHROOM}


export(String) var look_text = "I have found something here."
export(Type) var collider_type
