class MyRocketLauncher : Weapon{
	Default{
		Weapon.AmmoUse 0;
		Weapon.AmmoGive 2;
		Weapon.AmmoType "RocketAmmo";
		Weapon.SlotNumber 5;
		+WEAPON.NOALERT;
		Inventory.PickupMessage "Got Basic Rocket Launcher";
	}
	States{
	Ready:
		HSML A 1 A_WeaponReady();
		Loop;
	Select:
		HSML A 1 A_Raise;
		Loop;
	Deselect:
		HSML A 1 A_Lower;
		Loop;
	Fire:
		HSML B 0 {
			if(CountInv("RocketAmmo")==0){
				return ResolveState("Ready");
			}
			return ResolveState(null);
		}
		HSML B 0 Bright A_GunFlash;
		HSML B 3 Bright MyFire;
		HSML C 3;
		HSML D 3;
		HSML A 10;
		HSML A 1 Offset(0,34);
		HSML A 1 Offset(0,36);
		HSML A 1 Offset(0,38);
		HSML A 1 Offset(0,40);
		HSML A 1 Offset(0,42);
		HSML A 1 Offset(0,44);
		HSML A 1 Offset(0,46);
		HSML A 1 Offset(0,48);
		HSML A 1 Offset(0,50);
		HSML A 1 Offset(0,52);
		HSML A 1 Offset(0,54);
		HSML A 1 Offset(0,56);
		HSML A 1 Offset(0,58);
		HSML A 1 Offset(0,60);
		HSML A 1 Offset(0,62);
		HSML A 1 Offset(0,64);
		HSML A 1 Offset(0,66);
		HSML A 1 Offset(0,68);
		HSML A 1 Offset(0,70);
		HSML A 1 Offset(0,72);
		HSML A 1 Offset(0,74);
		HSML A 1 Offset(0,76);
		HSML A 1 Offset(0,78);
		HSML A 1 Offset(0,80);
		HSML A 1 Offset(0,82);
		HSML A 1 Offset(0,84);
		HSML A 1 Offset(0,86);
		HSML A 1 Offset(0,88);
		HSML A 0 A_PlaySound("TUBERELOAD");
		HSML A 20 Offset(0,90);
		HSML A 1 Offset(0,88);
		HSML A 1 Offset(0,86);
		HSML A 1 Offset(0,84);
		HSML A 1 Offset(0,82);
		HSML A 1 Offset(0,80);
		HSML A 1 Offset(0,78);
		HSML A 1 Offset(0,76);
		HSML A 1 Offset(0,74);
		HSML A 1 Offset(0,72);
		HSML A 1 Offset(0,70);
		HSML A 1 Offset(0,68);
		HSML A 1 Offset(0,66);
		HSML A 1 Offset(0,64);
		HSML A 1 Offset(0,62);
		HSML A 1 Offset(0,60);
		HSML A 1 Offset(0,58);
		HSML A 1 Offset(0,56);
		HSML A 1 Offset(0,54);
		HSML A 1 Offset(0,52);
		HSML A 1 Offset(0,50);
		HSML A 1 Offset(0,48);
		HSML A 1 Offset(0,46);
		HSML A 1 Offset(0,44);
		HSML A 1 Offset(0,42);
		HSML A 1 Offset(0,40);
		HSML A 1 Offset(0,38);
		HSML A 1 Offset(0,36);
		HSML A 1 Offset(0,34);
		HSML A 10;
		HSML A 0 A_Refire;
		Goto Ready;
	Flash:
		TNT1 A 2 A_Light1;
		TNT1 A 2 A_Light2;
		TNT1 A 0 A_Light0;
		Goto LightDone;
	Spawn:
		HSGN A -1;
		Stop;
	}
	action void MyFire(){
		A_Recoil(8);
		A_TakeInventory("RocketAmmo",1);
		A_GunFlash();
		A_AlertMonsters();
		A_FireProjectile("Rocket");
	}
}