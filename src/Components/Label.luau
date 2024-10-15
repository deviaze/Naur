local Color = require("@Classes/Color")
type Color = Color.Color

local Types = require("@src/types")
type Page = Types.Page

type Label = Types.Element<{
	Style: {
		BackgroundColor: Color,
		TextStyle: Types.TextStyleOptions,
	},
	Properties: {
		Text: string,
	}
}>

local Label = function(Page: Page, LabelProperties: { Text: string, Style: index<Label, "Style">? } ): Label
	local new = {
		Style = {},
		Properties = {},
		Children = {},
	} :: Label

	new.Style = LabelProperties.Style or Page.Style
	new.Properties.Text = LabelProperties.Text

	new.addChildren = function(self: Label, children: { Types.Element })
		local new = new :: Types.Element
		for _, element in children do 
			(table.insert :: any)(new.Children, element)
		end
		return new
	end

	new.serialize = function(self: Label)
		-- local t = "<div"
		-- handle style
		local t = `<div style="background-color:{if self.Style == Page.Style then Page.Style.FrameColor.RGB else self.Style.BackgroundColor.RGB};">`
		-- t ..= if self.Style == Page.Style then ">" else ` style="background-color:{self.Style.BackgroundColor.RGB};">`
		-- add text
		t ..= ` <p{if self.Style == Page.Style then ` {Types.serializeTextStyleOptions(Page.Style.TextStyle)}` else ` {Types.serializeTextStyleOptions(self.Style.TextStyle)}`}>{self.Properties.Text}</p>`
		if new.Children then
			for _, child in new.Children do
				if typeof(child) ~= "table" then error("expected table, got " .. tostring(child)) end
				t ..= "  " ..  child:serialize()
			end
		end
		-- close div
		t ..= "</div>"
		return t
	end

	return new
end


return Label