#using scripts\shared\flag_shared;
#using scripts\shared\array_shared;
#using scripts\zm\_zm_powerups;
#using scripts\shared\util_shared;
#using scripts\codescripts\struct;
#using scripts\shared\callbacks_shared;

#insert scripts\zm\souled_out\souled_out.gsh;
/*
#####################
by: M.A.K.E C E N T S
#####################

Script: 
#using scripts\zm\souled_out\souled_out;

Zone:
include,souled_out

###############################################################################
*/

#precache( "fx", SOULEDOUTRED);
#precache( "fx", SOULEDIDLEFX);
#precache( "fx", SOULEDCOLLECTFX);
#precache( "fx", SOULENTERFX );
#precache( "fx", SOULEDREWARDFX);
#precache( "fx", SOULEDOUTGREEN);

//#namespace souled_out;

#using_animtree( "souled_out" );

function autoexec init()
{	
	level.activecollectors = [];
	callback::on_ai_spawned(&WaitToDie);
	level thread SoulGroup("souled_out");
}

//################## SETUP ###########################
function private SoulGroup(kvp)
{
	if(!isdefined(level.allsoulcollectors))
	{
		level.allsoulcollectors = [];
	}
	souled_outs = GetEntArray(kvp,"targetname");
	array::thread_all(souled_outs, &Souled_Out_Setup);
	level.allsoulcollectors[kvp] = souled_outs.size;
}

function private Souled_Out_Setup()
{
	if(!isdefined(self.script_int))
	{
		self.script_int = SOULEDOUTTOTAL;
	}
	self.total = self.script_int;
	self WaitToPowerUp();
	self InitPowerUp();
	self StartCollection();
	self EndCollection();
}

