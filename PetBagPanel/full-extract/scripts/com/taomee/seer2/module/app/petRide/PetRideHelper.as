package com.taomee.seer2.module.app.petRide
{
   import com.taomee.seer2.app.actor.ActorManager;
   import com.taomee.seer2.app.inventory.item.EquipItem;
   
   public class PetRideHelper
   {
      
      private static var _instance:PetRideHelper;
      
      public function PetRideHelper()
      {
         super();
         if(_instance != null)
         {
            throw new Error("实例化单例类出错，只能有一个实例");
         }
      }
      
      public static function getInstance() : PetRideHelper
      {
         if(_instance == null)
         {
            _instance = new PetRideHelper();
         }
         return _instance;
      }
      
      public function getNormalRideEquip() : EquipItem
      {
         var _loc1_:int = 0;
         var _loc2_:Vector.<EquipItem> = ActorManager.actorInfo.equipVec;
         if(Boolean(_loc2_))
         {
            _loc1_ = 0;
            while(_loc1_ < _loc2_.length)
            {
               if(_loc2_[_loc1_].slotIndex == 11 || _loc2_[_loc1_].slotIndex == 3)
               {
                  return _loc2_[_loc1_];
               }
               _loc1_++;
            }
         }
         return null;
      }
   }
}

