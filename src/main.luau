
local self = {}

local types = require("@src/types")

type Page = types.Page

self.Components = {
	Container = require("./Components/Container"),
	Label = require("./Components/Label"),
	Text = require("./Components/Text"),
}

local Color = require("./Classes/Color")
type Color = Color.Color

local Components = self.Components

export type PageProperties = {
	Name: string,
	BackgroundColor: Color,
	TextStyle: types.TextStyleOptions,
	FrameColor: Color,
	Children: { types.Element }?,
}

function self.Page(PageProperties: PageProperties): Page
	local page = {
		Properties = {
			Name = PageProperties.Name,
		},
		Style = {
			BackgroundColor = PageProperties.BackgroundColor,
			FrameColor = PageProperties.FrameColor,
			TextStyle = {
				TextColor = PageProperties.TextStyle.TextColor,
				TextSize = PageProperties.TextStyle.TextSize or 12,
				Font = if PageProperties.TextStyle.Font then types.Fonts[PageProperties.TextStyle.Font] else "'Arial', sans-serif"
			},
		},
		Children = PageProperties.Children or {},
	} :: Page

	function page.append(self: Page, elements: { types.Element }): Page
		for _, element in elements do
			table.insert(self.Children, element)
		end
		return self
	end

	function page.serialize(self: Page): string

		local font_imports = [[	@import url('https://fonts.googleapis.com/css2?family=Arial:wght@400;700&display=swap');
				@import url('https://fonts.googleapis.com/css2?family=Helvetica:wght@400;700&display=swap');
				@import url('https://fonts.googleapis.com/css2?family=Times+New+Roman:wght@400;700&display=swap');
				@import url('https://fonts.googleapis.com/css2?family=Courier+New:wght@400;700&display=swap');
				@import url('https://fonts.googleapis.com/css2?family=Verdana:wght@400;700&display=swap');
				@import url('https://fonts.googleapis.com/css2?family=Georgia:wght@400;700&display=swap');
				@import url('https://fonts.googleapis.com/css2?family=Trebuchet+MS:wght@400;700&display=swap');
				@import url('https://fonts.googleapis.com/css2?family=Lucida+Sans+Unicode:wght@400;700&display=swap');
				@import url('https://fonts.googleapis.com/css2?family=Tahoma:wght@400;700&display=swap');
				@import url('https://fonts.googleapis.com/css2?family=Palatino+Linotype:wght@400;700&display=swap');
				@import url('https://fonts.googleapis.com/css2?family=Impact:wght@400;700&display=swap');
				@import url('https://fonts.googleapis.com/css2?family=Comic+Sans+MS:wght@400;700&display=swap');
				@import url('https://fonts.googleapis.com/css2?family=Lucida+Console:wght@400;700&display=swap');
				@import url('https://fonts.googleapis.com/css2?family=Garamond:wght@400;700&display=swap');
				@import url('https://fonts.googleapis.com/css2?family=Arial+Black:wght@400;700&display=swap');
				@import url('https://fonts.googleapis.com/css2?family=Brush+Script+MT:wght@400;700&display=swap');]]

		local result = ""

		result ..= [[
		<!DOCTYPE html>
		<html lang="en">
		<head>
    		<meta charset="UTF-8">
    		<meta name="viewport" content="width=device-width, initial-scale=1.0">
		]]
		result ..= "\t<title>" .. self.Properties.Name .. "</title>\n"
		result ..= `\z
			\t\t\t<style>\
			{font_imports}\
				body \{\
					color: {self.Style.TextStyle.TextColor.RGB};\
					background-color: {self.Style.BackgroundColor.RGB};\
					font-family: {self.Style.Font}\
				\}\
			</style>\
		</head>`
		
		result ..= "\n\t\t<body>\n"
		for _, element in self.Children do 
			result ..= "\t\t\t" .. element:serialize() .. "\n"
		end
		result ..= [[
		</body>
		</html>
		]]

		return result
	end

	return page
end


local page1: Page

local function Label(props: { Text: string, Style: {BackgroundColor: Color, TextStyle: types.TextStyleOptions }?, Children: {types.Element}?  }): types.Element
	local newLabel = Components.Label(page1, props :: any) :: types.Element
	if props.Children then
		newLabel:addChildren(props.Children)
	end
	return newLabel
end

local function Text(props: string | { Text: string, Style: { TextStyle: types.TextStyleOptions }? })
	local newText
	if typeof(props) == "string" then
		local passprops = {
			Text = props,
		}
		newText = Components.Text(page1, passprops :: any)
	else
		newText = Components.Text(page1, props)
	end
	return newText :: types.Element
end

local function Heading(text: string): types.Element
	return Label {
		Text = text,
		Style = {
			BackgroundColor = Color.new(40, 30, 52),
			TextStyle = {
				TextColor = Color.new(200, 200, 240),
				TextSize = 48,
				Font = "Verdana",
				Padding = 12,
			}
		}
	}
end

page1 = self.Page {
	Name = "TheNaurrPage",
	BackgroundColor = Color.new(30, 20, 42),
	FrameColor = Color.new(40, 60, 100),
	TextStyle = {
		TextColor = Color.new(240, 240, 240),
		TextSize = 12,
		Font = "LucidaConsole",
	},
}

page1:append {
	Heading "The Naurr Page",
	Text "idk lol",
	Label {
		Text = "meow"
	},
	Label {
		Text = "omg",
		Style = {
			BackgroundColor = Color.new(80, 90, 200),
			TextStyle = {
				TextColor = Color.new(200, 200, 240),
				TextSize = 28,
				Font = "Verdana",
			}
		},
		Children = {
			Label {
				Text = "hmm?",
				Children = {
					Label {
						Text = "hmmschild"
					}
				}
			}
		}
	}
}

local fs = require("@lune/fs")
fs.writeFile("./output.html", page1:serialize())

return self
