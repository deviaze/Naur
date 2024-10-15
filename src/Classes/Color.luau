local Color = {}

local function hexToRGB(code: string)
	local sr: string?, sg: string?, sb: string? = code:match("#(%x%x)(%x%x)(%x%x)")
	local r = tonumber(sr, 16) :: number
	local g = tonumber(sg, 16) :: number
	local b = tonumber(sb, 16) :: number
	return { r = r, g = g, b = b }
end

local function rgbToHex(r, g, b)
    return string.format("#%02X%02X%02X", r, g, b)
end


--- Accepts a hex code as a string in the format "#ABCDEF"; will use a type function to statically validate parameters once type functions get stabler
function Color.fromHex(code: string): Color
	if #code ~= 7 or not code:match("#[AaBbCcDdEeFf%d]+$") then
		error(`Color.fromHex: {code} is not a valid hex color code.\nHex color codes must start with # and be followed by 6 valid hex digits (0-F)`)
	end

	local rgb = hexToRGB(code)
	return Color.new(rgb.r, rgb.g, rgb.b)
end

function Color.new(r: number, g: number, b: number): Color
	local color = {
		Hex = rgbToHex(r, g, b),
		RGB = `rgb({r}, {g}, {b})`,
	}

	return color
end

export type Color = {
	Hex: string,
	RGB: string,
}


-- local color = Color.fromHex("meow" :: "meow")


return Color