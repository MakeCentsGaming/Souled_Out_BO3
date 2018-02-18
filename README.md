# Souled_Out_BO3
Souled out soul collectors from The Drill



Extract all
Rename usermaps/mapname folder to your mapname folder
Copy all to root folder


In your mapname folder you should have:

mapname\scripts\zm\souled_out\:
	credits.txt
	souled_out.gsc - the main script
	souled_out.gsh - adjust fx and settings

mapname\zone_source\:
	souled_out.zpkg

In share you should have:

share\raw\:

	fx\:
		greenlight.efx
		machineidlefx.efx
		redlight.efx
		soulcollect.efx
		souled_out_done.efx
		soulenter.fx

	animtrees\:
		souled_out.atr

In mapsource you should have:

mapsouce\_prefabs\souled_out\:
	souled_out.map
	soul_caps.map


Add to zone:
	include,souled_out


Radiant:
	Add as many soul collector prefabs as you like

For multiple systems:

	Make new prefab with new targetname
	Add new targetname and line in script:
	
		level thread SoulGroup("newtargetname");

Rewards edited in souled_out.gsh
Adding script_string kvp to collector will override reward for that collector
Reward for finsihing all not included
There is a flag set after all are finished for you to use, the flag is the targetname of the collector
