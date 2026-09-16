--!nonstrict

local status = noctalia.state.get("insomnia_status") or {
  active = false,
  busy = false,
  available = true,
}
local requestId = 0

local function render()
  if status.available == false then
    barWidget.setGlyph("bed-off")
    barWidget.setGlyphColor("error")
    barWidget.setTooltip(noctalia.tr("tooltip.unavailable"))
  elseif status.busy == true then
    barWidget.setGlyph("loader-2")
    barWidget.setGlyphColor("primary")
    barWidget.setTooltip(noctalia.tr("tooltip.changing"))
  elseif status.active == true then
    barWidget.setGlyph("bed")
    barWidget.setGlyphColor("tertiary")
    barWidget.setTooltip(noctalia.tr("tooltip.active"))
  else
    barWidget.setGlyph("shield-off")
    barWidget.setGlyphColor("on_surface_variant")
    barWidget.setTooltip(noctalia.tr("tooltip.inactive"))
  end
end

noctalia.state.watch("insomnia_status", function(value)
  if type(value) == "table" then
    status = value
    render()
  end
end)

render()

function onClick()
  if status.available == false then
    noctalia.notifyError(noctalia.tr("title"), status.error or noctalia.tr("error.missing_systemd"))
    return
  end
  if status.busy == true then return end

  requestId += 1
  noctalia.state.set("insomnia_command", {
    action = "toggle",
    requestId = `widget-{requestId}`,
  })
end

function onRightClick()
  requestId += 1
  noctalia.state.set("insomnia_command", {
    action = "refresh",
    requestId = `widget-refresh-{requestId}`,
  })
end
