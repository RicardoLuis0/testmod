class HomingRocketLauncher:Weapon{
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
		HSML A 20;
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
		A_FireProjectile("HomingRocket");
	}
}

class HomingRocket:Rocket{
	bool alive;
	double rotspeed;
	double maxrot;
	double sanitizeangle(double a){
		if(a>360) return sanitizeangle(a%360);
		if(a>180){
			return 360-a;
		}else if(a<0){
			while(a<0)a+=360;
			return sanitizeangle(a);
		}
		return a;
	}
	double anglediff(double a1,double a2){
		if(a1>a2)return -sanitizeangle(a1-a2);
		return sanitizeangle(a2-a1);
	}
	void recalculateVelocity(int speed){
		A_ChangeVelocity(cos(angle)*cos(pitch)*speed,sin(angle)*cos(pitch)*speed,sin(pitch)*speed,CVF_REPLACE);
	}
	override void BeginPlay(){
		super.BeginPlay();
		alive=true;
		rotspeed=5;
		maxrot=90;
	}
	override void Tick(){
		super.Tick();
		if(alive){
			MyPlayer p=MyPlayer(GetPointer(AAPTR_TARGET));
			if(p){
				Vector3 lpos=p.getLookAtPos();
				int dx=lpos.x-pos.x;
				int dy=lpos.y-pos.y;
				int dz=lpos.z-pos.z;
				double targetangle=atan2(dy,dx);
				double targetpitch=-(atan2(sqrt(dx*dx+dy*dy),dz)-90);
				//angle=targetangle;
				//pitch=targetpitch;
				double adiff=anglediff(angle,targetangle);
				double pdiff=anglediff(pitch,targetpitch);
				console.printf("angle:%f,targetangle:%f,pitch:%f,targetpitch:%f,adiff: %f,pdiff: %f",angle,targetangle,pitch,targetpitch,adiff,pdiff);
				if(abs(adiff)<=maxrot&&abs(pdiff)<=maxrot){
					if(abs(adiff)>rotspeed){
						angle+=(adiff>0)?rotspeed:-rotspeed;
					}else{
						angle+=adiff;
					}
					if(abs(pdiff)>rotspeed){
						pitch+=(pdiff>0)?rotspeed:-rotspeed;
					}else{
						pitch+=pdiff;
					}
					recalculateVelocity(20);
				}
			}
		}
	}
	States
	{
	Spawn:
		MISL A 1 Bright;
		Loop;
	Death:
		TNT1 A 0{
			alive=false;
		}
		MISL B 8 Bright A_Explode;
		MISL C 6 Bright;
		MISL D 4 Bright;
		Stop;
	BrainExplode:
		MISL BC 10 Bright;
		MISL D 10 A_BrainExplode;
		Stop;
	}
}