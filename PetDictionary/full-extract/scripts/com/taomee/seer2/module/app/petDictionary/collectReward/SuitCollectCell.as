package com.taomee.seer2.module.app.petDictionary.collectReward
{
   import com.taomee.seer2.app.component.IconDisplayer;
   import com.taomee.seer2.app.config.ItemConfig;
   import com.taomee.seer2.app.config.PetConfig;
   import com.taomee.seer2.app.config.info.PetDictionaryInfo;
   import com.taomee.seer2.app.config.item.EquipItemDefinition;
   import com.taomee.seer2.app.config.pet.PetDefinition;
   import com.taomee.seer2.app.manager.OnlyFlagManager;
   import com.taomee.seer2.app.popup.AlertManager;
   import com.taomee.seer2.app.utils.ActsHelperUtil;
   import com.taomee.seer2.core.module.ModuleManager;
   import com.taomee.seer2.core.ui.toolTip.TooltipManager;
   import com.taomee.seer2.core.utils.DisplayObjectUtil;
   import com.taomee.seer2.core.utils.URLUtil;
   import com.taomee.seer2.module.app.petDictionary.config.configInfo.SuitRewardInfo;
   import com.taomee.seer2.module.app.petDictionary.data.PetDictionaryDataServer;
   import com.taomee.seer2.module.app.petDictionary.suitCollecteCellUI;
   import flash.display.MovieClip;
   import flash.display.SimpleButton;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import flash.text.TextField;
   
   public class SuitCollectCell extends Sprite
   {
      
      private var _info:SuitRewardInfo;
      
      private var _getRewardBtn:SimpleButton;
      
      private var _receivedBtn:MovieClip;
      
      private var _iconVec:Vector.<IconDisplayer>;
      
      private var _txtVec:Vector.<TextField>;
      
      private var _rewardIcon:IconDisplayer;
      
      private var _collectCnt:int;
      
      private var _shineMC:MovieClip;
      
      public function SuitCollectCell()
      {
         super();
         this.createChildren();
         this.initEventListener();
      }
      
      private function createChildren() : void
      {
         var _loc1_:int = 0;
         var _loc2_:suitCollecteCellUI = null;
         var _loc3_:IconDisplayer = null;
         _loc2_ = new suitCollecteCellUI();
         addChild(_loc2_);
         this._getRewardBtn = _loc2_["getRewardBtn"];
         this._receivedBtn = _loc2_["receivedBtn"];
         this._shineMC = _loc2_["shineMC"];
         this._shineMC.mouseEnabled = false;
         this._shineMC.visible = false;
         this._shineMC.stop();
         this._rewardIcon = new IconDisplayer();
         TooltipManager.addItemTip(this._rewardIcon,null);
         this._rewardIcon.scaleX = this._rewardIcon.scaleY = 0.7538461538461538;
         _loc2_["rewardIcon"].addChild(this._rewardIcon);
         this._iconVec = new Vector.<IconDisplayer>();
         this._txtVec = new Vector.<TextField>();
         _loc1_ = 0;
         while(_loc1_ < 3)
         {
            _loc3_ = new IconDisplayer();
            _loc3_.scaleX = _loc3_.scaleY = 1.4912280701754386;
            _loc2_["icon_" + _loc1_].addChild(_loc3_);
            this._iconVec.push(_loc3_);
            this._txtVec.push(_loc2_["petIdTxt_" + _loc1_]);
            TooltipManager.addMultipleTip(_loc3_,"");
            _loc1_++;
         }
      }
      
      private function initEventListener() : void
      {
         this._getRewardBtn.addEventListener("click",this.onGerReward);
      }
      
      private function onGerReward(param1:MouseEvent) : void
      {
         var evt:MouseEvent = param1;
         PetDictionaryDataServer.getRewardByIndex(this._info.index,function():void
         {
            _info.flag = 1;
            OnlyFlagManager.updataFlag(_info.onlyFlagIndex,1);
            _getRewardBtn.removeEventListener("click",onGerReward);
            updata();
         });
      }
      
      public function setData(param1:SuitRewardInfo) : void
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:PetDefinition = null;
         var _loc5_:String = null;
         this._info = param1;
         this._rewardIcon.setIconUrl(URLUtil.getEquipIcon(param1.rewardId));
         var _loc6_:EquipItemDefinition = ItemConfig.getEquipDefinition(param1.rewardId);
         TooltipManager.setData(this._rewardIcon,{
            "name":_loc6_.name,
            "description":_loc6_.tip
         });
         _loc2_ = 0;
         while(_loc2_ < 3)
         {
            _loc3_ = param1.neePetIconVec[_loc2_];
            this._iconVec[_loc2_].setIconUrl(URLUtil.getPetIcon(_loc3_));
            _loc4_ = PetConfig.getPetDefinition(_loc3_);
            _loc5_ = "名称：" + _loc4_.name + "\n" + "分布：" + _loc4_.foundPlace;
            this._iconVec[_loc2_].name = _loc4_.foundPlace + "_" + _loc3_;
            this._iconVec[_loc2_].buttonMode = true;
            this._iconVec[_loc2_].addEventListener("click",this.onCell);
            TooltipManager.changeTip(this._iconVec[_loc2_],_loc5_);
            _loc2_++;
         }
         this.updata();
      }
      
      private function onCell(param1:MouseEvent) : void
      {
         var _loc2_:PetDictionaryInfo = null;
         var _loc3_:IconDisplayer = param1.currentTarget as IconDisplayer;
         var _loc4_:int = int(_loc3_.name.split("_")[1]);
         _loc2_ = PetConfig.getPetDefinitionInfo(_loc4_);
         if(Boolean(_loc2_))
         {
            if(int(_loc2_.getWay) != 0)
            {
               ModuleManager.closeForInstance(this);
               ActsHelperUtil.goHandle(int(_loc2_.getWay));
            }
            else if(_loc2_.getWay != "")
            {
               if(_loc2_.isClose == 1)
               {
                  AlertManager.showAlert("精灵获得路径已下架!");
               }
               else
               {
                  ModuleManager.closeForInstance(this);
                  ActsHelperUtil.goHandle(_loc2_.getWay);
               }
            }
            else
            {
               AlertManager.showAlert("精灵没有配置获得途径哦!");
            }
         }
      }
      
      public function updata() : void
      {
         this.updataStatus();
         this.updataBtn();
      }
      
      private function updataStatus() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         this._collectCnt = 0;
         _loc1_ = 0;
         while(_loc1_ < 3)
         {
            _loc2_ = this._info.neePetIconVec[_loc1_];
            if(PetDictionaryDataServer.getPetFlag(_loc2_) == 2)
            {
               ++this._collectCnt;
               DisplayObjectUtil.recoverDisplayObject(this._iconVec[_loc1_]);
            }
            else
            {
               DisplayObjectUtil.grayDisplayObject(this._iconVec[_loc1_]);
            }
            _loc1_++;
         }
         if(this._collectCnt < 3)
         {
            DisplayObjectUtil.disableButton(this._getRewardBtn);
            this._shineMC.stop();
            this._shineMC.visible = false;
         }
         else
         {
            DisplayObjectUtil.enableButton(this._getRewardBtn);
            this._shineMC.play();
            this._shineMC.visible = true;
         }
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

