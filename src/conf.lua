function love.conf(t)
	t.appendidentity = false
	t.version = "11.4"
	t.audio.mixwithsystem = true

	t.window.title = "Connection"
    t.window.icon = "assets/img/icon.png"
	t.window.width = 640
	t.window.height = 640
	t.window.vsync = 1
end
