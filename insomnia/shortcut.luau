--!nonstrict

local status = noctalia.state.get("insomnia_status") or {
  active = false,
  busy = false,
  available = true,
}
local requestId = 0

local function render()
  local active = status.active == true
  shortcut.setLabel(if active then noctalia.tr("shortcut.active") else noctalia.tr("shortcut.inactive"))
  shortcut.setIcon("bed-off", "bed")
  shortcut.setActive(active)
  shortcut.setEnabled(status.available ~= false and status.busy ~= true)
end

noctalia.state.watch("insomnia_status", function(value)
  if type(value) == "table" then
    status = value
    render()
  end
end)

render()

function onClick()
  if status.available == false or status.busy == true then return end
  requestId += 1
  noctalia.state.set("insomnia_command", {
    action = "toggle",
    requestId = `shortcut-{requestId}`,
  })
end
