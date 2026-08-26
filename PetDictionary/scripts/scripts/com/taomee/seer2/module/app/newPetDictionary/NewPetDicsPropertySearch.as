package com.taomee.seer2.module.app.newPetDictionary
{
   import com.taomee.seer2.app.arena.util.SkillFieldTable;
   import com.taomee.seer2.app.config.NewPetDicThisWeekListConfig;
   import com.taomee.seer2.app.config.PetConfig;
   import com.taomee.seer2.app.config.pet.PetDefinition;
   import com.taomee.seer2.core.ui.toolTip.TooltipManager;
   import com.taomee.seer2.module.app.petDictionary.data.PetDictionaryDataServer;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   
   public class NewPetDicsPropertySearch extends Sprite
   {
      
      private static var _property:int;
      
      private static var _dataOfAll:Array;
      
      private static var _dataOfThisWeek:Array;
      
      public static const CLICK_ITEM:String = "CLICK_ITEM";
      
      private static var _thisWeekPetsID:Vector.<int> = NewPetDicThisWeekListConfig.getPetIDForDic();
      
      private var _mainUI:Sprite;
      
      private var _btnVec:Vector.<MovieClip>;
      
      public function NewPetDicsPropertySearch()
      {
         super();
         this.createChildren();
      }
      
      private static function findDataByPropertyOfAll(param1:int) : void
      {
         var _loc2_:PetDefinition = null;
         var _loc3_:Vector.<int> = null;
         var _loc4_:Vector.<int> = null;
         var _loc5_:int = 0;
         var _loc6_:int = 0;
         if(!_dataOfAll)
         {
            _dataOfAll = [];
         }
         if(param1 == 0)
         {
            _dataOfAll[param1] = PetDictionaryDataServer.getAllPets();
         }
         else
         {
            _loc3_ = new Vector.<int>();
            _loc3_[0] = 0;
            _loc4_ = (PetConfig as Object)["getPetDefinitionResourceIds"]();
            _loc6_ = 0;
            while(_loc6_ < _loc4_.length)
            {
               _loc5_ = _loc4_[_loc6_];
               _loc2_ = PetConfig.getPetDefinition(_loc5_);
               if(Boolean(_loc2_) && Boolean(PetConfig.getPetDefinitionInfo(_loc5_)) && !PetDictionaryDataServer.isSkinResource(_loc5_))
               {
                  if(_loc2_.type == param1)
                  {
                     _loc3_.push(_loc2_.resId);
                  }
               }
               _loc6_++;
            }
            _dataOfAll[param1] = _loc3_;
         }
      }
      
      public static function getDataByPropertyOfAll() : Vector.<int>
      {
         if(Boolean(_dataOfAll) && Boolean(_dataOfAll[_property]))
         {
            return _dataOfAll[_property];
         }
         findDataByPropertyOfAll(_property);
         return _dataOfAll[_property];
      }
      
      private static function findDataByPropertyOfThisWeek(param1:int) : void
      {
         var _loc2_:PetDefinition = null;
         var _loc3_:Vector.<int> = null;
         var _loc4_:int = 0;
         if(!_dataOfThisWeek)
         {
            _dataOfThisWeek = [];
         }
         if(param1 == 0)
         {
            _dataOfThisWeek[param1] = PetDictionaryDataServer.thisWeekPets;
         }
         else
         {
            _loc3_ = new Vector.<int>();
            _loc3_[0] = 0;
            _loc4_ = 0;
            while(_loc4_ < _thisWeekPetsID.length)
            {
               _loc2_ = PetConfig.getPetDefinition(_thisWeekPetsID[_loc4_]);
               if(Boolean(_loc2_) && _loc2_.type == param1)
               {
                  _loc3_.push(_loc2_.resId);
               }
               _loc4_++;
            }
            _dataOfThisWeek[param1] = _loc3_;
         }
      }
      
      public static function getDataByPropertyOfThisWeek() : Vector.<int>
      {
         if(Boolean(_dataOfThisWeek) && Boolean(_dataOfThisWeek[_property]))
         {
            return _dataOfThisWeek[_property];
         }
         findDataByPropertyOfThisWeek(_property);
         return _dataOfThisWeek[_property];
      }
      
      private function createChildren() : void
      {
         var _loc1_:int = 0;
         this._mainUI = new NewPetDicsPropertySearchUI();
         addChild(this._mainUI);
         this._btnVec = new Vector.<MovieClip>();
         _loc1_ = 0;
         while(_loc1_ < 22)
         {
            this._btnVec.push(this._mainUI["btn" + _loc1_]);
            this._btnVec[_loc1_].buttonMode = true;
            if(_loc1_ == 0)
            {
               TooltipManager.addCommonTip(this._btnVec[_loc1_],"全部");
            }
            else
            {
               TooltipManager.addCommonTip(this._btnVec[_loc1_],SkillFieldTable.getTypeName(_loc1_));
            }
            this._btnVec[_loc1_].addEventListener("click",this.onClick);
            _loc1_++;
         }
      }
      
      private function onClick(param1:MouseEvent) : void
      {
         param1.stopPropagation();
         var _loc2_:int = this._btnVec.indexOf(param1.currentTarget as MovieClip);
         if(_loc2_ == 0)
         {
            _property = 0;
         }
         else
         {
            _property = _loc2_;
         }
         dispatchEvent(new Event("CLICK_ITEM"));
      }
   }
}

