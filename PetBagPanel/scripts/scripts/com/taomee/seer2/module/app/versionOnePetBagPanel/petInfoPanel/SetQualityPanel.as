package com.taomee.seer2.module.app.versionOnePetBagPanel.petInfoPanel
{
   import com.taomee.seer2.app.actor.ActorManager;
   import com.taomee.seer2.app.event.LogicEvent;
   import com.taomee.seer2.app.net.CommandSet;
   import com.taomee.seer2.app.net.Connection;
   import com.taomee.seer2.app.net.ErrorMap;
   import com.taomee.seer2.app.net.parser.Parser_1269;
   import com.taomee.seer2.app.pet.data.PetInfo;
   import com.taomee.seer2.app.pet.data.PetInfoManager;
   import com.taomee.seer2.app.popup.AlertManager;
   import com.taomee.seer2.app.processor.quest.handler.main.quest83.QuestMapHandler_83_80351;
   import com.taomee.seer2.app.processor.quest.handler.main.quest99.QuestMapHandler_99_80491;
   import com.taomee.seer2.app.quest.QuestManager;
   import com.taomee.seer2.app.swap.info.SwapInfo;
   import com.taomee.seer2.core.module.ModuleManager;
   import com.taomee.seer2.core.net.MessageEvent;
   import com.taomee.seer2.core.scene.events.ModelLocator;
   import com.taomee.seer2.module.app.versionOnePetBagPanel.PetBagPanel;
   import com.taomee.seer2.module.app.versionOnePetBagPanel.PetInfoPanel;
   import flash.display.MovieClip;
   import flash.display.SimpleButton;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.geom.Point;
   import flash.text.TextField;
   import flash.utils.IDataInput;
   import org.taomee.manager.EventManager;
   
   public class SetQualityPanel extends Sprite
   {
      
      private var _mainUI:MovieClip;
      
      private var _onClose:SimpleButton;
      
      private var _level:MovieClip;
      
      private var _propList:Vector.<TextField>;
      
      private var _changePropList:Vector.<TextField>;
      
      private var _allProp:TextField;
      
      private var _upLevelNeed:TextField;
      
      private var _changeVal:TextField;
      
      private var _coinSelect:MovieClip;
      
      private var _miSelect:MovieClip;
      
      private var _itemSelect:MovieClip;
      
      private var _actcionUI:MovieClip;
      
      private var _actionSure:SimpleButton;
      
      private var _actionCancel:SimpleButton;
      
      private var _coinNumList:Vector.<TextField>;
      
      private var _sure:SimpleButton;
      
      private var _swapItem:SimpleButton;
      
      private const FOR_LIST:Array = [204595];
      
      private const MI_ID_LIST:Vector.<uint> = Vector.<uint>([604102]);
      
      private const COST_NUM:Vector.<int> = Vector.<int>([5000,100000,720,10]);
      
      private const CHANGE_NORMAL:int = 0;
      
      private const CHANGE_MI:int = 1;
      
      private const CANCEL:int = 2;
      
      private const CHANGE_ITEM:int = 3;
      
      private var _thisParent:PetInfoPanel;
      
      private var _petBagPanel:PetBagPanel;
      
      private var _petInfo:PetInfo;
      
      private var _changePropVal:Vector.<int>;
      
      private var _changePropAllVal:Vector.<int>;
      
      private var _changePropAllVal2:Vector.<int>;
      
      private var _curSelectType:int = -1;
      
      private var _actionSurePos:Point;
      
      private var _newQuestMC2:MovieClip;
      
      private var _newQuestMC3:MovieClip;
      
      private var _newQuestMC4:MovieClip;
      
      private var _newQuestMC5:MovieClip;
      
      private var _newQuestMC6:MovieClip;
      
      private var _newQuestMC7:MovieClip;
      
      private var _setTimeout:uint;
      
      private var _successHandler:Function;
      
      private var _failHandler:Function;
      
      public function SetQualityPanel(param1:PetInfoPanel, param2:PetBagPanel)
      {
         super();
         this._thisParent = param1;
         this._petBagPanel = param2;
         this.initSet();
         this.initEvent();
      }
      
      private function initSet() : void
      {
         this._mainUI = new SetQualityUI();
         addChild(this._mainUI);
         this._mainUI.x = 710;
         this._mainUI.y = -30;
         this._onClose = this._mainUI["onClose"];
         this._propList = new Vector.<TextField>();
         this._changePropList = new Vector.<TextField>();
         var _loc1_:int = 0;
         while(_loc1_ < 6)
         {
            this._propList.push(this._mainUI["prop" + _loc1_]);
            this._changePropList.push(this._mainUI["changeProp" + _loc1_]);
            _loc1_++;
         }
         this._allProp = this._mainUI["allProp"];
         this._upLevelNeed = this._mainUI["upLevelNeed"];
         this._changeVal = this._mainUI["changeVal"];
         this._coinSelect = this._mainUI["coinSelect"];
         this._coinSelect.buttonMode = true;
         this._coinSelect.gotoAndStop(1);
         this._miSelect = this._mainUI["miSelect"];
         this._miSelect.buttonMode = true;
         this._miSelect.gotoAndStop(1);
         this._itemSelect = this._mainUI["itemSelect"];
         this._itemSelect.buttonMode = true;
         this._itemSelect.gotoAndStop(1);
         this._coinNumList = new Vector.<TextField>();
         _loc1_ = 0;
         while(_loc1_ < 3)
         {
            this._coinNumList.push(this._mainUI["coinNum" + _loc1_]);
            _loc1_++;
         }
         this._coinNumList[0].text = this.COST_NUM[0].toString();
         this._coinNumList[1].text = this.COST_NUM[1].toString();
         this._coinNumList[2].text = this.COST_NUM[3].toString();
         this._sure = this._mainUI["sure"];
         this._level = this._mainUI["level"];
         this._level.gotoAndStop(1);
         this._changePropVal = Vector.<int>([0,0,0,0,0,0]);
         this._changePropAllVal = Vector.<int>([0,0,0,0,0,0]);
         this._swapItem = this._mainUI["swapItem"];
         this._actcionUI = this._mainUI["actcionUI"];
         this._actcionUI.visible = false;
         this._actionSure = this._actcionUI["actionSure"];
         this._actionCancel = this._actcionUI["actionCancel"];
         this._newQuestMC2 = this._mainUI["newQuestMC2"];
         this._newQuestMC3 = this._mainUI["newQuestMC3"];
         this._newQuestMC4 = this._mainUI["newQuestMC4"];
         this._newQuestMC5 = this._mainUI["newQuestMC5"];
         this._newQuestMC6 = this._mainUI["newQuestMC6"];
         this._newQuestMC7 = this._mainUI["newQuestMC7"];
         this._newQuestMC2.visible = false;
         this._newQuestMC3.visible = false;
         this._newQuestMC4.visible = false;
         this._newQuestMC5.visible = false;
         this._newQuestMC6.visible = false;
         this._newQuestMC7.visible = false;
         this._curSelectType = 0;
         this._coinSelect.gotoAndStop(2);
         this._actionSurePos = new Point(this._actionSure.x,this._actionSure.y);
      }
      
      private function initEvent() : void
      {
         this._onClose.addEventListener("click",this.onCloseBtn);
         this._coinSelect.addEventListener("click",this.onCoinSelect);
         this._miSelect.addEventListener("click",this.onMiSelect);
         this._itemSelect.addEventListener("click",this.onItemSelect);
         this._sure.addEventListener("click",this.onSure);
         this._swapItem.addEventListener("click",this.onSwapItem);
         this._actionSure.addEventListener("click",this.onActionSure);
         this._actionCancel.addEventListener("click",this.onActionCancel);
      }
      
      private function onActionSure(param1:MouseEvent) : void
      {
         this.updatePetInfoProp();
         this._actcionUI.visible = false;
         this._sure.visible = true;
         if(Boolean(QuestManager.isAccepted(83)) && Boolean(QuestManager.isStepComplete(83,8)) && !QuestManager.isStepComplete(83,9) && Boolean(QuestMapHandler_83_80351.isClickQuest83))
         {
            this.hideAllMC();
            this._newQuestMC7.visible = true;
            this._newQuestMC7.addEventListener("click",this.onNewQuestMC7);
         }
         if(Boolean(QuestManager.isAccepted(99)) && Boolean(QuestManager.isStepComplete(99,4)) && !QuestManager.isStepComplete(99,5) && Boolean(QuestMapHandler_99_80491.isClickQuest99_5))
         {
            this.hideAllMC();
            this._newQuestMC7.visible = true;
            this._newQuestMC7.addEventListener("click",this.onNewQuestMC8);
         }
      }
      
      private function onNewQuestMC7(param1:MouseEvent) : void
      {
         this.hideAllMC();
         QuestMapHandler_83_80351.quest8IsOk = true;
         ModuleManager.closeForName("PetBagPanel");
      }
      
      private function onNewQuestMC8(param1:MouseEvent) : void
      {
         this.hideAllMC();
         ModelLocator.getInstance().dispatchEvent(new LogicEvent("newGuideBroad5"));
         ModuleManager.closeForName("PetBagPanel");
      }
      
      private function hideAllMC() : void
      {
         this._newQuestMC2.visible = false;
         this._newQuestMC3.visible = false;
         this._newQuestMC4.visible = false;
         this._newQuestMC5.visible = false;
         this._newQuestMC6.visible = false;
         this._newQuestMC7.visible = false;
      }
      
      private function onActionCancel(param1:MouseEvent) : void
      {
         var evt:MouseEvent = param1;
         this.changeQualitySendServer(2,this._petInfo.catchTime,function(param1:IDataInput):void
         {
            _actcionUI.visible = false;
            _sure.visible = true;
            setData(_petInfo);
         });
      }
      
      private function onSwapItem(param1:MouseEvent) : void
      {
         ModuleManager.showAppModule("QualityItemRecoveryPanel");
      }
      
      private function onCloseBtn(param1:MouseEvent) : void
      {
         this._thisParent.changePanelShow(0);
      }
      
      private function onSure(param1:MouseEvent) : void
      {
         var evt:MouseEvent = param1;
         if(Boolean(this._petInfo))
         {
            if(this._curSelectType == -1)
            {
               AlertManager.showAlert("请选择洗练类型。");
               return;
            }
            if(int(this._allProp.text) >= this.COST_NUM[2])
            {
               AlertManager.showAlert("所有资质已满，无法继续洗练");
               return;
            }
            if(this._curSelectType == 0)
            {
               if(ActorManager.actorInfo.coins < this.COST_NUM[0])
               {
                  AlertManager.showAlert("洗练需要5000赛尔豆哦，赛尔豆数量不足！");
                  return;
               }
               this._sure.mouseEnabled = false;
               this.changeQualitySendServer(0,this._petInfo.catchTime,function(param1:IDataInput):void
               {
                  var _loc2_:Parser_1269 = new Parser_1269(param1);
                  _changePropAllVal = _loc2_.changePropList;
                  updateBaseInfo(_loc2_.basePropList);
                  trace("洗练后随机值:(物攻、物防、特攻、特防、速度、血量)",_changePropAllVal);
                  update();
                  if(Boolean(QuestManager.isAccepted(83)) && Boolean(QuestManager.isStepComplete(83,8)) && !QuestManager.isStepComplete(83,9) && Boolean(QuestMapHandler_83_80351.isClickQuest83))
                  {
                     hideAllMC();
                     _newQuestMC6.visible = true;
                  }
                  if(Boolean(QuestManager.isAccepted(99)) && Boolean(QuestManager.isStepComplete(99,4)) && !QuestManager.isStepComplete(99,5) && Boolean(QuestMapHandler_99_80491.isClickQuest99_5))
                  {
                     hideAllMC();
                     _newQuestMC6.visible = true;
                  }
               },function(param1:uint):void
               {
                  _sure.mouseEnabled = true;
                  ErrorMap.parseStatusCode(param1);
               });
            }
            else if(this._curSelectType == 1)
            {
               this.changeQualitySendServer(0,this._petInfo.catchTime,this.sucFunc,null);
               this.changeQualitySendServer(0,this._petInfo.catchTime,this.sucFunc,null);
               this.changeQualitySendServer(0,this._petInfo.catchTime,this.sucFunc,null);
               this.changeQualitySendServer(0,this._petInfo.catchTime,this.sucFunc,null);
               this.changeQualitySendServer(0,this._petInfo.catchTime,this.sucFunc,null);
               this.changeQualitySendServer(0,this._petInfo.catchTime,this.sucFunc,null);
               this.changeQualitySendServer(0,this._petInfo.catchTime,this.sucFunc,null);
               this.changeQualitySendServer(0,this._petInfo.catchTime,this.sucFunc,null);
               this.changeQualitySendServer(0,this._petInfo.catchTime,this.sucFunc,null);
               this.changeQualitySendServer(0,this._petInfo.catchTime,this.sucFunc,null);
               this.changeQualitySendServer(0,this._petInfo.catchTime,this.sucFunc,null);
               this.changeQualitySendServer(0,this._petInfo.catchTime,this.sucFunc,null);
               this.changeQualitySendServer(0,this._petInfo.catchTime,this.sucFunc,null);
               this.changeQualitySendServer(0,this._petInfo.catchTime,this.sucFunc,null);
               this.changeQualitySendServer(0,this._petInfo.catchTime,this.sucFunc,null);
               this.changeQualitySendServer(0,this._petInfo.catchTime,this.sucFunc,null);
               this.changeQualitySendServer(0,this._petInfo.catchTime,this.sucFunc,null);
               this.changeQualitySendServer(0,this._petInfo.catchTime,this.sucFunc,null);
               this.changeQualitySendServer(0,this._petInfo.catchTime,this.sucFunc,null);
               this.changeQualitySendServer(0,this._petInfo.catchTime,this.sucFunc,null);
               this.changeQualitySendServer(0,this._petInfo.catchTime,function(param1:IDataInput):void
               {
                  var _loc2_:Parser_1269 = new Parser_1269(param1);
                  _changePropAllVal = _loc2_.changePropList;
                  updateBaseInfo(_loc2_.basePropList);
                  trace("洗练后随机值:(物攻、物防、特攻、特防、速度、血量)",_changePropAllVal);
                  update();
                  if(Boolean(QuestManager.isAccepted(83)) && Boolean(QuestManager.isStepComplete(83,8)) && !QuestManager.isStepComplete(83,9) && Boolean(QuestMapHandler_83_80351.isClickQuest83))
                  {
                     hideAllMC();
                     _newQuestMC6.visible = true;
                  }
                  if(Boolean(QuestManager.isAccepted(99)) && Boolean(QuestManager.isStepComplete(99,4)) && !QuestManager.isStepComplete(99,5) && Boolean(QuestMapHandler_99_80491.isClickQuest99_5))
                  {
                     hideAllMC();
                     _newQuestMC6.visible = true;
                  }
               },function(param1:uint):void
               {
                  _sure.mouseEnabled = true;
                  ErrorMap.parseStatusCode(param1);
               });
            }
            else
            {
               this._sure.mouseEnabled = false;
               this.changeQualitySendServer(3,this._petInfo.catchTime,function(param1:IDataInput):void
               {
                  var _loc2_:Parser_1269 = new Parser_1269(param1);
                  _changePropAllVal = _loc2_.changePropList;
                  updateBaseInfo(_loc2_.basePropList);
                  trace("洗练后随机值:(物攻、物防、特攻、特防、速度、血量)",_changePropAllVal);
                  update();
               },function(param1:uint):void
               {
                  update();
                  _sure.mouseEnabled = true;
                  ErrorMap.parseStatusCode(param1);
               });
            }
         }
      }
      
      private function onNewQuest5(param1:MouseEvent) : void
      {
         this._newQuestMC5.visible = false;
         this._newQuestMC6.visible = true;
      }
      
      private function updateBaseInfo(param1:Vector.<int>) : void
      {
         var _loc2_:PetInfo = PetInfoManager.getPetInfoFromAllBag(this._petInfo.catchTime);
         _loc2_.atk = param1[0];
         _loc2_.defence = param1[1];
         _loc2_.specialAtk = param1[2];
         _loc2_.specialDefence = param1[3];
         _loc2_.speed = param1[4];
         _loc2_.maxHp = param1[5];
         EventManager.dispatchEvent(new Event("PetUpdate"));
      }
      
      private function changeQualitySendServer(param1:int, param2:uint, param3:Function = null, param4:Function = null) : void
      {
         this._successHandler = param3;
         this._failHandler = param4;
         Connection.addCommandListener(CommandSet.CLI_CALC_POTENTIAL_1269,this.onGetSucess);
         Connection.addErrorHandler(CommandSet.CLI_CALC_POTENTIAL_1269,this.onGetError);
         Connection.send(CommandSet.CLI_CALC_POTENTIAL_1269,param2,param1);
         trace("洗练发送参数=====cathTime:",param2,";类型:",param1);
      }
      
      private function onGetSucess(param1:MessageEvent) : void
      {
         var _loc2_:SwapInfo = null;
         Connection.removeCommandListener(CommandSet.CLI_CALC_POTENTIAL_1269,this.onGetSucess);
         Connection.removeErrorHandler(CommandSet.CLI_CALC_POTENTIAL_1269,this.onGetError);
         var _loc3_:IDataInput = param1.message.getRawData();
         if(this._successHandler != null)
         {
            this._successHandler(_loc3_);
            this._successHandler = null;
         }
         else
         {
            _loc2_ = new SwapInfo(_loc3_);
         }
      }
      
      private function onGetError(param1:MessageEvent) : void
      {
         Connection.removeCommandListener(CommandSet.CLI_CALC_POTENTIAL_1269,this.onGetSucess);
         Connection.removeErrorHandler(CommandSet.CLI_CALC_POTENTIAL_1269,this.onGetError);
         var _loc2_:IDataInput = param1.message.getRawData();
         if(this._failHandler != null)
         {
            this._failHandler(param1.message.statusCode);
            this._failHandler = null;
            return;
         }
         ErrorMap.parseStatusCode(param1.message.statusCode);
      }
      
      private function update() : void
      {
         var _loc1_:int = 0;
         while(_loc1_ < this._changePropVal.length)
         {
            this._changePropVal[_loc1_] = this._changePropAllVal[_loc1_] - int(this._propList[_loc1_].text);
            this._changePropList[_loc1_].htmlText = this.getChangePropStr(int(this._propList[_loc1_].text),this._changePropAllVal[_loc1_]);
            _loc1_++;
         }
         this._changeVal.htmlText = this.getStrFilter(this._changePropVal[0] + this._changePropVal[1] + this._changePropVal[2] + this._changePropVal[3] + this._changePropVal[4] + this._changePropVal[5]);
         this._actcionUI.visible = true;
         this._sure.visible = false;
         if(this._curSelectType <= 2)
         {
            this._actionSure.visible = this._actionCancel.visible = true;
            this._actionSure.x = this._actionSurePos.x;
            this._actionSure.y = this._actionSure.y;
         }
         else
         {
            this._actionCancel.visible = false;
            this._actionSure.visible = true;
            this._actionSure.x = this._actionSurePos.x + 50;
            this._actionSure.y = this._actionSure.y;
         }
      }
      
      private function updatePetInfoProp() : void
      {
         this._petInfo = PetInfoManager.getPetInfoFromAllBag(this._petInfo.catchTime);
         this._petInfo.potentialAtk = this._changePropAllVal[0];
         this._petInfo.potentialDef = this._changePropAllVal[1];
         this._petInfo.potentialSpAtk = this._changePropAllVal[2];
         this._petInfo.potentialSpDef = this._changePropAllVal[3];
         this._petInfo.potentialSpeed = this._changePropAllVal[4];
         this._petInfo.potentialHp = this._changePropAllVal[5];
         this.setData(this._petInfo);
      }
      
      private function getChangePropStr(param1:int, param2:int) : String
      {
         return this.getStrFilter(param2 - param1);
      }
      
      private function getStrFilter(param1:int) : String
      {
         var _loc2_:String = null;
         if(param1 > 0)
         {
            _loc2_ = "<font color=\'#00ff00\'>+" + param1.toString() + "</font>";
         }
         else if(param1 < 0)
         {
            _loc2_ = "<font color=\'#ff0000\'>" + param1.toString() + "</font>";
         }
         else
         {
            _loc2_ = "<font color=\'#ff0000\'>" + param1.toString() + "</font>";
         }
         return _loc2_;
      }
      
      private function onCoinSelect(param1:MouseEvent) : void
      {
         this._miSelect.gotoAndStop(1);
         this._itemSelect.gotoAndStop(1);
         if(this._coinSelect.currentFrame == 2)
         {
            this._coinSelect.gotoAndStop(1);
            this._curSelectType = -1;
         }
         else
         {
            this._coinSelect.gotoAndStop(2);
            this._curSelectType = 0;
            if(Boolean(QuestManager.isAccepted(83)) && Boolean(QuestManager.isStepComplete(83,8)) && !QuestManager.isStepComplete(83,9) && Boolean(QuestMapHandler_83_80351.isClickQuest83))
            {
               this.hideAllMC();
               if(int(this._allProp.text) < this.COST_NUM[2])
               {
                  this._newQuestMC4.visible = true;
               }
            }
            if(Boolean(QuestManager.isAccepted(99)) && Boolean(QuestManager.isStepComplete(99,4)) && !QuestManager.isStepComplete(99,5) && Boolean(QuestMapHandler_99_80491.isClickQuest99_5))
            {
               this.hideAllMC();
               if(int(this._allProp.text) < this.COST_NUM[2])
               {
                  this._newQuestMC4.visible = true;
               }
            }
         }
      }
      
      private function onItemSelect(param1:MouseEvent) : void
      {
         this._coinSelect.gotoAndStop(1);
         this._miSelect.gotoAndStop(1);
         if(this._itemSelect.currentFrame == 2)
         {
            this._itemSelect.gotoAndStop(1);
            this._curSelectType = -1;
         }
         else
         {
            this._itemSelect.gotoAndStop(2);
            this._curSelectType = 3;
         }
      }
      
      private function onMiSelect(param1:MouseEvent) : void
      {
         this._coinSelect.gotoAndStop(1);
         this._itemSelect.gotoAndStop(1);
         if(this._miSelect.currentFrame == 2)
         {
            this._miSelect.gotoAndStop(1);
            this._curSelectType = -1;
         }
         else
         {
            this._miSelect.gotoAndStop(2);
            this._curSelectType = 1;
         }
      }
      
      public function setData(param1:PetInfo) : void
      {
         this._petInfo = param1;
         this.reSet();
         this.updataDisplay();
         this.updateNewQuest();
      }
      
      private function updateNewQuest() : void
      {
         this.hideAllMC();
         if(Boolean(QuestManager.isAccepted(83)) && Boolean(QuestManager.isStepComplete(83,8)) && !QuestManager.isStepComplete(83,9) && Boolean(QuestMapHandler_83_80351.isClickQuest83))
         {
            this._newQuestMC2.visible = true;
            this._newQuestMC2.addEventListener("click",this.onQuestMC2);
         }
         if(Boolean(QuestManager.isAccepted(99)) && Boolean(QuestManager.isStepComplete(99,4)) && !QuestManager.isStepComplete(99,5) && Boolean(QuestMapHandler_99_80491.isClickQuest99_5))
         {
            this._newQuestMC2.visible = true;
            this._newQuestMC2.addEventListener("click",this.onQuestMC2);
         }
      }
      
      private function onQuestMC2(param1:MouseEvent) : void
      {
         this.hideAllMC();
         this._newQuestMC3.addEventListener("click",this.onQuest3);
         this._newQuestMC3.visible = true;
      }
      
      private function onQuest3(param1:MouseEvent) : void
      {
         this.hideAllMC();
         if(int(this._allProp.text) < this.COST_NUM[2])
         {
            this._newQuestMC4.visible = true;
         }
      }
      
      private function reSet() : void
      {
         var _loc1_:TextField = null;
         var _loc2_:TextField = null;
         for each(_loc1_ in this._changePropList)
         {
            _loc1_.text = "";
         }
         for each(_loc2_ in this._propList)
         {
            _loc2_.text = "";
         }
         this._mainUI["potentialTxt"].text = "";
      }
      
      private function updataDisplay() : void
      {
         this._propList[0].text = this._petInfo.potentialAtk.toString();
         this._propList[1].text = this._petInfo.potentialDef.toString();
         this._propList[2].text = this._petInfo.potentialSpAtk.toString();
         this._propList[3].text = this._petInfo.potentialSpDef.toString();
         this._propList[4].text = this._petInfo.potentialSpeed.toString();
         this._propList[5].text = this._petInfo.potentialHp.toString();
         this._allProp.text = (int(this._propList[0].text) + int(this._propList[1].text) + int(this._propList[2].text) + int(this._propList[3].text) + int(this._propList[4].text) + int(this._propList[5].text)).toString();
         this._level.gotoAndStop(PetInfoManager.getQualityLevel(int(this._allProp.text)) + 1);
         this._upLevelNeed.text = PetInfoManager.getProcessNeedPoint(int(this._allProp.text)).toString();
         this._changeVal.text = "";
         this._sure.mouseEnabled = true;
         this._mainUI["potentialTxt"].text = this._petInfo.potential.toString();
      }
      
      private function sucFunc(param1:IDataInput) : void
      {
         var _loc2_:Parser_1269 = new Parser_1269(param1);
         this._changePropAllVal = _loc2_.changePropList;
         this.updateBaseInfo(_loc2_.basePropList);
         trace("洗练后随机值:(物攻、物防、特攻、特防、速度、血量)",this._changePropAllVal);
         this.update();
         if(Boolean(QuestManager.isAccepted(83)) && Boolean(QuestManager.isStepComplete(83,8)) && !QuestManager.isStepComplete(83,9) && Boolean(QuestMapHandler_83_80351.isClickQuest83))
         {
            this.hideAllMC();
            this._newQuestMC6.visible = true;
         }
         if(Boolean(QuestManager.isAccepted(99)) && Boolean(QuestManager.isStepComplete(99,4)) && !QuestManager.isStepComplete(99,5) && Boolean(QuestMapHandler_99_80491.isClickQuest99_5))
         {
            this.hideAllMC();
            this._newQuestMC6.visible = true;
         }
      }
   }
}

