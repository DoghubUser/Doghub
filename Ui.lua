-- RedzLib V5 - Dark Blue Theme Mod
local RedzLib = {}
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local TextService = game:GetService("TextService")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local Mouse = LocalPlayer:GetMouse()

-- Theme Configuration
local Theme = {
    Background = Color3.fromRGB(15, 15, 25),
    Topbar = Color3.fromRGB(25, 25, 40),
    Section = Color3.fromRGB(30, 30, 50),
    Accent = Color3.fromRGB(0, 162, 255),
    Text = Color3.fromRGB(230, 230, 255),
    DarkText = Color3.fromRGB(150, 150, 170)
}

-- Font Configuration
local Font = {
    Name = "GothamBold",
    Size = 14,
    TitleSize = 16
}

-- Utility Functions (unchanged from original)
local function MakeDraggable(topbarObject, object)
    local dragging = nil
    local dragInput = nil
    local dragStart = nil
    local startPos = nil

    local function Update(input)
        local delta = input.Position - dragStart
        local newPos = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        object.Position = newPos
    end

    topbarObject.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            dragStart = input.Position
            startPos = object.Position

            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end
            end)
        end
    end)

    topbarObject.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement then
            dragInput = input
        end
    end)

    UserInputService.InputChanged:Connect(function(input)
        if input == dragInput and dragging then
            Update(input)
        end
    end)
end

local function RippleEffect(button)
    local circle = Instance.new("ImageLabel")
    circle.Name = "Ripple"
    circle.Parent = button
    circle.BackgroundTransparency = 1
    circle.Image = "rbxassetid://2708891598"
    circle.ImageColor3 = Theme.Accent
    circle.ImageTransparency = 0.8
    circle.ZIndex = 10
    circle.AnchorPoint = Vector2.new(0.5, 0.5)
    circle.Position = UDim2.new(0, 0, 0, 0)
    circle.Size = UDim2.new(0, 0, 0, 0)

    local mouse = game:GetService("Players").LocalPlayer:GetMouse()
    local pos = Vector2.new(mouse.X - circle.AbsolutePosition.X, mouse.Y - circle.AbsolutePosition.Y)
    circle.Position = UDim2.new(0, pos.X, 0, pos.Y)

    circle:TweenSize(UDim2.new(5, 0, 5, 0), "Out", "Quad", 0.5, true)
    spawn(function()
        for i = 1, 10 do
            circle.ImageTransparency = circle.ImageTransparency + 0.05
            wait(0.05)
        end
        circle:Destroy()
    end)
end

