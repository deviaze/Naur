local Color = require("@Classes/Color")
type Color = Color.Color

export type Page = {
	Properties: {
		Name: string,
	},
	Style: {
		BackgroundColor: Color,
		TextStyle: TextStyleOptions,
		FrameColor: Color,
		Font: string
	},
	Children: { Element },
	append: (self: Page, { Element }) -> Page,
	serialize: (self: Page) -> string,
}

type BaseElement = {
	Style: {
		BackgroundColor: Color,
	},
	Properties: {},
	Children: { Element },
}

export type Element<ElementType = BaseElement> = {
	Style: index<ElementType, "Style">,
	Properties: index<ElementType, "Properties">,
	Children: { Element }?,
	serialize: (self: any ) -> string,
	addChildren: (self: any, children: { Element }) -> Element,
}

local fonts = {
    Arial = "'Arial', sans-serif",
    Helvetica = "'Helvetica', sans-serif",
    TimesNewRoman = "'Times New Roman', serif",
    CourierNew = "'Courier New', monospace",
    Verdana = "'Verdana', sans-serif",
    Georgia = "'Georgia', serif",
    TrebuchetMS = "'Trebuchet MS', sans-serif",
    LucidaSansUnicode = "'Lucida Sans Unicode', 'Lucida Grande', sans-serif",
    Tahoma = "'Tahoma', sans-serif",
    PalatinoLinotype = "'Palatino Linotype', 'Book Antiqua', Palatino, serif",
    Impact = "'Impact', sans-serif",
    ComicSansMS = "'Comic Sans MS', cursive, sans-serif",
    LucidaConsole = "'Lucida Console', monospace",
    Garamond = "'Garamond', serif",
    ArialBlack = "'Arial Black', sans-serif",
    BrushScriptMT = "'Brush Script MT', cursive"
}

export type TextStyleOptions = {
	TextColor: Color,
	TextSize: number?,
	Padding: number?,
	Font: keyof<typeof(fonts)>?,
}

local function serializeTextStyleOptions(options: TextStyleOptions): string
	local result = 'style="'
	result ..= `color:{options.TextColor.RGB};`
	if options.TextSize then
		result ..= ` font-size:{options.TextSize}px;`
	end
	if options.Font then
		result ..= ` font-family:{fonts[options.Font]};`
	end

	result ..= ` padding: {options.Padding or 4}pt;"`

	return result
end

-- print(serializeTextStyleOptions{
-- 	TextColor = Color.new(100, 100, 100),
-- 	Font = "Garamond",
-- 	TextSize = 14.5,
-- })

return {
	Fonts = fonts,
	serializeTextStyleOptions = serializeTextStyleOptions,
}