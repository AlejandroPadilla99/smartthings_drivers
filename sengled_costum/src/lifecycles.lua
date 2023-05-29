local clusters = require "st.zigbee.zcl.clusters"
local booleantypes = require "st.zigbee.data_types.Boolean"
local utils = require "st.utils"

-- import clusters
local OnOff = clusters.OnOff
local Level = clusters.Level

local lifecycles = {}

function lifecycles.device_added(driver, device, value, zb_rx)
		print("added device")
		local endpoint = device:get_endpoint(device_config)
		print(endpoint)
		local readValue = OnOff.attributes.OnOff:read(device)
		device:send(readValue)
end

function lifecycles.do_configured(driver, device)
		local on_off_configuration =   {
				cluster = OnOff.ID,
				attribute = OnOff.attributes.OnOff.ID,
				minimum_interval = 0,
				maximum_interval = 300,
				data_type = booleantypes
		}
		print(utils.stringify_table(on_off_configuration))

		device:add_configured_attribute(on_off_configuration)
        device:add_monitored_attribute(on_off_configuration)
		device:configure()
end

return lifecycles