-- Main Window Function (modified size and colors)
function RedzLib:MakeWindow(options)
    options = options or {}
    local Window = {}

    -- Main Frame
    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "RedzLib"
    ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    ScreenGui.Parent = game:GetService("CoreGui")

    local MainFrame = Instance.new("Frame")
    MainFrame.Name = "MainFrame"
    MainFrame.BackgroundColor3 = Theme.Background
    MainFrame.BorderSizePixel = 0
    MainFrame.Position = UDim2.new(0.275, 0, 0.225, 0) -- Centered at 45% width, 55% height
    MainFrame.Size = UDim2.new(0.45, 0, 0.55, 0) -- Compact size
    MainFrame.ClipsDescendants = true
    MainFrame.Parent = ScreenGui

    local UICorner = Instance.new("UICorner")
    UICorner.CornerRadius = UDim.new(0, 6)
    UICorner.Parent = MainFrame

    -- Topbar
    local Topbar = Instance.new("Frame")
    Topbar.Name = "Topbar"
    Topbar.BackgroundColor3 = Theme.Topbar
    Topbar.BorderSizePixel = 0
    Topbar.Size = UDim2.new(1, 0, 0, 40)
    Topbar.Parent = MainFrame

    local UICorner2 = Instance.new("UICorner")
    UICorner2.CornerRadius = UDim.new(0, 6)
    UICorner2.Parent = Topbar

    -- Title
    local Title = Instance.new("TextLabel")
    Title.Name = "Title"
    Title.BackgroundTransparency = 1
    Title.Position = UDim2.new(0, 15, 0, 0)
    Title.Size = UDim2.new(0.5, 0, 1, 0)
    Title.Font = Font.Name
    Title.Text = options.Title or "RedzLib"
    Title.TextColor3 = Theme.Text
    Title.TextSize = Font.TitleSize
    Title.TextXAlignment = Enum.TextXAlignment.Left
    Title.Parent = Topbar

    -- Subtitle
    local SubTitle = Instance.new("TextLabel")
    SubTitle.Name = "SubTitle"
    SubTitle.BackgroundTransparency = 1
    SubTitle.Position = UDim2.new(0.5, 15, 0, 0)
    SubTitle.Size = UDim2.new(0.5, -15, 1, 0)
    SubTitle.Font = Font.Name
    SubTitle.Text = options.SubTitle or "by tlredz"
    SubTitle.TextColor3 = Theme.DarkText
    SubTitle.TextSize = Font.Size
    SubTitle.TextXAlignment = Enum.TextXAlignment.Left
    SubTitle.Parent = Topbar

    MakeDraggable(Topbar, MainFrame)

    -- Tab Buttons
    local TabButtons = Instance.new("Frame")
    TabButtons.Name = "TabButtons"
    TabButtons.BackgroundTransparency = 1
    TabButtons.Position = UDim2.new(0, 0, 0, 40)
    TabButtons.Size = UDim2.new(1, 0, 0, 40)
    TabButtons.Parent = MainFrame

    local UIListLayout = Instance.new("UIListLayout")
    UIListLayout.FillDirection = Enum.FillDirection.Horizontal
    UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
    UIListLayout.Padding = UDim.new(0, 0)
    UIListLayout.Parent = TabButtons

    -- Pages
    local Pages = Instance.new("Frame")
    Pages.Name = "Pages"
    Pages.BackgroundTransparency = 1
    Pages.Position = UDim2.new(0, 0, 0, 80)
    Pages.Size = UDim2.new(1, 0, 1, -80)
    Pages.Parent = MainFrame

    local UIListLayout2 = Instance.new("UIListLayout")
    UIListLayout2.SortOrder = Enum.SortOrder.LayoutOrder
    UIListLayout2.Padding = UDim.new(0, 10)
    UIListLayout2.Parent = Pages

    local UIPadding = Instance.new("UIPadding")
    UIPadding.PaddingLeft = UDim.new(0, 10)
    UIPadding.PaddingRight = UDim.new(0, 10)
    UIPadding.PaddingTop = UDim.new(0, 10)
    UIPadding.Parent = Pages

    -- Tab Functions (unchanged functionality, updated visuals)
    function Window:MakeTab(options)
        options = options or {}
        local Tab = {}

        local TabButton = Instance.new("TextButton")
        TabButton.Name = "TabButton"
        TabButton.BackgroundColor3 = Theme.Topbar
        TabButton.BackgroundTransparency = 1
        TabButton.Size = UDim2.new(0, 100, 1, 0)
        TabButton.Font = Font.Name
        TabButton.Text = options[1] or "Tab"
        TabButton.TextColor3 = Theme.Text
        TabButton.TextSize = Font.Size
        TabButton.Parent = TabButtons

        local Page = Instance.new("ScrollingFrame")
        Page.Name = "Page"
        Page.BackgroundTransparency = 1
        Page.Size = UDim2.new(1, 0, 1, 0)
        Page.Visible = false
        Page.ScrollBarThickness = 3
        Page.ScrollBarImageColor3 = Theme.Accent
        Page.CanvasSize = UDim2.new(0, 0, 0, 0)
        Page.Parent = Pages

        local UIListLayout = Instance.new("UIListLayout")
        UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
        UIListLayout.Padding = UDim.new(0, 10)
        UIListLayout.Parent = Page

        local UIPadding = Instance.new("UIPadding")
        UIPadding.PaddingLeft = UDim.new(0, 5)
        UIPadding.PaddingRight = UDim.new(0, 5)
        UIPadding.Parent = Page

        if #TabButtons:GetChildren() == 1 then
            TabButton.BackgroundTransparency = 0.9
            Page.Visible = true
        end

        TabButton.MouseButton1Click:Connect(function()
            for _, v in pairs(TabButtons:GetChildren()) do
                if v:IsA("TextButton") then
                    v.BackgroundTransparency = 1
                end
            end
            for _, v in pairs(Pages:GetChildren()) do
                if v:IsA("ScrollingFrame") then
                    v.Visible = false
                end
            end
            TabButton.BackgroundTransparency = 0.9
            Page.Visible = true
        end)

        -- Section (updated colors)
        function Tab:AddSection(options)
            options = options or {}
            local Section = {}

            local SectionFrame = Instance.new("Frame")
            SectionFrame.Name = "Section"
            SectionFrame.BackgroundColor3 = Theme.Section
            SectionFrame.Size = UDim2.new(1, -10, 0, 30)
            SectionFrame.Parent = Page

            local UICorner = Instance.new("UICorner")
            UICorner.CornerRadius = UDim.new(0, 4)
            UICorner.Parent = SectionFrame

            local Title = Instance.new("TextLabel")
            Title.Name = "Title"
            Title.BackgroundTransparency = 1
            Title.Position = UDim2.new(0, 10, 0, 0)
            Title.Size = UDim2.new(1, -10, 1, 0)
            Title.Font = Font.Name
            Title.Text = options[1] or "Section"
            Title.TextColor3 = Theme.Text
            Title.TextSize = Font.Size
            Title.TextXAlignment = Enum.TextXAlignment.Left
            Title.Parent = SectionFrame

            local Container = Instance.new("Frame")
            Container.Name = "Container"
            Container.BackgroundTransparency = 1
            Container.Position = UDim2.new(0, 0, 0, 35)
            Container.Size = UDim2.new(1, 0, 0, 0)
            Container.Parent = SectionFrame

            local UIListLayout = Instance.new("UIListLayout")
            UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
            UIListLayout.Padding = UDim.new(0, 5)
            UIListLayout.Parent = Container

            Page.CanvasSize = UDim2.new(0, 0, 0, UIListLayout2.AbsoluteContentSize.Y + 10)

            function Section:UpdateSize()
                SectionFrame.Size = UDim2.new(1, -10, 0, 30 + Container.UIListLayout.AbsoluteContentSize.Y)
                Page.CanvasSize = UDim2.new(0, 0, 0, UIListLayout2.AbsoluteContentSize.Y + 10)
            end

            -- Button (updated colors)
            function Section:AddButton(options)
                options = options or {}
                local Button = {}

                local ButtonFrame = Instance.new("Frame")
                ButtonFrame.Name = "Button"
                ButtonFrame.BackgroundTransparency = 1
                ButtonFrame.Size = UDim2.new(1, 0, 0, 30)
                ButtonFrame.Parent = Container

                local Button = Instance.new("TextButton")
                Button.Name = "Button"
                Button.BackgroundColor3 = Theme.Accent
                Button.Size = UDim2.new(1, 0, 1, 0)
                Button.Font = Font.Name
                Button.Text = options[1] or "Button"
                Button.TextColor3 = Theme.Text
                Button.TextSize = Font.Size
                Button.Parent = ButtonFrame

                local UICorner = Instance.new("UICorner")
                UICorner.CornerRadius = UDim.new(0, 4)
                UICorner.Parent = Button

                Button.MouseButton1Click:Connect(function()
                    RippleEffect(Button)
                    if options[2] then
                        options[2]()
                    end
                end)

                Section:UpdateSize()
                return Button
            end

            -- Toggle (updated colors)
            function Section:AddToggle(options)
                options = options or {}
                local Toggle = {}

                local ToggleFrame = Instance.new("Frame")
                ToggleFrame.Name = "Toggle"
                ToggleFrame.BackgroundTransparency = 1
                ToggleFrame.Size = UDim2.new(1, 0, 0, 30)
                ToggleFrame.Parent = Container

                local ToggleButton = Instance.new("TextButton")
                ToggleButton.Name = "ToggleButton"
                ToggleButton.BackgroundColor3 = Theme.Section
                ToggleButton.Size = UDim2.new(1, 0, 1, 0)
                ToggleButton.Font = Font.Name
                ToggleButton.Text = options.Name or "Toggle"
                ToggleButton.TextColor3 = Theme.Text
                ToggleButton.TextSize = Font.Size
                ToggleButton.TextXAlignment = Enum.TextXAlignment.Left
                ToggleButton.Parent = ToggleFrame

                local UICorner = Instance.new("UICorner")
                UICorner.CornerRadius = UDim.new(0, 4)
                UICorner.Parent = ToggleButton

                local Toggle = Instance.new("Frame")
                Toggle.Name = "Toggle"
                Toggle.BackgroundColor3 = Theme.Background
                Toggle.Position = UDim2.new(1, -30, 0.5, -10)
                Toggle.Size = UDim2.new(0, 20, 0, 20)
                Toggle.Parent = ToggleButton

                local UICorner2 = Instance.new("UICorner")
                UICorner2.CornerRadius = UDim.new(0, 4)
                UICorner2.Parent = Toggle

                local ToggleInner = Instance.new("Frame")
                ToggleInner.Name = "ToggleInner"
                ToggleInner.BackgroundColor3 = Theme.Accent
                ToggleInner.Position = UDim2.new(0.5, -5, 0.5, -5)
                ToggleInner.Size = UDim2.new(0, 10, 0, 10)
                ToggleInner.Visible = false
                ToggleInner.Parent = Toggle

                local UICorner3 = Instance.new("UICorner")
                UICorner3.CornerRadius = UDim.new(0, 2)
                UICorner3.Parent = ToggleInner

                local Value = false
                if options.Flag then
                    getgenv()[options.Flag] = Value
                end

                ToggleButton.MouseButton1Click:Connect(function()
                    Value = not Value
                    ToggleInner.Visible = Value
                    if options.Flag then
                        getgenv()[options.Flag] = Value
                    end
                    if options.Callback then
                        options.Callback(Value)
                    end
                end)

                if options.Default then
                    Value = options.Default
                    ToggleInner.Visible = Value
                    if options.Flag then
                        getgenv()[options.Flag] = Value
                    end
                    if options.Callback then
                        options.Callback(Value)
                    end
                end

                Section:UpdateSize()
                return Toggle
            end

            -- Slider (updated colors)
            function Section:AddSlider(options)
                options = options or {}
                local Slider = {}

                local SliderFrame = Instance.new("Frame")
                SliderFrame.Name = "Slider"
                SliderFrame.BackgroundTransparency = 1
                SliderFrame.Size = UDim2.new(1, 0, 0, 50)
                SliderFrame.Parent = Container

                local Title = Instance.new("TextLabel")
                Title.Name = "Title"
                Title.BackgroundTransparency = 1
                Title.Size = UDim2.new(1, 0, 0, 20)
                Title.Font = Font.Name
                Title.Text = options.Name or "Slider"
                Title.TextColor3 = Theme.Text
                Title.TextSize = Font.Size
                Title.TextXAlignment = Enum.TextXAlignment.Left
                Title.Parent = SliderFrame

                local Slider = Instance.new("Frame")
                Slider.Name = "Slider"
                Slider.BackgroundColor3 = Theme.Section
                Slider.Position = UDim2.new(0, 0, 0, 25)
                Slider.Size = UDim2.new(1, 0, 0, 20)
                Slider.Parent = SliderFrame

                local UICorner = Instance.new("UICorner")
                UICorner.CornerRadius = UDim.new(0, 4)
                UICorner.Parent = Slider

                local Fill = Instance.new("Frame")
                Fill.Name = "Fill"
                Fill.BackgroundColor3 = Theme.Accent
                Fill.Size = UDim2.new(0, 0, 1, 0)
                Fill.Parent = Slider

                local UICorner2 = Instance.new("UICorner")
                UICorner2.CornerRadius = UDim.new(0, 4)
                UICorner2.Parent = Fill

                local Value = Instance.new("TextLabel")
                Value.Name = "Value"
                Value.BackgroundTransparency = 1
                Value.Size = UDim2.new(1, 0, 1, 0)
                Value.Font = Font.Name
                Value.Text = tostring(options.Default or options.Min or 0)
                Value.TextColor3 = Theme.Text
                Value.TextSize = Font.Size
                Value.Parent = Slider

                local Min = options.Min or 0
                local Max = options.Max or 100
                local Default = options.Default or Min
                local Value = Default

                if options.Flag then
                    getgenv()[options.Flag] = Value
                end

                local Dragging = false
                Slider.InputBegan:Connect(function(input)
                    if input.UserInputType == Enum.UserInputType.MouseButton1 then
                        Dragging = true
                    end
                end)

                Slider.InputEnded:Connect(function(input)
                    if input.UserInputType == Enum.UserInputType.MouseButton1 then
                        Dragging = false
                    end
                end)

                UserInputService.InputChanged:Connect(function(input)
                    if input.UserInputType == Enum.UserInputType.MouseMovement and Dragging then
                        local SizeX = math.clamp((input.Position.X - Slider.AbsolutePosition.X) / Slider.AbsoluteSize.X, 0, 1)
                        local Value = math.floor(Min + (Max - Min) * SizeX)
                        Value = math.clamp(Value, Min, Max)
                        Fill.Size = UDim2.new(SizeX, 0, 1, 0)
                        Value.Text = tostring(Value)
                        if options.Flag then
                            getgenv()[options.Flag] = Value
                        end
                        if options.Callback then
                            options.Callback(Value)
                        end
                    end
                end)

                if options.Default then
                    local SizeX = (options.Default - Min) / (Max - Min)
                    Fill.Size = UDim2.new(SizeX, 0, 1, 0)
                    Value.Text = tostring(options.Default)
                    if options.Flag then
                        getgenv()[options.Flag] = options.Default
                    end
                    if options.Callback then
                        options.Callback(options.Default)
                    end
                end

                Section:UpdateSize()
                return Slider
            end

            -- Dropdown (updated colors)
            function Section:AddDropdown(options)
                options = options or {}
                local Dropdown = {}

                local DropdownFrame = Instance.new("Frame")
                DropdownFrame.Name = "Dropdown"
                DropdownFrame.BackgroundTransparency = 1
                DropdownFrame.Size = UDim2.new(1, 0, 0, 30)
                DropdownFrame.Parent = Container

                local DropdownButton = Instance.new("TextButton")
                DropdownButton.Name = "DropdownButton"
                DropdownButton.BackgroundColor3 = Theme.Section
                DropdownButton.Size = UDim2.new(1, 0, 1, 0)
                DropdownButton.Font = Font.Name
                DropdownButton.Text = options.Name or "Dropdown"
                DropdownButton.TextColor3 = Theme.Text
                DropdownButton.TextSize = Font.Size
                DropdownButton.TextXAlignment = Enum.TextXAlignment.Left
                DropdownButton.Parent = DropdownFrame

                local UICorner = Instance.new("UICorner")
                UICorner.CornerRadius = UDim.new(0, 4)
                UICorner.Parent = DropdownButton

                local Arrow = Instance.new("ImageLabel")
                Arrow.Name = "Arrow"
                Arrow.BackgroundTransparency = 1
                Arrow.Position = UDim2.new(1, -20, 0.5, -5)
                Arrow.Size = UDim2.new(0, 10, 0, 10)
                Arrow.Image = "rbxassetid://6031090990"
                Arrow.ImageColor3 = Theme.Text
                Arrow.Rotation = 180
                Arrow.Parent = DropdownButton

                local DropdownList = Instance.new("Frame")
                DropdownList.Name = "DropdownList"
                DropdownList.BackgroundColor3 = Theme.Section
                DropdownList.Position = UDim2.new(0, 0, 1, 5)
                DropdownList.Size = UDim2.new(1, 0, 0, 0)
                DropdownList.Visible = false
                DropdownList.Parent = DropdownFrame

                local UICorner2 = Instance.new("UICorner")
                UICorner2.CornerRadius = UDim.new(0, 4)
                UICorner2.Parent = DropdownList

                local UIListLayout = Instance.new("UIListLayout")
                UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
                UIListLayout.Padding = UDim.new(0, 5)
                UIListLayout.Parent = DropdownList

                local UIPadding = Instance.new("UIPadding")
                UIPadding.PaddingTop = UDim.new(0, 5)
                UIPadding.PaddingBottom = UDim.new(0, 5)
                UIPadding.Parent = DropdownList

                local Selected = nil
                local Items = {}

                local function UpdateList()
                    DropdownList.Size = UDim2.new(1, 0, 0, UIListLayout.AbsoluteContentSize.Y + 10)
                    Section:UpdateSize()
                end

                local function ToggleDropdown()
                    DropdownList.Visible = not DropdownList.Visible
                    Arrow.Rotation = DropdownList.Visible and 0 or 180
                    UpdateList()
                end

                DropdownButton.MouseButton1Click:Connect(ToggleDropdown)

                function Dropdown:Add(text, value)
                    local ItemButton = Instance.new("TextButton")
                    ItemButton.Name = text
                    ItemButton.BackgroundColor3 = Theme.Background
                    ItemButton.Size = UDim2.new(1, -10, 0, 25)
                    ItemButton.Font = Font.Name
                    ItemButton.Text = text
                    ItemButton.TextColor3 = Theme.Text
                    ItemButton.TextSize = Font.Size
                    ItemButton.Parent = DropdownList

                    local UICorner = Instance.new("UICorner")
                    UICorner.CornerRadius = UDim.new(0, 4)
                    UICorner.Parent = ItemButton

                    Items[text] = value or text

                    ItemButton.MouseButton1Click:Connect(function()
                        Selected = text
                        DropdownButton.Text = options.Name .. ": " .. text
                        ToggleDropdown()
                        if options.Callback then
                            options.Callback(Items[text])
                        end
                    end)

                    UpdateList()
                end

                function Dropdown:Clear()
                    for _, v in pairs(DropdownList:GetChildren()) do
                        if v:IsA("TextButton") then
                            v:Destroy()
                        end
                    end
                    Selected = nil
                    DropdownButton.Text = options.Name
                    UpdateList()
                end

                function Dropdown:Set(list)
                    Dropdown:Clear()
                    for _, v in pairs(list) do
                        Dropdown:Add(v)
                    end
                end

                if options.Options then
                    for _, v in pairs(options.Options) do
                        Dropdown:Add(v)
                    end
                end

                if options.Default then
                    Selected = options.Default
                    DropdownButton.Text = options.Name .. ": " .. options.Default
                    if options.Callback then
                        options.Callback(Items[options.Default])
                    end
                end

                Section:UpdateSize()
                return Dropdown
            end

            Section:UpdateSize()
            return Section
        end

        return Tab
    end

    -- Minimize Button (updated colors)
    function Window:AddMinimizeButton(options)
        options = options or {}
        local Button = options.Button or {}
        local Corner = options.Corner or {}

        local MinimizeButton = Instance.new("ImageButton")
        MinimizeButton.Name = "MinimizeButton"
        MinimizeButton.Image = Button.Image or ""
        MinimizeButton.Size = Button.Size or UDim2.new(0, 30, 0, 30)
        MinimizeButton.BackgroundTransparency = Button.BackgroundTransparency or 0.8
        MinimizeButton.BackgroundColor3 = Theme.Topbar
        MinimizeButton.Position = UDim2.new(1, -35, 0, 5)
        MinimizeButton.Parent = Topbar

        local UICorner = Instance.new("UICorner")
        UICorner.CornerRadius = Corner.CornerRadius or UDim.new(0, 4)
        UICorner.Parent = MinimizeButton

        local Minimized = false
        MinimizeButton.MouseButton1Click:Connect(function()
            Minimized = not Minimized
            if Minimized then
                MainFrame:TweenSize(UDim2.new(MainFrame.Size.X.Scale, 0, 0, 40), "Out", "Quad", 0.2, true)
            else
                MainFrame:TweenSize(UDim2.new(0.45, 0, 0.55, 0), "Out", "Quad", 0.2, true)
            end
        end)
    end

    return Window
end

-- Icon Function (unchanged)
function RedzLib:GetIcon(id)
    return id
end

return RedzLib