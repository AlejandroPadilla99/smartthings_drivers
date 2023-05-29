local capabilities = require "st.capabilities"
local ZigbeeDriver = require "st.zigbee"
local clusters = require "st.zigbee.zcl.clusters"
local booleantypes = require "st.zigbee.data_types.Boolean"
local utils = require "st.utils"

-- import clusters
local OnOff = clusters.OnOff
local Level = clusters.Level

-- import command_handlers
local command_handlers = require "command_handlers"
-- import lifecycles
local lifecycles = require "lifecycles"

--- driver cconfig
local zigbee_light_driver_template = {
		supported_capabilities = {
				capabilities.switch,
				capabilities.switchLevel
		},
		lifecycle_handlers = {
				added = lifecycles.device_added,
				doConfigure = lifecycles.do_configured
		},
		zigbee_handlers = {
				global = {},
				cluster = {},
				attr = {
				-- Switch
						[OnOff.ID] = {
								[OnOff.attributes.OnOff.ID] = command_handlers.on_off_attr_handler,
						}
				}
		},
		capability_handlers = {
				[capabilities.switch.ID] = {
						[capabilities.switch.commands.on.NAME] = command_handlers.on_handler,
						[capabilities.switch.commands.off.NAME] = command_handlers.on_handler
				},
				[capabilities.level.ID] = {
						[capabilities.level.commands.
				}
		}
		
}

local zigbee_light = ZigbeeDriver("zigbee-light", zigbee_light_driver_template)
zigbee_light:run()
