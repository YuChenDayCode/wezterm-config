-- Key bindings
-- Docs: https://wezterm.org/config/keys.html
-- Default keys: https://wezterm.org/config/default-keys.html
local wezterm = require('wezterm')
local act = wezterm.action

local keys = {
   ------------------------------------------------
   -- 标签切换
   ------------------------------------------------
   -- 默认：Ctrl+Tab → 下一个标签
   { key = 'Tab', mods = 'CTRL', action = act.ActivateTabRelative(1) },
   -- 默认：Ctrl+Shift+Tab → 上一个标签
   { key = 'Tab', mods = 'CTRL|SHIFT', action = act.ActivateTabRelative(-1) },

   -- Ctrl+1..6：切换到对应标签（从 0 起算）
   { key = '1', mods = 'CTRL', action = act.ActivateTab(0) },
   { key = '2', mods = 'CTRL', action = act.ActivateTab(1) },
   { key = '3', mods = 'CTRL', action = act.ActivateTab(2) },
   { key = '4', mods = 'CTRL', action = act.ActivateTab(3) },
   { key = '5', mods = 'CTRL', action = act.ActivateTab(4) },
   { key = '6', mods = 'CTRL', action = act.ActivateTab(5) },

   ------------------------------------------------
   -- 分屏 / 标签
   ------------------------------------------------
   -- Alt+\：左右分屏
   {
      key = '\\',
      mods = 'ALT',
      action = act.SplitHorizontal({ domain = 'CurrentPaneDomain' }),
   },
   -- Alt+-：上下分屏
   {
      key = '-',
      mods = 'ALT',
      action = act.SplitVertical({ domain = 'CurrentPaneDomain' }),
   },
   -- Alt+t：新建标签
   {
      key = 't',
      mods = 'ALT',
      action = act.SpawnTab('CurrentPaneDomain'),
   },
   -- Alt+c：关闭当前分屏；唯一 pane 时关闭标签
   {
      key = 'c',
      mods = 'ALT',
      action = act.CloseCurrentPane({ confirm = true }),
   },

   ------------------------------------------------
   -- 字体大小（默认）
   ------------------------------------------------
   -- Ctrl++ / Ctrl+=：放大字体
   { key = '=', mods = 'CTRL', action = act.IncreaseFontSize },
   { key = '+', mods = 'CTRL', action = act.IncreaseFontSize },
   -- Ctrl+-：缩小字体
   { key = '-', mods = 'CTRL', action = act.DecreaseFontSize },
   -- Ctrl+0：重置字体大小
   { key = '0', mods = 'CTRL', action = act.ResetFontSize },

   ------------------------------------------------
   -- 窗口 / 面板 / 搜索（默认语义）
   ------------------------------------------------
   -- Alt+Enter：全屏切换
   { key = 'Enter', mods = 'ALT', action = act.ToggleFullScreen },
   -- Ctrl+N：新建窗口
   { key = 'n', mods = 'CTRL', action = act.SpawnWindow },
   -- Ctrl+P：命令面板
   { key = 'p', mods = 'CTRL', action = act.ActivateCommandPalette },
   -- Ctrl+F：搜索
   { key = 'f', mods = 'CTRL', action = act.Search({ CaseSensitiveString = '' }) },

   ------------------------------------------------
   -- Copy Mode（f/F/t/T 字符跳转在此模式下生效）
   -- 默认入口：Ctrl+Shift+X
   ------------------------------------------------
   { key = 'x', mods = 'CTRL|SHIFT', action = act.ActivateCopyMode },
}

-- 恢复默认 copy_mode / search_mode（含 f/F/t/T 字符跳转）
local key_tables = nil
if wezterm.gui then
   key_tables = wezterm.gui.default_key_tables()
end

-- 鼠标绑定
-- Docs: https://wezterm.org/config/mouse.html
-- disable_default_key_bindings 也会清掉默认鼠标绑定
local mouse_bindings = {
   -- Ctrl+Alt + 左键拖拽空白处：拖动整个窗口
   {
      event = { Drag = { streak = 1, button = 'Left' } },
      mods = 'CTRL|ALT',
      action = act.StartWindowDrag,
   },
}

return {
   keys = keys,
   key_tables = key_tables,
   mouse_bindings = mouse_bindings,
}
