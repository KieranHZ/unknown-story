ESX = nil

Wrapper.TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

Wrapper.RegisterNetEvent('blargleambulance:finishLevel')
Wrapper.AddEventHandler('blargleambulance:finishLevel', function(levelFinished)
    TriggerEvent('esx_addonaccount:getSharedAccount', 'society_ambulance', function(account)
        account.addMoney(Config.Formulas.moneyPerLevel(levelFinished))
    end)
    TriggerEvent('esx_addonaccount:getSharedAccount', 'society_gouvernor', function(account)
        account.addMoney(Config.Formulas.moneyPerLevel(levelFinished))
    end)
end)