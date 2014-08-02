local PANEL = {}

function PANEL:Init( )
	self.header = vgui.Create( "DPanel", self )
	self.header:Dock( TOP )
	self.header:DockPadding( 10, 10, 10, 10 )
	self.header.Paint = function( ) end
	function self.header:PerformLayout( )
		self.title:SizeToContents( )
		self:SizeToChildren( false, true )
		self.icon:SetWide( self.icon:GetTall( ) )
	end
	
	local icon = vgui.Create( "DImage", self.header ) 
	icon:Dock( LEFT )
	icon:SetSize( 32, 32 )
	self.header.icon = icon
	
	local title = vgui.Create( "DLabel", self.header )
	title:Dock( TOP )
	title:DockMargin( 5, 0, 0, 0 )
	self.header.title = title 
	
	self.content = vgui.Create( "DMultilineLabel", self )
	self.content:DockMargin( 5, 0, 5, 0 )
	self.content:Dock( TOP )
end

function PANEL:ApplySchemeSettings( )
	self.header.title:SetFont( self:GetSkin( ).SmallTitleFont )
	self.header.title:SetTextColor( self:GetSkin( ).Colours.Label.Bright )
	self.content.font = self:GetSkin( ).fontName
end

function PANEL:SetInfo( title, description, icon )
	icon = icon or "pointshop2/info20.png"
	
	self.header.icon:SetMaterial( Material( icon, "noclamp smooth" ) )
	self.header.title:SetText( title )
	self.content:SetText( description )
end

function PANEL:PerformLayout( )
	self:SizeToChildren( false, true )
end

Derma_Hook( PANEL, "Paint", "Paint", "InnerPanel" )

vgui.Register( "DInfoPanel", PANEL, "DPanel" )