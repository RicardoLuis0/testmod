class ThingSpawnerBase:Actor{
	bool spawnactor(string a_name,int replace,Vector3 v){
		class<Actor> a_class=a_name;
		if(a_class==null){
			console.printf("\c[red] Invalid Actor \""..a_name.."\"");
			return false;
		}
		Actor obj=Spawn(a_class,pos,replace);
		if(obj){
			obj.vel=v;
			obj.bDropped = bDropped;
			Float ammoFactor;
			if(bDropped){
				ammoFactor=G_SkillPropertyFloat(SKILLP_AmmoFactor);
				if(ammoFactor==-1)ammoFactor=0.5;
			}else{
				ammoFactor=G_SkillPropertyFloat(SKILLP_DropAmmoFactor);
				if(ammoFactor==-1)ammoFactor=1;
			}
			if(obj is "Ammo"){
				Ammo a_obj=Ammo(obj);
				if (ammoFactor > 0){
					a_obj.amount=int(a_obj.default.amount*ammoFactor);
				}
			}else if(obj is "Weapon"){
				Weapon w_obj=Weapon(obj);
				if (ammoFactor > 0){
					w_obj.ammoGive1=int(w_obj.default.ammoGive1*ammoFactor);
					w_obj.ammoGive2=int(w_obj.default.ammoGive2*ammoFactor);
				}
			}
			return true;
		}
		return false;
	}
}

class BasicThingSpawnerElement{
	string actor_name;
	int actor_amount;
	int actor_weight;
	int areplace;
	BasicThingSpawnerElement Init(string name="None",int amount=1,int weight=1,int replace=ALLOW_REPLACE){
		actor_name=name;
		actor_amount=amount;
		actor_weight=weight;
		replace=replace;
		return self;
	}
}

class BasicThingSpawner:ThingSpawnerBase{

	Array<BasicThingSpawnerElement> spawnlist;
	int max_weight;

	int arrayMaxWeight(){
		int total=0;
		int i;
		for(i=0;i<spawnlist.Size();i++){
			total+=spawnlist[i].actor_weight;
		}
		return total-1;
	}

	BasicThingSpawnerElement getFromWeight(int weight){
		int total=0;
		int i;
		for(i=0;i<spawnlist.Size();i++){
			total+=spawnlist[i].actor_weight;
			if(total>weight) break;
		}
		if(i>=spawnlist.Size()){
			return null;
		}
		return spawnlist[i];
	}

	override void BeginPlay(){
		super.BeginPlay();
		setDrops();
		max_weight=arrayMaxWeight();
	}

	virtual void setDrops(){}

	bool DoSpawn(){
		int weight=random(0,max_weight);
		BasicThingSpawnerElement toSpawn=getFromWeight(weight);

		if(toSpawn==null) return false;

		if(toSpawn.actor_name!="None"){
			int i;
			if(toSpawn.actor_amount==1){
				return spawnactor(toSpawn.actor_name,toSpawn.areplace,vel);
			}else{
				for(i=0;i<toSpawn.actor_amount;i++){
					Vector3 Spawnvel=vel+(frandom(-1,1),frandom(-1,1),frandom(1,2));
					if(!spawnactor(toSpawn.actor_name,toSpawn.areplace,Spawnvel))return false;
				}
				return true;
			}
		}
		return true;
	}

	override void PostBeginPlay(){
		super.PostBeginPlay();
		setDrops();
		if(!DoSpawn()) console.printf("\c[Red] Error Spawning Drops");
		Destroy();
	}

}
