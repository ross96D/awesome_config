local spawn = require("awful.spawn")
local with_shell = spawn.with_shell

local run_once = require("actionless.util.spawn").run_once


local autorun = {}

function autorun.init(awesome_context)
  local sanwa_pad = true

  if sanwa_pad then -- detect it after asynchronously reading `xinput list` output
    --libinput-based:
    spawn {
      'xinput', 'set-prop', 'HID 04d9:1166',
      "libinput Scroll Method Enabled", '0', '0', '1'
    }
  end

  -- keyboard settings:
  spawn { "xset", "r", "rate", "250", "25" }
  spawn { "xset", "b", "off" } -- turn off beep
  spawn {
    "setxkbmap",
    "-layout", "us,es",
    -- "-variant", ",winkeys",
    -- "-option", "grp:caps_toggle,grp_led:caps,terminate:ctrl_alt_bksp,compose:ralt"
  }

  run_once { awesome_context.cmds.compositor }

  with_shell("start-pulseaudio-x11") -- yes, with shell

  for _, item in ipairs(awesome_context.autorun) do
    with_shell(item)
  end

  local delayed_call = require("gears.timer").delayed_call
  delayed_call(function()
    run_once { "unclutter" }
    run_once { "kbdd" }
  end)
end

return autorun
