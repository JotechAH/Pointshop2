local PANEL = {}

function PANEL:Init( )
	self:SetTitle( "Settings Editor" )
	self.scroll = vgui.Create( "DScrollPanel", self )
	self.scroll:Dock( FILL )
	
	self.buttonBar = vgui.Create( "DIconLayout", self )
	self.buttonBar:SetBorder( 0 )
	self.buttonBar:SetSpaceX( 5 )
	self.buttonBar:DockMargin( 0, 0, 0, 0 )
	self.buttonBar:Dock( BOTTOM )
	
	self.saveButton = self:AddFormButton( vgui.Create( "DButton", self ) )
	self.saveButton:SetText( "Save" )
	self.saveButton:SetSize( 80, 25 )
	self.saveButton:PerformLayout( )
	self.saveButton:Paint( 10, 10 )
	function self.saveButton.DoClick( )
		self:DoSave( )
		self:Close( )
	end
end

function PANEL:AddFormButton( btn )
	btn:SetParent( self.buttonBar )
	return btn
end

function PANEL:AddSection( name )
	local section = vgui.Create( "DSettingsSection", self.scroll )
	section:SetSettingsListener( self )
	section:Dock( TOP )
	section:DockMargin( 0, 5, 0, 5 )
	section.title:SetText( name )
	
	return section
end

function PANEL:SetData( data )
	self.settings = data
	self:InitSettings( )
end

function PANEL:InitSettings( )
	for path, value in pairs( self.settings ) do
		if self.settingsLookup[path] then
			self.settingsLookup[path]:SetValue( value )
		end
	end
end

function PANEL:OnValueChanged( path, value )
	self.settings[path] = value
end

function PANEL:AutoAddSettingsTable( tbl, settingListener )
	rootPath = rootPath or ""
	
	self.settingsLookup = self.settingsLookup or {}
	for catPath, settingsTable in pairs( tbl ) do
		if settingsTable.info and settingsTable.info.isManualSetting then
			continue
		end
		
		self[catPath] = self:AddSection( settingsTable.info and settingsTable.info.label or catPath )
		self[catPath]:SetSettingsListener( settingListener )
		
		for settingPath, settingInfo in pairs( settingsTable ) do
			if settingPath == "info" then
				--Info about the category
				continue
			end
			
			local path = rootPath .. catPath .. "." .. settingPath
			local panel = self[catPath]:AddSettingByType( path, settingInfo )
			self.settingsLookup[path] = panel
		end
	end
end

function PANEL:SetModule( mod )
	self.mod = mod
end

function PANEL:DoSave( )
	
end

derma.DefineControl( "DSettingsEditor", "", PANEL, "DFrame" )