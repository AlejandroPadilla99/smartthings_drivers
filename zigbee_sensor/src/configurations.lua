-- Alejandro Padilla Flores

-- Description:
-- this is the diferents configurations of all devices supported by this driver
local clusters = require "st.zigbee.zcl.clusters"

local IASZone = clusters.IASZone
local PowerConfiguration = clusters.PowerConfiguration
local TemperatureMeasurement = clusters.TemperatureMeasurement

local device = {
  ZONOFF = {
    FINGERPRINTS = {
      { mfr = "eWeLink", model = "DS01" }
	},
	CONFIGURATION = {
      {
        cluster = PowerConfiguration.ID,
        attribute = PowerConfiguration.attributes.BatteryPercentageRemaining.ID,
        minimum_interval = 30,
        maximum_interval = 600,
        data_type = PowerConfiguration.attributes.BatteryPercentageRemaining.base_type,
        reportable_change = 1
      },
      {
        cluster = IASZone.ID,
        attribute = IASZone.attributes.ZoneStatus.ID,
        minimum_interval = 30,
        maximum_interval = 300,
        data_type = IASZone.attributes.ZoneStatus.base_type,
        reportable_change = 1
      }
	}
  }
}

local configurations = {}

configurations.get_device_configuration = function(zigbee_device)
  for _, device in pairs(device) do
    for _, fingerprint in pairs(device.FINGERPRINTS) do
      if zigbee_device:get_manufacturer() == fingerprint.mfr and zigbee_device:get_model() == fingerprint.model then
        return device.CONFIGURATION
      end
    end
  end
  return nil
end

return configurations
