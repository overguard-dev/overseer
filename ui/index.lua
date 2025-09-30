if shared.OverseerLibrary then
        shared.OverseerLibrary:Unload()
end

-- Services
local UserInputService = game:GetService("UserInputService")
local HttpService = game:GetService("HttpService")
local CoreGui = game:GetService("CoreGui")
local Players = game:GetService("Players")

-- Variables
local isMobile = UserInputService.TouchEnabled
local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")
local Tooltip
local Container

local Library = {
        KeyCode = Enum.KeyCode.RightShift,
        Themes = {
                Default = {
                        MainBG = Color3.fromRGB(0, 0, 0),
                        TitleBG = Color3.fromRGB(5, 5, 5),
                        SectionStroke = Color3.fromRGB(15, 15, 15),
                        SectionTitleBG = Color3.fromRGB(10, 10, 10),
                        ComponentBG = Color3.fromRGB(50, 50, 50),
                        Selected = Color3.fromRGB(240, 240, 240),
                        Deselected = Color3.fromRGB(150, 150, 150)
                }
        },

        Connections = {},
        -- ...
}

function Library:Unload()
        for _, connection in self.Connections do
                connection:Disconnect()
        end

        Container:ClearAllChildren()
        Container:Destroy()

        table.clear(self)
end

-- Helper functions
local function New(className: string, properties: {[string]: any}?): Instance
        local instance = Instance.new(className)

        if properties then
                for property, value in properties do
                        instance[property] = value
                end
        end

        return instance
end

local function Connect(signal: RBXScriptSignal, callback: (...any) -> ()): RBXScriptConnection
        local connection = signal:Connect(callback)

        table.insert(Library.Connections, connection)

        return connection
end

-- UI helper functions
local function AddCorner(object: GuiObject, component: boolean?): UICorner
        return New("UICorner", {
                CornerRadius = UDim.new(0, component and 2 or 4),
                Parent = object
        })
end

local function AddStroke(object: GuiObject, color: Color3): UIStroke
        return New("UIStroke", {
                Color = color,
                Parent = object
        })
end

local function AddShadow(object: GuiObject): ImageLabel
        return New("ImageLabel", {
                BackgroundTransparency = 1,
                Position = UDim2.fromOffset(-4, -4),
                Size = UDim2.new(1, 8, 1, 8),
                Image = getcustomasset("Overseer/assets/glow.png"),
                ImageTransparency = 0.5,
                ImageColor3 = Library.Themes.Default.MainBG,
                ScaleType = Enum.ScaleType.Slice,
                SliceCenter = Rect.new(14, 14, 514, 514),
                Parent = object
        })
end

local function AddPadding(object: GuiObject, paddings: {[string]: number?}): UIPadding
        return New("UIPadding", {
                PaddingBottom = UDim.new(0, paddings.B or 0),
                PaddingLeft = UDim.new(0, paddings.L or 0),
                PaddingRight = UDim.new(0, paddings.R or 0),
                PaddingTop = UDim.new(0, paddings.T or 0),
                Parent = object
        })
end

local function AddTooltip(object: GuiObject, text: string)

end
-- UI
Container = New("ScreenGui", {
        LayoutOrder = 2147483647,
        IgnoreGuiInset = true,
        Parent = (gethui and gethui()) or CoreGui or PlayerGui
})
Library.ScreenGui = Container

Tooltip = New("TextLabel", {

})

-- UI functions

-- // Window
function Library:Window(name: string)
        local Window = New("Frame", {
                AnchorPoint = Vector2.new(.5, .5),
                Position = UDim2.fromScale(.5, .5),
                Size = UDim2.fromOffset(400, 400),
                BackgroundColor3 = self.Themes.Default.MainBG,
                Parent = Container
        }) AddCorner(Window)

        Connect(UserInputService.InputChanged, function(input)
                if input.KeyCode == self.KeyCode then
                        Window.Visible = not Window.Visible
                end
        end)

        -- the tabs will also be in the title
        local TitleFrame = New("Frame", {
                Size = UDim2.new(1, 0, 0, 25),
                BackgroundColor3 = self.Themes.Default.TitleBG,
                Parent = Window
        }) AddCorner(TitleFrame)

        -- local Title = New("TextLabel", {
        --         -- ...
        --         Parent = TitleFrame
        -- })

        -- local TabsHolder = New("Frame", {
        --         -- ...
        --         Parent = TitleFrame
        -- })

        -- holder for tabs' components
        local TabComponents = New("Frame", {
                BackgroundTransparency = 1,
                Position = UDim2.fromOffset(0, 25),
                Size = UDim2.new(1, 0, 1, -25),
                Parent = Window
        })

        local WindowFunctions = {}

        -- // Tab
        function WindowFunctions:Tab(name: string)

                local TabFunctions = {}
                
                function TabFunctions:Section(name: string)
                        local SectionFunctions = {}

                        function SectionFunctions:Label(text: string)

                        end

                        function SectionFunctions:Button(text: string, callback: () -> ())

                        end

                        function SectionFunctions:Toggle(text: string, callback: (boolean) -> ())

                        end

                        function SectionFunctions:Slider(text: string, min: number, max: number, callback: (number) -> ())

                        end

                        function SectionFunctions:Dropdown(text: string, options: {string}, callback: ({string}) -> ())

                        end

                        function SectionFunctions:Input(text: string, placeholder: string, callback: (string) -> ())

                        end
                
                        return SectionFunctions
                end

                return TabFunctions
        end
        return WindowFunctions
end

function Library:Notify(type: string, text: string)
        -- type: "success" / "info" / "warn"
end

-- // Init
shared.OverseerLibrary = Library
return Library
