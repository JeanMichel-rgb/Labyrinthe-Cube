extends Node

#region Variables
#region scene
@export_category("Scene's background")
@export var scene_bg_image : CompressedTexture2D
@export var scene_bg_color : Color
#endregion scene

#region GUI
@export_category("Text")
@export var font : Font
@export var font_color : Color
@export var disabled_font_alpha : float
@onready var disabled_font_color : Color = Color(font_color, disabled_font_alpha)
@export var font_selected_color : Color
@export var selection_color : Color
@export var font_outline_color : Color
@export var font_outline_size : int

@export_category("GUI")
@export var GUI_bg_color : Color
@export var GUI_outline_color : Color
@export var GUI_disabled_alpha : float
@onready var GUI_disabled_color : Color = Color(GUI_bg_color, GUI_disabled_alpha)
@onready var GUI_disabled_outline_color : Color = Color(GUI_outline_color, GUI_disabled_alpha)
@export var GUI_outline_size : int
@export var GUI_corner_radius : Vector4i

@export_category("Menus")
@export var menus_bg_image : CompressedTexture2D
@export var menus_bg_color : Color
#endregion GUI

#region NodesID
@onready var scene : Node2D = get_node("scene")
@onready var GUI : Node2D = get_node("GUI")
@onready var menus : Node2D = get_node("GUI/menus")
#endregion NodesID

#region Window
@onready var window : Window = get_window()
@onready var initial_window_size : Vector2i = window.size
@onready var window_ratio : float = float(window.size.y)/float(window.size.x)
#endregion Window

#region miscellaneous
var global_mouse_position : Vector2 = Vector2.ZERO
#endregion miscellaneous
#endregion Variables

func _ready() -> void:
	pass

func _process(delta: float) -> void:
	update()

#region Update
func update() -> void:
	update_variables()
	update_screen_size()
	update_scene()
	update_GUI()

func update_variables():
	global_mouse_position = scene.get_global_mouse_position()

func update_screen_size() -> void:
	window.size.y = window.size.x * window_ratio

func update_scene() -> void:
	#scene's scale
	var ratio : float = float(window.size.x) / float(initial_window_size.x)
	scene.scale = Vector2(1,1) * ratio
	#region Background
	var background : Node2D = scene.get_node("background")
	#image
	if scene_bg_image != null:
		background.texture = scene_bg_image
	#color
	background.modulate = scene_bg_color
	#scale
	background.scale = initial_window_size
	#position
	background.position = initial_window_size/2
	#endregion Backgrond

