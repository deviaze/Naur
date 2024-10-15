--!nocheck
local Naur = require("../../src/main")

local Container, Element = Naur.Container, Naur.Element

local result: string = Naur.HTML {
	Container {
		Element "Label" {
			Text = "meow"
		}
	}
}