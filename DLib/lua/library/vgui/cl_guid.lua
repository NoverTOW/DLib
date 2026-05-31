local DLibGuid = {}
local RNDX = include("library/modules/sh_rndx.lua")

function DLibGuid:Init()
    self:SetSize(DLib.Scale(800),DLib.Scale(600))
    self:Center()
    self:SetHDI("icon16/gun.png")
    self:SetHDN("Гайд по библиотеке DLib")

    self:ListPanel()
    self:AddCatergory()
    self:ContentPanel()
end

function DLibGuid:ListPanel(name)
    local panel = self:Add("Panel")
    panel:SetSize(DLib.Scale(165),DLib.Scale(560))
    panel:SetPos(DLib.Scale(0),DLib.Scale(40))
    panel.Paint = function(self,w,h)
        RNDX.Draw(0,0,0,w,h,DLib.GetHexCol("00000030"))
    end
    

    local scrollPanel = vgui.Create("DLib.ScrollPanel", panel)
    scrollPanel:SetPos(0, 0)
    scrollPanel:SetSize(panel:GetWide(), panel:GetTall())
    scrollPanel:SetScrollSpeed(25)
    scrollPanel:SetAnimationSpeed(0.2)
    scrollPanel:SetInertia(0.42)
    

    local categoriesContainer = vgui.Create("Panel", scrollPanel)
    categoriesContainer:SetSize(scrollPanel:GetWide(), 0)
    categoriesContainer.Paint = function() end
    
    self.CategoriesContainer = categoriesContainer
    self.CategoriesScroll = scrollPanel
    

    scrollPanel:AddItem(categoriesContainer)
    
    self.CategoryPanel = panel
end

function DLibGuid:ContentPanel()
    local panel = self:Add("Panel")
    panel:SetSize(DLib.Scale(600),DLib.Scale(560))
    panel:SetPos(DLib.Scale(180),DLib.Scale(40))
    panel.Paint = function(self,w,h)
        RNDX.Draw(0,0,0,w,h,DLib.GetHexCol("00000020"))
    end
    
    self.ContentPanel = panel
end

