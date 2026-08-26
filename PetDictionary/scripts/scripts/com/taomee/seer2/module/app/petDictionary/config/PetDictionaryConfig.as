package com.taomee.seer2.module.app.petDictionary.config
{
   import com.taomee.seer2.app.pet.data.PetInfo;
   import com.taomee.seer2.app.pet.data.PetInfoManager;
   import com.taomee.seer2.module.app.petDictionary.config.configInfo.InitialPetRewardInfo;
   import com.taomee.seer2.module.app.petDictionary.config.configInfo.SuitInfo;
   import com.taomee.seer2.module.app.petDictionary.config.configInfo.SuitRewardInfo;
   import com.taomee.seer2.module.app.petDictionary.config.configInfo.ThirdPetRewardInfo;
   import com.taomee.seer2.module.app.petDictionary.config.configInfo.TrainRewardInfo;
   import org.taomee.ds.HashMap;
   
   public class PetDictionaryConfig
   {
      
      private static var _xml:XML;
      
      public static var trainRewardVec:Vector.<TrainRewardInfo>;
      
      public static var initPetRewardInfo:InitialPetRewardInfo;
      
      public static var thirdPetRewardInfo:ThirdPetRewardInfo;
      
      private static var _suitRewardMap:HashMap;
      
      private static var _suitMap:HashMap;
      
      private static var _xmlClass:Class = PetDictionaryConfig__xmlClass;
      
      setup();
      
      public function PetDictionaryConfig()
      {
         super();
      }
      
      public static function setup() : void
      {
         var _loc1_:XML = null;
         var _loc2_:int = 0;
         trainRewardVec = new Vector.<TrainRewardInfo>();
         _suitRewardMap = new HashMap();
         _suitMap = new HashMap();
         _xml = XML(new _xmlClass());
         var _loc3_:XMLList = _xml.descendants("HandBook");
         for each(_loc1_ in _loc3_)
         {
            _loc2_ = int(_loc1_.attribute("type"));
            if(_loc2_ == 1)
            {
               parserSuitReward(_loc1_);
            }
            else if(_loc2_ == 2)
            {
               parserInitialPetReward(_loc1_);
            }
            else if(_loc2_ == 3)
            {
               parserTrainReward(_loc1_);
            }
            else if(_loc2_ == 4)
            {
               parserThirdPetReward(_loc1_);
            }
         }
      }
      
      private static function parserSuitReward(param1:XML) : void
      {
         var _loc2_:SuitInfo = null;
         var _loc3_:SuitRewardInfo = null;
         var _loc4_:Vector.<SuitRewardInfo> = null;
         var _loc5_:int = int(param1.attribute("SuitID"));
         _loc2_ = new SuitInfo();
         _loc2_.suitName = param1.attribute("SuitName");
         var _loc6_:String = param1.attribute("SuitVec");
         _loc2_.suitVec = Vector.<int>(_loc6_.split(" "));
         _suitMap.add(_loc5_,_loc2_);
         if(_suitRewardMap.containsKey(_loc5_))
         {
            _loc4_ = _suitRewardMap.getValue(_loc5_);
         }
         else
         {
            _loc4_ = new Vector.<SuitRewardInfo>();
            _suitRewardMap.add(_loc5_,_loc4_);
         }
         _loc3_ = new SuitRewardInfo();
         _loc3_.suitId = _loc5_;
         _loc3_.index = int(param1.attribute("Index"));
         _loc3_.onlyFlagIndex = int(param1.attribute("OnlyFlagIndex"));
         var _loc7_:String = param1.attribute("PetNumID");
         _loc3_.needPetVec = Vector.<int>(_loc7_.split(" "));
         var _loc8_:String = param1.attribute("PetIcon");
         _loc3_.neePetIconVec = Vector.<int>(_loc8_.split(" "));
         var _loc9_:XML = param1.elements("Item")[0];
         _loc3_.rewardId = int(_loc9_.attribute("ID"));
         _loc3_.rewardCount = int(_loc9_.attribute("Count"));
         _loc4_.push(_loc3_);
      }
      
      private static function parserInitialPetReward(param1:XML) : void
      {
         var _loc2_:int = 0;
         var _loc3_:XML = null;
         var _loc4_:PetInfo = PetInfoManager.getInitialPetInfo();
         _loc2_ = int(param1.attribute("NumID"));
         if(_loc2_ == _loc4_.bunchId)
         {
            initPetRewardInfo = new InitialPetRewardInfo();
            initPetRewardInfo.resourceId = (_loc2_ - 1) * 3 + 1;
            initPetRewardInfo.numId = _loc2_;
            initPetRewardInfo.index = int(param1.attribute("Index"));
            initPetRewardInfo.onlyFlagIndex = int(param1.attribute("OnlyFlagIndex"));
            initPetRewardInfo.initialPetLevel = int(param1.attribute("InitMonLevel"));
            initPetRewardInfo.collectPetNum = int(param1.attribute("DoneCount"));
            _loc3_ = param1.elements("Item")[0];
            initPetRewardInfo.rewardId = int(_loc3_.attribute("ID"));
            initPetRewardInfo.rewardLevel = int(_loc3_.attribute("Level"));
         }
      }
      
      private static function parserThirdPetReward(param1:XML) : void
      {
         var _loc2_:int = 0;
         var _loc3_:XML = null;
         var _loc4_:PetInfo = PetInfoManager.getInitialPetInfo();
         _loc2_ = int(param1.attribute("NumID"));
         if(_loc2_ == _loc4_.bunchId)
         {
            thirdPetRewardInfo = new ThirdPetRewardInfo();
            thirdPetRewardInfo.index = int(param1.attribute("Index"));
            thirdPetRewardInfo.onlyFlagIndex = int(param1.attribute("OnlyFlagIndex"));
            thirdPetRewardInfo.firstPetId = (_loc2_ - 1) * 3 + 1;
            thirdPetRewardInfo.secondPetId = int(param1.attribute("secondPetID"));
            _loc3_ = param1.elements("Item")[0];
            thirdPetRewardInfo.rewardId = int(_loc3_.attribute("ID"));
            thirdPetRewardInfo.rewardLevel = int(_loc3_.attribute("Level"));
         }
      }
      
      private static function parserTrainReward(param1:XML) : void
      {
         var _loc2_:TrainRewardInfo = new TrainRewardInfo();
         _loc2_.index = int(param1.attribute("Index"));
         _loc2_.onlyFlagIndex = int(param1.attribute("OnlyFlagIndex"));
         _loc2_.needLevel = int(param1.attribute("NumLevel"));
         _loc2_.needCount = int(param1.attribute("NumCount"));
         _loc2_.tip = param1.attribute("tip");
         _loc2_.tip = _loc2_.tip.replace(/ /g,"\n");
         trainRewardVec.push(_loc2_);
      }
      
      public static function getSuitRewardVec(param1:int) : Vector.<SuitRewardInfo>
      {
         if(_suitRewardMap.containsKey(param1))
         {
            return _suitRewardMap.getValue(param1);
         }
         return null;
      }
      
      public static function getSuitInfo(param1:int) : SuitInfo
      {
         if(_suitMap.containsKey(param1))
         {
            return _suitMap.getValue(param1);
         }
         return null;
      }
      
      public static function getAllSuitReward() : Vector.<int>
      {
         return Vector.<int>(_suitRewardMap.getKeys());
      }
   }
}

