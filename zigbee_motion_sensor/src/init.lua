-- Alejandro Padilla Flores

local capabilities = require "st.capabilities"
local ZigbeeDriver = require "st.zigbee"
local defaults = require "st.zigbee.defaults"

local zigbee_motion_driver = {
   supported_capabilites = {
     capabilities.motionSensor,
	 capabilities.battery
   }
}

defaults.register_for_default_handlers(zigbee_motion_driver, zigbee_motion_driver.supported_capabilites)
local motion = ZigbeeDriver("zigbee_motion", zigbee_motion_driver)
motion:run()
