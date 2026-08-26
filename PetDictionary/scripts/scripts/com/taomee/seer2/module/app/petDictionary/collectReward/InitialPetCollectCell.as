package com.taomee.seer2.module.app.petDictionary.collectReward
{
   import com.taomee.seer2.app.component.IconDisplayer;
   import com.taomee.seer2.app.config.PetConfig;
   import com.taomee.seer2.app.manager.OnlyFlagManager;
   import com.taomee.seer2.app.pet.data.PetInfoManager;
   import com.taomee.seer2.core.ui.toolTip.TooltipManager;
   import com.taomee.seer2.core.utils.DisplayObjectUtil;
   import com.taomee.seer2.core.utils.URLUtil;
   import com.taomee.seer2.module.app.petDictionary.InitialPetCollecteCellUI;
   import com.taomee.seer2.module.app.petDictionary.config.PetDictionaryConfig;
   import com.taomee.seer2.module.app.petDictionary.config.configInfo.InitialPetRewardInfo;
   import com.taomee.seer2.module.app.petDictionary.data.PetDictionaryDataServer;
   import com.taomee.seer2.module.app.petDictionary.event.PetDictionaryEvent;
   import flash.display.MovieClip;
   import flash.display.SimpleButton;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   
   public class InitialPetCollectCell extends Sprite
   {
      
      private var _initialInfo:InitialPetRewardInfo;
      
      private var _rewardBigIcon:IconDisplayer;
      
      private var _rewardSmallIcon:IconDisplayer;
      
      private var _initialIcon:IconDisplayer;
      
      private var _getRewardBtn:SimpleButton;
      
      private var _receivedBtn:MovieClip;
      
      private var _monsterIcon:MovieClip;
      
      private var _shineMC:MovieClip;
      
      private var _p:Sprite;
      
      public function InitialPetCollectCell(param1:Sprite)
      {
         super();
         this._p = param1;
         this._initialInfo = PetDictionaryConfig.initPetRewardInfo;
         this.createChildren();
         this.initEventListener();
         this.updataStatus();
      }
      
      private function createChildren() : void
      {
         var _loc1_:InitialPetCollecteCellUI = new InitialPetCollecteCellUI();
         addChild(_loc1_);
         _loc1_.x = 58;
         _loc1_.y = 88;
         this._initialIcon = new IconDisplayer();
         this._rewardBigIcon = new IconDisplayer();
         this._rewardSmallIcon = new IconDisplayer();
         this._initialIcon.scaleX = this._initialIcon.scaleY = 1.4912280701754386;
         this._rewardSmallIcon.scaleX = this._rewardSmallIcon.scaleY = 0.8421052631578947;
         this._rewardBigIcon.scaleX = this._rewardBigIcon.scaleY = 2.9473684210526314;
         this._rewardBigIcon.x = 100;
         this._rewardBigIcon.y = 150;
         this._initialIcon.setIconUrl(URLUtil.getPetIcon(this._initialInfo.resourceId));
         this._rewardBigIcon.setIconUrl(URLUtil.getPetIcon(this._initialInfo.rewardId));
         this._rewardSmallIcon.setIconUrl(URLUtil.getPetIcon(this._initialInfo.rewardId));
         _loc1_["rewardPetName"].text = PetConfig.getPetDefinition(this._initialInfo.rewardId).name;
         _loc1_["initialIcon"].addChild(this._initialIcon);
         _loc1_["rewardIcon"].addChild(this._rewardSmallIcon);
         addChild(this._rewardBigIcon);
         this._getRewardBtn = _loc1_["getRewardBtn"];
         this._receivedBtn = _loc1_["receivedBtn"];
         this._monsterIcon = _loc1_["monstIcon"];
         this._shineMC = _loc1_["shineMC"];
         this._shineMC.mouseEnabled = false;
         this._shineMC.stop();
         this._shineMC.visible = false;
         TooltipManager.addCommonTip(this._initialIcon,"初始精灵超过60级");
         TooltipManager.addCommonTip(this._monsterIcon,"收集20种不同种类的精灵");
      }
      
      private function initEventListener() : void
      {
         this._getRewardBtn.addEventListener("click",this.onGetReward);
      }
      
      private function onGetReward(param1:MouseEvent) : void
      {
         var evt:MouseEvent = param1;
         PetDictionaryDataServer.getRewardByIndex(this._initialInfo.index,function():void
         {
            OnlyFlagManager.updataFlag(_initialInfo.onlyFlagIndex,1);
            _getRewardBtn.removeEventListener("click",onGetReward);
            _initialInfo.flag = 1;
            updata();
         });
      }
      
      public function updata() : void
      {
         this.updataStatus();
         this.updataBtn();
      }
      
      private function updataStatus() : void
      {
         var _loc1_:Boolean = false;
         var _loc2_:Boolean = false;
         if(PetDictionaryDataServer.petGainedNum >= this._initialInfo.collectPetNum)
         {
            DisplayObjectUtil.recoverDisplayObject(this._monsterIcon);
            _loc1_ = true;
         }
         else
         {
            DisplayObjectUtil.grayDisplayObject(this._monsterIcon);
         }
         if(PetInfoManager.getInitialPetInfo().level >= this._initialInfo.initialPetLevel)
         {
            DisplayObjectUtil.recoverDisplayObject(this._initialIcon);
            _loc2_ = true;
         }
         else
         {
            DisplayObjectUtil.grayDisplayObject(this._initialIcon);
         }
         if(_loc1_ && _loc2_)
         {
            DisplayObjectUtil.enableButton(this._getRewardBtn);
            this._shineMC.play();
            this._shineMC.visible = true;
            if(this._initialInfo.flag != 1)
            {
               this._p.dispatchEvent(new PetDictionaryEvent("collectPetShine"));
            }
         }
         else
         {
            DisplayObjectUtil.disableButton(this._getRewardBtn);
            this._shineMC.stop();
            this._shineMC.visible = false;
         }
      }
      
      private function updataBtn() : void
      {
         if(this._initialInfo.flag == 1)
         {
            this._receivedBtn.visible = true;
            this._getRewardBtn.visible = false;
            this._shineMC.stop();
            this._shineMC.visible = false;
         }
         else
         {
            this._receivedBtn.visible = false;
            this._getRewardBtn.visible = true;
         }
      }
   }
}

