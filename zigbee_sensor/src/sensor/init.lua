-- Alejandro Padilla

local zcl_commands = require "st.zigbee.zcl.global_commands"
local multi_utils = require "multi-sensor/multi_utils"
local zcl_clusters = require "st.zigbee.zcl.clusters"
local contactSensor_defaults = require "st.zigbee.defaults.contactSensor_defaults"

local utils = require "st.utils"


----------- utils for the driver
local cluster = {}

local SAMJIN_MFG = 0x1241

local CUSTOM_ACCELERATION_CLUSTER = 0xFC02
local AXIS_X_ATTR = 0x0012
local AXIS_Y_ATTR = 0x0013
local AXIS_Z_ATTR = 0x0014

local axis_x_config_base = utils.deep_copy(axis_config_base)
axis_x_config_base.attribute = AXIS_X_ATTR
multi_utils.axis_x_config_base = axis_x_config_base
local axis_y_config_base = utils.deep_copy(axis_config_base)
axis_y_config_base.attribute = AXIS_Y_ATTR
multi_utils.axis_y_config_base = axis_y_config_base
local axis_z_config_base = utils.deep_copy(axis_config_base)
axis_z_config_base.attribute = AXIS_Z_ATTR
multi_utils.axis_z_config_base = axis_z_config_base

local function handle_three_axis_report(device, x, y, z)
  if x ~= nil and y ~= nil and z ~= nil then
    device:emit_event(capabilities.threeAxis.threeAxis({value = {x, y, z}}))
  end
end
-----------

local ACCELERATION_CONFIG = utils.deep_copy(multi_utils.acceleration_config_base)
ACCELERATION_CONFIG.minimum_interval = 0
local AXIS_X_CONFIG = utils.deep_copy(axis_x_config_base)
AXIS_X_CONFIG.minimum_interval = 0
local AXIS_Y_CONFIG = utils.deep_copy(axis_y_config_base)
AXIS_Y_CONFIG.minimum_interval = 0
local AXIS_Z_CONFIG = utils.deep_copy(axis_z_config_base)
AXIS_Z_CONFIG.minimum_interval = 0

local function multi_sensor_report_handler(driver, device, zb_rx)
  local x, y,z
  for i,v in ipairs(zb_rx.body.zcl_body.attr_records) do
    if (v.attr_id.value == AXIS_X_ATTR) then
      y = v.data.value
    elseif (v.attr_id.value == AXIS_Y_ATTR) then
      z = v.data.value
    elseif (v.attr_id.value == AXIS_Z_ATTR) then
      x = v.data.value
    --elseif (v.attr_id.value == multi_utils.ACCELERATION_ATTR) then
      --multi_utils.handle_acceleration_report(device, v.data.value)
    --end
  end
  handle_three_axis_report(device, x, y, z)
end


local do_configure = function(self, device)
  device:configure()
  device:send(multi_utils.custom_write_attribute(device, multi_utils.MOTION_THRESHOLD_MULTIPLIER_ATTR, data_types.Uint8, 0x14, SAMJIN_MFG))
  device:send(device_management.build_bind_request(device, multi_utils.CUSTOM_ACCELERATION_CLUSTER, self.environment_info.hub_zigbee_eui))
  device:send(multi_utils.custom_configure_reporting(device, ACCELERATION_CONFIG, SAMJIN_MFG))
  device:send(multi_utils.custom_configure_reporting(device, AXIS_X_CONFIG, SAMJIN_MFG))
  device:send(multi_utils.custom_configure_reporting(device, AXIS_Y_CONFIG, SAMJIN_MFG))
  device:send(multi_utils.custom_configure_reporting(device, AXIS_Z_CONFIG, SAMJIN_MFG))
end


local do_refresh = function(_, device)
  print("device refleshed")
  device:reflesh()
end

---------------------
local sensor = {
  NAME = "Zigbee sensor",
  lifecycle_handlers = {
    doConfigure = do_configure
  },
  -- zigbee handlers
  capability_handlers = { 
	  [capabilities.refresh.ID] = {
        [capabilities.refresh.commands.refresh.NAME] = do_refresh,
      }
  },
  zigbee_handler = {
		-- add zigbee handler 
    [zcl_commands.ReportAttribute.ID] = multi_sensor_report_handler,
    [zcl_commands.ReadAttributeResponse.ID] = multi_sensor_report_handler
  }
  can_handle = function(opts, driver, device, ...)
    return device:get_manufacturer() == "Samjin"
  end
}

return sensor
