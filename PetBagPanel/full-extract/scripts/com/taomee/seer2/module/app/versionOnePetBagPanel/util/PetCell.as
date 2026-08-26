package com.taomee.seer2.module.app.versionOnePetBagPanel.util
{
   import com.taomee.seer2.app.component.IconDisplayer;
   import com.taomee.seer2.app.pet.data.PetInfo;
   import com.taomee.seer2.app.popup.AlertManager;
   import com.taomee.seer2.core.config.ClientConfig;
   import com.taomee.seer2.core.effects.MotionEffects;
   import com.taomee.seer2.core.module.ModuleManager;
   import com.taomee.seer2.core.scene.SceneManager;
   import com.taomee.seer2.core.utils.DisplayObjectUtil;
   import com.taomee.seer2.core.utils.URLUtil;
   import com.taomee.seer2.module.app.moduleCommon.PetEmblemIcon;
   import flash.display.MovieClip;
   import flash.display.Shape;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.geom.Rectangle;
   import flash.text.TextField;
   
   public class PetCell extends Sprite
   {
      
      public static const FIRST:String = "first";
      
      public static const FIGHT:String = "fight";
      
      public static const SELECT:String = "select";
      
      private var _mainUI:MovieClip;
      
      private var _content:Sprite;
      
      private var _levelTxt:TextField;
      
      private var _hpBar:Sprite;
      
      private var _hpTxt:TextField;
      
      private var _levelBackground:Sprite;
      
      private var _lightMc:MovieClip;
      
      private var _selector:MovieClip;
      
      private var _bgCell:Sprite;
      
      private var _fightStateMC:MovieClip;
      
      private var _openStateMC:MovieClip;
      
      private var _icon:IconDisplayer;
      
      private var _snapshotIcon:PetIconPreviewViewport;
      
      private var _iconHost:Sprite;
      
      private var _iconMask:Shape;
      
      private var _previewSerial:uint;
      
      private var _hotArea:Sprite;
      
      private var _info:PetInfo;
      
      private var _isBigUI:Boolean;
      
      private var _fightState:String;
      
      private var border:MovieClip;
      
      private var embIcon:PetEmblemIcon;
      
      public function PetCell(param1:MovieClip, param2:Boolean = false, param3:String = "select")
      {
         super();
         this._mainUI = param1;
         this._isBigUI = param2;
         this._fightState = param3;
         this.createChildren();
      }
      
      private function createChildren() : void
      {
         addChild(this._mainUI);
         this._content = this._mainUI["content"];
         this._levelTxt = this._content["levelTxt"];
         this._hpBar = this._content["HP"];
         this._hpTxt = this._content["hpText"];
         this._levelBackground = this._content["levelBg"];
         this._lightMc = this._content["light"];
         if(Boolean(this._lightMc))
         {
            this._lightMc.gotoAndStop(1);
         }
         this._selector = this._content["selector"];
         this._bgCell = this._content["bgCell"];
         this._icon = new IconDisplayer();
         this._icon.scaleX = this._icon.scaleY = 1.5;
         if(this._isBigUI)
         {
            this._icon.x = 25;
            this._icon.y = 30;
         }
         else
         {
            this._icon.x = this._icon.y = -40;
            this._icon.x = -42;
         }
         this.attachIconHost();
         this._mainUI.mouseChildren = this._mainUI.mouseEnabled = false;
         this.embIcon = new PetEmblemIcon();
         this.embIcon.scaleX = 1;
         this.embIcon.scaleY = 1;
         this.embIcon.x = -45;
         this.embIcon.y = -43;
         this._content.addChild(this.embIcon);
         this._hotArea = DisplayObjectUtil.createHotArea(this._bgCell.width,this._bgCell.height);
         this._hotArea.buttonMode = true;
         addChild(this._hotArea);
         this._hotArea.addEventListener("mouseOver",this.onMouseOver);
         this._hotArea.addEventListener("mouseOut",this.onMouseOut);
         this._fightStateMC = this._mainUI["fightStateMC"];
         this._fightStateMC.gotoAndStop(this._fightState);
         this._openStateMC = this._content["openStateMC"];
         if(this._fightState != "select")
         {
            this._openStateMC.visible = false;
         }
      }
      
      private function onMouseOver(param1:MouseEvent) : void
      {
         if(Boolean(this._lightMc))
         {
            this._lightMc.addEventListener("enterFrame",this.onLightMcEnter);
            this._lightMc.gotoAndPlay(1);
         }
         MotionEffects.execElastic(this._content);
      }
      
      public function get() : void
      {
      }
      
      private function onMouseOut(param1:MouseEvent) : void
      {
         MotionEffects.resetScale(this._content);
      }
      
      private function onLightMcEnter(param1:Event) : void
      {
         if(this._lightMc.currentFrame == this._lightMc.totalFrames)
         {
            this._lightMc.removeEventListener("enterFrame",this.onLightMcEnter);
            this._lightMc.gotoAndStop(1);
         }
      }
      
      private function updateDisplay() : void
      {
         var _loc1_:String = null;
         var _loc2_:uint = 0;
         this.updatePreview();
         this.updateSimpleInfo();
         this.setChildrenVisible(true);
         if(Boolean(this.border))
         {
            DisplayObjectUtil.removeFromParent(this.border);
            this._bgCell.visible = true;
         }
      }
      
      private function updatePreview() : void
      {
         var url:String = null;
         var resourceId:uint = 0;
         var serial:uint = 0;
         url = String(URLUtil.getPetIcon(this._info.resourceId));
         resourceId = uint(this._info.resourceId);
         serial = ++this._previewSerial;
         this.removeSnapshotIcon();
         this._icon.visible = true;
         PetIconPreviewViewport.resolveOfficialIconRoute(resourceId,function(param1:Boolean):void
         {
            if(serial != _previewSerial || _info == null || _info.resourceId != resourceId)
            {
               return;
            }
            if(param1)
            {
               loadOfficialIconWithModelFallback(resourceId,serial);
               return;
            }
            _icon.setIconUrl(url,onContentLoaded);
            PetIconPreviewViewport.resolveFightDerivedIconRoute(resourceId,function(param1:Boolean):void
            {
               if(!param1 || serial != _previewSerial || _info == null || _info.resourceId != resourceId)
               {
                  return;
               }
               PetIconPreviewViewport.resolveModelRouteType(resourceId,function(param1:String):void
               {
                  if(serial != _previewSerial || _info == null || _info.resourceId != resourceId)
                  {
                     return;
                  }
                  showFightDerivedSnapshot(resolveModelUrl(resourceId,param1,url));
               });
            });
         });
         this.embIcon.id = 0;
         this.embIcon.visible = false;
         if(this._info.emblemId != 0)
         {
            this.embIcon.visible = false;
            this.embIcon.id = this._info.emblemId;
         }
      }
      
      private function loadOfficialIconWithModelFallback(param1:uint, param2:uint) : void
      {
         var resourceId:uint = param1;
         var serial:uint = param2;
         var officialUrl:String = URLUtil.getPetIcon(resourceId);
         this._icon.setIconUrl(officialUrl,function():void
         {
            if(serial != _previewSerial || _info == null || _info.resourceId != resourceId)
            {
               return;
            }
            if(_icon.icon != null)
            {
               onContentLoaded();
               return;
            }
            PetIconPreviewViewport.resolveModelRouteType(resourceId,function(param1:String):void
            {
               if(serial != _previewSerial || _info == null || _info.resourceId != resourceId)
               {
                  return;
               }
               if(param1 == "")
               {
                  onContentLoaded();
                  return;
               }
               showFightDerivedSnapshot(resolveModelUrl(resourceId,param1,null));
            });
         });
      }
      
      private function resolveModelUrl(param1:uint, param2:String, param3:String) : String
      {
         if(param2 == "fight" || param2 == "normal")
         {
            return URLUtil.rewrite(ClientConfig.rootURL + "launcher/pet-preview/" + param2 + "/" + param1 + ".swf");
         }
         return param3;
      }
      
      private function showFightDerivedSnapshot(param1:String) : void
      {
         var _loc2_:Rectangle = this._iconHost.scrollRect;
         this._icon.removeIcon();
         this._icon.visible = false;
         this.removeSnapshotIcon();
         this._snapshotIcon = new PetIconPreviewViewport(_loc2_.width,_loc2_.height);
         this._iconHost.addChild(this._snapshotIcon);
         this._snapshotIcon.setIconUrl(param1,this.onContentLoaded);
      }
      
      private function attachIconHost() : void
      {
         var _loc1_:Rectangle = this.resolveIconSafeBounds();
         var _loc2_:Number = Number(this._icon.x);
         var _loc3_:Number = Number(this._icon.y);
         this._iconHost = new Sprite();
         this._iconHost.mouseEnabled = false;
         this._iconHost.mouseChildren = false;
         this._iconHost.x = _loc1_.x;
         this._iconHost.y = _loc1_.y;
         this._iconHost.scrollRect = new Rectangle(0,0,_loc1_.width,_loc1_.height);
         this._content.addChildAt(this._iconHost,1);
         this._iconMask = new Shape();
         this._iconMask.graphics.beginFill(16777215,1);
         this._iconMask.graphics.drawRect(_loc1_.x,_loc1_.y,_loc1_.width,_loc1_.height);
         this._iconMask.graphics.endFill();
         this._content.addChildAt(this._iconMask,2);
         this._iconHost.mask = this._iconMask;
         this._icon.x = _loc2_ - _loc1_.x;
         this._icon.y = _loc3_ - _loc1_.y;
         this._iconHost.addChild(this._icon);
      }
      
      private function resolveIconSafeBounds() : Rectangle
      {
         var _loc1_:Rectangle = null;
         var _loc2_:Number = 3;
         try
         {
            _loc1_ = this._bgCell.getBounds(this._content);
         }
         catch(error:Error)
         {
         }
         if(_loc1_ != null && isFinite(_loc1_.x) && isFinite(_loc1_.y) && isFinite(_loc1_.width) && isFinite(_loc1_.height) && _loc1_.width > _loc2_ * 2 && _loc1_.height > _loc2_ * 2)
         {
            return new Rectangle(_loc1_.x + _loc2_,_loc1_.y + _loc2_,_loc1_.width - _loc2_ * 2,_loc1_.height - _loc2_ * 2);
         }
         if(this._isBigUI)
         {
            return new Rectangle(25,30,80,80);
         }
         return new Rectangle(-42,-40,80,80);
      }
      
      private function removeSnapshotIcon() : void
      {
         if(this._snapshotIcon != null)
         {
            this._snapshotIcon.dispose();
            DisplayObjectUtil.removeFromParent(this._snapshotIcon);
            this._snapshotIcon = null;
         }
      }
      
      private function updateSimpleInfo() : void
      {
         this._levelTxt.text = String(this._info.level);
         this._hpTxt.text = this._info.hp.toString() + "/" + this._info.maxHp.toString();
         this._hpBar.scaleX = this._info.hp / this._info.maxHp;
         if(this._hpBar.scaleX > 1)
         {
            this._hpBar.scaleX = 1;
         }
      }
      
      public function get openStateMC() : MovieClip
      {
         return this._openStateMC;
      }
      
      private function onContentLoaded() : void
      {
         DisplayObjectUtil.enableSprite(this);
      }
      
      private function setChildrenVisible(param1:Boolean) : void
      {
         this._hpBar.visible = param1;
         this._levelTxt.visible = param1;
         this._levelBackground.visible = param1;
         this._hpTxt.visible = param1;
      }
      
      private function onPetRideIcon(param1:MouseEvent) : void
      {
         var e:MouseEvent = param1;
         AlertManager.showConfirm("是否前往骑宠驯化场？",function():void
         {
            if(SceneManager.active.mapID != 1600)
            {
               SceneManager.changeScene(1,1600);
            }
            ModuleManager.closeForName("PetBagPanel");
         });
      }
      
      public function setPetInfo(param1:PetInfo) : void
      {
         this.reset();
         this._info = param1;
         if(this._info != null)
         {
            this.mouseEnabled = true;
            this.updateDisplay();
         }
      }
      
      public function reset() : void
      {
         DisplayObjectUtil.disableSprite(this);
         ++this._previewSerial;
         this.removeSnapshotIcon();
         this._icon.visible = true;
         this._icon.removeIcon();
         this.setChildrenVisible(false);
         this.mouseEnabled = false;
         this._bgCell.visible = true;
         this.embIcon.visible = false;
         this.embIcon.id = 0;
         if(Boolean(this.border))
         {
            DisplayObjectUtil.removeFromParent(this.border);
         }
         this._info = null;
      }
      
      public function set selected(param1:Boolean) : void
      {
         this._selector.visible = param1;
         if(Boolean(this._info) && this._info.getPetDefinition().chgMonId != 0)
         {
            this._selector.gotoAndStop(2);
         }
         else
         {
            this._selector.gotoAndStop(1);
         }
      }
      
      public function get petInfo() : PetInfo
      {
         return this._info;
      }
   }
}

