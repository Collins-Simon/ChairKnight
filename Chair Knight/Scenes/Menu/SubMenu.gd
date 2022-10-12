class_name SubMenu
extends Control

## This SubMenu's focus.
var local_focus : Control

## Records the current Control focus as the local focus.
func register_focus_as_local():
	self.local_focus = get_focus_owner()
