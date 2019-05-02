class HeavyGatlingGun:MyWeapon{
	int dmg;
	Default{
		Weapon.SlotNumber 4;
		Weapon.AmmoType1 "Clip";
		Weapon.AmmoType2 "Clip";
		Weapon.AmmoUse1 1;
		Weapon.AmmoUse2 1;
		Weapon.AmmoGive1 50;
		+WEAPON.NOALERT;
		+WEAPON.AMMO_OPTIONAL;
		Inventory.PickupMessage "You've got the Heavy Gatling Gun!";
	}
	override void BeginPlay(){
		super.BeginPlay();
		crosshair=35;
		dmg=16;
	}
	States{
		ready:
			DGTG A 1 A_WeaponReady();
			loop;
		select:
			TNT1 A 0 {
				A_UpdateBob();
				TestModPlayer cast=TestModPlayer(invoker.owner);
				if(cast){
					cast.ChangeMove(.75,false);
					cast.DisableJump();
				}
			}
		selectloop:
			DGTG A 1 A_Raise;
			loop;
		deselect:
			TNT1 A 0 {
				TestModPlayer cast=TestModPlayer(invoker.owner);
				if(cast){
					cast.RevertMove();
					cast.RevertJump();
				}
			}
		deselectloop:
			DGTG A 1 A_Lower;
			loop;
		firespin:
			TNT1 A 0 {
				if(CountInv("Clip")==0)return ResolveState("idlespin");
				return ResolveState(null);
			}
			DGTG A 0 A_Bob;
			DGTF A 1 Bright A_FireGun;
			DGTG A 0 A_Bob;
			DGTF B 1 Bright;
			goto idlespin2;
		idlespin:
			DGTG A 0 A_Bob;
			DGTG A 2;
		idlespin2:
			DGTG A 0 A_Bob;
			DGTG B 2;
			DGTG A 0 A_Bob;
			DGTG C 2;
			DGTG A 0 A_Bob;
			DGTG D 2;
			DGTG A 0 CheckFire("firespin","idlespin","spin1down");
			goto ready;
		spin1up:
			DGTG A 0 A_Bob;
			DGTG A 4;
			DGTG A 0 A_Bob;
			DGTG B 4;
			DGTG A 0 A_Bob;
			DGTG C 3;
			DGTG A 0 A_Bob;
			DGTG D 3;
			DGTG A 0 CheckFire("firespin","idlespin","spin1down");
		spin1down:
			DGTG A 0 A_Bob;
			DGTG A 3;
			DGTG A 0 A_Bob;
			DGTG B 3;
			DGTG A 0 A_Bob;
			DGTG C 4;
			DGTG A 0 A_Bob;
			DGTG D 4;
			DGTG A 0 CheckFire("firespin","idlespin","spin2down");
		fire:
		altfire:
		spin2up:
			TNT1 A 0 {
				A_PlaySound("weapons/gatlingspin",CHAN_7,3,true);
				A_PlaySound("weapons/gatlingwindup",CHAN_6,4);
			}
			DGTG A 0 A_Bob;
			DGTG A 7;
			DGTG A 0 A_Bob;
			DGTG B 6;
			DGTG A 0 A_Bob;
			DGTG C 5;
			DGTG A 0 A_Bob;
			DGTG D 4;
			DGTG A 0 CheckFire("spin1up","spin1up","spin2down");
		spin2down:
			DGTG A 0 A_StopSound(CHAN_7);
			DGTG A 0 A_PlaySound("weapons/gatlingwinddown",CHAN_6,3);
			DGTG A 0 A_Bob;
			DGTG A 4;
			DGTG A 0 A_Bob;
			DGTG B 5;
			DGTG A 0 A_Bob;
			DGTG C 6;
			DGTG A 0 A_Bob;
			DGTG D 7;
			DGTG A 0 CheckFire("spin2up","spin2up","ready");
		spawn:
			DEGT A -1;
			stop;
	}
	action State A_FireGun(){
		if(CountInv("Clip")==0){
			return ResolveState("noammo");
		}
		A_GunFlash();
		int refire=player.refire;
		if(refire<=0)player.refire=1;
		W_FireBullets(2,1,1,invoker.dmg,"BulletPuff");
		player.refire=refire;
		A_Recoil(1.5);
		A_AlertMonsters();
		A_SetPitch(pitch+frandom(-2,0),SPF_INTERPOLATE);
		A_PlaySound("weapons/gatlingfire");
		return ResolveState(null);
	}
}