package com.taomee.seer2.module.app.petDictionary.collectReward
{
   import com.taomee.seer2.app.actor.ActorManager;
   import com.taomee.seer2.app.actor.data.UserInfo;
   import com.taomee.seer2.app.actor.preview.ActorPreview;
   import com.taomee.seer2.app.actor.util.ActorEquipAssembler;
   import com.taomee.seer2.app.inventory.item.EquipItem;
   import com.taomee.seer2.module.app.petDictionary.config.PetDictionaryConfig;
   import com.taomee.seer2.module.app.petDictionary.config.configInfo.SuitInfo;
   import com.taomee.seer2.module.app.petDictionary.config.configInfo.SuitRewardInfo;
   import com.taomee.seer2.module.app.petDictionary.data.PetDictionaryDataServer;
   import com.taomee.seer2.module.app.petDictionary.event.PetDictionaryEvent;
   import com.taomee.seer2.module.app.petDictionary.suitCollectePanelUI;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.text.TextField;
   
   public class SuitCollectPanel extends Sprite
   {
      
      private var _suitVec:Vector.<SuitRewardInfo>;
      
      private var _suitCellVec:Vector.<SuitCollectCell>;
      
      private var _actorPreview:ActorPreview;
      
      private var _suitNameTxt:TextField;
      
      private var _newMC:MovieClip;
      
      public function SuitCollectPanel()
      {
         super();
         this.createChildren();
         this.createActorPreview();
      }
      
      public function get newMc() : MovieClip
      {
         return this._newMC;
      }
      
      private function createChildren() : void
      {
         var _loc1_:int = 0;
         var _loc2_:SuitCollectCell = null;
         var _loc3_:suitCollectePanelUI = new suitCollectePanelUI();
         _loc3_.x = 52;
         _loc3_.y = 107;
         addChild(_loc3_);
         this._suitNameTxt = _loc3_["nameTxt"];
         this._newMC = _loc3_["newMc"];
         this._newMC.visible = false;
         this._suitCellVec = new Vector.<SuitCollectCell>();
         _loc1_ = 0;
         while(_loc1_ < 5)
         {
            _loc2_ = new SuitCollectCell();
            _loc2_.x = 302;
            _loc2_.y = 82 + 70 * _loc1_;
            addChild(_loc2_);
            this._suitCellVec.push(_loc2_);
            _loc1_++;
         }
      }
      
      private function createActorPreview() : void
      {
         this._actorPreview = new ActorPreview();
         this._actorPreview.scaleX = this._actorPreview.scaleY = 0.8;
         this._actorPreview.x = 155;
         this._actorPreview.y = 340;
         addChild(this._actorPreview);
      }
      
      private function updateActorPreview(param1:Vector.<int>) : void
      {
         var _loc2_:UserInfo = null;
         var _loc3_:uint = 0;
         var _loc4_:EquipItem = null;
         _loc2_ = new UserInfo();
         _loc2_.color = ActorManager.actorInfo.color;
         _loc2_.equipVec = new Vector.<EquipItem>();
         for each(_loc3_ in param1)
         {
            _loc4_ = new EquipItem(_loc3_);
            _loc2_.equipVec.push(_loc4_);
         }
         ActorEquipAssembler.mergeDefaultEquip(_loc2_.color,_loc2_.equipVec);
         this._actorPreview.setData(_loc2_);
      }
      
      public function setData(param1:int) : void
      {
         var _loc2_:int = 0;
         this._suitVec = PetDictionaryConfig.getSuitRewardVec(param1);
         var _loc3_:SuitInfo = PetDictionaryConfig.getSuitInfo(param1);
         this.updateActorPreview(_loc3_.suitVec);
         this._suitNameTxt.text = _loc3_.suitName;
         _loc2_ = 0;
         while(_loc2_ < this._suitVec.length)
         {
            this._suitCellVec[_loc2_].setData(this._suitVec[_loc2_]);
            _loc2_++;
         }
      }
      
      public function updateShine(param1:Vector.<int>) : void
      {
         var _loc2_:Vector.<SuitRewardInfo> = null;
         var _loc3_:uint = 0;
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         var _loc6_:int = 0;
         var _loc7_:int = 0;
         _loc3_ = 0;
         loop0:
         while(_loc3_ < param1.length)
         {
            _loc2_ = PetDictionaryConfig.getSuitRewardVec(param1[_loc3_]);
            _loc4_ = 0;
            while(_loc4_ < _loc2_.length)
            {
               _loc7_ = 0;
               _loc5_ = 0;
               while(_loc5_ < 3)
               {
                  _loc6_ = _loc2_[_loc4_].neePetIconVec[_loc5_];
                  if(PetDictionaryDataServer.getPetFlag(_loc6_) == 2)
                  {
                     _loc7_++;
                  }
                  _loc5_++;
               }
               if(_loc7_ >= 3 && _loc2_[_loc4_].flag != 1)
               {
                  dispatchEvent(new PetDictionaryEvent("collectPetShine"));
                  break loop0;
               }
               _loc4_++;
            }
            _loc3_++;
         }
      }
      
      public function updata() : void
      {
         var _loc1_:int = 0;
         _loc1_ = 0;
         while(_loc1_ < this._suitCellVec.length)
         {
            this._suitCellVec[_loc1_].updata();
            _loc1_++;
         }
      }
   }
}

