package com.taomee.seer2.module.app.petDictionary.event
{
   import flash.events.Event;
   
   public class PetDictionaryEvent extends Event
   {
      
      public static const SHOW_PET_DETAIL:String = "showPetDetail";
      
      public static const HIDE_PET_DETAIL:String = "hidePetDetail";
      
      public static const COLLECT_PET_SHINE:String = "collectPetShine";
      
      public static const TRAIN_PET_SHINE:String = "trainPetShine";
      
      private var _petResourceId:uint;
      
      public function PetDictionaryEvent(param1:String, param2:uint = 0, param3:Boolean = false, param4:Boolean = false)
      {
         super(param1,param3,param4);
         this._petResourceId = param2;
      }
      
      public function getPetResourceId() : uint
      {
         return this._petResourceId;
      }
   }
}

