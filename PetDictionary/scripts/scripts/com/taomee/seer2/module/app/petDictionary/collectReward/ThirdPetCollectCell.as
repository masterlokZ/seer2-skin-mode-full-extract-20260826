package com.taomee.seer2.module.app.petDictionary.collectReward
{
   import com.taomee.seer2.app.component.IconDisplayer;
   import com.taomee.seer2.app.config.PetConfig;
   import com.taomee.seer2.app.manager.OnlyFlagManager;
   import com.taomee.seer2.app.pet.data.PetInfo;
   import com.taomee.seer2.app.pet.data.PetInfoManager;
   import com.taomee.seer2.core.ui.toolTip.TooltipManager;
   import com.taomee.seer2.core.utils.DisplayObjectUtil;
   import com.taomee.seer2.core.utils.URLUtil;
   import com.taomee.seer2.module.app.petDictionary.InitialPetCollecteCellUI_1;
   import com.taomee.seer2.module.app.petDictionary.config.PetDictionaryConfig;
   import com.taomee.seer2.module.app.petDictionary.config.configInfo.ThirdPetRewardInfo;
   import com.taomee.seer2.module.app.petDictionary.data.PetDictionaryDataServer;
   import com.taomee.seer2.module.app.petDictionary.event.PetDictionaryEvent;
   import flash.display.MovieClip;
   import flash.display.SimpleButton;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   
   public class ThirdPetCollectCell extends Sprite
   {
      
      private var _rewardBigIcon:IconDisplayer;
      
      private var _rewardSmallIcon:IconDisplayer;
      
      private var _firstPetIcon:IconDisplayer;
      
      private var _secondPetIcon:IconDisplayer;
      
      private var _getRewardBtn:SimpleButton;
      
      private var _receivedBtn:MovieClip;
      
      private var _monsterIcon:MovieClip;
      
      private var _info:ThirdPetRewardInfo;
      
      private var _shineMC:MovieClip;
      
      private var _p:Sprite;
      
      public function ThirdPetCollectCell(param1:Sprite)
      {
         super();
         this._p = param1;
         this._info = PetDictionaryConfig.thirdPetRewardInfo;
         this.createChildren();
         this.initEventListener();
      }
      
      private function createChildren() : void
      {
         var _loc1_:InitialPetCollecteCellUI_1 = new InitialPetCollecteCellUI_1();
         _loc1_.x = 58;
         _loc1_.y = 88;
         addChild(_loc1_);
         this._firstPetIcon = new IconDisplayer();
         this._secondPetIcon = new IconDisplayer();
         this._rewardBigIcon = new IconDisplayer();
         this._rewardSmallIcon = new IconDisplayer();
         this._firstPetIcon.scaleX = this._firstPetIcon.scaleY = 1.4912280701754386;
         this._secondPetIcon.scaleX = this._secondPetIcon.scaleY = 1.4912280701754386;
         this._rewardSmallIcon.scaleX = this._rewardSmallIcon.scaleY = 0.8421052631578947;
         this._rewardBigIcon.scaleX = this._rewardBigIcon.scaleY = 2.9473684210526314;
         this._rewardBigIcon.x = 100;
         this._rewardBigIcon.y = 150;
         this._firstPetIcon.setIconUrl(URLUtil.getPetIcon(this._info.firstPetId));
         this._secondPetIcon.setIconUrl(URLUtil.getPetIcon(this._info.secondPetId));
         this._rewardBigIcon.setIconUrl(URLUtil.getPetIcon(this._info.rewardId));
         this._rewardSmallIcon.setIconUrl(URLUtil.getPetIcon(this._info.rewardId));
         _loc1_["rewardPetName"].text = PetConfig.getPetDefinition(this._info.rewardId).name;
         _loc1_["initialIcon"].addChild(this._firstPetIcon);
         _loc1_["initialIcon_1"].addChild(this._secondPetIcon);
         _loc1_["rewardIcon"].addChild(this._rewardSmallIcon);
         addChild(this._rewardBigIcon);
         this._getRewardBtn = _loc1_["getRewardBtn"];
         this._receivedBtn = _loc1_["receivedBtn"];
         this._monsterIcon = _loc1_["monstIcon"];
         this._shineMC = _loc1_["shineMC"];
         this._shineMC.mouseEnabled = false;
         this._shineMC.stop();
         this._shineMC.visible = false;
         TooltipManager.addCommonTip(this._firstPetIcon,"初始精灵超过100级");
         TooltipManager.addCommonTip(this._secondPetIcon,"第二只主宠超过60级");
         TooltipManager.addCommonTip(this._monsterIcon,"收集40种不同种类的精灵");
      }
      
      private function initEventListener() : void
      {
         this._getRewardBtn.addEventListener("click",this.onGetReward);
      }
      
      private function onGetReward(param1:MouseEvent) : void
      {
         var evt:MouseEvent = param1;
         PetDictionaryDataServer.getRewardByIndex(this._info.index,function():void
         {
            _getRewardBtn.removeEventListener("click",onGetReward);
            OnlyFlagManager.updataFlag(_info.onlyFlagIndex,1);
            _info.flag = 1;
            updata();
         });
      }
      
      private function updataStatus() : void
      {
         var _loc1_:PetInfo = null;
         var _loc2_:PetInfo = null;
         var _loc3_:Boolean = false;
         var _loc4_:Boolean = false;
         var _loc5_:Boolean = false;
         if(PetDictionaryDataServer.petGainedNum >= this._info.collectPetNum)
         {
            DisplayObjectUtil.recoverDisplayObject(this._monsterIcon);
            _loc3_ = true;
         }
         else
         {
            DisplayObjectUtil.grayDisplayObject(this._monsterIcon);
         }
         if(PetInfoManager.getInitialPetInfo().level >= 100)
         {
            DisplayObjectUtil.recoverDisplayObject(this._firstPetIcon);
            _loc4_ = true;
         }
         else
         {
            DisplayObjectUtil.grayDisplayObject(this._firstPetIcon);
         }
         var _loc6_:Vector.<PetInfo> = PetInfoManager.getInitialPetInfoVec();
         for each(_loc2_ in _loc6_)
         {
            if(_loc2_.bunchId == PetConfig.getPetDefinition(this._info.secondPetId).bunchId)
            {
               _loc1_ = _loc2_;
               break;
            }
         }
         if(_loc1_ != null && _loc1_.level >= 60)
         {
            DisplayObjectUtil.recoverDisplayObject(this._secondPetIcon);
            _loc5_ = true;
         }
         else
         {
            DisplayObjectUtil.grayDisplayObject(this._secondPetIcon);
         }
         if(_loc3_ && _loc4_ && _loc5_)
         {
            DisplayObjectUtil.enableButton(this._getRewardBtn);
            this._shineMC.play();
            this._shineMC.visible = true;
            if(this._info.flag != 1)
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
      
      public function updata() : void
      {
         this.updataStatus();
         this.updataBtn();
      }
      
      private function updataBtn() : void
      {
         if(this._info.flag == 1)
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

