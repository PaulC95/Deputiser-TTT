SWEP.Gun 					= ("ttt_deputiser")
SWEP.Category				= "Deputiser"
SWEP.Author					= "Paul"
SWEP.Contact				= "https://steamcommunity.com/id/PaulGC/"
SWEP.Purpose				= ""
SWEP.Instructions			= ""
SWEP.PrintName				= "Deputiser"
SWEP.Slot					= 8
SWEP.SlotPos				= 8
SWEP.DrawAmmo				= false
SWEP.DrawWeaponInfoBox		= false
SWEP.BounceWeaponIcon   	= false
SWEP.DrawCrosshair			= false
SWEP.Weight					= 40
SWEP.AutoSwitchTo			= true
SWEP.AutoSwitchFrom			= true

SWEP.HoldType 				= "pistol"

SWEP.ViewModel			        = "models/weapons/v_eq_flashbang.mdl"
SWEP.WorldModel			        = "models/dethat/deerstalker.mdl"

SWEP.ShowWorldModel			= true
SWEP.Spawnable				= true
SWEP.AdminOnly				= false
SWEP.FiresUnderwater 		        = true
SWEP.UseHands                           = true

SWEP.Base 					= "weapon_tttbase"
SWEP.Kind 					= WEAPON_EQUIP2
SWEP.CanBuy 				= { ROLE_DETECTIVE }
SWEP.AllowDrop 				= true
SWEP.NoSights 				= true
SWEP.AutoSpawnable 			= false

SWEP.Primary.Automatic			= true

SWEP.EquipMenuData = {
      type="Weapon",
      name="Depustiser",
      desc="Give this hat to someone you trust \nso they can help you regain order! \nEquips the reciever with:\nBody Armour, DNA Scanner and a Swanky Hat"
   };

SWEP.Icon = "vgui/Deputiser.png"

SWEP.LimitedStock = false
SWEP.rotated = false

owner = NULL

---------------------------------------------------------
---------------------------------------------------------

function SWEP:Initialize()

        

        if CLIENT then
                ////print("modelset")
	        self.ModelEntity = ClientsideModel(self.WorldModel)
                self.ModelEntity:SetNoDraw(true)
               
                self:AddHUDHelp("Left Click to give the hat to a trusted ally", "Right Click to put the hat on yourself", false)
                     
                return self.BaseClass.Initialize(self)
                        
        end
end

if CLIENT then
       
     
                function SWEP:DrawWorldModel()
                     --self:DrawModel()
                     local ply = self.Owner
                     local pos = self.Weapon:GetPos()
                     local ang = self.Weapon:GetAngles()
                     if ply:IsValid() then
                             local bone = ply:LookupBone("ValveBiped.Bip01_R_Hand")
                             if bone then
                                     pos,ang = ply:GetBonePosition(bone)
                             end
                     else
                             self.Weapon:DrawModel() --Draw the actual model when not held.
                             return
                     end
                     
                     if !self.ModelEntity then
                             self.ModelEntity = ClientsideModel(self.WorldModel)
                             self.ModelEntity:SetNoDraw(true)
                     end
                     
                     self.ModelEntity:SetModelScale(1.2,0)
                     self.ModelEntity:SetPos(pos + Vector(0,0,0))
                     self.ModelEntity:SetAngles(ang)

                     self.ModelEntity:DrawModel()
                end

             function SWEP:ViewModelDrawn()
                     local ply = self.Owner
                     if ply:IsValid() and ply == LocalPlayer() then
                             local vmodel = ply:GetViewModel()
                             local idParent = vmodel:LookupBone("v_weapon.Flashbang_Parent")
                             local idBase = vmodel:LookupBone("v_weapon")
                             if not vmodel:IsValid() or not idParent or not idBase then return end --Ensure the model and bones are valid.
                             local pos, ang = vmodel:GetBonePosition(idParent)	
                             local pos1, ang1 = vmodel:GetBonePosition(idBase) --Rotations were screwy with the parent's angle; use the models baseinstead.
     
                             if !self.ModelEntity then
                                     self.ModelEntity = ClientsideModel(self.WorldModel)
                                     self.ModelEntity:SetNoDraw(true)
                             end
                             
                             self.ModelEntity:SetModelScale(1,0)
			self.ModelEntity:SetPos(pos-ang1:Forward()*1.25-ang1:Up()*1.25+2.3*ang1:Right() + Vector(0,0,0))
			self.ModelEntity:SetAngles(ang1 + Angle(0,0,180))
			self.ModelEntity:DrawModel()
                     end
             end
end




/*
if CLIENT then
        self:AddHUDHelp(primary, secondary, true)
     
        return self.BaseClass.Initialize(self)
end
*/


function SWEP:PrimaryAttack()

        
        tr = self.Owner:GetEyeTrace()
        //print(tr.Entity)

        ply = tr.Entity
        
        if SERVER then

        if tr.Entity:IsPlayer()  and ply:Alive() then 

                
                //print("stuff happening")

                ply:GiveEquipmentItem(EQUIP_ARMOR)
                ply:Give("weapon_ttt_wtester")

                print(GetConVar("ttt_detective_hats"):GetBool())
                
                if ply:Alive() and GetConVar("ttt_detective_hats"):GetBool() then

                  if not IsValid(ply.hat) then

                        

                local hat = ents.Create("ttt_hat_deerstalker")
                     if not IsValid(hat) then return end
          
                    hat:SetPos(ply:GetPos() + Vector(0,0,70))
                    hat:SetAngles(ply:GetAngles())
          
                           hat:SetParent(ply)
          
                           ply.hat = hat
          
                           hat:Spawn()

                        
                end
                
        end

        self:Remove()

end
end
end




function SWEP:SecondaryAttack() 
        
        if SERVER then

                //print("giving items")
                ply:GiveEquipmentItem(EQUIP_ARMOR)
                ply:Give("weapon_ttt_wtester")
                ply = self.Owner

                //print(ply)

                if !ply:IsActiveDetective()  and GetConVar("ttt_detective_hats"):GetBool() then

                        if not IsValid(ply.hat) then
      
                              
      
                              local hat = ents.Create("ttt_hat_deerstalker")
                           if not IsValid(hat) then return end
                
                          hat:SetPos(ply:GetPos() + Vector(0,0,70))
                          hat:SetAngles(ply:GetAngles())
                
                                 hat:SetParent(ply)
                
                                 ply.hat = hat
                
                                 hat:Spawn()
      
                              //ply:Give("item_armor")
                              
                              
                              
                      end
                end
                self:Remove()
        end
        
end

function SWEP:Think()

        ply = self.Owner
        vel = self.Owner:GetVelocity()
        
        ////print(owner)

        

        if vel.z < -250 then
                upvel = Vector(0,0,15)

                ply:SetVelocity(upvel)
        end
        
        
        self.Weapon:NextThink(CurTime())

end

help_spec = {text = "", font = "TabLarge", xalign = TEXT_ALIGN_CENTER}

function SWEP:DrawSkin()

        local data = self.HUDSkin
  
        local primary   = data.primary
        local secondary = data.secondary
  
        help_spec.pos  = { ScrW() / 2.0, ScrH() - 40}
        help_spec.text = secondary or primary
        draw.TextShadow(help_spec, 2)
  
        -- if no secondary exists, primary is drawn at the bottom and no top line
        -- is drawn
        if secondary then
           help_spec.pos[2] = ScrH() - 60
           help_spec.text = primary
           draw.TextShadow(help_spec, 2)
        end
end

