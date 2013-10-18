#!/usr/local/bin/lua
--[[

lr2acr

Convert Lightroom .lrtemplate to Adobe Bridge .xmp format

jarnoh@komplex.org	October 2013


Notes:
- this is not secure, loadstring will execute code
- Gradients, Brushes, Redeye, Paints etc are not supported
]]

local lrtemplate = require "lrtemplate"
local xmpgenerator = require "xmpgenerator"

local lr = lrtemplate.loadlrtemplate(io.read("*a"))
local ds = lr.value.settings

print(xmpgenerator.generatepreset(lr.value.uuid, lr.internalName, ds))

