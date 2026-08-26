package com.taomee.seer2.module.app.petBag.helper
{
   import com.taomee.seer2.app.net.CommandSet;
   import com.taomee.seer2.app.net.Connection;
   import com.taomee.seer2.app.pet.data.PetInfo;
   import com.taomee.seer2.app.pet.data.PetInfoManager;
   import com.taomee.seer2.app.popup.ServerMessager;
   import com.taomee.seer2.core.net.LittleEndianByteArray;
   import com.taomee.seer2.core.net.MessageEvent;
   import flash.events.Event;
   import flash.utils.IDataInput;
   import org.taomee.manager.EventManager;
   
   public class PetBagLearningPointHelper
   {
      
      public function PetBagLearningPointHelper()
      {
         super();
      }
      
      public static function canChangeLearningPointSvr(param1:Vector.<int>, param2:Vector.<int>) : Boolean
      {
         return getLearningPointChangedVec(param1,param2).length > 0;
      }
      
      public static function changeLearningPointSvr(param1:uint, param2:Vector.<int>, param3:Vector.<int>) : void
      {
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         var _loc6_:Vector.<int> = getLearningPointChangedVec(param2,param3);
         var _loc7_:LittleEndianByteArray = new LittleEndianByteArray();
         var _loc8_:int = int(_loc6_.length);
         _loc7_.writeUnsignedInt(param1);
         _loc7_.writeUnsignedInt(_loc8_);
         _loc4_ = 0;
         while(_loc4_ < _loc8_)
         {
            _loc5_ = _loc6_[_loc4_];
            _loc7_.writeByte(_loc5_);
            _loc7_.writeShort(param2[_loc5_] - param3[_loc5_]);
            _loc4_++;
         }
         Connection.addCommandListener(CommandSet.PET_ADD_LEARNING_POINT_1033,onAddedLearningPoint);
         Connection.send(CommandSet.PET_ADD_LEARNING_POINT_1033,_loc7_);
      }
      
      private static function onAddedLearningPoint(param1:MessageEvent) : void
      {
         Connection.removeCommandListener(CommandSet.PET_ADD_LEARNING_POINT_1033,onAddedLearningPoint);
         updatePetLearningPoint(param1.message.getRawDataCopy());
      }
      
      private static function getLearningPointChangedVec(param1:Vector.<int>, param2:Vector.<int>) : Vector.<int>
      {
         var _loc3_:int = 0;
         var _loc4_:Vector.<int> = new Vector.<int>();
         _loc3_ = 0;
         while(_loc3_ < 6)
         {
            if(param2[_loc3_] != param1[_loc3_])
            {
               _loc4_.push(_loc3_);
            }
            _loc3_++;
         }
         return _loc4_;
      }
      
      private static function updatePetLearningPoint(param1:IDataInput) : void
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         var _loc6_:uint = param1.readUnsignedInt();
         var _loc7_:PetInfo = PetInfoManager.getPetInfoFromAllBag(_loc6_);
         if(_loc7_ == null)
         {
            return;
         }
         var _loc8_:int = int(param1.readUnsignedInt());
         _loc2_ = 0;
         while(_loc2_ < _loc8_)
         {
            _loc3_ = int(param1.readUnsignedByte());
            _loc4_ = int(param1.readUnsignedShort());
            _loc5_ = int(param1.readUnsignedShort());
            updatePetAbilityValueRecord(_loc7_,_loc3_,_loc4_,_loc5_);
            _loc2_++;
         }
         _loc7_.learningInfo.pointUnused = param1.readUnsignedShort();
         ServerMessager.addMessage("学习力分配成功!");
         PetInfoManager.dispatchEvent("petPropertiesChange",_loc7_);
         EventManager.dispatchEvent(new Event("PetUpdate"));
      }
      
      private static function updatePetAbilityValueRecord(param1:PetInfo, param2:int, param3:int, param4:int) : void
      {
         switch(param2)
         {
            case 0:
               param1.atk = param3;
               param1.learningInfo.pointAtk = param4;
               break;
            case 1:
               param1.defence = param3;
               param1.learningInfo.pointDefence = param4;
               break;
            case 2:
               param1.specialAtk = param3;
               param1.learningInfo.pointSpecialAtk = param4;
               break;
            case 3:
               param1.specialDefence = param3;
               param1.learningInfo.pointSpecialDefence = param4;
               break;
            case 4:
               param1.speed = param3;
               param1.learningInfo.pointSpeed = param4;
               break;
            case 5:
               param1.maxHp = param3;
               param1.learningInfo.pointHp = param4;
         }
      }
      
      public static function canChangeLearningPointByItem(param1:int) : Boolean
      {
         return param1 == 200224 || param1 == 201004;
      }
      
      public static function changeLearningPointByItem(param1:uint, param2:int) : void
      {
         var _loc3_:LittleEndianByteArray = new LittleEndianByteArray();
         _loc3_.writeUnsignedInt(param2);
         _loc3_.writeUnsignedInt(param1);
         Connection.addCommandListener(CommandSet.PET_WASH_LEARNING_POINT_1159,onWashedLearningPoint);
         Connection.send(CommandSet.PET_WASH_LEARNING_POINT_1159,_loc3_);
      }
      
      private static function onWashedLearningPoint(param1:MessageEvent) : void
      {
         Connection.removeCommandListener(CommandSet.PET_WASH_LEARNING_POINT_1159,onWashedLearningPoint);
         updatePetLearningPoint(param1.message.getRawDataCopy());
      }
   }
}

