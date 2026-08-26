package com.taomee.seer2.module.app.newPetDictionary
{
   import flash.events.Event;
   
   public class NewPetDicsEvent extends Event
   {
      
      public static const SHOW_PET_DETAIL:String = "showPetDetail";
      
      private var _petResourceId:uint;
      
      public function NewPetDicsEvent(param1:String, param2:uint = 0, param3:Boolean = false, param4:Boolean = false)
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

