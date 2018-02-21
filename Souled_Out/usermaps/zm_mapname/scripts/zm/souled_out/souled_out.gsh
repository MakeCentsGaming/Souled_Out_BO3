//Settings
#define ACTIVATIONFLAG			"power_on" //flat to start them, "zones_initialized" will start them imediately
#define SOULTRAVELRATE			200 //speed the soul travels
#define SOULEDOUTTOTAL			10 //total kills needed for each collector
#define MAXDISTANCE				1200 //furthest distance to collect souls from
#define LINEOFSIGHTREQUIRED		true //is line of sight required to collect soul

//rewards
#define SOULEDREWARDSPAWN		array("free_perk", "minigun", "bonus_points_player") //change to undefined to use level.zombie_powerup_array

//fx 
#define SOULEDOUTRED			"souled_out/redlight" //collectors activated and collecting
#define SOULEDIDLEFX 			"souled_out/machineidlefx" //the fx to play on them when powered up
#define SOULEDCOLLECTFX			"souled_out/soulcollect" //the trail fx to play on soul
#define SOULENTERFX				"souled_out/soulenter" //the fx to play when it enters the collector
#define SOULEDOUTGREEN	 		"souled_out/greenlight" //the green light indicating the collector is done
#define SOULEDREWARDFX			"zombie/fx_powerup_grab_solo_zmb" //the fx to play on reward

//sounds
#define SOULEDFINISHSOUND 		"zmb_hellhound_prespawn" //the sound that the collector is done
#define SOULEDTRAVELSOUND		"evt_nuked" //the sound the soul makes as it travels
#define SOULEDENTERSOUND		"amb_sparks" //the sound the soul makes when it enters collector
#define SOULEDREWARDSPAWNSOUND	"zmb_spawn_powerup" //the sound for the collector completion reward


//end game
#define ENDGAMEHINTSTRING 		"Press ^3[{+activate}]^7 to end game [Cost: &&1]"
#define ENDGAMEAVAILFLAG 		"souled_out"
#define ENDGAMECOST 			5000
