package com.taomee.seer2.module.app.versionOnePetBagPanel
{
   import com.greensock.TweenNano;
   import com.taomee.seer2.app.config.PetConfig;
   import com.taomee.seer2.app.config.skill.PetSkillSettingDefinition;
   import com.taomee.seer2.app.controls.MapTitlePanel;
   import com.taomee.seer2.app.inventory.ItemManager;
   import com.taomee.seer2.app.inventory.events.ItemEvent;
   import com.taomee.seer2.app.manager.StatisticsManager;
   import com.taomee.seer2.app.net.Command;
   import com.taomee.seer2.app.net.CommandSet;
   import com.taomee.seer2.app.net.Connection;
   import com.taomee.seer2.app.pet.data.PetInfo;
   import com.taomee.seer2.app.pet.data.PetInfoManager;
   import com.taomee.seer2.app.pet.data.PetItemInfo;
   import com.taomee.seer2.app.pet.events.PetInfoEvent;
   import com.taomee.seer2.app.serverBuffer.ServerBuffer;
   import com.taomee.seer2.app.serverBuffer.ServerBufferManager;
   import com.taomee.seer2.app.utils.PetUtil;
   import com.taomee.seer2.core.module.Module;
   import com.taomee.seer2.core.net.MessageEvent;
   import com.taomee.seer2.core.scene.LayerManager;
   import com.taomee.seer2.module.app.petBag.data.PetBagDataService;
   import com.taomee.seer2.module.app.petBag.event.PetBagEvent;
   import com.taomee.seer2.module.app.versionOnePetBagPanel.petSkillPanel.selectSkillPanel.GraspHideSkillPanel;
   import flash.geom.Point;
   import flash.utils.IDataInput;
   
   public class PetBagPanel extends Module
   {
      
      private var _petDemoPanel:PetDemoPanel;
      
      private var _petListPanel:PetListPanel;
      
      private var _petTabPanel:PetTabPanel;
      
      private var _dataService:PetBagDataService;
      
      private var _currPetInfo:PetInfo;
      
      public function PetBagPanel()
      {
         super();
         _lifecycleType = "global";
      }
      
      override public function setup() : void
      {
         setMainUI(new PetBagBgUI());
         this.initSet();
         this.initEvent();
      }
      
      override public function init(param1:Object) : void
      {
         var type:int = 0;
         var subType:int = 0;
         var data:Object = param1;
         type = 0;
         subType = 0;
         if(Boolean(data))
         {
            type = int(data.type);
            subType = int(data.subType);
            this._petTabPanel.changeTab(type);
            TweenNano.delayedCall(0.1,function():void
            {
               _petTabPanel.changeCurPanelTab(type,subType);
            });
         }
      }
      
      override public function show() : void
      {
         super.show();
         StatisticsManager.sendNovice("0x10033859");
         ItemManager.addEventListener1("requestSpecialItemSuccess",this.onSeer);
         ItemManager.requestSpecialItemList();
      }
      
      override public function hide() : void
      {
         PetInfoManager.removeEventListener("petFightItem",this.petFightItem);
         this._dataService.clearEventListener();
         MapTitlePanel.show();
         super.hide();
         LayerManager.resetOperation();
      }
      
      private function initSet() : void
      {
         this._petDemoPanel = new PetDemoPanel();
         addChild(this._petDemoPanel);
         this._petDemoPanel.x = 284;
         this._petDemoPanel.y = 100;
         this._petListPanel = new PetListPanel();
         addChild(this._petListPanel);
         this._petListPanel.x = 52;
         this._petListPanel.y = 74;
         this._petTabPanel = new PetTabPanel(this);
         this._petTabPanel.y = 10;
         addChild(this._petTabPanel);
         this._dataService = new PetBagDataService();
         this.liftOuterCloseButton();
      }
      
      private function liftOuterCloseButton() : void
      {
         var _loc1_:Point = null;
         var _loc2_:Point = null;
         if(this._closeBtn == null || this._closeBtn.parent == this)
         {
            return;
         }
         _loc1_ = this._closeBtn.localToGlobal(new Point(0,0));
         this.addChild(this._closeBtn);
         _loc2_ = this.globalToLocal(_loc1_);
         this._closeBtn.x = _loc2_.x;
         this._closeBtn.y = _loc2_.y;
         this.setChildIndex(this._closeBtn,this.numChildren - 1);
      }
      
      private function initEvent() : void
      {
         this._petListPanel.addEventListener("petSelected",this.onPetSelected);
         this._dataService.addEventListener("petAddedHp",this.onPetAddedHp);
         Connection.addCommandListener(Command.getCommand(1215),this.onPetAddedHp2);
         this._dataService.addEventListener("petDataChange",this.onPetDataChange);
         this._dataService.addEventListener("petTrainingError",this.onPetTrainingError);
      }
      
      private function onPetAddedHp(param1:PetBagEvent) : void
      {
         param1.stopPropagation();
         this._petListPanel.updateDisplay();
         this._petDemoPanel.showHpAnnimation(param1.petInfo);
      }
      
      private function onPetAddedHp2(param1:MessageEvent) : void
      {
         this._petListPanel.updateDisplay();
         this._petDemoPanel.showHpAnnimation();
      }
      
      private function onPetDataChange(param1:PetBagEvent) : void
      {
         this.updatePanel();
      }
      
      private function onPetTrainingError(param1:PetBagEvent) : void
      {
         param1.stopPropagation();
         this._petDemoPanel.updateButtonStatus();
      }
      
      private function onPetSelected(param1:PetBagEvent) : void
      {
         param1.stopPropagation();
         this._currPetInfo = param1.petInfo;
         if(this._currPetInfo.level >= 60 && this.getPetHideSkillCount(this._currPetInfo) && this._currPetInfo.resourceId != 91 && this.getPetHideCount(this._currPetInfo) > 0)
         {
            this.checkBuff();
         }
         else
         {
            this._petDemoPanel.setData(this._currPetInfo);
            this._petTabPanel.setData(this._currPetInfo);
         }
      }
      
      private function getPetHideSkillCount(param1:PetInfo) : Boolean
      {
         if(PetUtil.getMaxStatusPet(param1.bunchId).resId == param1.resourceId)
         {
            return true;
         }
         return false;
      }
      
      private function getPetHideCount(param1:PetInfo) : uint
      {
         var _loc2_:PetSkillSettingDefinition = null;
         var _loc3_:uint = 0;
         for each(_loc2_ in PetConfig.getPetSkillSettingDefinitionVec(param1.bunchId))
         {
            if(_loc2_.learningLv > 100)
            {
               _loc3_++;
            }
         }
         return _loc3_;
      }
      
      private function checkBuff() : void
      {
         ServerBufferManager.getServerBuffer(76,this.onUpdateServerBuf);
      }
      
      private function onUpdateServerBuf(param1:ServerBuffer) : void
      {
         GraspHideSkillPanel.newGuideOpen = false;
         this._petDemoPanel.setData(this._currPetInfo);
         this._petTabPanel.setData(this._currPetInfo);
      }
      
      public function updatePetInfoByPetInfoChange(param1:PetInfo) : void
      {
         this._currPetInfo = param1;
         this.updatePanel();
      }
      
      private function updatePanel() : void
      {
         this._petListPanel.setData(this._dataService.petInfoVec,this._dataService.petInfoStorageVec);
         this._petDemoPanel.setData(this._currPetInfo);
         if(Boolean(this._currPetInfo))
         {
            this._petTabPanel.setData(this._currPetInfo);
         }
      }
      
      private function onSeer(param1:ItemEvent) : void
      {
         ItemManager.removeEventListener1("requestSpecialItemSuccess",this.onSeer);
         this.getPetItemList();
         PetInfoManager.addEventListener("petFightItem",this.petFightItem);
         LayerManager.focusOnUILayer();
      }
      
      private function getPetItemList() : void
      {
         Connection.addCommandListener(CommandSet.GET_PET_ITEM_INFO_1234,this.onGetPetItemList);
         Connection.send(CommandSet.GET_PET_ITEM_INFO_1234);
      }
      
      private function petFightItem(param1:PetInfoEvent) : void
      {
         if(this._petDemoPanel.petInfo.catchTime == param1.info.catchTime)
         {
            this._petDemoPanel.setData(param1.info);
         }
      }
      
      private function onGetPetItemList(param1:MessageEvent) : void
      {
         var _loc2_:PetInfo = null;
         var _loc3_:uint = 0;
         var _loc4_:int = 0;
         Connection.removeCommandListener(CommandSet.GET_PET_ITEM_INFO_1234,this.onGetPetItemList);
         var _loc5_:IDataInput = param1.message.getRawData();
         var _loc6_:Vector.<PetInfo> = PetInfoManager.getAllBagPetInfo();
         for each(_loc2_ in _loc6_)
         {
            _loc2_.itemList = new Vector.<PetItemInfo>();
         }
         _loc3_ = _loc5_.readUnsignedInt();
         _loc4_ = 0;
         while(_loc4_ < _loc3_)
         {
            this.updatePetItem(_loc5_);
            _loc4_++;
         }
         this.reset();
         this.updatePanel();
      }
      
      private function updatePetItem(param1:IDataInput) : void
      {
         var _loc2_:PetInfo = null;
         var _loc3_:uint = 0;
         var _loc4_:PetItemInfo = null;
         var _loc5_:int = 0;
         var _loc6_:uint = param1.readUnsignedInt();
         var _loc7_:Vector.<PetInfo> = PetInfoManager.getAllBagPetInfo();
         for each(_loc2_ in _loc7_)
         {
            if(_loc2_.catchTime == _loc6_)
            {
               _loc3_ = param1.readUnsignedInt();
               _loc5_ = 0;
               while(_loc5_ < _loc3_)
               {
                  _loc4_ = new PetItemInfo();
                  _loc4_.itemId = param1.readUnsignedInt();
                  _loc4_.itemCurrCount = param1.readUnsignedInt();
                  _loc2_.itemList.push(_loc4_);
                  _loc5_++;
               }
               return;
            }
         }
      }
      
      public function reset() : void
      {
         this._petListPanel.reset();
         this._petDemoPanel.reset();
         this._dataService.reloadEventListener();
      }
      
      public function updateSelectedPet() : void
      {
         this._petDemoPanel.updateDisplay();
         this._petListPanel.updateDisplay();
      }
   }
}

