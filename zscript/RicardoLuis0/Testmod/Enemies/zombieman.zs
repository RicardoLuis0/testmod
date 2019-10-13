class PistolZombieManClipDrop : BasicThingSpawner{
	override void setDrops(){
		spawnlist.Push(new("BasicThingSpawnerElement").Init("None",1,4,ALLOW_REPLACE));
		spawnlist.Push(new("BasicThingSpawnerElement").Init("LightClip",1,2,ALLOW_REPLACE));
		spawnlist.Push(new("BasicThingSpawnerElement").Init("LightClip",2,1,ALLOW_REPLACE));
	}
}

class RifleZombieManClipDrop : BasicThingSpawner{
	override void setDrops(){
		spawnlist.Push(new("BasicThingSpawnerElement").Init("HeavyClip",1,4,ALLOW_REPLACE));
		spawnlist.Push(new("BasicThingSpawnerElement").Init("HeavyClip",2,2,ALLOW_REPLACE));
		spawnlist.Push(new("BasicThingSpawnerElement").Init("HeavyClip",4,1,ALLOW_REPLACE));
	}
}

class ZombieManSpawner : RandomSpawner replaces ZombieMan {
	Default {
		DropItem "PistolZombieMan";
		DropItem "PistolZombieMan";
		DropItem "PistolZombieMan";
		DropItem "RifleZombieMan";
		DropItem "RifleZombieMan";
	}
}

class PistolZombieMan : ZombieMan{
	Default{
		DropItem "PistolZombieManClipDrop";
		DropItem "MyPistol";
	}
}

class RifleZombieMan : ZombieMan{
	Default{
		DropItem "RifleZombieManClipDrop";
		DropItem "AssaultRifle";
		Health 60;//has more health
		PainChance 64;//less stun
	}

	action void A_RPosAttack1(){//attack 1 for possessed riflemen, more accurate
		A_PlaySound ("grunt/attack");
		A_CustomBulletAttack (15, 0, 1, random(1,3) * 3, "BulletPuff", 0, CBAF_NORANDOM);
	}

	action void A_RPosAttack2(){//attack 2 for possessed riflemen, less accurate
		A_PlaySound ("grunt/attack");
		A_CustomBulletAttack (30, 0, 1, random(1,3) * 3, "BulletPuff", 0, CBAF_NORANDOM);
	}

	States {
	Spawn:
		RFTR AB 10 A_Look;
		Loop;
	SeeStun:
		RFTR A 16;
	See:
		RFTR AABBCCDD 4 A_Chase;
		Loop;
	Missile:
		TNT1 A 0 A_Jump(16,"FireSingle");//6.25% chance of firing once
		TNT1 A 0 A_Jump(64,"FireMany");//25% chance of firing many times
		Goto FireBurst;
	FireSingle:
		RFTR E 10 A_FaceTarget;
		RFTR F 3 Bright A_RPosAttack1;
		RFTR E 3;
		Goto See;
	FireBurst:
		RFTR E 10 A_FaceTarget;//fire 3 shots, pause for a while
		RFTR F 3 Bright A_RPosAttack1;
		RFTR E 1;
		RFTR F 3 Bright A_RPosAttack1;
		RFTR E 1;
		RFTR F 3 Bright A_RPosAttack1;
		RFTR E 5;
		Goto See;
	FireMany:
		RFTR E 10 A_FaceTarget;
	FireManyLoop:
		RFTR F 3 Bright A_RPosAttack2;
		RFTR E 1;
		RFTR F 3 Bright A_RPosAttack2;
		RFTR E 1;
		RFTR F 3 Bright A_RPosAttack2;
		RFTR E 3;
		RFTR E 0 A_MonsterRefire(128,"SeeStun");//50% chance for each shot to continue firing while out of sight
		RFTR E 3 A_Jump(32,"SeeStun");//12.5% chance to stop firing
		Loop;
	Pain:
		RFTR G 3;
		RFTR G 3 A_Pain;
		Goto SeeStun;
	Death:
		RFTR H 5;
		RFTR I 5 A_Scream;
		RFTR J 5 A_Fall;
		RFTR K 5;
		RFTR L -1;
		Stop;
	XDeath:
		RFTR M 5;
		RFTR N 5 A_XScream;
		RFTR N 5;
		RFTR P 5 A_Fall;
		RFTR QRST 5;
		RFTR U -1;
		Stop;
	Raise:
		RFTR KJ 5;
		RFTR IH 5;
		Goto See;
	}
}
