local Color = require("@Classes/Color")
type Color = Color.Color

local Types = require("@src/types")
type Page = Types.Page

type Text = Types.Element<{
	Style: {
		TextStyle: Types.TextStyleOptions,
	},
	Properties: {
		Text: string,
	}
}>

local Text = function(Page: Page, LabelProperties: { Text: string, Style: index<Text, "Style">? } ): Text
	local new = {
		Style = {},
		Properties = {},
		Children = {},
	} :: Text

	new.Style = LabelProperties.Style or Page.Style
	new.Properties.Text = LabelProperties.Text

	new.addChildren = function(self: Text, children: { Types.Element })
		local new = new :: Types.Element
		for _, element in children do 
			(table.insert :: any)(new.Children, element)
		end
		return new
	end

	new.serialize = function(self: Text)
		local t = ""
		t ..= `  <p{if self.Style == Page.Style then "" else ` {Types.serializeTextStyleOptions(self.Style.TextStyle)}`}>{self.Properties.Text}</p>`
		if new.Children then
			for _, child in new.Children do
				if typeof(child) ~= "table" then error("expected table, got " .. tostring(child)) end
				t ..= "  " ..  child:serialize()
			end
		end
		return t
	end

	return new
end


return Text