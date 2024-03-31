-- Enable jit if on luajit
pcall(function() jit.on() end)

-- Localization
os.setlocale(os.getenv("LANG"))

-- Default icon size
awesome.set_preferred_icon_size(256)


local awful_util = require("awful.util")
local awful_spawn = require("awful.spawn")


-- Add third-party modules to lua path
local userconfdir = awful_util.get_configuration_dir()
package.path = package.path .. ';' .. userconfdir .. 'third_party/?.lua;' .. userconfdir .. 'third_party/?/init.lua'


-- Run session and settings daemon
-------------------------------------------------------------------------------
-- option a)
-- awful_spawn.with_shell("xsettingsd")
--awful_spawn.once("/usr/lib/mate-polkit/polkit-mate-authentication-agent-1")
-- option b)
--awful_spawn.once("lxsession -a -n -r -s awesome -e LXDE")
--awful_spawn.once("lxpolkit")
-- option c)
awful_spawn.with_shell("gnome-session")
--awful_spawn.with_shell("/usr/lib/gnome-settings-daemon/gnome-settings-daemon")


-- Hotkeys help for apps
-------------------------------------------------------------------------------
-- Enable all available hotkey help maps
-- Load local hotkeys help
require("hotkeys")

-- GLOBAL debug helpers:
-------------------------------------------------------------------------------
-- local debug = require("actionless.util.debug")
-- nlog = debug.nlog
-- log = debug.log


-- Config state object:
-------------------------------------------------------------------------------
local editor = "nvim"
local terminal = "kitty"
local context = {

  --DEVEL_DYNAMIC_LAYOUTS = true,
  DEVEL_DYNAMIC_LAYOUTS = false,

  modkey = "Mod4",
  altkey = "Mod1",
  clientbuttons = nil,
  clientkeys = nil,

  theme_dir = awful_util.getdir("config") .. "/themes/gtk/theme.lua",

  -- @TODO: rename to 'widget_config'
  config = {
    net_preset = 'netctl-auto',
    wlan_if = 'wlp12s0',
    eth_if = 'enp0s25',
    -- music_players = { 'spotify', 'clementine' },
  },
  -- @TODO: move to 'widget_config'?
  have_battery = true,
  sensors = {
    gpu = {
      device = 'amdgpu-pci-0100',
      sensor = 'temp1',
      warning = 89,
    },
    cpu = {
      device = 'k10temp-pci-00c3',
      sensor = 'temp1',
      warning = 65,
    },
  },
  apw_on_the_left = false,

  cmds = {
    terminal       = terminal,
    terminal_light = terminal, -- @TODO: add it

    editor_cmd     = terminal .. " -e " .. editor,

    compositor     = "killall picom; picom", -- is necessary to killall picom?????

    -- scrot_preview_cmd = [['mv $f ~/images/ && viewnior ~/images/$f']],

    system_monitor = 'gnome-system-monitor',
  },

  autorun = {},

  -- place for custom callbacks:
  before_config_loaded = {},
  after_config_loaded = {},

  extra_global_keys = {},


  -- can't be overriden in local settings:
  widgets = {},
  menu = {},
  topwibox = {},
  topwibox_layout = {},
  lcars_assets = {},
}


-- Make it global for debugging:
CONFIG_CONTEXT = context


-- Init default terminal emulator
-------------------------------------------------------------------------------
require("menubar.utils").terminal = context.cmds.terminal


-- Init theme
-------------------------------------------------------------------------------
local beautiful = require("beautiful")
beautiful.init(context.theme_dir)


-- Init config
-------------------------------------------------------------------------------
for _, callback in ipairs(context.before_config_loaded) do
  callback()
end
local config = require("config")
config.notify.init(context)
config.autorun.init(context)
config.menu.init(context)
config.menubar.init(context)
config.layouts.init(context)
config.widgets.init(context)
config.toolbar_horizontal.init(context)
config.keys.init(context)
config.signals.init(context)

local persistent = require("actionless.persistent")
if persistent.lcarslist.get() then
  --@TODO: somewhere inside a nasty memory leak is hiding:
  config.lcars_toolbar_vertical.init(context)
  config.lcars_toolbar_horizontal.init(context)
  config.lcars_layout.init(context)
end
config.rules.init(context)
for _, callback in ipairs(context.after_config_loaded) do
  callback()
end

-- END
