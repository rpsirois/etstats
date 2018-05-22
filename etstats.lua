--[[
	Author: Robert Sirois [http://universesgames.com]
	License: MIT
	Last update 5/22/18
	Website: http://www.etlegacy.com
	Mod: compatible with Legacy, but might also work with other mods
	Description: this script posts end-game stats to an http(s) route
]]--

--[[
local version = _VERSION:match("%d+%.%d+")
package.path = 'lualibs/share/lua/' .. version .. '/?.lua;lualibs/share/lua/' .. version .. '/?/init.lua;' .. package.path
package.cpath = 'lualibs/lib/lua/' .. version .. '/?.so;' .. package.cpath
]]--

--http = require 'socket.http'
--requests = require 'requests'
json = require 'json'
io = require 'io'
os = require 'os'

local modname = 'stats'
local version = '0.1'
local game = {
    ['mapname'] = nil
    ; ['starttime'] = nil
    ; ['endtime'] = nil
    ; ['players'] = nil
}
local players = {}
local defaultStats = {
    ['name'] = nil
    ; ['team'] = nil
    ; ['playerType'] = nil
    ; ['skillPointsBattleSense'] = nil
    ; ['skillPointsEngineering'] = nil
    ; ['skillPointsMedic'] = nil
    ; ['skillPointsFieldOps'] = nil
    ; ['skillPointsLightWeapons'] = nil
    ; ['skillPointsHeavyWeapons'] = nil
    ; ['skillPointsCovertOps'] = nil
    ; ['skill'] = nil
    ; ['rank'] = nil
    ; ['medals'] = nil
    ; ['kills'] = nil
    ; ['deaths'] = nil
    ; ['gibs'] = nil
    ; ['suicides'] = nil
    ; ['teamKills'] = nil
    ; ['teamGibs'] = nil
    ; ['damageDealt'] = nil
    ; ['damageTaken'] = nil
    ; ['teamDamageDealt'] = nil
    ; ['teamDamageTaken'] = nil
    ; ['weaponStats'] = nil
}

-- skill identifiers
local BATTLESENSE 	= 0
local ENGINEERING 	= 1
local MEDIC 		= 2
local FIELDOPS 		= 3
local LIGHTWEAPONS	= 4
local HEAVYWEAPONS	= 5
local COVERTOPS		= 6

-- thanks http://lua-users.org/wiki/CopyTable
function shallowCopy( orig )
    local orig_type = type( orig )
    local copy
    if orig_type == 'table' then
        copy = {}
        for orig_key, orig_value in pairs( orig ) do
            copy[orig_key] = orig_value
        end
    else -- number, string, boolean, etc.
        copy = orig
    end
    return copy
end

function getTeam( cNum )
    return et.gentity_get( cNum, 'sess.sessionTeam' )
end

function getGuid( cNum )
    return et.Info_ValueForKey( et.trap_GetUserinfo( cNum ), 'cl_guid' )
end

function getName( cNum )
    return et.gentity_get( cNum, 'pers.netname' )
end

function setPlayerStats( cNum )
    local stats = players[getGuid( cNum )]

    if stats then
        stats['name']                       = getName( cNum )
        stats['team']                       = getTeam( cNum )
        stats['playerType']                 = et.gentity_get( cNum, 'sess.playerType' )
        stats['skillPointsBattleSense']     = et.gentity_get( cNum, 'sess.skillpoints', BATTLESENSE )
        stats['skillPointsEngineering']     = et.gentity_get( cNum, 'sess.skillpoints', ENGINEERING )
        stats['skillPointsMedic']           = et.gentity_get( cNum, 'sess.skillpoints', MEDIC )
        stats['skillPointsFieldOps']        = et.gentity_get( cNum, 'sess.skillpoints', FIELDOPS )
        stats['skillPointsLightWeapons']    = et.gentity_get( cNum, 'sess.skillpoints', LIGHTWEAPONS )
        stats['skillPointsHeavyWeapons']    = et.gentity_get( cNum, 'sess.skillpoints', HEAVYWEAPONS )
        stats['skillPointsCovertOps']       = et.gentity_get( cNum, 'sess.skillpoints', COVERTOPS )
        stats['skill']                      = et.gentity_get( cNum, 'sess.skill' )
        stats['rank']                       = et.gentity_get( cNum, 'sess.rank' )
        stats['medals']                     = et.gentity_get( cNum, 'sess.medals' )
        stats['kills']                      = et.gentity_get( cNum, 'sess.kills' )
        stats['deaths']                     = et.gentity_get( cNum, 'sess.deaths' )
        stats['gibs']                       = et.gentity_get( cNum, 'sess.gibs' )
        stats['suicides']                   = et.gentity_get( cNum, 'sess.self_kills' )
        stats['teamKills']                  = et.gentity_get( cNum, 'sess.team_kills' )
        stats['teamGibs']                   = et.gentity_get( cNum, 'sess.team_gibs' )
        stats['damageDealt']                = et.gentity_get( cNum, 'sess.damage_given' )
        stats['damageTaken']                = et.gentity_get( cNum, 'sess.damage_received' )
        stats['teamDamageDealt']            = et.gentity_get( cNum, 'sess.team_damage_given' )
        stats['teamDamageTaken']            = et.gentity_get( cNum, 'sess.team_damage_received' )
        stats['weaponStats']                = et.gentity_get( cNum, 'sess.aWeaponStats' )
    end
end

function et_InitGame()
    et.RegisterModname( modname .. ' ' .. version )
    game['starttime'] = os.date( '!%Y-%m-%dT%TZ' )
    game['mapname'] = et.trap_Cvar_Get( 'mapname' )
end

-- set empty stats for players joining if they haven't been already
function et_ClientBegin( cNum )
    local guid = getGuid( cNum )
    local stats = players[guid]

    if not stats then
        players[guid] = shallowCopy( defaultStats )
    end
    
    print '------------------------------------ LUA STATSLOADED'
    print( json.encode( players ) )
end

function et_ShutdownGame( isRestarting )
    game['endtime'] = os.date( '!%Y-%m-%dT%TZ' )

	local cNum = 0
	local maxclients = tonumber( et.trap_Cvar_Get( 'sv_maxclients' ) )

	-- iterate through players and update their stats
	while cNum < maxclients do
		local cs = et.trap_GetConfigstring( tonumber( et.CS_PLAYERS ) + cNum )
		
		if cs and cs ~= '' then
			setPlayerStats( cNum )
		end

		cNum = cNum + 1
	end

    game['players'] = players

    -- POST the data
    print '------------------------------------ LUA STATS GAME FINISHED'
    print( json.encode( game ) )

    local file = io.open( './matches/' .. game['starttime'] .. '_' .. game['mapname'] .. '.json', 'w' )
    io.output( file )
    io.write( json.encode( game ) )
    io.close( file )

    -- TODO make one of these work... need to have a 32 bit version of luasocket for either to function within the ET:L environment

    --response = requests.post{ url='http://localhost:1337/etstats/webhook', data=json.encode( players ) }

    -- thanks https://gist.github.com/lidashuang/6286723
    --[[
    local reqBody = json.encode( players )
    local resBody = {}

    local res, code, response_headers = http.request{
        url = 'http://localhost:1337/etstats/webhook'
        , method = 'POST'
        , headers = {
                ['Content-Type'] = 'application/x-www-form-urlencoded';
                ['Content-Length'] = #reqBody;
        }
        , source = ltn12.source.string( reqBody )
        , sink = ltn12.sink.table( resBody )
    }
    ]]--

end
