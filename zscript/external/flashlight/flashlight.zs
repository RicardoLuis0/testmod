class FlashLightData : Inventory {
	ActorHeadLight light;
}

class FlashLightHandler : StaticEventHandler {
	override void WorldUnloaded(WorldEvent e){
		cleanupFlashlight();
	}
	override void WorldLoaded(WorldEvent e){
		cleanupFlashlight();
	}

	override void NetworkProcess(ConsoleEvent e){
		if(e.name=="flashlight_toggle"){
			PlayerPawn p=players[e.player].mo;
			if(p){
				FlashLightData flash=FlashLightData(p.FindInventory("FlashLightData"));
				if(flash&&flash.light){//don't crash, check for null
					flash.light.toggle();
				}else{
					setupFlashLight(p);
				}
			}
		}else if(e.name=="flashlight_cleanup"){
			cleanupFlashlight();
		}
	}

	void cleanupFlashlight(){
		let it=ThinkerIterator.Create("PlayerPawn");
		PlayerPawn act=null;
		while((act=PlayerPawn(it.next()))!=null){
			FlashLightData flash=FlashLightData(act.FindInventory("FlashLightData"));
			bool was_on=false;
			if(flash){
				flash.light=null;
			}
		}
		it=ThinkerIterator.Create("ActorHeadLight");
		ActorHeadLight light=null;
		while((light=ActorHeadLight(it.next()))!=null){
			light.destroy();
		}
	}

	void setupFlashLight(PlayerPawn p){
		p.GiveInventoryType("FlashLightData");
		FlashLightData flash=FlashLightData(p.FindInventory("FlashLightData"));
		ActorHeadLight light = ActorHeadLight(Actor.Spawn("ActorHeadLight"));
		flash.light=light;
		light.toFollow = p;
		light.activate(null);
	}
}

class ActorHeadLight : Spotlight {

    enum ELocation
	{
		HELMET = 0,
		RIGHT_SHOULDER = 1,
		LEFT_SHOULDER = 2,
        CAMERA = 3
	};

    PlayerPawn toFollow;

    Vector3 offset;
    
    Vector3 finalOffset;
    
    double zBump; // z offset for locations that are not CAMERA
    
    double angleDiff;    
    double turnAnglePerTic;
    bool ready;
    bool on;
    
    ELocation location;
    
    void updateFromCvars () {
    
        Color c = CVar.FindCVar("flashlight_color").GetString();
    
        args[0] = c.r;
        args[1] = c.g;
        args[2] = c.b;    
        args[3] = CVar.FindCVar("flashlight_intensity").GetInt();
        
        self.SpotInnerAngle = CVar.FindCVar("flashlight_inner").GetFloat();        
        self.SpotOuterAngle = CVar.FindCVar("flashlight_outer").GetFloat();
        
        self.location = CVar.FindCVar("flashlight_location").GetInt();
                      
    }
    
	void Toggle(){
		if(on){
			DeActivate(null);
		}else{
			Activate(null);
		}
	}
    
    override void Activate(Actor activator) {
        updateFromCvars();
        on = true;
        super.Activate(activator);
    }
    
    
    override void DeActivate(Actor activator) {
        on = false;
        super.DeActivate(activator);
    
    }
        
    
    override void Tick() {
    
        if (ready && on) {

            switch (location) {
            
                case HELMET:
                    offset = (0, 0, toFollow.player.viewheight + zBump);
                    break;
                    
                case RIGHT_SHOULDER:
                    offset = (toFollow.radius, 0, toFollow.player.viewheight + zBump);
                    break;
                    
                case LEFT_SHOULDER:
                    offset = (toFollow.radius * -1, 0, toFollow.player.viewheight + zBump);
                    break;
                    
                case CAMERA:
                    offset = (0, 0, toFollow.ViewHeight);
                    break;
                    
                default:
                    offset = (0, 0, 0);
            
            }
            
            A_SetAngle(toFollow.angle, 0);
            
            Vector2 finalOffset2D = RotateVector ((offset.x, offset.y), toFollow.angle - 90.0); 
                        
            finalOffset = (finalOffset2D.x, finalOffset2D.y, offset.z);
            
            A_SetPitch(toFollow.pitch, SPF_INTERPOLATE);
            
            SetOrigin(self.toFollow.pos + finalOffset, true);
    
        } else if (on && self.toFollow) {

            ready = true;
            
            zBump = (toFollow.height - toFollow.viewheight) / 2;
        
        }
        
        Super.Tick();    
             
    }
    
}
