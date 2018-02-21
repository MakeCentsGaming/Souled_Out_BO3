#using scripts\shared\array_shared;
#using scripts\zm\_zm_score;

#insert scripts\zm\souled_out\souled_out.gsh;
/*
#####################
by: M.A.K.E C E N T S
#####################
Script:

Add to top of mapname.gsc
#using scripts\zm\souled_out\souled_out_end_game;

Add to zone file
scriptparsetree,scripts/zm/souled_out/souled_out_end_game.gsc


Radiant:
Add trigger_use with targetname>mcendgame

###############################################################################
*/

//#precache ( , )

//#namespace mc_end_game;
function autoexec init()
{
	trigs = GetEntArray("mcendgame","targetname");
	array::thread_all(trigs, &EndGameSetup);
}

function private EndGameSetup()
{
	self SetTriggerHints();
	self Hide();
	self WaitToEndGame();
	self Show();
	self thread WaitTillEndGame();
}

function private WaitTillEndGame()
{
	level endon("end_game");
	cost = 0;
	if(isdefined(ENDGAMECOST))
	{
		cost = ENDGAMECOST;
	}
	while(1)
	{
		self waittill("trigger", player);
		if(player.score>=cost)
		{
			player zm_score::minus_to_player_score(cost);
			player PlayLocalSound("zmb_cha_ching");
			level thread NoPlayerDies();
			level notify("end_game");
		}
		player PlayLocalSound("zmb_no_cha_ching");
		player IPrintLnBold("You cannot afford to end the game [Cost: " + cost + "]");
		wait(1);//stop spamming the end game
	}
}

function private NoPlayerDies()
{
	players = GetPlayers();
	foreach(player in players)
	{
		player EnableInvulnerability();
	}
}

function private SetTriggerHints()
{
	cost = " ";
	if(isdefined(ENDGAMECOST))
	{
		cost = ENDGAMECOST;
	}
	self SetHintString(ENDGAMEHINTSTRING,cost);
	self SetCursorHint("HINT_NOICON");
}

function private WaitToEndGame()
{
	if(!isdefined(ENDGAMEAVAILFLAG)) return;
	level waittill(ENDGAMEAVAILFLAG);
}