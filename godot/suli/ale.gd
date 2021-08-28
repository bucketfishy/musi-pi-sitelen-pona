extends Node2D


var state = "game"
var pause = false
var focus = "soweli"
var kije_climbing = false
var kije = preload("res://lon tawa/kije.tscn")

onready var menu = $menu/menu
# Called when the node enters the scene tree for the first time.

signal unpause

func _ready():
	change_focus("soweli")
	redo_color()
	menu._pause()
	yield(get_tree().create_timer(0.5
	), "timeout")
	$cutscenes.play("fadein")
	
func redo_color():
	persistent.set_color(self)

func change_focus(thing=""):
	if state != "game" || (thing in ["", "kije"] && !("kije" in persistent.sona["jo"])):
		return
	if (thing == "" && focus == "soweli") || thing == "kije":

		if kije_climbing:
			var new = kije.instance()
			new.position = $tawa/soweli.position
			new.position.y -= 48
			
			$tawa.add_child(new)
			$tawa/soweli.kije_climb(false)
			kije_climbing = false
			
		focus = "kije"
		$tawa/soweli.focus(false)
		$tawa/kije.focus(true)
		
	else:
		focus = "soweli"
		$tawa/soweli.focus(true)
		if !kije_climbing:
			$tawa/kije.focus(false)

func _input(event):
	if event.is_action_pressed("change_focus"):
		change_focus()
		


func kije_climb():
	$tawa/soweli.kije_climb(true)
	kije_climbing = true
	change_focus("soweli")
	
