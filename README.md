## etstats
### an Enemy Territory: Legacy Script

Requires a JSON module, ie. [https://github.com/rxi/json.lua]()

**TODO**: POST data instead of outputting a file.

Creates output JSON file `matches/starttime_mapname.json` at end of match, eg.:
```json
{
	"mapname": "radar",
	"endtime": "ISO",
	"starttime": "ISO",
	"players": {
		"guid": {
			"team": 2,
			"teamKills": 0,
			"skillPointsLightWeapons": 0,
			"rank": 0,
			"kills": 0,
			"skillPointsFieldOps": 0,
			"teamGibs": 0,
			"playerType": 0,
			"deaths": 0,
			"medals": 0,
			"teamDamageDealt": 0,
			"weaponStats": [ 0, 0, 0, 0, 0 ],
			"skillPointsCovertOps": 0,
			"teamDamageTaken": 0,
			"gibs": 0,
			"damageTaken": 0,
			"damageDealt": 0,
			"suicides": 0,
			"name": "playername",
			"skillPointsEngineering": 0,
			"skill": 0,
			"skillPointsMedic": 0,
			"skillPointsHeavyWeapons": 0,
			"skillPointsBattleSense": 0
		}
	}
}
```