/*
class Slot1Spawner:ClassRestrictedThingSpawner replaces Chainsaw{
	override void setDrops(){
		spawnlist.Push(new("ClassRestrictedThingSpawnerElement").Init("Melee","MyChainsaw",1,1));
	}
}
*/

class Slot2Spawner:ClassRestrictedThingSpawner{
	override void setDrops(){
		spawnlist.Push(new("ClassRestrictedThingSpawnerElement").Init("Marine","MyPistol",1,1));
	}
}

class Slot3Spawner:ClassRestrictedThingSpawner{
	override void setDrops(){
		spawnlist.Push(new("ClassRestrictedThingSpawnerElement").Init("Marine","PumpShotgun",1,1));
		spawnlist.Push(new("ClassRestrictedThingSpawnerElement").Init("Marine","SSG",1,1));
	}
}

class Slot4Spawner:ClassRestrictedThingSpawner{
	override void setDrops(){
		spawnlist.Push(new("ClassRestrictedThingSpawnerElement").Init("Marine","AssaultRifle",1,1));
		spawnlist.Push(new("ClassRestrictedThingSpawnerElement").Init("Marine","GatlingGun",1,1));
	}
}

class Slot5Spawner:ClassRestrictedThingSpawner{
	override void setDrops(){
		spawnlist.Push(new("ClassRestrictedThingSpawnerElement").Init("Marine","GuidedRocketLauncher",1,1));
		spawnlist.Push(new("ClassRestrictedThingSpawnerElement").Init("Marine","GatlingRocketLauncher",1,1));
	}
}

class Slot6Spawner:ClassRestrictedThingSpawner{
	override void setDrops(){
		spawnlist.Push(new("ClassRestrictedThingSpawnerElement").Init("Marine","MyPlasmaRifle",1,1));
	}
}

class PistolSpawner:Slot2Spawner replaces Pistol{
	override void setDrops(){
		spawnlist.Push(new("ClassRestrictedThingSpawnerElement").Init("Marine","MyPistol",1,1));
	}
}

class ShotgunSpawner:ClassRestrictedThingSpawner replaces Shotgun{
	override void setDrops(){
		spawnlist.Push(new("ClassRestrictedThingSpawnerElement").Init("Marine","PumpShotgun",1,3));
		if(CVar.FindCVar("ssg_from_shotgun").GetInt())spawnlist.Push(new("ClassRestrictedThingSpawnerElement").Init("Marine","SSG",1,1));
	}
}

class SuperShotgunSpawner:ClassRestrictedThingSpawner replaces SuperShotgun{
	override void setDrops(){
		spawnlist.Push(new("ClassRestrictedThingSpawnerElement").Init("Marine","SSG",1,1));
	}
}

class ChaingunSpawner:ClassRestrictedThingSpawner replaces Chaingun{
	override void setDrops(){
		spawnlist.Push(new("ClassRestrictedThingSpawnerElement").Init("Marine","Minigun",1,3));
		spawnlist.Push(new("ClassRestrictedThingSpawnerElement").Init("Marine","HeavyGatlingGun",1,1));
	}
}

class RocketLauncherSpawner:ClassRestrictedThingSpawner replaces RocketLauncher{
	override void setDrops(){
		spawnlist.Push(new("ClassRestrictedThingSpawnerElement").Init("Marine","GuidedRocketLauncher",1,2));
		if(CVar.FindCVar("gatling_rocket_launcher").GetInt())spawnlist.Push(new("ClassRestrictedThingSpawnerElement").Init("Marine","GatlingRocketLauncher",1,1));
	}
}

class PlasmaRifleSpawner:ClassRestrictedThingSpawner replaces PlasmaRifle{
	override void setDrops(){
		spawnlist.Push(new("ClassRestrictedThingSpawnerElement").Init("Marine","MyPlasmaRifle",1,1));
	}
}