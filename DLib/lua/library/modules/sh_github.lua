DLIB_REPO = "NoverTOW/DLib"
DLIB_CURRENT_VERSION = "1.01" 
DLIB_LAST_COMMIT_DATE = "2026-05-31"


local function CheckDLibUpdates()
    local url = "https://api.github.com/repos/" .. DLIB_REPO .. "/commits/main"
    
    http.Fetch(url, function(body)
        local data = util.JSONToTable(body)
        if not data or not data.commit then
            print("[DLib] Не удалось проверить обновления")
            return
        end
        
 
        local lastCommitDate = data.commit.committer.date
        local lastCommitHash = data.sha:sub(1, 7)
        local lastCommitMessage = data.commit.message
        

        local currentDate = DLIB_LAST_COMMIT_DATE
        local newDate = lastCommitDate:sub(1, 10)  
        
        if newDate > currentDate then

            chat.AddText(Color(100, 200, 255), "[DLib] ", Color(255, 100, 0), "Доступно обновление библиотеки!")
            chat.AddText(Color(200, 200, 200), "Последнее изменение: ", Color(0, 255, 0), newDate)
            chat.AddText(Color(200, 200, 200), "Коммит: ", Color(255, 200, 0), lastCommitMessage)
            chat.AddText(Color(100, 150, 255), "Скачать: https://github.com/" .. DLIB_REPO)
            

            notification.AddLegacy(
                "DLib обновлён! Новые изменения от " .. newDate,
                NOTIFY_GENERIC, 8
            )
            

            SetGlobalString("DLib_last_update", newDate)
        else
            print("[DLib] Библиотека актуальна (последнее обновление: " .. currentDate .. ")")
        end
        

        print("[DLib] Текущая версия: v1.0 от 31.05.2026")
        print("[DLib] Хеш последнего коммита: " .. lastCommitHash)
        
    end, function(error)
        print("[DLib] Ошибка HTTP запроса: " .. error)
    end)
end


hook.Add("Initialize", "CheckDLibOnStart", function()
    timer.Simple(3, CheckDLibUpdates)
end)


timer.Create("DLibAutoUpdateCheck", 7200, 0, CheckDLibUpdates)