function DLibGuid:AddCatergory()
    self.Category = {
        { 
            name = "Scale()", 
            icon = "icon16/monitor.png", 
            content = {
                { type = "label", text = "DLib.Scale() - Адаптивное масштабирование", font = "Trebuchet24", pos = {10, 10} },
                { type = "label", text = "Функция для адаптации размеров под любое разрешение экрана", pos = {10, 50} },
                { type = "label", text = "Базовое разрешение: 1920x1080", pos = {10, 75} },
                { type = "label", text = "Пример использования:", pos = {10, 110 }, font = "Trebuchet18" },
                { type = "label", text = 'local w = DLib.Scale(100)  -- 100px в 1920,', pos = {10, 140} },
                { type = "label", text = '                            -- на 1366x768 будет ≈71px', pos = {10, 160} },
                { type = "button", text = "Показать пример", pos = {10, 200}, size = {150, 30} },
                { type = "label", text = "Где используется: SetSize(), SetPos(), все размеры GUI", pos = {10, 250} }
            }
        },
        { 
            name = "GetHexCol()", 
            icon = "icon16/color_wheel.png",
            content = {
                { type = "label", text = "DLib.GetHexCol() - HEX в Color", font = "Trebuchet24", pos = {10, 10} },
                { type = "label", text = "Преобразует HEX строку в объект Color", pos = {10, 50} },
                { type = "label", text = "Поддерживает 6-значные (RGB) и 8-значные (RGBA) HEX", pos = {10, 75} },
                { type = "label", text = "Примеры:", pos = {10, 110 }, font = "Trebuchet18" },
                { type = "label", text = 'DLib.GetHexCol("FF0000")  → Color(255,0,0,255) - Красный', pos = {10, 140} },
                { type = "label", text = 'DLib.GetHexCol("00FF0080") → Color(0,255,0,128) - Зеленый с прозрачностью', pos = {10, 160} },
                { type = "label", text = 'DLib.GetHexCol("00000030") → Color(0,0,0,48) - Черный полупрозрачный', pos = {10, 180} },
                { type = "button", text = "Показать пример цвета", pos = {10, 220}, size = {150, 30} }
            }
        },
        { 
            name = "GetColor()", 
            icon = "icon16/palette.png",
            content = {
                { type = "label", text = "DLib.GetColor() - Получение цвета по имени", font = "Trebuchet24", pos = {10, 10} },
                { type = "label", text = "Возвращает Color объект по строковому имени", pos = {10, 50} },
                { type = "label", text = "Доступные цвета: black, white, red, green, blue, yellow", pos = {10, 75} },
                { type = "label", text = "Пример:", pos = {10, 110 }, font = "Trebuchet18" },
                { type = "label", text = 'DLib.GetColor("red")   → Color(255,35,35,255)', pos = {10, 140} },
                { type = "label", text = 'DLib.GetColor("green") → Color(130,255,28,255)', pos = {10, 160} },
                { type = "label", text = 'DLib.GetColor("blue")  → Color(59,95,255,255)', pos = {10, 180} },
                { type = "label", text = "Если цвет не найден - возвращает белый", pos = {10, 210} },
                { type = "checkbox", text = "Показать предупреждения", pos = {10, 240} }
            }
        },
        { 
            name = "DLib.Frame", 
            icon = "icon16/application.png",
            content = {
                { type = "label", text = "DLib.Frame - Базовое окно с анимацией", font = "Trebuchet24", pos = {10, 10} },
                { type = "label", text = "Улучшенное окно с возможностью перетаскивания", pos = {10, 50} },
                { type = "label", text = "Основные методы:", pos = {10, 90 }, font = "Trebuchet18" },
                { type = "label", text = "• SetHDN(name) - Установка заголовка окна", pos = {10, 120} },
                { type = "label", text = "• SetHDI(material) - Установка иконки в заголовке", pos = {10, 140} },
                { type = "label", text = "• SetGrab() - Включение/выключение перетаскивания", pos = {10, 160} },
                { type = "label", text = "• HDVisible(bool) - Скрыть/показать заголовок", pos = {10, 180} },
                { type = "label", text = "• ESC - Закрыть окно с анимацией", pos = {10, 200} },
                { type = "button", text = "Показать пример окна", pos = {10, 240}, size = {150, 30} }
            }
        },
        { 
            name = "ScrollPanel", 
            icon = "icon16/page_white.png",
            content = {
                { type = "label", text = "DLib.ScrollPanel - Прокручиваемая панель", font = "Trebuchet24", pos = {10, 10} },
                { type = "label", text = "Панель с плавной прокруткой и инерцией", pos = {10, 50} },
                { type = "label", text = "Основные методы:", pos = {10, 90 }, font = "Trebuchet18" },
                { type = "label", text = "• AddItem(panel) - Добавление элемента", pos = {10, 120} },
                { type = "label", text = "• Clear() - Очистка всех элементов", pos = {10, 140} },
                { type = "label", text = "• SetScrollSpeed(speed) - Скорость прокрутки", pos = {10, 160} },
                { type = "label", text = "• SetAnimationSpeed(speed) - Скорость анимации", pos = {10, 180} },
                { type = "label", text = "• SetInertia(inertia) - Сила инерции (0.8-0.99)", pos = {10, 200} },
                { type = "label", text = "• SetScrollValue(value) - Установка позиции", pos = {10, 220} },
            }
        },
        { 
            name = "Кнопки", 
            icon = "icon16/box.png",
            content = {
                { type = "label", text = "DLib.Button - Система кнопок", font = "Trebuchet24", pos = {10, 10} },
                { type = "label", text = "5 типов кнопок и 7 стилей оформления", pos = {10, 50} },
                { type = "label", text = "Типы кнопок:", pos = {10, 90 }, font = "Trebuchet18" },
                { type = "label", text = "• DLib.Button - Обычная кнопка", pos = {10, 120} },
                { type = "label", text = "• DLib.BigButton - Большая кнопка с иконкой", pos = {10, 140} },
                { type = "label", text = "• DLib.ToggleButton - Кнопка-переключатель", pos = {10, 160} },
                { type = "label", text = "• DLib.IconButton - Кнопка только с иконкой", pos = {10, 180} },
                { type = "label", text = "Стили: primary, success, danger, warning, dark, ghost, glass", pos = {10, 210} },
                { type = "label", text = "Все кнопки имеют звуки наведения и клика", pos = {10, 235} },
                { type = "button", text = "Показать все кнопки", pos = {10, 270}, size = {150, 30} }
            }
        },
        { 
            name = "Ошибки", 
            icon = "icon16/error.png",
            content = {
                { type = "label", text = "Система ошибок DLib", font = "Trebuchet24", pos = {10, 10} },
                { type = "label", text = "DLib.Error() - Вывод ошибки в консоль и чат", pos = {10, 50} },
                { type = "label", text = 'DLib.Error("Текст ошибки")', pos = {20, 75} },
                { type = "label", text = "DLib.ShowError() - Показать GUI окно с ошибкой", pos = {10, 110} },
                { type = "label", text = 'DLib.ShowError("Ошибка!")', pos = {20, 135} },
                { type = "label", text = "Встроенная защита от спама (кулдаун 3-5 сек)", pos = {10, 170} },
                { type = "button", text = "Вызвать тестовую ошибку", pos = {10, 210}, size = {150, 30} },
                { type = "button", text = "Показать GUI ошибку", pos = {170, 210}, size = {150, 30} }
            }
        },
        { 
            name = "Материалы", 
            icon = "icon16/picture.png",
            content = {
                { type = "label", text = "Работа с материалами", font = "Trebuchet24", pos = {10, 10} },
                { type = "label", text = "DLib.GetMaterial() - Загрузка материала с кэшированием", pos = {10, 50} },
                { type = "label", text = 'local mat = DLib.GetMaterial("vgui/avatar_default")', pos = {10, 75} },
                { type = "label", text = "DLib.DrawMaterial() - Отрисовка материала", pos = {10, 110} },
                { type = "label", text = 'DLib.DrawMaterial(mat, x, y, w, h, color)', pos = {10, 135} },
                { type = "label", text = "Автоматическое кэширование материалов", pos = {10, 170} },
                { type = "label", text = "Ошибка если материал не найден", pos = {10, 195} },
                { type = "button", text = "Показать пример материала", pos = {10, 230}, size = {150, 30} }
            }
        },
        { 
            name = "Cooldown", 
            icon = "icon16/time.png",
            content = {
                { type = "label", text = "Система кулдаунов", font = "Trebuchet24", pos = {10, 10} },
                { type = "label", text = "Встроенная функция CheckCooldown()", pos = {10, 50} },
                { type = "label", text = "Используется внутри DLib для защиты от спама", pos = {10, 75} },
                { type = "label", text = "Кулдауны:", pos = {10, 110 }, font = "Trebuchet18" },
                { type = "label", text = "• Ошибки материалов - 2 секунды", pos = {10, 140} },
                { type = "label", text = "• Ошибки цветов - 5 секунд", pos = {10, 160} },
                { type = "label", text = "• GUI ошибки - 1 секунда", pos = {10, 180} },
                { type = "label", text = "• Логи ошибок - 3 секунды", pos = {10, 200} },
                { type = "slider", text = "Тест кулдауна (сек)", pos = {10, 240}, min = 1, max = 10 }
            }
        }
    }
    
    if not self.CategoriesContainer then return end
    

    self.CategoriesContainer:Clear()
    
    local yOffset = DLib.Scale(10)
    local buttonHeight = DLib.Scale(82)
    local buttonSpacing = DLib.Scale(3)
    
    for k,v in ipairs(self.Category) do
        local btn = DLib.CreateBigButton(self.CategoriesContainer, v.name, v.icon, "glass", function()
            self:SwitchPanel(k)
        end)
        btn:SetPos(DLib.Scale(10), yOffset)
        btn:SetSize(DLib.Scale(145), buttonHeight)
        yOffset = yOffset + buttonHeight + buttonSpacing
    end
    

    self.CategoriesContainer:SetTall(yOffset + DLib.Scale(10))
