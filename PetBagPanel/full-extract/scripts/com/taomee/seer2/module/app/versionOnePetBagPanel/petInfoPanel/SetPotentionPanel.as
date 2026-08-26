package com.taomee.seer2.module.app.versionOnePetBagPanel.petInfoPanel
{
   import com.taomee.seer2.app.config.PetConfig;
   import com.taomee.seer2.app.event.LogicEvent;
   import com.taomee.seer2.app.guide.manager.GuideManager;
   import com.taomee.seer2.app.pet.data.PetInfo;
   import com.taomee.seer2.app.pet.data.PetInfoManager;
   import com.taomee.seer2.app.pet.events.PetInfoEvent;
   import com.taomee.seer2.app.popup.AlertManager;
   import com.taomee.seer2.app.processor.quest.handler.main.quest99.QuestMapHandler_99_80491;
   import com.taomee.seer2.app.quest.QuestManager;
   import com.taomee.seer2.core.module.ModuleManager;
   import com.taomee.seer2.core.scene.events.ModelLocator;
   import com.taomee.seer2.core.utils.DisplayObjectUtil;
   import com.taomee.seer2.module.app.petBag.helper.PetBagLearningPointHelper;
   import com.taomee.seer2.module.app.versionOnePetBagPanel.PetInfoPanel;
   import flash.display.MovieClip;
   import flash.display.SimpleButton;
   import flash.display.Sprite;
   import flash.events.KeyboardEvent;
   import flash.events.MouseEvent;
   import flash.geom.Point;
   import flash.geom.Rectangle;
   import flash.text.TextField;
   
   public class SetPotentionPanel extends Sprite
   {
      
      private var _mainUI:MovieClip;
      
      private var _onClose:SimpleButton;
      
      private var _introduceTxt:TextField;
      
      private var _barList:Vector.<MovieClip>;
      
      private var _reduceBtnList:Vector.<SimpleButton>;
      
      private var _addBtnList:Vector.<SimpleButton>;
      
      private var _valTxtList:Vector.<TextField>;
      
      private var _leftPointTxt:TextField;
      
      private var _setBtn:SimpleButton;
      
      private var _sureBtn:SimpleButton;
      
      private var _setPropUIList:Vector.<MovieClip>;
      
      private var _setPropValList:Vector.<TextField>;
      
      private var _addPointList:Vector.<TextField>;
      
      private const WHOLE_LEARNING_POINT_MAX:int = 510;
      
      private const MAX_NUM:int = 6;
      
      private const CHANGE_VALUE:int = 1;
      
      private const CHANGE_VALUE_CONTINUOUS:int = 10;
      
      private const LEARNING_POINT_MAX:int = 255;
      
      private const DOWN_INTERVAL:int = 200;
      
      private var _petInfo:PetInfo;
      
      private var _hasUsedPoint:uint;
      
      private var _unusedLearningPoint:uint;
      
      private var _propMaxVal:Vector.<int>;
      
      private var _propRealVal:Vector.<int>;
      
      private var _originalAbilityValueVec:Vector.<int>;
      
      private var _originalLearingPointVec:Vector.<int>;
      
      private var _changedLearningPointVec:Vector.<int>;
      
      private var _thisParent:PetInfoPanel;
      
      public function SetPotentionPanel(param1:PetInfoPanel)
      {
         super();
         this._thisParent = param1;
         this.initSet();
         this.initEvent();
      }
      
      private function initSet() : void
      {
         var _loc1_:int = 0;
         this._mainUI = new SetPotentionUI();
         addChild(this._mainUI);
         this._mainUI.x = 710;
         this._mainUI.y = 20;
         this._onClose = this._mainUI["onClose"];
         this._introduceTxt = this._mainUI["introduceTxt"];
         this._barList = new Vector.<MovieClip>();
         this._reduceBtnList = new Vector.<SimpleButton>();
         this._addBtnList = new Vector.<SimpleButton>();
         this._valTxtList = new Vector.<TextField>();
         this._setPropUIList = new Vector.<MovieClip>();
         this._setPropValList = new Vector.<TextField>();
         this._addPointList = new Vector.<TextField>();
         _loc1_ = 0;
         while(_loc1_ < 6)
         {
            this._barList.push(this._mainUI["bar" + _loc1_]);
            this._reduceBtnList.push(this._mainUI["reduceBtn" + _loc1_]);
            this._addBtnList.push(this._mainUI["addBtn" + _loc1_]);
            this._valTxtList.push(this._mainUI["valTxt" + _loc1_]);
            this._addPointList.push(this._mainUI["addPoint" + _loc1_]);
            this._setPropUIList.push(this._mainUI["setPropUI" + _loc1_]);
            this._setPropValList.push(this._setPropUIList[_loc1_]["setPropVal"] as TextField);
            this._setPropValList[_loc1_].maxChars = 3;
            this._setPropValList[_loc1_].restrict = "0-9";
            this._setPropValList[_loc1_].addEventListener("keyDown",this.onKeyClick);
            this._setPropValList[_loc1_].addEventListener("keyUp",this.onKeyClick);
            _loc1_++;
         }
         this._leftPointTxt = this._mainUI["leftPointTxt"];
         this._setBtn = this._mainUI["setBtn"];
         this._sureBtn = this._mainUI["sureBtn"];
         this._sureBtn.visible = false;
      }
      
      private function onKeyClick(param1:KeyboardEvent) : void
      {
         var _loc2_:int = this._setPropValList.indexOf(param1.currentTarget as TextField);
         if(int(this._setPropValList[_loc2_].text) == 0)
         {
            this._setPropValList[_loc2_].text = "";
         }
         this.updateLearningPointToCell(int(this._setPropValList[_loc2_].text),_loc2_);
      }
      
      private function initEvent() : void
      {
         var _loc1_:SimpleButton = null;
         var _loc2_:SimpleButton = null;
         this._onClose.addEventListener("click",this.onCloseBtn);
         this._setBtn.addEventListener("click",this.onSetBtn);
         this._sureBtn.addEventListener("click",this.onSureBtn);
         for each(_loc1_ in this._addBtnList)
         {
            _loc1_.addEventListener("click",this.onAddClick);
         }
         for each(_loc2_ in this._reduceBtnList)
         {
            _loc2_.addEventListener("click",this.onReduceClick);
         }
      }
      
      private function setPropUIListVisible(param1:Boolean) : void
      {
         var _loc2_:MovieClip = null;
         for each(_loc2_ in this._setPropUIList)
         {
            _loc2_.visible = param1;
         }
      }
      
      private function setAddPointListVisible(param1:Boolean) : void
      {
         var _loc2_:TextField = null;
         for each(_loc2_ in this._addPointList)
         {
            _loc2_.visible = param1;
         }
      }
      
      private function onReduceClick(param1:MouseEvent) : void
      {
         var _loc2_:int = this._reduceBtnList.indexOf(param1.currentTarget as SimpleButton);
         if(int(this._setPropValList[_loc2_].text) <= 0)
         {
            return;
         }
         this._setPropValList[_loc2_].text = (int(this._setPropValList[_loc2_].text) - 1).toString();
         this.updateLearningPointToCell(int(this._setPropValList[_loc2_].text),_loc2_);
      }
      
      private function reduceLearningPointToCell(param1:int, param2:int) : void
      {
         var _loc3_:* = 0;
         if(this._changedLearningPointVec[param2] - param1 >= this._originalLearingPointVec[param2])
         {
            _loc3_ = param1;
         }
         else
         {
            _loc3_ = this._changedLearningPointVec[param2] - this._originalLearingPointVec[param2];
         }
         var _loc4_:int = param2;
         var _loc5_:Number = this._changedLearningPointVec[_loc4_] - _loc3_;
         this._changedLearningPointVec[_loc4_] = _loc5_;
         this._unusedLearningPoint += _loc3_;
         this.updateAddPointTxt(param2);
         this.updateLearningPoolText();
         this.updateBarListShow();
      }
      
      private function onSetBtn(param1:MouseEvent) : void
      {
         if(Boolean(QuestManager.isAccepted(99)) && !QuestManager.isStepComplete(99,6) && Boolean(QuestMapHandler_99_80491.isClickQuest99_6))
         {
            GuideManager.instance.pause();
            this._setBtn.visible = false;
            this._sureBtn.visible = true;
            this.setAddPointListVisible(false);
            this.setPropUIListVisible(true);
            this.setActBtnsVisble(true);
            this.setPointBtnEnable(true,0);
            this.setPointBtnEnable(true,1);
            this.onGuideNext1();
            return;
         }
         if(this._unusedLearningPoint == 0)
         {
            AlertManager.showAlert("当前没有可分配的学习力哦!");
            return;
         }
         this._setBtn.visible = false;
         this._sureBtn.visible = true;
         this.setAddPointListVisible(false);
         this.setPropUIListVisible(true);
         this.setActBtnsVisble(true);
         this.setPointBtnEnable(true,0);
         this.setPointBtnEnable(true,1);
      }
      
      private function setPointBtnEnable(param1:Boolean, param2:int) : void
      {
         var _loc3_:SimpleButton = null;
         var _loc4_:SimpleButton = null;
         if(param2 == 0)
         {
            for each(_loc3_ in this._addBtnList)
            {
               if(param1)
               {
                  DisplayObjectUtil.enableButton(_loc3_);
               }
               else
               {
                  DisplayObjectUtil.disableButton(_loc3_);
               }
            }
         }
         else
         {
            for each(_loc4_ in this._reduceBtnList)
            {
               if(param1)
               {
                  DisplayObjectUtil.enableButton(_loc4_);
               }
               else
               {
                  DisplayObjectUtil.disableButton(_loc4_);
               }
            }
         }
      }
      
      private function updateLearningPointToCell(param1:int, param2:int) : void
      {
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         if(param1 > this._changedLearningPointVec[param2] - this._originalLearingPointVec[param2])
         {
            _loc3_ = this._changedLearningPointVec[param2];
            _loc4_ = param1 - (this._changedLearningPointVec[param2] - this._originalLearingPointVec[param2]);
            if(this._unusedLearningPoint - _loc4_ < 0)
            {
               _loc4_ = int(this._unusedLearningPoint);
            }
            if(_loc4_ + _loc3_ > 255)
            {
               _loc4_ = 255 - _loc3_;
            }
            this._unusedLearningPoint -= _loc4_;
            this._changedLearningPointVec[param2] += _loc4_;
            this._setPropValList[param2].text = (this._changedLearningPointVec[param2] - this._originalLearingPointVec[param2]).toString();
            this.updateLearningPoolText();
            this.updateBarListShow();
         }
         if(param1 < this._changedLearningPointVec[param2] - this._originalLearingPointVec[param2])
         {
            _loc5_ = this._changedLearningPointVec[param2] - this._originalLearingPointVec[param2] - param1;
            this._changedLearningPointVec[param2] -= _loc5_;
            this._unusedLearningPoint += _loc5_;
            this._setPropValList[param2].text = (this._changedLearningPointVec[param2] - this._originalLearingPointVec[param2]).toString();
            this.updateLearningPoolText();
            this.updateBarListShow();
         }
      }
      
      private function updateAddPointTxt(param1:int) : void
      {
         this._addPointList[param1].text = "+" + this._changedLearningPointVec[param1];
      }
      
      private function onCloseBtn(param1:MouseEvent) : void
      {
         this._thisParent.changePanelShow(0);
      }
      
      private function hide() : void
      {
         DisplayObjectUtil.removeFromParent(this);
      }
      
      private function onAddClick(param1:MouseEvent) : void
      {
         var _loc2_:int = this._addBtnList.indexOf(param1.currentTarget as SimpleButton);
         this.onGuideNext2();
         if(this._unusedLearningPoint <= 0)
         {
            return;
         }
         this._setPropValList[_loc2_].text = (int(this._setPropValList[_loc2_].text) + 1).toString();
         this.updateLearningPointToCell(int(this._setPropValList[_loc2_].text),_loc2_);
      }
      
      private function onSureBtn(param1:MouseEvent) : void
      {
         var evt:MouseEvent = param1;
         if(Boolean(QuestManager.isAccepted(99)) && !QuestManager.isStepComplete(99,6) && Boolean(QuestMapHandler_99_80491.isClickQuest99_6))
         {
            this.onGuideNext3();
            return;
         }
         AlertManager.showConfirm("你确定要这样分配精灵学习力吗？",function():void
         {
            if(PetBagLearningPointHelper.canChangeLearningPointSvr(_changedLearningPointVec,_originalLearingPointVec))
            {
               DisplayObjectUtil.disableSprite(this as Sprite);
               PetInfoManager.addEventListener("petPropertiesChange",onPetPropertiesChange);
               PetBagLearningPointHelper.changeLearningPointSvr(_petInfo.catchTime,_changedLearningPointVec,_originalLearingPointVec);
            }
            else
            {
               AlertManager.showAlert("你当前没有分配学习力哦!");
            }
         });
      }
      
      private function onPetPropertiesChange(param1:PetInfoEvent) : void
      {
         if(param1.info.catchTime == this._petInfo.catchTime)
         {
            this.setData(param1.info);
         }
      }
      
      public function setData(param1:PetInfo) : void
      {
         var _loc2_:SimpleButton = null;
         this.clear();
         this._petInfo = param1;
         this.updateData();
         this.updateDisplay();
         this.resetButtons();
         this.setAddPointListVisible(true);
         this.setActBtnsVisble(false);
         if(Boolean(QuestManager.isAccepted(99)) && !QuestManager.isStepComplete(99,6) && Boolean(QuestMapHandler_99_80491.isClickQuest99_6))
         {
            this.setActBtnsVisble(true);
            for each(_loc2_ in this._addBtnList)
            {
               DisplayObjectUtil.enableButton(_loc2_);
            }
         }
      }
      
      private function setActBtnsVisble(param1:Boolean) : void
      {
         var _loc2_:SimpleButton = null;
         var _loc3_:SimpleButton = null;
         for each(_loc2_ in this._addBtnList)
         {
            _loc2_.visible = param1;
         }
         for each(_loc3_ in this._reduceBtnList)
         {
            _loc3_.visible = param1;
         }
      }
      
      private function clear() : void
      {
         PetInfoManager.removeEventListener("petPropertiesChange",this.onPetPropertiesChange);
         DisplayObjectUtil.enableSprite(this);
         this._hasUsedPoint = 0;
         this._petInfo = null;
      }
      
      private function updateData() : void
      {
         if(Boolean(this._petInfo) && Boolean(this._petInfo.learningInfo))
         {
            this._unusedLearningPoint = this._petInfo.learningInfo.pointUnused;
         }
         this.updateAbilityValue();
         this.updateLearningPoint();
      }
      
      private function updateAbilityValue() : void
      {
         this._originalAbilityValueVec = new Vector.<int>();
         this._originalAbilityValueVec.push(this._petInfo.atk);
         this._originalAbilityValueVec.push(this._petInfo.defence);
         this._originalAbilityValueVec.push(this._petInfo.specialAtk);
         this._originalAbilityValueVec.push(this._petInfo.specialDefence);
         this._originalAbilityValueVec.push(this._petInfo.speed);
         this._originalAbilityValueVec.push(this._petInfo.maxHp);
      }
      
      private function updateLearningPoint() : void
      {
         this._originalLearingPointVec = new Vector.<int>();
         this._originalLearingPointVec.push(this._petInfo.learningInfo.pointAtk);
         this._originalLearingPointVec.push(this._petInfo.learningInfo.pointDefence);
         this._originalLearingPointVec.push(this._petInfo.learningInfo.pointSpecialAtk);
         this._originalLearingPointVec.push(this._petInfo.learningInfo.pointSpecialDefence);
         this._originalLearingPointVec.push(this._petInfo.learningInfo.pointSpeed);
         this._originalLearingPointVec.push(this._petInfo.learningInfo.pointHp);
         this._changedLearningPointVec = this._originalLearingPointVec.slice();
      }
      
      private function updateDisplay() : void
      {
         this.updateLearningPoolText();
         this.updateBarListShow();
         this.newGuideShow();
      }
      
      private function newGuideShow() : void
      {
         var _loc1_:Rectangle = null;
         if(Boolean(QuestManager.isAccepted(99)) && !QuestManager.isStepComplete(99,6) && Boolean(QuestMapHandler_99_80491.isClickQuest99_6))
         {
            GuideManager.instance.close();
            _loc1_ = new Rectangle(0,0,73,31);
            GuideManager.instance.addTarget(_loc1_,0);
            GuideManager.instance.addGuide2Target(_loc1_,0,25,new Point(924,479),false,false,9,false,true,false,990,560);
            GuideManager.instance.startGuide(25);
         }
      }
      
      private function onGuideNext1() : void
      {
         var _loc1_:Rectangle = null;
         if(Boolean(QuestManager.isAccepted(99)) && !QuestManager.isStepComplete(99,6) && Boolean(QuestMapHandler_99_80491.isClickQuest99_6))
         {
            GuideManager.instance.pause();
            _loc1_ = new Rectangle(0,0,24,24);
            GuideManager.instance.addTarget(_loc1_,0);
            GuideManager.instance.addGuide2Target(_loc1_,0,23,new Point(973,325),false,false,9,false,true,false,990,560);
            GuideManager.instance.startGuide(23);
         }
      }
      
      private function onGuideNext2() : void
      {
         var _loc1_:Rectangle = null;
         if(Boolean(QuestManager.isAccepted(99)) && !QuestManager.isStepComplete(99,6) && Boolean(QuestMapHandler_99_80491.isClickQuest99_6))
         {
            GuideManager.instance.pause();
            _loc1_ = new Rectangle(0,0,73,31);
            GuideManager.instance.addTarget(_loc1_,0);
            GuideManager.instance.addGuide2Target(_loc1_,0,24,new Point(924,479),false,false,9,false,true,false,990,560);
            GuideManager.instance.startGuide(24);
         }
      }
      
      private function onGuideNext3() : void
      {
         GuideManager.instance.close();
         ModuleManager.closeForName("PetBagPanel");
         ModelLocator.getInstance().dispatchEvent(new LogicEvent("newGuideBroad8"));
      }
      
      private function updateLearningPoolText() : void
      {
         this._leftPointTxt.text = String(this._unusedLearningPoint);
      }
      
      private function updateIntroduce() : void
      {
         var _loc1_:String = String(PetConfig.getPetDefinition(this._petInfo.resourceId).charaPoint);
         if(Boolean(_loc1_) && _loc1_ != "")
         {
            this._introduceTxt.text = _loc1_;
         }
         else
         {
            this._introduceTxt.text = "";
         }
      }
      
      private function updateBarListShow() : void
      {
         var _loc1_:int = 0;
         _loc1_ = 0;
         while(_loc1_ < 6)
         {
            this._hasUsedPoint += this._originalLearingPointVec[_loc1_];
            _loc1_++;
         }
         this.setMaxData();
         this.setRealData();
         _loc1_ = 0;
         while(_loc1_ < this._barList.length)
         {
            this._barList[_loc1_].scaleX = this._propRealVal[_loc1_] / this._propMaxVal[_loc1_];
            this._valTxtList[_loc1_].text = this._propRealVal[_loc1_] + "/" + this._propMaxVal[_loc1_];
            this.updateAddPointTxt(_loc1_);
            _loc1_++;
         }
      }
      
      private function resetButtons() : void
      {
         this._sureBtn.visible = false;
         this._setBtn.visible = true;
         if(this._hasUsedPoint >= 510)
         {
            DisplayObjectUtil.disableButton(this._setBtn);
         }
         else if(this._unusedLearningPoint > 0)
         {
            DisplayObjectUtil.enableButton(this._setBtn);
         }
         else
         {
            DisplayObjectUtil.disableButton(this._setBtn);
         }
         if(Boolean(QuestManager.isAccepted(99)) && !QuestManager.isStepComplete(99,6) && Boolean(QuestMapHandler_99_80491.isClickQuest99_6))
         {
            DisplayObjectUtil.enableButton(this._setBtn);
         }
         this.setPointBtnEnable(false,0);
         this.setPointBtnEnable(false,1);
         this.clearPointProp();
         this.setPropUIListVisible(false);
      }
      
      private function clearPointProp() : void
      {
         var _loc1_:TextField = null;
         for each(_loc1_ in this._setPropValList)
         {
            _loc1_.text = "";
         }
      }
      
      private function setRealData() : void
      {
         this._propRealVal = new Vector.<int>();
         this._propRealVal.push(this.createRealData(this._petInfo.getPetDefinition().atk,this._changedLearningPointVec[0],0));
         this._propRealVal.push(this.createRealData(this._petInfo.getPetDefinition().defence,this._changedLearningPointVec[1],1));
         this._propRealVal.push(this.createRealData(this._petInfo.getPetDefinition().specialAtk,this._changedLearningPointVec[2],2));
         this._propRealVal.push(this.createRealData(this._petInfo.getPetDefinition().specialDefence,this._changedLearningPointVec[3],3));
         this._propRealVal.push(this.createRealData(this._petInfo.getPetDefinition().speed,this._changedLearningPointVec[4],4));
         this._propRealVal.push(this.createRealData(this._petInfo.getPetDefinition().maxHp,this._changedLearningPointVec[5],5));
      }
      
      private function createMaxData(param1:int, param2:int, param3:int) : int
      {
         var _loc4_:int = 0;
         if(param3 != 5)
         {
            _loc4_ = int(uint(((param1 * 2 + 120) * 1 + 100 + 10 + 63.75) * 1.1));
         }
         else
         {
            _loc4_ = int(uint((param1 * 2 + 120) * 1 + 100 + 10 + 63.75));
         }
         return _loc4_;
      }
      
      private function setMaxData() : void
      {
         this._propMaxVal = new Vector.<int>();
         this._propMaxVal.push(this.createMaxData(this._petInfo.getPetDefinition().atk,this._originalLearingPointVec[0],0));
         this._propMaxVal.push(this.createMaxData(this._petInfo.getPetDefinition().defence,this._originalLearingPointVec[1],1));
         this._propMaxVal.push(this.createMaxData(this._petInfo.getPetDefinition().specialAtk,this._originalLearingPointVec[2],2));
         this._propMaxVal.push(this.createMaxData(this._petInfo.getPetDefinition().specialDefence,this._originalLearingPointVec[3],3));
         this._propMaxVal.push(this.createMaxData(this._petInfo.getPetDefinition().speed,this._originalLearingPointVec[4],4));
         this._propMaxVal.push(this.createMaxData(this._petInfo.getPetDefinition().maxHp,this._originalLearingPointVec[5],5));
      }
      
      private function createRealData(param1:int, param2:int, param3:int) : int
      {
         var _loc4_:int = 0;
         var _loc5_:Vector.<int> = Vector.<int>([this._petInfo.potentialAtk,this._petInfo.potentialDef,this._petInfo.potentialSpAtk,this._petInfo.potentialSpDef,this._petInfo.potentialSpeed,this._petInfo.potentialHp]);
         if(param3 != 5)
         {
            _loc4_ = int(uint(((param1 * 2 + _loc5_[param3]) * (this._petInfo.level / 100) + this._petInfo.level + 10 + param2 / 4) * this._petInfo.characterArr[param3]));
         }
         else
         {
            _loc4_ = int(uint((param1 * 2 + _loc5_[param3]) * (this._petInfo.level / 100) + this._petInfo.level + 10 + int(param2 / 4)));
         }
         return _loc4_;
      }
   }
}

