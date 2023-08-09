-- Alejandro Padilla Flores

local capabilities = require "st.capabilities"
local zcl_clusters = require "st.zigbee.zcl.clusters"
local constants = require "st.zigbee.constants"
local ZigbeeDriver = require "st.zigbee"
local defaults = require "st.zigbee.defaults"
local configurationMap = require "configurations"

local function device_init(driver, device)
  local configuration = configurationMap.get_device_configuration(device)
  if configuration ~= nil then
    for _, attribute in ipairs(configuration) do
      device:add_configured_attribute(attribute)
	  device:add_monitored_attribute(attribute)
    end
  end
end


-- template
local zigbee_contact_driver_template = {
  supported_capabilites = {
    capabilities.contactSensor,
    capabilities.temperatureMeasurement,
    capabilities.battery,
    capabilities.threeAxis,
    capabilities.accelerationSensor
  },
  lifecycle_handlers = {
    init = device_init
  },
  ias_zone_configuration_method = constants.IAS_ZONE_CONFIGURE_TYPE.AUTO_ENROLL_RESPONSE
}


defaults.register_for_default_handlers(zigbee_contact_driver_template, zigbee_contact_driver_template.supported_capabilites)
local zigbee_contact = ZigbeeDriver("zigbee_contact", zigbee_contact_driver_template)
zigbee_contact:run()