end

function DLibGuid:SwitchPanel(index)
    if not self.ContentPanel or not self.Category[index] then return end
    
    self.ContentPanel:Clear()
    
    local contentTable = self.Category[index].content
    
    for _, item in ipairs(contentTable) do
        if item.type == "label" then
            local label = self.ContentPanel:Add("DLabel")
            label:SetText(item.text)
            label:SetPos(DLib.Scale(item.pos[1]), DLib.Scale(item.pos[2]))
            if item.font then
                label:SetFont(item.font)
            end
            label:SizeToContents()
            
        elseif item.type == "button" then
            local button = self.ContentPanel:Add("DButton")
            button:SetText(item.text)
            button:SetPos(DLib.Scale(item.pos[1]), DLib.Scale(item.pos[2]))
            button:SetSize(DLib.Scale(item.size[1]), DLib.Scale(item.size[2]))
            

            if item.text == "Показать пример" then
                button.DoClick = function()
                    local w = DLib.Scale(100)
                    local h = DLib.Scale(50)
                    print("[DLib Пример] Scale(100) на этом экране = " .. w .. "px")
                    print("[DLib Пример] Scale(50) на этом экране = " .. h .. "px")
                    DLib.ShowError("На вашем экране: Scale(100) = " .. math.Round(w) .. "px")
                end
            elseif item.text == "Показать пример цвета" then
                button.DoClick = function()
                    local colors = {
                        {"FF0000", "Красный"},
                        {"00FF00", "Зеленый"},
                        {"0000FF", "Синий"},
                        {"FF00FF", "Розовый"},
                        {"FFFF00", "Желтый"}
                    }
                    for _, c in ipairs(colors) do
                        print("[DLib Пример] HEX " .. c[1] .. " = " .. tostring(DLib.GetHexCol(c[1])))
                    end
                    DLib.ShowError("Цвета преобразованы! Смотрите консоль (F7)")
                end
            elseif item.text == "Вызвать тестовую ошибку" then
                button.DoClick = function()
                    DLib.Error("Тестовая ошибка из гайд-меню!")
                end
            elseif item.text == "Показать GUI ошибку" then
                button.DoClick = function()
                    DLib.ShowError("Это GUI окно ошибки!\nОно автоматически закроется через 5 секунд")
                end
            elseif item.text == "Показать пример материала" then
                button.DoClick = function()
                    local mat = DLib.GetMaterial("vgui/avatar_default")
                    if mat and not mat:IsError() then
                        DLib.ShowError("Материал успешно загружен!\nСмотрите консоль для деталей")
                        print("[DLib] Материал загружен:", mat)
                    end
                end
            elseif item.text == "Показать пример окна" then
                button.DoClick = function()
                    local exampleFrame = vgui.Create("DLib.Frame")
                    exampleFrame:SetSize(DLib.Scale(400), DLib.Scale(300))
                    exampleFrame:Center()
                    exampleFrame:SetHDN("Пример окна DLib")
                    exampleFrame:SetHDI("icon16/application.png")
                    exampleFrame:SetGrab() 
                    
             
                    local closeBtn = DLib.CreateButton(exampleFrame, "Закрыть", "danger", function()
                        exampleFrame:Remove()
                    end)
                    closeBtn:SetPos(DLib.Scale(150), DLib.Scale(250))
                    closeBtn:SetSize(DLib.Scale(100), DLib.Scale(30))
                    
                    local label = exampleFrame:Add("DLabel")
                    label:SetText("Это окно можно перетаскивать за заголовок\nНажмите ESC для закрытия")
                    label:SetPos(DLib.Scale(50), DLib.Scale(100))
                    label:SizeToContents()
                    
                    print("[DLib] Открыто примерное окно")
                end
        
            elseif item.text == "Показать все кнопки" then
                button.DoClick = function()
                    local btnFrame = vgui.Create("DLib.Frame")
                    btnFrame:SetSize(DLib.Scale(550), DLib.Scale(450))
                    btnFrame:Center()
                    btnFrame:SetHDN("Примеры кнопок DLib")
                    btnFrame:SetHDI("icon16/button.png")
                    btnFrame:SetGrab()
                    
                    local yPos = 60
                    
              
                    local label1 = btnFrame:Add("DLabel")
                    label1:SetText("Обычные кнопки (DLib.Button):")
                    label1:SetPos(DLib.Scale(10), DLib.Scale(yPos - 25))
                    label1:SetFont("Trebuchet18")
                    label1:SizeToContents()
                    
                    local btn1 = DLib.CreateButton(btnFrame, "Primary", "primary", function() print("Primary clicked") end)
                    btn1:SetPos(DLib.Scale(10), yPos)
                    
                    local btn2 = DLib.CreateButton(btnFrame, "Success", "success", function() print("Success clicked") end)
                    btn2:SetPos(DLib.Scale(130), yPos)
                    
                    local btn3 = DLib.CreateButton(btnFrame, "Danger", "danger", function() print("Danger clicked") end)
                    btn3:SetPos(DLib.Scale(250), yPos)
                    
                    local btn4 = DLib.CreateButton(btnFrame, "Warning", "warning", function() print("Warning clicked") end)
                    btn4:SetPos(DLib.Scale(370), yPos)
                    
                    yPos = yPos + 55
                    
                  
                    local label2 = btnFrame:Add("DLabel")
                    label2:SetText("Большие кнопки с иконками (DLib.BigButton):")
                    label2:SetPos(DLib.Scale(10), DLib.Scale(yPos - 25))
                    label2:SetFont("Trebuchet18")
                    label2:SizeToContents()
                    
                    local bigBtn1 = DLib.CreateBigButton(btnFrame, "Купить", "icon16/cart.png", "success", function() print("Buy clicked") end)
                    bigBtn1:SetPos(DLib.Scale(10), yPos)
                    bigBtn1:SetSize(DLib.Scale(120), DLib.Scale(70))
                    
                    local bigBtn2 = DLib.CreateBigButton(btnFrame, "Удалить", "icon16/bin.png", "danger", function() print("Delete clicked") end)
                    bigBtn2:SetPos(DLib.Scale(140), yPos)
                    bigBtn2:SetSize(DLib.Scale(120), DLib.Scale(70))
                    
                    local bigBtn3 = DLib.CreateBigButton(btnFrame, "Настройки", "icon16/cog.png", "dark", function() print("Settings clicked") end)
                    bigBtn3:SetPos(DLib.Scale(270), yPos)
                    bigBtn3:SetSize(DLib.Scale(120), DLib.Scale(70))
                    
                    yPos = yPos + 85
                    
    
                    local label3 = btnFrame:Add("DLabel")
                    label3:SetText("Кнопки-переключатели (DLib.ToggleButton):")
                    label3:SetPos(DLib.Scale(10), DLib.Scale(yPos - 25))
                    label3:SetFont("Trebuchet18")
                    label3:SizeToContents()
                    
                    local toggle1 = DLib.CreateToggleButton(btnFrame, "Авто-обновление", "primary", function(btn, state)
                        print("Toggle state:", state)
                    end)
                    toggle1:SetPos(DLib.Scale(10), yPos)
                    
                    local toggle2 = DLib.CreateToggleButton(btnFrame, "Звуки", "success", function(btn, state)
                        print("Sound enabled:", state)
                    end)
                    toggle2:SetPos(DLib.Scale(200), yPos)
                    
                    yPos = yPos + 55
                    
        
                    local label4 = btnFrame:Add("DLabel")
                    label4:SetText("Иконка кнопки (DLib.IconButton):")
                    label4:SetPos(DLib.Scale(10), DLib.Scale(yPos - 25))
                    label4:SetFont("Trebuchet18")
                    label4:SizeToContents()
                    
                    local iconBtn1 = DLib.CreateIconButton(btnFrame, "icon16/cog.png", "dark", function() print("Settings") end)
                    iconBtn1:SetPos(DLib.Scale(10), yPos)
                    
                    local iconBtn2 = DLib.CreateIconButton(btnFrame, "icon16/heart.png", "danger", function() print("Like") end)
                    iconBtn2:SetPos(DLib.Scale(60), yPos)
                    
                    local iconBtn3 = DLib.CreateIconButton(btnFrame, "icon16/accept.png", "success", function() print("Accept") end)
                    iconBtn3:SetPos(DLib.Scale(110), yPos)
                    
                    local iconBtn4 = DLib.CreateIconButton(btnFrame, "icon16/cross.png", "warning", function() print("Close") end)
                    iconBtn4:SetPos(DLib.Scale(160), yPos)
                    
                    local iconBtn5 = DLib.CreateIconButton(btnFrame, "icon16/monitor.png", "primary", function() print("Monitor") end)
                    iconBtn5:SetPos(DLib.Scale(210), yPos)
                    
           
                    local closeAllBtn = DLib.CreateButton(btnFrame, "Закрыть окно", "danger", function()
                        btnFrame:Remove()
                    end)
                    closeAllBtn:SetPos(DLib.Scale(225), DLib.Scale(400))
                    closeAllBtn:SetSize(DLib.Scale(100), DLib.Scale(30))
                    
                    print("[DLib] Открыто окно со всеми типами кнопок")
                end
            else
                button.DoClick = function()
                    print("Нажата кнопка: " .. item.text)
                end
            end
            
        elseif item.type == "checkbox" then
            local checkbox = self.ContentPanel:Add("DCheckBoxLabel")
            checkbox:SetText(item.text)
            checkbox:SetPos(DLib.Scale(item.pos[1]), DLib.Scale(item.pos[2]))
            checkbox:SizeToContents()
            
            if item.text == "Показать предупреждения" then
                checkbox.OnChange = function(self, val)
                    if val then
                        print("[DLib] Предупреждения включены")
                    else
                        print("[DLib] Предупреждения выключены")
                    end
                end
            end
            
        elseif item.type == "slider" then
            local slider = self.ContentPanel:Add("DNumSlider")
            slider:SetText(item.text)
            slider:SetPos(DLib.Scale(item.pos[1]), DLib.Scale(item.pos[2]))
            slider:SetSize(DLib.Scale(200), DLib.Scale(20))
            slider:SetMin(item.min)
            slider:SetMax(item.max)
            
            if item.text == "Тест кулдауна (сек)" then
                slider.OnValueChanged = function(self, val)
                    print("[DLib] Установлен кулдаун: " .. math.Round(val) .. " секунд")
                end
            end
        end
    end
end

vgui.Register("DLib.GuidMenu",DLibGuid,"DLib.Frame")

concommand.Add("DLib.guid",function()
    local frame = vgui.Create("DLib.GuidMenu")
end)


local DLibMenuFrame = nil

hook.Add( "OnPlayerChat", "DLib.OpenMenu", function( ply, strText )

    if ply ~= LocalPlayer() then return end
    

    local command = string.lower( strText )
    

    if command == "/dlib" or command == "!dlib" then

        if IsValid( DLibMenuFrame ) then
            DLibMenuFrame:SetVisible( true )
            DLibMenuFrame:MakePopup()
            return false  
        end
        

        DLibMenuFrame = vgui.Create( "DLib.GuidMenu" )
        

        function DLibMenuFrame:OnClose()
            DLibMenuFrame = nil
        end
        
        return false 
    end
end)