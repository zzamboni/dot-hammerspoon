package.path = package.path .. ';plugins/?.lua'
require("omh-lib")

for i,plugin in ipairs(OMH_PLUGINS) do
   require(plugin)
end
