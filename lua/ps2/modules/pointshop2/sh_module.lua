local MODULE = {}

--Pointshop2 Basic Items
MODULE.Name = "Pointshop 2"
MODULE.Author = "Kamshak"

--This defines blueprints that players can use to create items.
--base is the name of the class that is used as a base
--creator is the name of the derma control that is used to create new items from the blueprint
MODULE.Blueprints = {
	{
		label = "Player Model",
		base = "base_playermodel",
		icon = "pointshop2/playermodel.png",
		creator = "DPlayerModelCreator"
	},
	{
		label = "Trail",
		base = "base_trail",
		icon = "pointshop2/winner2.png",
		creator = "DTrailCreator"
	},
	{
		label = "Accessory/Hat",
		base = "base_hat",
		icon = "pointshop2/fedora.png",
		creator = "DHatCreator"
	}
}

MODULE.SettingButtons = {
	{
		label = "Basic Settings",
		icon = "pointshop2/small43.png",
		control = "DPointshop2Configurator"
	},
	{
		label = "Reset All",
		icon = "pointshop2/restart1.png",
		control = "DPointshopReset"
	},
	{
		label = "Install Default Items",
		icon = "pointshop2/download7.png",
		onClick = function( )
			Pointshop2View:getInstance( ):installDefaults( )
			Derma_Message( "We're installing the default items for you. Please give us about a minute, your shop will update automatically once the items are installed", "Information" )
		end 
	},
	{
		label = "Repair Database",
		icon = "pointshop2/wizard_l.png",
		onClick = function( )
			Derma_Query( "This will attempt to repair a broken database, then switch the map. If you have strange errors you can try this. Backup your database as you could lose data or problems could get worse. Open a support ticket in this case.", "Warning",
			"Ok, do it", function( )
				Pointshop2View:getInstance( ):fixDatabase( )
			end, 
			"No", function( )
			end )
		end
	},
	{
		label = "Points over Time",
		icon = "pointshop2/person25.png",
		control = "DPointsOverTimeConfigurator"
	}
}

MODULE.Settings = {}
MODULE.Settings.Shared = {
	BasicSettings = {
		info = {
			label = "General Settings"
		},
		SellRatio = {
			tooltip = "The price is multiplied with this to calculate the sell price",
			label = "Item sell repay ratio", 
			value = 0.75
		},
		ServerId = {
			tooltip = "Generated from the ip and hostname, if you switch hosts/ips save this and change it back on the new host.",
			label = "Server Id",
			value = util.CRC( GetConVarString( "ip" ) .. GetConVarString( "port" ) ),
		},
		SendPointsEnabled = {
			label = "Allow players to send points",
			tooltip = "This can be used to disable the possibility to send points to other players",
			value = true
		},
	}
}

MODULE.Settings.Server = {
	BasicSettings = {
		info = {
			label = "Player Defaults"
		},
		DefaultSlots = {
			value = 40,
			label = "Starting inventory slots",
			tooltip = "Size of the inventory when a player first joins",
		},
		["DefaultWallet.Points"] = {
			label = "Starting points",
			value = 1000
		},
		["DefaultWallet.PremiumPoints"] = {
			label = "Starting donator points",
			value = 1000
		},
	},
	GUISettings = {
		info = {
			label = "GUI Settings",
		},
		ShopKey = {
			value = "F3",
			possibleValues = {
				"F1",
				"F2",
				"F3",
				"F4",
				"None"
			},
			type = "option",
			label = "Shop Key",
			tooltip = "Key used to open the shop"
		},
		ShopChat = { 
			value = "!shop",
			possibleValues = {
				"!shop",
				"!ps", 
				"!ps2",
				"!pointshop",
				"!pointshop2",
				"!points"
			},
			type = "option",
			label = "Shop Chat Command",
			tooltip = "Chat command used to open the shop"
		}
	},
	PointsOverTime = {
		info = {
			isManualSetting = true, --Ignored by AutoAddSettingsTable
		},
		Delay = 10,
		Points = 100,
		GroupMultipliers = { 
			type = "table",
			value = { }
		}
	}
}

Pointshop2.RegisterModule( MODULE )
Pointshop2.NotifyGamemodeModuleLoaded( "terrortown", MODULE )