class NewShotgunGuy : MyEnemy replaces ShotgunGuy{
	override int rank(){
		return 2;
	}

	override void setDrops(){
		drops.Push(new("MyEnemy_Drop_Single").Init("Shotgun",1,255,5));
	}

	Default{
		Health 30;
		Radius 20;
		Height 56;
		Mass 100;
		Speed 8;
		PainChance 170;
		Monster;
		+FLOORCLIP
		SeeSound "shotguy/sight";
		AttackSound "shotguy/attack";
		PainSound "shotguy/pain";
		DeathSound "shotguy/death";
		ActiveSound "shotguy/active";
		Obituary "$OB_SHOTGUY";
	}

	States{
	Spawn:
		SPOS AB 10 A_Look;
		Loop;
	See:
		SPOS AABBCCDD 3 A_Chase;
		Loop;
	Missile:
		SPOS E 10 A_FaceTarget;
		SPOS F 10 BRIGHT A_SposAttackUseAtkSound;
		SPOS E 10;
		Goto See;
	Pain:
		SPOS G 3;
		SPOS G 3 A_Pain;
		Goto See;
	Death:
		SPOS H 5 resolveDrops;
		SPOS I 5 A_Scream;
		SPOS J 5 A_NoBlocking;
		SPOS K 5;
		SPOS L -1;
		Stop;
	XDeath:
		SPOS M 5 resolveDrops;
		SPOS N 5 A_XScream;
		SPOS O 5 A_NoBlocking;
		SPOS PQRST 5;
		SPOS U -1;
		Stop;
	Raise:
		SPOS L 5;
		SPOS KJIH 5;
		Goto See;
	}
}