function private InitPowerUp()
{
	self UseAnimTree(#animtree);
	self AnimScripted("done",self.origin,self.angles,%o_zgrimm_extenders_all);	
	PlayFX(SOULEDIDLEFX,self.origin);
	self SetEntityPaused(true);
	level.activecollectors[level.activecollectors.size] = self;
}

function private StartCollection()
{
	self LightOn(SOULEDOUTRED);
	self StartPistons();
	self WaitTillAllSoulsCollected();	
}

//################## WAITING FUNCTIONS ###########################
function private WaitTillAllSoulsCollected()
{
	self waittill("nomoresouls");
}

function private WaitToPowerUp()
{
	level flag::init(self.targetname);
	flag = ACTIVATIONFLAG; 
	if(isdefined(self.script_flag))
	{
		flag =self.script_flag;
	}
	level flag::init(flag);
	level flag::wait_till(flag);
}

function private WaitToDie()
{
	self waittill("death");
	origin = self.origin;
	collector = undefined;
	if(level.activecollectors.size<=0)
	{
		//there were no active soul collectors
		return;
	}
	collector = ArrayGetClosest(origin,level.activecollectors);
	if(isdefined(collector))
	{
		if(CloseAndLineOfSight(origin, collector))
		{			
			collector thread SoulTravel(origin);			
		}
	}
}

//###################### ANIMATIONS #########################
function private StartPistons()
{
	piston = getent(self.target,"targetname");
	piston endon("death");
	piston PlayLoopSound("sg_pistons");
	piston UseAnimTree(#animtree);
	piston AnimScripted("done",piston.origin,piston.angles,%o_zgrimm_piston_loop, "normal",undefined,1,.5);
}

function private Expand()
{
	time = GetAnimLength(%o_zgrimm_extenders_all)/self.total;
	if(!isdefined(self.expandtime))
	{
		self.expandtime = -time;
	}
	if(self.expandtime>0)
	{
		self.expandtime+=time;
		return;
	}
	self.expandtime+=time;
	
	self SetEntityPaused(false);
	while(self.expandtime>0)
	{
		wait(time);
		self.expandtime-=time;
	}
	
	if(self.script_int<=0)
	{		
		return;
	}
	self SetEntityPaused(true);
}

//###################### FUNCTIONS #########################
function private SoulTravel(origin)
{	
	end = self.origin;
	fxOrg = util::spawn_model( "tag_origin", origin+(0,0,30) );
	self thread KillSoul(fxOrg);
	fx = PlayFxOnTag( SOULEDCOLLECTFX, fxOrg, "tag_origin" );
	fxOrg PlaySound(SOULEDTRAVELSOUND);
	time = Distance(origin,end)/SOULTRAVELRATE;
	fxOrg MoveTo(end+(0,0,50),time);
	wait(time - .05);
	fxOrg moveto(end, .5);
	fxOrg waittill("movedone");
	self PlaySound(SOULEDENTERSOUND);
	PlayFX(SOULENTERFX,end+(0,0,30));
	if(isdefined(fxOrg))
	{
		fxOrg delete();
	}		
	self thread Expand();
	self CheckDone();
}

function private CheckDone()
{
	self.script_int--;
	if(self.script_int<=0)
	{
		if(self.script_int<=0)
		{							
			ArrayRemoveValue(level.activecollectors,self);
		}
		self notify("nomoresouls");
	}
}

function private KillSoul(fxOrg)
{
	fxOrg endon("death");
	self waittill("nomoresouls");
	if(isdefined(fxOrg))
	{
		fxOrg delete();
	}	
}

function private CloseAndLineOfSight(origin, collector)
{
	if(Distance(origin,collector.origin)>MAXDISTANCE)
	{
		//the zombie is too far away
		return false;
	}
	if(LINEOFSIGHTREQUIRED && !BulletTracePassed( origin, collector.origin+(0,0,50), false, self ) )
	{
		//line of sight is required and there is not line of sight between them
		return false;
	}
	//there is line of sight between the two origins and it is close enough
	return true;
}

function private LightOn(FX)
{	
	if(isdefined(self.lighttag))
	{
		self.lighttag delete();
	}
	self.lighttag = spawn("script_model",self.origin);
	self.lighttag SetModel("tag_origin");
	self.lighttag.angles = self.angles;
	PlayFXOnTag(FX,self.lighttag,"tag_origin");	
}

function private EndCollection()
{
	self LightOn(SOULEDOUTGREEN);
	self RewardForOne();
	self AllDone();
}

function private AllDone()
{
	if(!isdefined(level.allsoulcollectors[self.targetname]))
	{
		IPrintLnBold("No system is set for " + self.taretname);
		return;
	}
	level.allsoulcollectors[self.targetname]--;
	if(level.allsoulcollectors[self.targetname]<=0)
	{
		self RewardForAll();
	}
}

//################## REWARDS ###########################
function private RewardForAll()
{
	//A flag is set by the name of this targetname, SoulGroup("souled_out")
	level flag::set(self.targetname);
	//add your reward here or just wait for the above flag in your script

}

function private RewardForOne()
{	
	self PlaySound(SOULEDREWARDSPAWNSOUND);
	struct = struct::get(self.target, "targetname");
	PlayFX(SOULEDREWARDFX,struct.origin);
	reward = self GetReward();
	if(!isdefined(reward)) 
	{
		//no reward
		return;
	}
	level.lastsoulreward = reward;
	zm_powerups::specific_powerup_drop( reward, struct.origin);
}

function private GetReward()
{
	if(isdefined(self.script_string))
	{
		//override this boxes reward
		return self.script_string;
	}
	options = SOULEDREWARDSPAWN;
	if(!isdefined(options))
	{
		options = level.zombie_powerup_array;
	}
	reward = undefined;
	if(IsArray(options))
	{
		reward = array::randomize(options)[0];
	}
	else
	{
		reward = options;
	}	
	//don't give same reward twice in a row but still make it random
	while(isdefined(level.lastsoulreward) && level.lastsoulreward == reward)
	{
		if(options.size<=1) break;
		reward = array::randomize(SOULEDREWARDSPAWN)[0];
	}
	return reward;
}