extends Button

# --- Переменные ---

# --- --- Ноды --- ---
@onready var le_find_element = %LE_FindElement
@onready var file_tree = %FileTree

# --- Методы ---

func _ready():
	# Делаем кнопку неактивной по умолчанию
	self.disabled = true
	pressed.connect(_on_filter_button_pressed)

# Включаем кнопку, когда папка выбрана
func enable_button():
	self.disabled = false  # Делаем кнопку активной

func _on_filter_button_pressed():
	var search_text = le_find_element.text.strip_edges().to_lower()
	file_tree.filter_tree(search_text)
