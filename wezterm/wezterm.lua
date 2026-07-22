-- WezTerm config
-- Docs: https://wezterm.org/config/lua/general.html
local wezterm = require('wezterm')
local config = wezterm.config_builder()


config.font = wezterm.font({
   family = 'Consolas ligaturized v3',
   weight = 'Regular',
})
config.font_size = 12

config.use_ime = true

-- Transparency
config.window_background_opacity = 0.95

-- Background image 
config.background = {
  {
    source = {
      File = wezterm.config_dir .. '/img/wanye.jpg',
    },
    width = 'Cover',
    height = 'Cover',
    horizontal_align = 'Center',
    vertical_align = 'Middle',
    -- 压暗背景，保证文字清晰可读（0.05~0.3 按喜好调）
    hsb = {
      brightness = 0.02,
      hue = 1.0,
      saturation = 1.0,
    },
  },
}

--config.front_end = 'OpenGL'
--config.win32_system_backdrop = 'Acrylic'

-- Default shell
config.default_prog = { 'pwsh','-NoLogo','-NoExit' }
config.launch_menu = {
      {
         label = 'PowerShell Core',
         args = { 'pwsh', '-NoLogo', '-NoExit', '-File', pwsh_init },
      },
      {
         label = 'PowerShell Core (plain)',
         args = { 'pwsh', '-NoLogo' },
      },
      {
         label = 'Git Bash',
         args = { 'C:\\Program Files\\Git\\git-bash.exe' },
      },
   }
config.automatically_reload_config = true

----------------------------------------------------
-- Keys（独立配置文件 keys.lua）
-- 禁用内置快捷键后，只保留 keys.lua 中定义的绑定
----------------------------------------------------
config.disable_default_key_bindings = true
local keyconf = require('keys')
config.keys = keyconf.keys
if keyconf.key_tables then
   config.key_tables = keyconf.key_tables
end
config.mouse_bindings = keyconf.mouse_bindings


----------------------------------------------------
-- 窗口大小 & 出现位置 (2000x1200, centered)
-- https://wezterm.org/config/lua/gui-events/gui-startup.html
----------------------------------------------------
local WINDOW_WIDTH = 2000
local WINDOW_HEIGHT = 1200

wezterm.on('gui-startup', function(cmd)
   local _, _, window = wezterm.mux.spawn_window(cmd or {})
   local gui = window:gui_window()
   gui:set_inner_size(WINDOW_WIDTH, WINDOW_HEIGHT)

   local screen = wezterm.gui.screens().active
   local x = screen.x + math.floor((screen.width - WINDOW_WIDTH) / 2)
   local y = screen.y + math.floor((screen.height - WINDOW_HEIGHT) / 2)
   gui:set_position(x, y)
end)

----------------------------------------------------
-- 标签栏
----------------------------------------------------
-- Hide the title bar
config.window_decorations = "RESIZE"
-- Show the tab bar
--config.show_tabs_in_tab_bar = true
-- Hide the tab bar when there is only one tab
--config.hide_tab_bar_if_only_one_tab = true

config.tab_max_width = 20

-- Fancy 标签栏：高度由 window_frame.font_size 控制
config.use_fancy_tab_bar = true
config.window_frame = {
  font = wezterm.font({ family = 'Consolas ligaturized v3', weight = 'Regular' }),
  font_size = 14, -- 调大/调小可改变 tab 栏高度
  active_titlebar_bg = '#000000',
  inactive_titlebar_bg = '#000000',
}

-- 新建标签按钮（true 显示 / false 隐藏）
config.show_new_tab_button_in_tab_bar = true
-- 隐藏每个 tab 上的关闭按钮（仅 fancy 标签栏；较新版本支持）
config.show_close_tab_button_in_tabs = false

-- 标签栏颜色
config.colors = {
  tab_bar = {
    background = '#000000',
    inactive_tab_edge = '#000000',
  },
}

--激活标签变色
local SOLID_LEFT_ARROW = wezterm.nerdfonts.ple_lower_right_triangle
local SOLID_RIGHT_ARROW = wezterm.nerdfonts.ple_upper_left_triangle

wezterm.on("format-tab-title", function(tab, tabs, panes, config, hover, max_width)
   --所有标签的背景色、字体色、标签栏底色
   local background = "#333333"
   local foreground = "#FFFFFF"
   local edge_background = "#000000"
   --选中的
   if tab.is_active then
     background = "#ff8e67"
     foreground = "#FFFFFF"
   end
   local edge_foreground = background

   -- max_width 限制的是整段 tab 文本（含左右箭头）。
   -- 左右箭头各占 1 格，必须预留 2，否则右侧箭头会被裁掉。
   local title = " " .. tab.active_pane.title .. "  "
   title = wezterm.truncate_right(title, math.max(0, max_width - 2))

   return {
     { Background = { Color = edge_background } },
     { Foreground = { Color = edge_foreground } },
     { Text = SOLID_LEFT_ARROW },
     { Background = { Color = background } },
     { Foreground = { Color = foreground } },
     { Text = title },
     { Background = { Color = edge_background } },
     { Foreground = { Color = edge_foreground } },
     { Text = SOLID_RIGHT_ARROW },
   }
 end)


return config
