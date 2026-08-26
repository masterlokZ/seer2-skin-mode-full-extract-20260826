package com.taomee.seer2.module.app.versionOnePetBagPanel
{
   import com.taomee.seer2.app.actor.ActorManager;
   import com.taomee.seer2.app.event.LogicEvent;
   import com.taomee.seer2.app.manager.StatisticsManager;
   import com.taomee.seer2.app.net.CommandSet;
   import com.taomee.seer2.app.net.Connection;
   import com.taomee.seer2.app.pet.data.PetInfo;
   import com.taomee.seer2.app.pet.data.PetInfoManager;
   import com.taomee.seer2.app.pet.events.PetInfoEvent;
   import com.taomee.seer2.app.processor.quest.handler.main.quest99.QuestMapHandler_99_80491;
   import com.taomee.seer2.app.quest.QuestManager;
   import com.taomee.seer2.app.serverBuffer.ServerBuffer;
   import com.taomee.seer2.app.serverBuffer.ServerBufferManager;
   import com.taomee.seer2.app.vip.VipManager;
   import com.taomee.seer2.core.module.ModuleManager;
   import com.taomee.seer2.core.net.MessageEvent;
   import com.taomee.seer2.core.scene.events.ModelLocator;
   import com.taomee.seer2.core.utils.URLUtil;
   import com.taomee.seer2.module.app.petBag.event.PetBagEvent;
   import com.taomee.seer2.module.app.versionOnePetBagPanel.util.PetCell;
   import flash.display.MovieClip;
   import flash.display.SimpleButton;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   
   public class PetListPanel extends Sprite
   {
      
      private const MAX_NUM:int = 12;
      
      private var _mainUI:MovieClip;
      
      private var _goBlood:SimpleButton;
      
      private var _goVipStore:SimpleButton;
      
      private var _newGuideMc:MovieClip;
      
      private var _newGuideMc1:MovieClip;
      
      private var _petCellVec:Vector.<PetCell>;
      
      private var _petInfoVec:Vector.<PetInfo>;
      
      private var _selectedPetInfo:PetInfo;
      
      public function PetListPanel()
      {
         super();
         this.initSet();
         this.initEvent();
      }
      
      private function initSet() : void
      {
         var _loc1_:PetCell = null;
         this._mainUI = new PetListUI();
         this.addChild(this._mainUI);
         this._goBlood = this._mainUI["goBlood"];
         this._goVipStore = this._mainUI["goVipStore"];
         this._newGuideMc = this._mainUI["newGuideMc"];
         this._newGuideMc.visible = false;
         this._newGuideMc1 = this._mainUI["newGuideMc1"];
         this._newGuideMc1.visible = false;
         this._petCellVec = new Vector.<PetCell>();
         var _loc2_:int = 0;
         while(_loc2_ < 12)
         {
            if(_loc2_ <= 5)
            {
               if(_loc2_ == 0)
               {
                  _loc1_ = new PetCell(new PetCellResUI(),false,"first");
               }
               else
               {
                  _loc1_ = new PetCell(new PetCellResUI(),false,"fight");
               }
            }
            else
            {
               _loc1_ = new PetCell(new PetCellResUI(),false,"select");
               if(VipManager.vipInfo.level >= _loc2_ - 6 && VipManager.vipInfo.leftDay > 0 || _loc2_ <= 6)
               {
                  _loc1_.openStateMC.visible = false;
               }
               else
               {
                  _loc1_.openStateMC.visible = true;
                  _loc1_.openStateMC.gotoAndStop(_loc2_ - 6);
               }
            }
            if(_loc2_ <= 5)
            {
               _loc1_.scaleX = _loc1_.scaleY = 0.95;
               if(_loc2_ % 2 == 0)
               {
                  _loc1_.x = 21;
               }
               else
               {
                  _loc1_.x = 114;
               }
               _loc1_.y = 24 + (Math.ceil((_loc2_ + 1) / 2) - 1) * 93;
            }
            else
            {
               _loc1_.scaleX = _loc1_.scaleY = 0.65;
               if(_loc2_ % 3 == 0)
               {
                  _loc1_.x = 20;
               }
               else if(_loc2_ % 3 == 1)
               {
                  _loc1_.x = 79.8;
               }
               else
               {
                  _loc1_.x = 139.6;
               }
               _loc1_.y = 305 + (Math.ceil((_loc2_ - 5) / 3) - 1) * 59;
            }
            this._mainUI.addChild(_loc1_);
            this._petCellVec.push(_loc1_);
            _loc2_++;
         }
      }
      
      private function initEvent() : void
      {
         this._goBlood.addEventListener("click",this.onGoBlood);
         this._goVipStore.addEventListener("click",this.onGoVipStore);
      }
      
      private function onGoBlood(param1:MouseEvent) : void
      {
         var _loc2_:int = 0;
         var _loc3_:* = null;
         var _loc4_:* = null;
         this.recoverAllPetBagPet();
      }
      
      private function onGoVipStore(param1:MouseEvent) : void
      {
         var evt:MouseEvent = param1;
         StatisticsManager.sendNovice("0x10033867");
         ModuleManager.closeForName("NewPetBagPanel");
         ModuleManager.closeForName("PetBagPanel");
         ServerBufferManager.getServerBuffer(461,function(param1:ServerBuffer):void
         {
            var _loc2_:Boolean = Boolean(param1.readDataAtPostion(8));
            if(_loc2_)
            {
               ModuleManager.showModule(URLUtil.getAppModule("NewPetStoragePanel"),"正在打开...");
            }
            else
            {
               ModuleManager.showModule(URLUtil.getAppModule("PetStoragePanel"),"正在打开...");
            }
         });
      }
      
      private function addPetInfoEventListener() : void
      {
         PetInfoManager.addEventListener("petPropertiesChange",this.onPetPropetiesChange);
      }
      
      private function removePetInfoEventListener() : void
      {
         PetInfoManager.removeEventListener("petPropertiesChange",this.onPetPropetiesChange);
      }
      
      private function onPetPropetiesChange(param1:PetInfoEvent) : void
      {
         var _loc2_:PetCell = null;
         var _loc3_:uint = 0;
         while(_loc3_ < this._petCellVec.length)
         {
            _loc2_ = this._petCellVec[_loc3_];
            if(_loc2_.petInfo == param1.info)
            {
               _loc2_.setPetInfo(param1.info);
               this._petInfoVec[_loc3_] = param1.info;
               break;
            }
            _loc3_++;
         }
      }
      
      private function sortPetInfoVec() : void
      {
         var _loc1_:PetInfo = null;
         var _loc2_:int = int(this._petInfoVec.length);
         var _loc3_:int = 0;
         while(_loc3_ < _loc2_)
         {
            _loc1_ = this._petInfoVec[_loc3_];
            if(Boolean(_loc1_) && Boolean(_loc1_.isStarting))
            {
               this._petInfoVec.splice(_loc3_,1);
               this._petInfoVec.unshift(_loc1_);
               break;
            }
            _loc3_++;
         }
      }
      
      private function addCellEventListener(param1:PetCell) : void
      {
         param1.buttonMode = true;
         param1.addEventListener("click",this.onCellClick);
      }
      
      private function removeCellEventListener(param1:PetCell) : void
      {
         param1.buttonMode = false;
         param1.removeEventListener("click",this.onCellClick);
      }
      
      private function onCellClick(param1:MouseEvent) : void
      {
         var _loc2_:PetCell = param1.currentTarget as PetCell;
         var _loc3_:PetInfo = _loc2_.petInfo;
         if(this._selectedPetInfo.catchTime != _loc3_.catchTime)
         {
            this.selectedPetInfo = _loc3_;
         }
      }
      
      private function clearAllCellEventListener() : void
      {
         var _loc1_:PetCell = null;
         for each(_loc1_ in this._petCellVec)
         {
            this.removeCellEventListener(_loc1_);
         }
      }
      
      private function updatePetCell() : void
      {
         var _loc1_:PetCell = null;
         var _loc2_:PetInfo = null;
         var _loc3_:uint = 0;
         while(_loc3_ < 12)
         {
            _loc1_ = this._petCellVec[_loc3_];
            if(_loc3_ < this._petInfoVec.length)
            {
               _loc2_ = this._petInfoVec[_loc3_];
               this.addCellEventListener(_loc1_);
               _loc1_.setPetInfo(_loc2_);
            }
            else
            {
               _loc1_.setPetInfo(null);
            }
            _loc3_++;
         }
      }
      
      private function selectPetCell() : void
      {
         if(this._petInfoVec.length == 0)
         {
            return;
         }
         this.selectedPetInfo = this._petInfoVec[0];
      }
      
      private function set selectedPetInfo(param1:PetInfo) : void
      {
         var _loc2_:PetCell = null;
         var _loc3_:PetInfo = null;
         this._selectedPetInfo = param1;
         var _loc4_:int = 0;
         while(_loc4_ < 12)
         {
            _loc2_ = this._petCellVec[_loc4_];
            _loc3_ = _loc2_.petInfo;
            if(Boolean(_loc3_) && _loc3_.catchTime == this._selectedPetInfo.catchTime)
            {
               _loc2_.selected = true;
            }
            else
            {
               _loc2_.selected = false;
            }
            _loc4_++;
         }
         dispatchEvent(new PetBagEvent("petSelected",this._selectedPetInfo));
      }
      
      public function setData(param1:Vector.<PetInfo>, param2:Vector.<PetInfo>) : void
      {
         this._petInfoVec = Vector.<PetInfo>([null,null,null,null,null,null,null,null,null,null,null,null]);
         var _loc3_:Boolean = false;
         var _loc4_:int = 0;
         while(_loc4_ < 6)
         {
            if(param1.length - 1 >= _loc4_)
            {
               this._petInfoVec[_loc4_] = param1[_loc4_];
               _loc3_ = true;
            }
            _loc4_++;
         }
         _loc4_ = 6;
         while(_loc4_ < 12)
         {
            if(Boolean(param2) && param2.length - 1 >= _loc4_ - 6)
            {
               this._petInfoVec[_loc4_] = param2[_loc4_ - 6];
               _loc3_ = true;
            }
            _loc4_++;
         }
         if(_loc3_)
         {
            this.addPetInfoEventListener();
         }
         this.sortPetInfoVec();
         this.updateDisplay();
         this.selectPetCell();
      }
      
      public function updateDisplay() : void
      {
         this.clearAllCellEventListener();
         this.updatePetCell();
         this.updateGuide();
         this.updateGuide1();
      }
      
      private function updateGuide() : void
      {
         this._newGuideMc.visible = false;
         if(Boolean(QuestManager.isAccepted(99)) && !QuestManager.isStepComplete(99,3) && Boolean(QuestMapHandler_99_80491.isClickQuest99_3))
         {
            this._newGuideMc.visible = true;
            this._mainUI.addChild(this._newGuideMc);
            this._newGuideMc.removeEventListener("click",this.onGuideClick);
            this._newGuideMc.addEventListener("click",this.onGuideClick);
         }
      }
      
      private function updateGuide1() : void
      {
         this._newGuideMc1.visible = false;
         if(Boolean(QuestManager.isAccepted(99)) && !QuestManager.isStepComplete(99,6) && Boolean(QuestMapHandler_99_80491.isClickQuest99_6))
         {
            this._newGuideMc1.visible = true;
            this._mainUI.addChild(this._newGuideMc1);
            this._newGuideMc1.removeEventListener("click",this.onGuideClick1);
            this._newGuideMc1.addEventListener("click",this.onGuideClick1);
         }
      }
      
      private function onGuideClick(param1:MouseEvent) : void
      {
         this._newGuideMc.removeEventListener("click",this.onGuideClick);
         this._newGuideMc.visible = false;
         var _loc2_:PetInfo = this.getPetInfoById(7);
         if(Boolean(_loc2_))
         {
            this.selectedPetInfo = _loc2_;
            ModelLocator.getInstance().dispatchEvent(new LogicEvent("newGuideBroad2"));
         }
      }
      
      private function onGuideClick1(param1:MouseEvent) : void
      {
         this._newGuideMc1.removeEventListener("click",this.onGuideClick1);
         this._newGuideMc1.visible = false;
         var _loc2_:PetInfo = this.getPetInfoById(824);
         if(Boolean(_loc2_))
         {
            this.selectedPetInfo = _loc2_;
            ModelLocator.getInstance().dispatchEvent(new LogicEvent("newGuideBroad7"));
         }
      }
      
      private function getPetInfoById(param1:int) : PetInfo
      {
         var _loc2_:PetInfo = null;
         var _loc3_:PetInfo = null;
         for each(_loc2_ in PetInfoManager.getAllBagPetInfo())
         {
            if(_loc2_.resourceId == param1)
            {
               _loc3_ = _loc2_;
               break;
            }
         }
         return _loc3_;
      }
      
      public function reset() : void
      {
         var _loc1_:int = int(this._petCellVec.length);
         var _loc2_:int = 0;
         while(_loc2_ < _loc1_)
         {
            this._petCellVec[_loc2_].reset();
            _loc2_++;
         }
         this.removePetInfoEventListener();
      }
      
      private function recoverAllPetBagPet() : void
      {
         Connection.addCommandListener(CommandSet.TREAT_ALL_PET_1215,this.onAddAllPetBlood);
         Connection.send(CommandSet.TREAT_ALL_PET_1215);
      }
      
      private function onAddAllPetBlood(param1:MessageEvent) : void
      {
         var _loc2_:PetInfo = null;
         var _loc3_:int = 0;
         Connection.removeCommandListener(CommandSet.TREAT_ALL_PET_1215,this.onAddAllPetBlood);
         var _loc4_:Vector.<PetInfo> = PetInfoManager.getAllBagPetInfo();
         for each(_loc2_ in _loc4_)
         {
            _loc2_.hp = _loc2_.maxHp;
            PetInfoManager.dispatchEvent("petPropertiesChange",_loc2_);
         }
         _loc3_ = int(param1.message.getRawData().readUnsignedInt());
         ActorManager.actorInfo.coins = _loc3_;
      }
   }
}

