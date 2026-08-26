package com.taomee.seer2.module.app.newPetDictionary
{
   import com.taomee.seer2.app.actor.ActorManager;
   import com.taomee.seer2.app.arena.util.SkillFieldTable;
   import com.taomee.seer2.app.component.PetDemoDisplayer;
   import com.taomee.seer2.app.config.PetConfig;
   import com.taomee.seer2.app.config.info.PetDictionaryInfo;
   import com.taomee.seer2.app.config.pet.PetDefinition;
   import com.taomee.seer2.app.popup.AlertManager;
   import com.taomee.seer2.app.utils.ActsHelperUtil;
   import com.taomee.seer2.core.module.ModuleManager;
   import com.taomee.seer2.core.scene.SceneManager;
   import com.taomee.seer2.core.ui.UINumberGenerator;
   import com.taomee.seer2.core.ui.toolTip.TooltipManager;
   import com.taomee.seer2.core.utils.DisplayObjectUtil;
   import com.taomee.seer2.core.utils.URLUtil;
   import com.taomee.seer2.core.utils.Util;
   import com.taomee.seer2.module.app.moduleCommon.PetDecorationIcon;
   import com.taomee.seer2.module.app.moduleCommon.PetEmblemIcon;
   import com.taomee.seer2.module.app.moduleCommon.PetFeatureIcon;
   import com.taomee.seer2.module.app.petDictionary.data.PetDictionaryDataServer;
   import com.taomee.seer2.module.app.petDictionary.parser.PetAttributeParser;
   import flash.display.MovieClip;
   import flash.display.SimpleButton;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import flash.events.TextEvent;
   import flash.text.TextField;
   import org.taomee.utils.DisplayUtil;
   
   public class NewPetDicsPetDetailPanel extends Sprite
   {
      
      private var _descriptUI:NewPetDicsDetailUI;
      
      private var _petNameTxt:TextField;
      
      private var _numContainer:Sprite;
      
      private var _petFeatureIcon:PetFeatureIcon;
      
      private var _petEmblemIcon:PetEmblemIcon;
      
      private var _petDecorationIcon:PetDecorationIcon;
      
      private var _petResourceID:uint;
      
      private var _petFlag:int;
      
      private var _petDefinition:PetDefinition;
      
      private var _petHeightTxt:TextField;
      
      private var _petWeightTxt:TextField;
      
      private var _petBornAreaTxt:TextField;
      
      private var _petIntroTxt:TextField;
      
      private var _charaTxt:TextField;
      
      private const SPACESTRING:String = "   ";
      
      private var _petDemoDisplayer:PetDemoDisplayer;
      
      private var _petDemoMask:Sprite;
      
      private var _goBtn:SimpleButton;
      
      private var _starLevel:MovieClip;
      
      private var _changPetBtn:SimpleButton;
      
      private var _prevPetId:uint;
      
      private var _currResId:int;
      
      private var _isChangePet:Boolean;
      
      public function NewPetDicsPetDetailPanel()
      {
         super();
         this.createChildren();
      }
      
      private function createChildren() : void
      {
         this._descriptUI = new NewPetDicsDetailUI();
         addChild(this._descriptUI);
         this._petNameTxt = this._descriptUI["nameTxt"];
         this._petHeightTxt = this._descriptUI["heightTxt"];
         this._petWeightTxt = this._descriptUI["weightTxt"];
         this._petBornAreaTxt = this._descriptUI["bornAreaTxt"];
         this._petIntroTxt = this._descriptUI["introTxt"];
         this._charaTxt = this._descriptUI["charaTxt"];
         this._goBtn = this._descriptUI["goBtn"];
         this._starLevel = this._descriptUI["starLevel"];
         this._changPetBtn = this._descriptUI["changPetBtn"];
         this._changPetBtn.addEventListener("click",this.onChangPet);
         this._numContainer = new Sprite();
         this._numContainer.x = 10;
         this._numContainer.y = 3;
         this._descriptUI.addChild(this._numContainer);
         this._petFeatureIcon = new PetFeatureIcon();
         this._petFeatureIcon.x = 290;
         this._petFeatureIcon.y = 75;
         this._petFeatureIcon.visible = false;
         addChild(this._petFeatureIcon);
         this._petEmblemIcon = new PetEmblemIcon();
         this._petEmblemIcon.x = 320;
         this._petEmblemIcon.y = 97;
         this._petEmblemIcon.visible = false;
         addChild(this._petEmblemIcon);
         this._petDecorationIcon = new PetDecorationIcon();
         this._petDecorationIcon.x = 355;
         this._petDecorationIcon.y = 97;
         this._petDecorationIcon.visible = false;
         addChild(this._petDecorationIcon);
         this._petDemoDisplayer = new PetDemoDisplayer();
         this._petDemoDisplayer.mouseEnabled = false;
         this._petDemoDisplayer.mouseChildren = false;
         addChild(this._petDemoDisplayer);
         this._petDemoMask = new Sprite();
         this._petDemoMask.mouseEnabled = false;
         this._petDemoMask.mouseChildren = false;
         this._petDemoMask.graphics.beginFill(16777215);
         this._petDemoMask.graphics.drawRect(-1,-22,229,253);
         this._petDemoMask.graphics.endFill();
         addChild(this._petDemoMask);
         this._petDemoDisplayer.mask = this._petDemoMask;
         DisplayUtil.removeForParent(this._descriptUI["goBtn"]);
         addChild(this._goBtn);
         DisplayUtil.removeForParent(this._descriptUI["changPetBtn"]);
         addChild(this._changPetBtn);
      }
      
      private function onChangPet(param1:MouseEvent) : void
      {
         if(this._isChangePet)
         {
            this._currResId = this._prevPetId;
            this.changePetDemo();
         }
         else
         {
            this._prevPetId = this._currResId;
            this._currResId = PetConfig.getPetDefinition(this._prevPetId).chgMonId;
            this.changePetDemo();
         }
         this._isChangePet = !this._isChangePet;
      }
      
      public function setData(param1:uint) : void
      {
         this._petResourceID = param1;
         this._petFlag = PetDictionaryDataServer.getPetFlag(param1);
         this._petFeatureIcon.visible = false;
         this._petEmblemIcon.visible = false;
         this._petDecorationIcon.visible = false;
         this._petDefinition = PetConfig.getPetDefinition(this._petResourceID);
         DisplayObjectUtil.removeAllChildren(this._numContainer);
         this._petFeatureIcon.visible = true;
         this._petEmblemIcon.visible = true;
         this._petBornAreaTxt.addEventListener("link",this.linkHandler);
         this.updata();
         this._currResId = this._petResourceID;
         this.changePetDemo();
         this.onGoStateFilter();
         this._goBtn.addEventListener("click",this.onGoBtn);
      }
      
      private function changePetDemo() : void
      {
         var _loc1_:String = String(URLUtil.getPetOriginDemo(this._currResId));
         this._petDemoDisplayer.newSetUrl(_loc1_,199,198,this.onLoadDemo);
      }
      
      private function onLoadDemo() : void
      {
         this._petDemoDisplayer.x = 117;
         this._petDemoDisplayer.y = 126;
      }
      
      public function get petResourceId() : int
      {
         return int(this._petResourceID);
      }
      
      private function updateDes(param1:String) : void
      {
         var _loc2_:* = null;
         var _loc3_:* = param1;
         _loc2_ = _loc3_;
         this._petBornAreaTxt.htmlText = _loc2_;
      }
      
      private function updata() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         var _loc3_:Sprite = null;
         this._petNameTxt.text = SkillFieldTable.getTypeName(this._petDefinition.type) + "   " + this._petDefinition.name;
         this._starLevel.gotoAndStop(PetConfig.getPetDefinition(this._petResourceID).starLevel);
         if(PetConfig.getPetDefinition(this._petResourceID).chgMonId != 0)
         {
            this._changPetBtn.visible = true;
            TooltipManager.addCommonTip(this._changPetBtn,PetConfig.getPetDefinitionInfo(this._petResourceID).changeTip);
         }
         else
         {
            this._changPetBtn.visible = false;
         }
         var _loc4_:int = PetDictionaryDataServer.getNormalizedBaseResourceId(this._petResourceID);
         var _loc5_:String = String(Util.pad(_loc4_.toString(),"0",4,false));
         _loc1_ = 0;
         while(_loc1_ < _loc5_.length)
         {
            _loc2_ = int(_loc5_.charAt(_loc1_));
            _loc3_ = UINumberGenerator.generateLoaderNumber(_loc2_);
            _loc3_.x = _loc1_ * _loc3_.width;
            this._numContainer.addChild(_loc3_);
            _loc1_++;
         }
         this.updateDes(this._petDefinition.foundPlace);
         this._petHeightTxt.text = PetAttributeParser.parseHeightRange(this._petDefinition.heightRange);
         this._petWeightTxt.text = PetAttributeParser.parseWeightRange(this._petDefinition.weightRange);
         this._petFeatureIcon.setFeature(this._petDefinition.featureId,this._petDefinition.featureDescription);
         this._petEmblemIcon.id = this._petDefinition.emblemId;
         if(this._petDefinition.emblem2Id != 0)
         {
            this._petDecorationIcon.visible = true;
            this._petDecorationIcon.id = this._petDefinition.emblem2Id;
         }
         this._charaTxt.text = this._petDefinition.chara;
         this._petIntroTxt.text = "   " + this._petDefinition.description;
         if(this._petDefinition.featureId == 0)
         {
            this._petFeatureIcon.visible = false;
         }
         else
         {
            this._petFeatureIcon.visible = true;
         }
      }
      
      private function linkHandler(param1:TextEvent) : void
      {
         var _loc2_:int = int(param1.text);
         this.onGoBtn(null);
      }
      
      private function onGoBtn(param1:MouseEvent) : void
      {
         var _loc2_:PetDictionaryInfo = null;
         if(Boolean(this._petDefinition))
         {
            _loc2_ = PetConfig.getPetDefinitionInfo(this._petResourceID);
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
                     AlertManager.showAlert("精灵获得途径已下架!");
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
      }
      
      private function onGoStateFilter() : void
      {
         var _loc1_:PetDictionaryInfo = null;
         if(Boolean(this._petDefinition))
         {
            _loc1_ = PetConfig.getPetDefinitionInfo(this._petResourceID);
            if(Boolean(_loc1_))
            {
               if(int(_loc1_.getWay) != 0)
               {
                  DisplayObjectUtil.enableButton(this._goBtn);
               }
               else if(_loc1_.getWay != "")
               {
                  if(_loc1_.isClose == 1)
                  {
                     DisplayObjectUtil.disableButton(this._goBtn);
                  }
                  else
                  {
                     DisplayObjectUtil.enableButton(this._goBtn);
                  }
               }
               else
               {
                  DisplayObjectUtil.disableButton(this._goBtn);
               }
            }
         }
      }
      
      private function changeMap(param1:int) : void
      {
         if(param1 > 0 && param1 != 981)
         {
            if(param1 == 50000)
            {
               if(SceneManager.active.mapID == ActorManager.getActor().id)
               {
                  AlertManager.showAlert("你已经在此地图了！");
               }
               else
               {
                  SceneManager.changeScene(3,ActorManager.getActor().id);
               }
            }
            else if(SceneManager.active.mapID == param1)
            {
               AlertManager.showAlert("你已经在此地图了！");
            }
            else
            {
               SceneManager.changeScene(1,param1);
            }
         }
         else
         {
            AlertManager.showAlert("当前地图不可传送！");
         }
         ModuleManager.closeForName("PetDictionary");
      }
      
      public function hide() : void
      {
         if(Boolean(this._petDemoDisplayer))
         {
            removeChild(this._petDemoDisplayer);
         }
      }
   }
}

