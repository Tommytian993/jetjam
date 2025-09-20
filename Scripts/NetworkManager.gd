extends Node

# 网络配置
const MAX_CLIENTS = 4 # 最大连接客户端数量

# UI引用
@onready var ip_input = $Network/NetworkUI/VBoxContainer/IPInput
@onready var port_input = $Network/NetworkUI/VBoxContainer/PortInput
@onready var username_input = $Network/NetworkUI/VBoxContainer/UsernameInput

# 本地玩家数据
var local_username: String

# 当节点首次进入场景树时调用
func _ready() -> void:
	# 准备就绪时连接UI信号
	connect_ui_signals()

# 连接按钮信号到网络功能
func connect_ui_signals() -> void:
	var start_server_btn = $Network/NetworkUI/VBoxContainer/StartServerButton
	var join_server_btn = $Network/NetworkUI/VBoxContainer/JoinServerButton
	
	start_server_btn.pressed.connect(_on_start_server_pressed)
	join_server_btn.pressed.connect(_on_join_server_pressed)

# 开始托管多人游戏服务器
func start_host() -> void:
	var peer = ENetMultiplayerPeer.new() # 创建ENet对等体用于可靠网络连接
	peer.create_server(int(port_input.text), MAX_CLIENTS) # 使用端口和最大客户端数创建服务器
	multiplayer.multiplayer_peer = peer # 设置为活跃的多人游戏对等体
	print("服务器已启动，端口: ", port_input.text)

# 开始作为客户端连接
func start_client() -> void:
	var peer = ENetMultiplayerPeer.new() # 创建ENet对等体用于可靠网络连接
	peer.create_client(ip_input.text, int(port_input.text)) # 连接到服务器IP和端口
	multiplayer.multiplayer_peer = peer # 设置为活跃的多人游戏对等体
	print("正在连接到: ", ip_input.text, ":", port_input.text)

# 处理启动服务器按钮按下事件
func _on_start_server_pressed() -> void:
	local_username = username_input.text # 存储本地用户名
	start_host() # 开始托管

# 处理加入服务器按钮按下事件
func _on_join_server_pressed() -> void:
	local_username = username_input.text # 存储本地用户名
	start_client() # 连接到服务器
