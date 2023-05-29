local capabilities = require "st.capabilities"
local clusters = require "st.zigbee.zcl.clusters"

local OnOff = clusters.OnOff
local Level = clusters.Level

local command_handlers = {}

-- handlers 
function command_handlers.on_off_attr_handler(driver, device, value, zb_rx)
		local attr = capabilities.switch.switch
		return device:emit_event(value.value and attr.on() or attr.off())	
end

function command_handlers.on_handler(driver, device, command)
		local ep = device:get_endpoint_for_component_id(command.component)
		local attr = OnOff.server.commands

		local onoff = command.command == 'on' and attr.On or attr.Off
		return device:send(onoff(device):to_endpoint(ep))
end

function command_handlers.setLevel(driver, device, command)
		local ep = device:get_endpoint_for_component_id(command.component)
		local attr = Level.server.commands

		local level = command.command == attr
		return device:send(level(device):to_endpoint(ep))
end

return command_handlers
