-- Enable faster loading
if vim.loader then
  vim.loader.enable()
end

-- Debug utilities
_G.dd = function(...)
  require("util.debug").dump(...)
end
vim.print = _G.dd

-- Load the rest of your configuration
require("config.lazy")