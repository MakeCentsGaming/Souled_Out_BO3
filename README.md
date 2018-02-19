# Souled_Out_BO3
Souled out soul collectors from The Drill


```
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
	
	sound\aliases\: (Add the sound alias to your szc)
		Souled_Out.csv

In mapsource you should have:
mapsouce\_prefabs\souled_out\:
	souled_out.map
	soul_caps.map

In sound_assets: 
	sound_assets\soul_grow\pistons.wav
	
In model_export\souled_out\:
	soul_trap_shine.xmodel_bin
	zgrimm_soultrap_pistons_30.xmodel.bin

In art_assets\custom\soultrap\:
	4 images

In xanim_export\souled_out\:
	zgrimm_soultrap_ext_anim.XANIM_BIN
	zgrimm_soultrap_piston_loop.XANIM_BIN

Add to zone:
	include,souled_out

In mapname.gsc
	#using scripts\zm\souled_out\souled_out;

Radiant:
	Add as many soul collector prefabs as you like (the caps are part of the souled_out prefab)

For multiple systems:

	Make new prefab with new targetname
	Add new targetname and line in script:
	
		level thread SoulGroup("newtargetname");

Don't forget to add the sound alias to your szc file
Rewards edited in souled_out.gsh
Adding script_string kvp to collector will override reward for that collector
Reward for finsihing all not included
There is a flag set after all are finished for you to use, the flag is the targetname of the collector
```