func update_GUI() -> void:
	#region Store node's ID
	#store here all Button's ID
	var buttons : Array = [
		
	]
	#store here all OptionButton's ID
	var option_buttons : Array = [
		
	]
	#store here all CheckButton's ID
	var check_buttons : Array = [
		
	]
	#store here all CheckBox's ID
	var check_boxs : Array = [
		
	]
	#store here all TextEdit's ID
	var text_edits : Array = [
		
		]
	#store here all LineEdit's ID
	var line_edits : Array = [
		
	]
	#store here all Label's ID
	var labels : Array = [
		
	]
	#endregion Store node's ID
	
	#region Themes
	#region Create control node's theme
	var control_node_theme : Theme = Theme.new()
	
	#region Text
	#region Button
	control_node_theme.set_font("font", "Button", font)
	control_node_theme.set_color("font_color", "Button", font_color)
	control_node_theme.set_color("font_disabled_color", "Button", disabled_font_color)
	control_node_theme.set_color("font_focus_color", "Button", font_color)
	control_node_theme.set_color("font_hover_color", "Button", font_color*1.5)
	control_node_theme.set_color("font_pressed_color", "Button", font_selected_color)
	control_node_theme.set_color("font_outline_color", "Button", font_outline_color)
	control_node_theme.set_constant("outline_size", "Button", font_outline_size)
	#endregion Button
	
	#region 0ptionButton
	control_node_theme.set_font("font", "0ptionButton", font)
	control_node_theme.set_color("font_color", "0ptionButton", font_color)
	control_node_theme.set_color("font_disabled_color", "0ptionButton", disabled_font_color)
	control_node_theme.set_color("font_focus_color", "0ptionButton", font_color)
	control_node_theme.set_color("font_hover_color", "0ptionButton", font_color*1.5)
	control_node_theme.set_color("font_hover_pressed_color", "0ptionButton", font_color*1.5)
	control_node_theme.set_color("font_pressed_color", "0ptionButton", font_color)
	control_node_theme.set_color("font_outline_color", "0ptionButton", font_outline_color)
	control_node_theme.set_constant("outline_size", "0ptionButton", font_outline_size)
	#endregion 0ptionButton
	
	#region CheckButton
	control_node_theme.set_font("font", "CheckButton", font)
	control_node_theme.set_color("font_color", "CheckButton", font_color)
	control_node_theme.set_color("font_disabled_color", "CheckButton", disabled_font_color)
	control_node_theme.set_color("font_focus_color", "CheckButton", font_color)
	control_node_theme.set_color("font_hover_color", "CheckButton", font_color*1.5)
	control_node_theme.set_color("font_hover_pressed_color", "CheckButton", font_color*1.5)
	control_node_theme.set_color("font_pressed_color", "CheckButton", font_color)
	control_node_theme.set_color("font_outline_color", "CheckButton", font_outline_color)
	control_node_theme.set_constant("outline_size", "CheckButton", font_outline_size)
	#endregion CheckButton
	
	#region CheckBox
	control_node_theme.set_font("font", "CheckBox", font)
	control_node_theme.set_color("font_color", "CheckBox", font_color)
	control_node_theme.set_color("font_disabled_color", "CheckBox", disabled_font_color)
	control_node_theme.set_color("font_focus_color", "CheckBox", font_color)
	control_node_theme.set_color("font_hover_color", "CheckBox", font_color*1.5)
	control_node_theme.set_color("font_hover_pressed_color", "CheckBox", font_color*1.5)
	control_node_theme.set_color("font_pressed_color", "CheckBox", font_color)
	control_node_theme.set_color("font_outline_color", "CheckBox", font_outline_color)
	control_node_theme.set_constant("outline_size", "CheckBox", font_outline_size)
	#endregion CheckBox
	
	#region TextEdit
	control_node_theme.set_font("font", "TextEdit", font)
	control_node_theme.set_color("font_placeholder_color", "TextEdit", disabled_font_color)
	control_node_theme.set_color("font_color", "TextEdit", font_color)
	control_node_theme.set_color("font_readonly_color", "TextEdit", font_color)
	control_node_theme.set_color("font_selected_color", "TextEdit", font_selected_color)
	control_node_theme.set_color("selection_color", "TextEdit", selection_color)
	control_node_theme.set_color("font_outline_color", "TextEdit", font_outline_color)
	control_node_theme.set_constant("outline_size", "TextEdit", font_outline_size)
	#endregion TextEdit
	
	#region LineEdit
	control_node_theme.set_font("font", "LineEdit", font)
	control_node_theme.set_color("font_color", "LineEdit", font_color)
	control_node_theme.set_color("font_selected_color", "LineEdit", font_selected_color)
	control_node_theme.set_color("selection_color", "LineEdit", selection_color)
	control_node_theme.set_color("font_uneditable_color", "LineEdit", disabled_font_color)
	control_node_theme.set_color("font_outline_color", "LineEdit", font_outline_color)
	control_node_theme.set_constant("outline_size", "LineEdit", font_outline_size)
	#endregion LineEdit
	#endregion Text
	
	#region Background
	#region Create the StyleBoxFlat template
	var _StyleBoxFlat : StyleBoxFlat = StyleBoxFlat.new()
	_StyleBoxFlat.bg_color = GUI_bg_color
	_StyleBoxFlat.corner_radius_top_left = GUI_corner_radius.x
	_StyleBoxFlat.corner_radius_top_right = GUI_corner_radius.y
	_StyleBoxFlat.corner_radius_bottom_left = GUI_corner_radius.z
	_StyleBoxFlat.corner_radius_bottom_right = GUI_corner_radius.w
	_StyleBoxFlat.border_width_bottom = GUI_outline_size
	_StyleBoxFlat.border_width_left = GUI_outline_size
	_StyleBoxFlat.border_width_top = GUI_outline_size
	_StyleBoxFlat.border_width_right = GUI_outline_size
	_StyleBoxFlat.border_color = GUI_outline_color
	#endregion Create the StyleBoxFlat template
	
	#region Adapt to multiples StyleBoxFlat
	#disabled
	var StyleBoxFlat_disabled : StyleBoxFlat = _StyleBoxFlat.duplicate()
	StyleBoxFlat_disabled.bg_color = GUI_disabled_color
	StyleBoxFlat_disabled.border_color = GUI_disabled_outline_color
	#normal
	var StyleBoxFlat_normal : StyleBoxFlat = _StyleBoxFlat.duplicate()
	#focus
	var StyleBoxFlat_focus : StyleBoxFlat = _StyleBoxFlat.duplicate()
	#hover
	var StyleBoxFlat_hover : StyleBoxFlat = _StyleBoxFlat.duplicate()
	StyleBoxFlat_disabled.bg_color *= 1.5
	#hover pressed
	var StyleBoxFlat_hover_pressed : StyleBoxFlat = StyleBoxFlat_hover.duplicate()
	#pressed
	var StyleBoxFlat_pressed : StyleBoxFlat = StyleBoxFlat_hover.duplicate()
	#endregion Adapt to multiples StyleBoxFlat
	
	#region Add backgrounds to control_node_theme
	for theme_type in ["Button", "0ptionButton", "CheckButton", "CheckBox", "TextEdit", "LineEdit"]:
		control_node_theme.set_stylebox("disabled", theme_type, StyleBoxFlat_disabled)
		control_node_theme.set_stylebox("normal", theme_type, StyleBoxFlat_normal)
		control_node_theme.set_stylebox("focus", theme_type, StyleBoxFlat_focus)
		control_node_theme.set_stylebox("hover", theme_type, StyleBoxFlat_hover)
		control_node_theme.set_stylebox("hover_pressed", theme_type, StyleBoxFlat_hover_pressed)
		control_node_theme.set_stylebox("pressed", theme_type, StyleBoxFlat_pressed)
	#endregion Add backgrounds to control_node_theme
	#endregion Background
	#endregion Create control node's theme
	
	#region Add theme
	for button in buttons:
		button.theme = control_node_theme
		button.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	
	for option_button in option_buttons:
		option_button.theme = control_node_theme
		option_button.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	
	for check_button in check_buttons:
		check_button.theme = control_node_theme
		check_button.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	
	for check_box in check_boxs:
		check_box.theme = control_node_theme
		check_box.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
		check_box.alignment = HORIZONTAL_ALIGNMENT_CENTER
	
	for text_edit in text_edits:
		text_edit.theme = control_node_theme
	
	for line_edit in line_edits:
		line_edit.theme = control_node_theme
	#endregion Add theme
	#endregion Themes
	
	#region Labels
	#region Create label settings
	var label_settings : LabelSettings = LabelSettings.new()
	label_settings.font = font
	label_settings.font_color = font_color
	label_settings.outline_color = font_outline_color
	label_settings.outline_size = font_outline_size
	#endregion Create label settings
	
	#region Add label settings
	for label in labels:
		label.label_settings = label_settings
	#endregion Add label settings
	#endregion Labels
	
	#create a dictionary with all nodes that can be focused
	var control_nodes : Dictionary = {
		"buttons" = buttons,
		"option_buttons" = option_buttons,
		"check_buttons" = check_buttons,
		"check_boxs" = check_boxs,
		"text_edits" = text_edits,
		"line_edits" = line_edits,
	}
	update_focus(control_nodes)

func update_focus(control_nodes : Dictionary) -> void:
	for node_type in control_nodes:
		for node in control_nodes[node_type]:
			if node.has_focus():
				if Input.is_action_just_pressed("click"):
					#get rectangle's global transform
					var rectangle_UpLeft_position : Vector2 = node.get_global_rect().position
					var rectangle_diagonal : Vector2 = node.get_global_rect().size
					var rectangle_rotation : float = node.get_global_transform().get_rotation()
					if not is_in_rectangle(global_mouse_position, rectangle_UpLeft_position, rectangle_diagonal, rectangle_rotation):
						node.release_focus()
#endregion Update

#region utilities
func is_in_rectangle(position : Vector2, rectangle_UpLeft_position : Vector2, rectangle_diagonal : Vector2, rectangle_rotation : float) -> bool:
	#recalculate the position based on rectangle's position and rotation
	position -= rectangle_UpLeft_position
	position = Vector2.from_angle(-rectangle_rotation + position.angle())*position.length()
	#check if position is in rectangle
	return (
		(position.x >= 0 and position.y >= 0) and
		(position.x <= rectangle_diagonal.x and position.y <= rectangle_diagonal.y)
	)
#endregion endregion
