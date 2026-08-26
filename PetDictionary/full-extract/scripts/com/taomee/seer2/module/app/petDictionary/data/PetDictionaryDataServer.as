package com.taomee.seer2.module.app.petDictionary.data
{
   import com.taomee.seer2.app.config.NewPetDicThisWeekListConfig;
   import com.taomee.seer2.app.config.PetConfig;
   import com.taomee.seer2.app.config.info.PetDictionaryInfo;
   import com.taomee.seer2.app.config.pet.PetDefinition;
   import com.taomee.seer2.app.inventory.ItemManager;
   import com.taomee.seer2.app.manager.OnlyFlagManager;
   import com.taomee.seer2.app.net.CommandSet;
   import com.taomee.seer2.app.net.Connection;
   import com.taomee.seer2.app.pet.data.PetInfoManager;
   import com.taomee.seer2.app.popup.AlertManager;
   import com.taomee.seer2.core.config.ClientConfig;
   import com.taomee.seer2.core.net.MessageEvent;
   import com.taomee.seer2.core.utils.URLUtil;
   import com.taomee.seer2.module.app.petDictionary.config.PetDictionaryConfig;
   import com.taomee.seer2.module.app.petDictionary.config.configInfo.SuitRewardInfo;
   import com.taomee.seer2.module.app.petDictionary.config.configInfo.TrainRewardInfo;
   import flash.events.Event;
   import flash.events.IOErrorEvent;
   import flash.events.SecurityErrorEvent;
   import flash.net.URLLoader;
   import flash.net.URLRequest;
   import flash.utils.ByteArray;
   import flash.utils.clearTimeout;
   import flash.utils.setTimeout;
   import org.taomee.ds.HashMap;
   
   public class PetDictionaryDataServer
   {
      
      public static var petGainedNum:uint;
      
      private static var _petDictionaryMap:HashMap;
      
      private static var _onGetPetDictionary:Function;
      
      private static var _onGetRewardStatus:Function;
      
      private static var _onGetReward:Function;
      
      private static var _onGetGiftStatus:Function;
      
      private static var _launcherRouteLoader:URLLoader;
      
      private static var _launcherRouteCompleteHandler:Function;
      
      private static var _launcherRouteErrorHandler:Function;
      
      private static var _launcherRouteSerial:uint;
      
      private static var _launcherRouteTimeout:uint;
      
      private static var _launcherRouteRevision:uint;
      
      private static var _launcherRoutesSettled:Boolean;
      
      private static var _serverDataSettled:Boolean;
      
      private static var _launcherRouteMap:HashMap = new HashMap();
      
      public static const PAGE_SIZE:int = 12;
      
      public static const RESOURCE_ROLE_BODY:String = "body";
      
      public static const RESOURCE_ROLE_OFFICIAL_SKIN:String = "officialSkin";
      
      public static const RESOURCE_ROLE_EXTERNAL_SKIN:String = "externalSkin";
      
      private static const LEGACY_VARIANT_NAMESPACE:int = 10000;
      
      public static const thisWeekPets:Vector.<int> = NewPetDicThisWeekListConfig.getPetIDForDic();
      
      public function PetDictionaryDataServer()
      {
         super();
      }
      
      public static function getDataFromServer(param1:Function, param2:Function, param3:Function) : void
      {
         _onGetGiftStatus = param1;
         _onGetPetDictionary = param2;
         _onGetRewardStatus = param3;
         _serverDataSettled = false;
         loadLauncherRouteManifest();
         Connection.addCommandListener(CommandSet.PET_GET_DICTIONARY_LIST_1034,onGetPetDictionary);
         Connection.send(CommandSet.PET_GET_DICTIONARY_LIST_1034);
      }
      
      private static function loadLauncherRouteManifest() : void
      {
         var serial:uint = 0;
         clearLauncherRouteLoader();
         _launcherRouteMap = new HashMap();
         _launcherRouteRevision = 0;
         _launcherRoutesSettled = false;
         serial = ++_launcherRouteSerial;
         try
         {
            _launcherRouteLoader = new URLLoader();
            _launcherRouteCompleteHandler = function(param1:Event):void
            {
               onLauncherRouteManifestReady(param1,serial);
            };
            _launcherRouteErrorHandler = function(param1:Event):void
            {
               onLauncherRouteManifestError(param1,serial);
            };
            _launcherRouteLoader.addEventListener(Event.COMPLETE,_launcherRouteCompleteHandler);
            _launcherRouteLoader.addEventListener(IOErrorEvent.IO_ERROR,_launcherRouteErrorHandler);
            _launcherRouteLoader.addEventListener(SecurityErrorEvent.SECURITY_ERROR,_launcherRouteErrorHandler);
            _launcherRouteTimeout = setTimeout(function():void
            {
               settleLauncherRouteManifest(serial,null);
            },3000);
            _launcherRouteLoader.load(new URLRequest(ClientConfig.rootURL + "launcher/custom-skin-routes.xml?time=" + new Date().time));
         }
         catch(error:Error)
         {
            settleLauncherRouteManifest(serial,null);
         }
      }
      
      private static function onLauncherRouteManifestReady(param1:Event, param2:uint) : void
      {
         var _loc5_:XML;
         var _loc6_:XML;
         var _loc7_:uint;
         var _loc3_:HashMap = new HashMap();
         var _loc4_:uint = 0;
         try
         {
            _loc5_ = new XML(String(_launcherRouteLoader.data));
            if(String(_loc5_.name()) != "launcherSkinRoutes")
            {
               throw new Error("invalid launcher route root");
            }
            _loc4_ = uint(_loc5_.@revision);
            _loc6_ = null;
            _loc7_ = 0;
            for each(_loc6_ in _loc5_.route)
            {
               _loc7_ = uint(_loc6_.@id);
               if(_loc7_ > 0)
               {
                  _loc3_.add(_loc7_,{
                     "sourceId":uint(_loc6_.@sourceId),
                     "officialIdOverride":routeFlag(_loc6_.@officialIdOverride),
                     "fight":routeFlag(_loc6_.@fight),
                     "normal":routeFlag(_loc6_.@normal),
                     "demo":routeFlag(_loc6_.@demo),
                     "icon":routeFlag(_loc6_.@icon),
                     "presentation":String(_loc6_.@presentation),
                     "iconPresentation":String(_loc6_.@iconPresentation)
                  });
               }
            }
            settleLauncherRouteManifest(param2,_loc3_,_loc4_);
         }
         catch(error:Error)
         {
            settleLauncherRouteManifest(param2,null);
         }
      }
      
      private static function onLauncherRouteManifestError(param1:Event, param2:uint) : void
      {
         settleLauncherRouteManifest(param2,null);
      }
      
      private static function routeFlag(param1:*) : Boolean
      {
         var _loc2_:String = String(param1).toLowerCase();
         return _loc2_ == "1" || _loc2_ == "true";
      }
      
      private static function settleLauncherRouteManifest(param1:uint, param2:HashMap, param3:uint = 0) : void
      {
         if(param1 != _launcherRouteSerial || _launcherRoutesSettled)
         {
            return;
         }
         _launcherRouteMap = param2 == null ? new HashMap() : param2;
         _launcherRouteRevision = param3;
         _launcherRoutesSettled = true;
         clearLauncherRouteLoader();
         completeDataLoadIfReady();
      }
      
      private static function clearLauncherRouteLoader() : void
      {
         if(_launcherRouteTimeout != 0)
         {
            clearTimeout(_launcherRouteTimeout);
            _launcherRouteTimeout = 0;
         }
         if(_launcherRouteLoader != null)
         {
            if(_launcherRouteCompleteHandler != null)
            {
               _launcherRouteLoader.removeEventListener(Event.COMPLETE,_launcherRouteCompleteHandler);
            }
            if(_launcherRouteErrorHandler != null)
            {
               _launcherRouteLoader.removeEventListener(IOErrorEvent.IO_ERROR,_launcherRouteErrorHandler);
               _launcherRouteLoader.removeEventListener(SecurityErrorEvent.SECURITY_ERROR,_launcherRouteErrorHandler);
            }
            try
            {
               _launcherRouteLoader.close();
            }
            catch(error:Error)
            {
            }
         }
         _launcherRouteLoader = null;
         _launcherRouteCompleteHandler = null;
         _launcherRouteErrorHandler = null;
      }
      
      private static function completeDataLoadIfReady() : void
      {
         if(!_serverDataSettled || !_launcherRoutesSettled)
         {
            return;
         }
         if(_onGetGiftStatus != null)
         {
            _onGetGiftStatus();
            _onGetGiftStatus = null;
         }
         if(_onGetPetDictionary != null)
         {
            _onGetPetDictionary();
            _onGetPetDictionary = null;
         }
         if(_onGetRewardStatus != null)
         {
            _onGetRewardStatus();
            _onGetRewardStatus = null;
         }
      }
      
      private static function onGetGiftStatus(param1:MessageEvent) : void
      {
         var _loc2_:uint = 0;
         var _loc3_:int = 0;
         Connection.removeCommandListener(CommandSet.GET_GIFT_CANGET_1124,onGetGiftStatus);
         var _loc4_:ByteArray = param1.message.getRawDataCopy();
         var _loc5_:uint = _loc4_.readUnsignedInt();
         var _loc6_:Vector.<TrainRewardInfo> = PetDictionaryConfig.trainRewardVec;
         var _loc7_:int = 0;
         while(_loc7_ < _loc5_)
         {
            _loc2_ = _loc4_.readUnsignedInt();
            _loc3_ = 0;
            while(_loc3_ < _loc6_.length)
            {
               if(_loc6_[_loc3_].index == _loc2_)
               {
                  _loc6_[_loc3_].status = 1;
               }
               _loc3_++;
            }
            _loc7_++;
         }
         OnlyFlagManager.RequestFlag(onGetRewardsStatus);
      }
      
      private static function onGetPetDictionary(param1:MessageEvent) : void
      {
         var _loc2_:ByteArray = null;
         var _loc3_:uint = 0;
         var _loc4_:uint = 0;
         Connection.removeCommandListener(CommandSet.PET_GET_DICTIONARY_LIST_1034,onGetPetDictionary);
         _petDictionaryMap = new HashMap();
         _loc2_ = param1.message.getRawDataCopy();
         petGainedNum = _loc2_.readUnsignedInt();
         var _loc5_:uint = _loc2_.readUnsignedInt();
         var _loc6_:int = 0;
         while(_loc6_ < _loc5_)
         {
            _loc3_ = _loc2_.readUnsignedInt();
            _loc4_ = _loc2_.readUnsignedByte();
            _petDictionaryMap.add(_loc3_,_loc4_);
            _loc6_++;
         }
         Connection.addCommandListener(CommandSet.GET_GIFT_CANGET_1124,onGetGiftStatus);
         Connection.send(CommandSet.GET_GIFT_CANGET_1124);
      }
      
      private static function onGetRewardsStatus() : void
      {
         var _loc1_:Vector.<SuitRewardInfo> = null;
         var _loc2_:int = 0;
         var _loc3_:SuitRewardInfo = null;
         var _loc4_:TrainRewardInfo = null;
         var _loc5_:Vector.<int> = PetDictionaryConfig.getAllSuitReward();
         var _loc6_:int = 0;
         while(_loc6_ < _loc5_.length)
         {
            _loc1_ = PetDictionaryConfig.getSuitRewardVec(_loc5_[_loc6_]);
            _loc2_ = 0;
            while(_loc2_ < _loc1_.length)
            {
               _loc3_ = _loc1_[_loc2_];
               _loc3_.flag = OnlyFlagManager.getFlag(_loc3_.onlyFlagIndex);
               _loc2_++;
            }
            _loc6_++;
         }
         PetDictionaryConfig.initPetRewardInfo.flag = OnlyFlagManager.getFlag(PetDictionaryConfig.initPetRewardInfo.onlyFlagIndex);
         PetDictionaryConfig.thirdPetRewardInfo.flag = OnlyFlagManager.getFlag(PetDictionaryConfig.thirdPetRewardInfo.onlyFlagIndex);
         var _loc7_:Vector.<TrainRewardInfo> = new Vector.<TrainRewardInfo>();
         var _loc8_:int = 0;
         while(_loc8_ < PetDictionaryConfig.trainRewardVec.length)
         {
            _loc4_ = PetDictionaryConfig.trainRewardVec[_loc8_];
            _loc4_.flag = OnlyFlagManager.getFlag(_loc4_.onlyFlagIndex);
            _loc7_.push(_loc4_);
            _loc8_++;
         }
         _serverDataSettled = true;
         completeDataLoadIfReady();
      }
      
      public static function getRewardByIndex(param1:int, param2:Function) : void
      {
         _onGetReward = param2;
         Connection.addCommandListener(CommandSet.GET_REWARDS_HANDBOOK_1036,onGetRewards);
         Connection.send(CommandSet.GET_REWARDS_HANDBOOK_1036,param1);
      }
      
      private static function onGetRewards(param1:MessageEvent) : void
      {
         var _loc2_:uint = 0;
         var _loc3_:uint = 0;
         var _loc4_:uint = 0;
         var _loc5_:uint = 0;
         Connection.removeCommandListener(CommandSet.GET_REWARDS_HANDBOOK_1036,onGetRewards);
         if(_onGetReward != null)
         {
            _onGetReward();
            _onGetReward = null;
         }
         var _loc6_:ByteArray = param1.message.getRawDataCopy();
         var _loc7_:uint = _loc6_.readUnsignedInt();
         var _loc8_:int = 0;
         while(_loc8_ < _loc7_)
         {
            _loc2_ = _loc6_.readUnsignedInt();
            _loc3_ = _loc6_.readUnsignedInt();
            ItemManager.addItem(_loc2_,_loc3_,0);
            AlertManager.showItemGainedAlert(_loc2_,_loc3_);
            _loc8_++;
         }
         var _loc9_:uint = _loc6_.readUnsignedInt();
         var _loc10_:int = 0;
         while(_loc10_ < _loc9_)
         {
            _loc4_ = _loc6_.readUnsignedInt();
            _loc5_ = _loc6_.readUnsignedInt();
            PetInfoManager.requestAddToBagFromStorage(_loc5_,_loc4_);
            _loc10_++;
         }
      }
      
      public static function getPetListByPageIndex(param1:uint) : Vector.<int>
      {
         var _loc2_:int = (param1 - 1) * 12 + 1;
         var _loc3_:Vector.<int> = new Vector.<int>();
         var _loc4_:* = _loc2_;
         while(_loc4_ < _loc2_ + 12)
         {
            _loc3_.push(_loc4_);
            _loc4_++;
         }
         return _loc3_;
      }
      
      public static function getPetFlag(param1:int) : int
      {
         if(Boolean(_petDictionaryMap) && Boolean(_petDictionaryMap.containsKey(param1)))
         {
            return _petDictionaryMap.getValue(param1);
         }
         return 0;
      }
      
      private static function isExternalDefinition(param1:PetDefinition) : Boolean
      {
         return param1 != null && (param1.foundPlace == "启动器本地导入" || param1.chara == "自定义资源");
      }
      
      private static function isLegacyVariantDefinition(param1:PetDefinition) : Boolean
      {
         return param1 != null && param1.foundPlace == "???" && param1.chara != null && param1.chara.indexOf("作者：") == 0;
      }
      
      private static function resolveResourceIdentity(param1:int) : Object
      {
         var _loc2_:PetDefinition = PetConfig.getPetDefinition(param1);
         var _loc3_:int = 0;
         var _loc4_:int = param1;
         var _loc5_:String = RESOURCE_ROLE_BODY;
         if(_loc2_ == null)
         {
            return {
               "resourceID":param1,
               "baseID":_loc4_,
               "role":_loc5_
            };
         }
         if(isExternalDefinition(_loc2_))
         {
            _loc5_ = RESOURCE_ROLE_EXTERNAL_SKIN;
         }
         else if(_loc2_.realId > 0 && _loc2_.realId != param1 && PetConfig.getPetDefinition(_loc2_.realId) != null)
         {
            _loc4_ = int(_loc2_.realId);
            _loc5_ = RESOURCE_ROLE_OFFICIAL_SKIN;
         }
         else if(isLegacyVariantDefinition(_loc2_))
         {
            _loc3_ = param1;
            while(_loc3_ > LEGACY_VARIANT_NAMESPACE)
            {
               _loc3_ -= LEGACY_VARIANT_NAMESPACE;
               if(_loc3_ > 0 && PetConfig.getPetDefinition(_loc3_) != null)
               {
                  _loc4_ = _loc3_;
               }
            }
            if(_loc4_ != param1)
            {
               _loc5_ = RESOURCE_ROLE_OFFICIAL_SKIN;
            }
         }
         return {
            "resourceID":param1,
            "baseID":_loc4_,
            "role":_loc5_
         };
      }
      
      public static function getNormalizedResourceRole(param1:int) : String
      {
         return String(resolveResourceIdentity(param1).role);
      }
      
      public static function getNormalizedBaseResourceId(param1:int) : int
      {
         return int(resolveResourceIdentity(param1).baseID);
      }
      
      public static function isSkinResource(param1:int) : Boolean
      {
         return getNormalizedResourceRole(param1) != RESOURCE_ROLE_BODY;
      }
      
      public static function usesExternalModelIcon(param1:int) : Boolean
      {
         return getNormalizedResourceRole(param1) == RESOURCE_ROLE_EXTERNAL_SKIN;
      }
      
      public static function usesFightSnapshotIcon(param1:int) : Boolean
      {
         var _loc2_:Object = null;
         var _loc3_:String = null;
         var _loc4_:String = null;
         if(getNormalizedResourceRole(param1) != RESOURCE_ROLE_EXTERNAL_SKIN)
         {
            return false;
         }
         if(!hasLauncherRoute(param1,"icon"))
         {
            return true;
         }
         _loc2_ = _launcherRouteMap.getValue(param1);
         _loc3_ = _loc2_ == null ? "" : String(_loc2_.iconPresentation).toLowerCase();
         _loc4_ = _loc2_ == null ? "" : String(_loc2_.presentation).toLowerCase();
         return _loc3_ == "frozen-avatar" || _loc3_ == "fight" || _loc3_ == "model" || _loc4_ == "frozen-avatar";
      }
      
      public static function getPetIconUrl(param1:int) : String
      {
         var _loc2_:String = null;
         if(getNormalizedResourceRole(param1) == RESOURCE_ROLE_EXTERNAL_SKIN && hasLauncherRoute(param1,"icon"))
         {
            return getLauncherResourceUrl(param1,"icon");
         }
         _loc2_ = URLUtil.getPetIcon(param1);
         if(getNormalizedResourceRole(param1) != RESOURCE_ROLE_EXTERNAL_SKIN && _launcherRouteRevision > 0)
         {
            return _loc2_ + (_loc2_.indexOf("?") >= 0 ? "&" : "?") + "launcherRouteRevision=" + _launcherRouteRevision;
         }
         return _loc2_;
      }
      
      public static function isOfficialIdOverride(param1:int) : Boolean
      {
         return hasLauncherRoute(param1,"officialIdOverride");
      }
      
      public static function getPetAvatarFallbackModelUrl(param1:int) : String
      {
         if(hasLauncherRoute(param1,"fight"))
         {
            return getLauncherResourceUrl(param1,"fight");
         }
         if(hasLauncherRoute(param1,"normal"))
         {
            return getLauncherResourceUrl(param1,"normal");
         }
         if(hasLauncherRoute(param1,"demo"))
         {
            return getLauncherResourceUrl(param1,"demo");
         }
         return null;
      }
      
      public static function getPetDemoUrl(param1:int) : String
      {
         if(hasLauncherRoute(param1,"demo"))
         {
            return getLauncherResourceUrl(param1,"demo");
         }
         return URLUtil.getPetOriginDemo(param1);
      }
      
      public static function getLauncherRouteRevision() : uint
      {
         return _launcherRouteRevision;
      }
      
      private static function hasLauncherRoute(param1:int, param2:String) : Boolean
      {
         if(param1 <= 0 || _launcherRouteMap == null || !_launcherRouteMap.containsKey(param1))
         {
            return false;
         }
         var _loc3_:Object = _launcherRouteMap.getValue(param1);
         return _loc3_ != null && _loc3_[param2] === true;
      }
      
      private static function getLauncherResourceUrl(param1:int, param2:String) : String
      {
         return URLUtil.rewrite(ClientConfig.rootURL + "res/pet/" + param2 + "/" + param1 + ".swf");
      }
      
      public static function getAllPets() : Vector.<int>
      {
         var _loc1_:PetDefinition = null;
         var _loc2_:PetDictionaryInfo = null;
         var _loc3_:Vector.<int> = new Vector.<int>();
         var _loc4_:Vector.<int> = (PetConfig as Object)["getPetDefinitionResourceIds"]();
         var _loc5_:int = 0;
         _loc3_.push(0);
         var _loc6_:int = 0;
         while(_loc6_ < _loc4_.length)
         {
            _loc5_ = _loc4_[_loc6_];
            _loc1_ = PetConfig.getPetDefinition(_loc5_);
            _loc2_ = PetConfig.getPetDefinitionInfo(_loc5_);
            if(Boolean(_loc2_) && Boolean(_loc1_) && !isSkinResource(_loc5_))
            {
               _loc3_.push(_loc5_);
            }
            _loc6_++;
         }
         return _loc3_;
      }
      
      public static function getAllSkins() : Vector.<int>
      {
         var _loc1_:PetDefinition = null;
         var _loc2_:PetDictionaryInfo = null;
         var _loc3_:Vector.<int> = new Vector.<int>();
         var _loc4_:Vector.<int> = (PetConfig as Object)["getPetDefinitionResourceIds"]();
         var _loc5_:int = 0;
         _loc3_.push(0);
         var _loc6_:int = 0;
         while(_loc6_ < _loc4_.length)
         {
            _loc5_ = _loc4_[_loc6_];
            _loc1_ = PetConfig.getPetDefinition(_loc5_);
            _loc2_ = PetConfig.getPetDefinitionInfo(_loc5_);
            if(Boolean(_loc2_) && Boolean(_loc1_) && isSkinResource(_loc5_))
            {
               _loc3_.push(_loc5_);
            }
            _loc6_++;
         }
         return _loc3_;
      }
      
      public static function getGainedPets() : Vector.<int>
      {
         var _loc1_:Vector.<int> = new Vector.<int>();
         var _loc2_:Vector.<int> = (PetConfig as Object)["getPetDefinitionResourceIds"]();
         var _loc3_:int = 0;
         _loc1_.push(0);
         var _loc4_:int = 0;
         while(_loc4_ < _loc2_.length)
         {
            _loc3_ = _loc2_[_loc4_];
            if(getPetFlag(_loc3_) == 2 && !isSkinResource(_loc3_))
            {
               _loc1_.push(_loc3_);
            }
            _loc4_++;
         }
         return _loc1_;
      }
      
      public static function getNotGainedPets() : Vector.<int>
      {
         var _loc1_:Vector.<int> = new Vector.<int>();
         _loc1_.push(0);
         var _loc2_:PetDefinition = null;
         var _loc3_:PetDictionaryInfo = null;
         var _loc4_:Vector.<int> = (PetConfig as Object)["getPetDefinitionResourceIds"]();
         var _loc5_:int = 0;
         var _loc6_:int = 0;
         while(_loc6_ < _loc4_.length)
         {
            _loc5_ = _loc4_[_loc6_];
            if(getPetFlag(_loc5_) != 2 && !isSkinResource(_loc5_))
            {
               _loc2_ = PetConfig.getPetDefinition(_loc5_);
               _loc3_ = PetConfig.getPetDefinitionInfo(_loc5_);
               if(Boolean(_loc3_) && Boolean(_loc2_))
               {
                  _loc1_.push(_loc5_);
               }
            }
            _loc6_++;
         }
         return _loc1_;
      }
      
      public static function getPetsByLevel(param1:int) : Vector.<int>
      {
         var _loc2_:Vector.<int> = new Vector.<int>();
         var _loc3_:Vector.<int> = (PetConfig as Object)["getPetDefinitionResourceIds"]();
         var _loc4_:int = 0;
         var _loc5_:PetDefinition = null;
         _loc2_.push(0);
         var _loc6_:int = 0;
         while(_loc6_ < _loc3_.length)
         {
            _loc4_ = _loc3_[_loc6_];
            _loc5_ = PetConfig.getPetDefinition(_loc4_);
            if(Boolean(_loc5_) && Boolean(PetConfig.getPetDefinitionInfo(_loc4_)) && _loc5_.starLevel == param1 && !isSkinResource(_loc4_))
            {
               _loc2_.push(_loc4_);
            }
            _loc6_++;
         }
         return _loc2_;
      }
      
      public static function getthisWeekGained() : Vector.<int>
      {
         var _loc1_:Vector.<int> = new Vector.<int>();
         _loc1_.push(0);
         var _loc2_:int = 0;
         while(_loc2_ < thisWeekPets.length)
         {
            if(getPetFlag(thisWeekPets[_loc2_]) == 2)
            {
               _loc1_.push(thisWeekPets[_loc2_]);
            }
            _loc2_++;
         }
         return _loc1_;
      }
      
      public static function getthisWeekNotGained() : Vector.<int>
      {
         var _loc1_:Vector.<int> = new Vector.<int>();
         var _loc2_:int = 0;
         while(_loc2_ < thisWeekPets.length)
         {
            if(getPetFlag(thisWeekPets[_loc2_]) != 2)
            {
               _loc1_.push(thisWeekPets[_loc2_]);
            }
            _loc2_++;
         }
         return _loc1_;
      }
      
      public static function getPageData(param1:Vector.<int>, param2:int) : Vector.<int>
      {
         var _loc3_:int = (param2 - 1) * 12 + 1;
         var _loc4_:Vector.<int> = new Vector.<int>();
         var _loc5_:* = _loc3_;
         while(_loc5_ < _loc3_ + 12)
         {
            _loc4_.push(param1[_loc5_]);
            _loc5_++;
         }
         return _loc4_;
      }
   }
}

