package com.taomee.seer2.module.app.petBag.event
{
   import com.taomee.seer2.app.pet.data.PetInfo;
   import flash.events.Event;
   
   public class PetBagEvent extends Event
   {
      
      public static const PET_DATA_CHANGE:String = "petDataChange";
      
      public static const PET_SELCTED:String = "petSelected";
      
      public static const PET_ADDED_HP:String = "petAddedHp";
      
      public static const TRAINING_PET_ERROR:String = "petTrainingError";
      
      private var _info:PetInfo;
      
      public function PetBagEvent(param1:String, param2:PetInfo = null, param3:Boolean = false, param4:Boolean = false)
      {
         super(param1,param3,param4);
         this._info = param2;
      }
      
      public function get petInfo() : PetInfo
      {
         return this._info;
      }
   }
}

