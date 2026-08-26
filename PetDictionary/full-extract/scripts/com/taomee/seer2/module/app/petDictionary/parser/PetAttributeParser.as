package com.taomee.seer2.module.app.petDictionary.parser
{
   public class PetAttributeParser
   {
      
      public function PetAttributeParser()
      {
         super();
      }
      
      public static function parseWeightRange(param1:String) : String
      {
         var _loc2_:Array = param1.split(" ");
         return _loc2_[0] + " - " + _loc2_[1] + " kg";
      }
      
      public static function parseHeightRange(param1:String) : String
      {
         var _loc2_:Array = param1.split(" ");
         return _loc2_[0] + " - " + _loc2_[1] + " cm";
      }
      
      public static function parseGenderRange(param1:String) : String
      {
         if(param1.length == 1)
         {
            return param1 + " 100%";
         }
         return param1.charAt(0) + " " + param1.charAt(1) + "0%" + param1.charAt(2) + " " + param1.charAt(3) + "0%";
      }
   }
}

