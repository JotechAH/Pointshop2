local S = function( id )
	return Pointshop2.GetSetting( "TTT Integration", id )
end
	
local delayedRewards = {}
local function delayReward( ply, points, message, small )
	if S("Kills.DelayReward") then
		table.insert( delayedRewards, { ply = ply, points = points, message = message, small = small } )
	else
		ply:PS2_AddStandardPoints( points, message, small )
	end
end

local function applyDelayedRewards( )
	for k, v in ipairs( delayedRewards )  do
		v.ply:PS2_AddStandardPoints( v.points, v.message, v.small )
	end
	delayedRewards = {}
end

hook.Add( "TTTEndRound", "PS2_TTTEndRound", function( result )
	applyDelayedRewards( )
	
	if result == WIN_INNOCENT then
		for k, v in pairs( player.GetAll( ) ) do
			if v:IsActiveTraitor( ) then
				continue
			end
		
			if v:GetCleanRound( ) and (not v:IsSpec()) and S("RoundWin.CleanRound") then
				v:PS2_AddStandardPoints( S("RoundWin.CleanRound"), "Clean round bonus", true )
			end
			if v:Alive( ) and not (v:IsSpec() or (v.IsGhost and v:IsGhost())) and S("RoundWin.InnocentAlive") then
				v:PS2_AddStandardPoints( S("RoundWin.InnocentAlive"), "Alive bonus", true )
			end
			if S("RoundWin.Innocent") then
				v:PS2_AddStandardPoints( S("RoundWin.Innocent"), "Winning the round" )
			end
			
		end
	elseif result == WIN_TRAITOR then
		for k, v in pairs( player.GetAll( ) ) do
			if not v:IsActiveTraitor( ) then
				continue
			end
			
			if v:Alive( ) and not (v:IsSpec() or (v.IsGhost and v:IsGhost())) and S("RoundWin.TraitorAlive") then
				v:PS2_AddStandardPoints( S("RoundWin.TraitorAlive"), "Alive bonus", true )
			end
			if S("RoundWin.Traitor") then
				v:PS2_AddStandardPoints( S("RoundWin.Traitor"), "Winning the round" )
			end
		end
	end
end )

hook.Add( "TTTFoundDNA", "PS2_TTTFoundDNA", function( ply, dnaOwner, ent )
	if S("Detective.DnaFound") then
		v:PS2_AddStandardPoints( S("Detective.DnaFound"), "Retrieved DNA", true )
	end
	
	ply.hasDnaOn = ply.hasDnaOn or {}
	ply.hasDnaOn[dnaOwner] = true
end )

hook.Add( "PlayerDeath", "PS2_PlayerDeath", function( victim, inflictor, attacker )
	if ply == attacker then
		return
	end
	if (attacker.IsGhost and attacker:IsGhost()) then return end --SpecDM Support.
	
	if not victim.GetRole then
		return
	end
	local victimRole = victim:GetRole( )
	
	if not attacker.GetRole then
		return
	end
	local attackerRole = attacker:GetRole( )
	
	if attackerRole == ROLE_TRAITOR then
		if victimRole == ROLE_INNOCENT and S("Kills.TraitorKillsInno") then
			attacker:PS2_AddStandardPoints( S("Kills.TraitorKillsInno"), "Killed Innocent" )
		elseif victimRole == ROLE_DETECTIVE and S("Kills.TraitorKillsDetective") then
			attacker:PS2_AddStandardPoints( S("Kills.TraitorKillsDetective"), "Killed Detective" )
		end
	elseif attackerRole == ROLE_DETECTIVE then
		if victimRole == ROLE_TRAITOR and S("Kills.DetectiveKillsTraitor") then
			if attacker.hasDnaOn and attacker.hasDnaOn[victim] then
				delayReward( attacker, S("Kills.DetectiveDnaBonus"), "DNA bonus" )
			end
			delayReward( attacker, S("Kills.DetectiveKillsTraitor"), "Killed Traitor" )
		end
	elseif attackerRole == ROLE_INNOCENT then
		if victimRole == ROLE_TRAITOR and S("Kills.InnoKillsTraitor") then
			delayReward( attacker, S("Kills.InnoKillsTraitor"), "Killed Traitor" )
		end
	end
end )

