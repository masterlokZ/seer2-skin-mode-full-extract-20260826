package com.taomee.seer2.module.app.newPetDictionary
{
   import com.taomee.seer2.app.component.IconDisplayer;
   import com.taomee.seer2.app.config.PetConfig;
   import com.taomee.seer2.app.config.pet.PetDefinition;
   import com.taomee.seer2.core.cache.CacheManager;
   import com.taomee.seer2.core.effects.MotionEffects;
   import com.taomee.seer2.core.loader.ContentInfo;
   import com.taomee.seer2.core.utils.DisplayObjectUtil;
   import com.taomee.seer2.core.utils.Util;
   import com.taomee.seer2.module.app.petDictionary.data.PetDictionaryDataServer;
   import flash.display.Bitmap;
   import flash.display.BitmapData;
   import flash.display.DisplayObject;
   import flash.display.DisplayObjectContainer;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.geom.Matrix;
   import flash.geom.Rectangle;
   import flash.text.TextField;
   import flash.text.TextFormat;
   
   public class NewPetDicsListCell extends Sprite
   {
      
      private var _cell:NewPetDicsListCellUI;
      
      private var _iconHolder:Sprite;
      
      private var _icon:IconDisplayer;
      
      private var _iconMask:Sprite;
      
      private var _iconTargetWidth:Number;
      
      private var _iconTargetHeight:Number;
      
      private var _modelIconLayer:Sprite;
      
      private var _modelIconContent:DisplayObject;
      
      private var _modelIconBitmap:BitmapData;
      
      private var _modelIconUrl:String;
      
      private var _modelIconType:String;
      
      private var _modelIconPortraitCrop:Boolean;
      
      private var _modelIconFallbackUrl:String;
      
      private var _modelIconUsingFallback:Boolean;
      
      private var _modelIconComplete:Function;
      
      private var _modelIconError:Function;
      
      private var _modelIconSerial:uint;
      
      private var _modelIconWaitFrames:int;
      
      private var _isOpenMC:Sprite;
      
      private var _isGainedMC:MovieClip;
      
      private var _isNewMC:Sprite;
      
      private var _petIdTxt:TextField;
      
      private var _petNameTxt:TextField;
      
      private var _textFormat:TextFormat;
      
      private var _hotArea:Sprite;
      
      public var resourceID:uint;
      
      private var _isSpeak:Boolean;
      
      public function NewPetDicsListCell()
      {
         super();
         this.createChildren();
      }
      
      private function createChildren() : void
      {
         var _loc1_:Number = Number(NaN);
         var _loc2_:Number = Number(NaN);
         this._cell = new NewPetDicsListCellUI();
         addChild(this._cell);
         this._iconHolder = this._cell["iconHolder"];
         _loc1_ = this._iconHolder.width;
         _loc2_ = this._iconHolder.height;
         this._iconTargetWidth = _loc1_;
         this._iconTargetHeight = _loc2_;
         this._isGainedMC = this._cell["isGained"];
         this._isNewMC = this._cell["isNew"];
         this._petIdTxt = this._cell["petNumber"];
         this._isOpenMC = this._cell["isOpen"];
         this._petNameTxt = this._cell["petName"];
         this._textFormat = new TextFormat();
         this._textFormat.color = 16777113;
         this._petIdTxt.defaultTextFormat = this._textFormat;
         this._icon = new IconDisplayer();
         this._icon.scaleX = this._icon.scaleY = 1.5;
         this._icon.x = (this._iconHolder.width - 80) / 2;
         this._icon.y = (this._iconHolder.height - 80) / 2;
         this._iconHolder.addChild(this._icon);
         this._modelIconLayer = new Sprite();
         this._modelIconLayer.mouseEnabled = false;
         this._modelIconLayer.mouseChildren = false;
         this._iconHolder.addChild(this._modelIconLayer);
         this._iconMask = new Sprite();
         this._iconMask.mouseEnabled = false;
         this._iconMask.mouseChildren = false;
         this._iconMask.graphics.beginFill(16777215);
         this._iconMask.graphics.drawRect(0,0,_loc1_,_loc2_);
         this._iconMask.graphics.endFill();
         this._iconHolder.addChild(this._iconMask);
         this._icon.mask = this._iconMask;
         this.buttonMode = true;
         this._isGainedMC.visible = false;
         this._isNewMC.visible = false;
         this._isOpenMC.visible = false;
         this._hotArea = DisplayObjectUtil.createHotArea(85,85);
         this._hotArea.x = -42.5;
         this._hotArea.y = -42.5;
         addChild(this._hotArea);
         this._hotArea.addEventListener("rollOver",this.onHotOver);
         this._hotArea.addEventListener("rollOut",this.onHotOut);
      }
      
      private function onHotOver(param1:MouseEvent) : void
      {
         MotionEffects.execElastic(this._cell);
      }
      
      private function onHotOut(param1:MouseEvent) : void
      {
         MotionEffects.resetScale(this._cell);
      }
      
      public function setData(param1:uint, param2:Boolean) : void
      {
         var _loc3_:int = 0;
         var _loc4_:int = int(param1);
         var _loc5_:PetDefinition = null;
         var _loc6_:Boolean = false;
         var _loc7_:String = null;
         this.resourceID = param1;
         if(param1 == 0)
         {
            return;
         }
         _loc5_ = PetConfig.getPetDefinition(param1);
         this._petIdTxt.text = Util.pad(_loc4_.toString(),"0",4,false);
         this._petNameTxt.text = _loc5_ == null ? "" : _loc5_.name;
         if(_loc5_ == null)
         {
            this._isOpenMC.visible = true;
            return;
         }
         this.clearModelIcon();
         _loc6_ = PetDictionaryDataServer.usesExternalModelIcon(param1);
         _loc7_ = PetDictionaryDataServer.getPetIconUrl(param1);
         if(PetDictionaryDataServer.isOfficialIdOverride(param1))
         {
            this._icon.visible = true;
            this._modelIconLayer.mask = null;
            this._icon.mask = null;
            this._iconMask.visible = false;
            this._icon.setBoundary(Number.NaN,Number.NaN);
            this._icon.setIconUrl(_loc7_);
         }
         else if(_loc6_)
         {
            this._iconMask.visible = true;
            this._modelIconLayer.mask = this._iconMask;
            this._icon.visible = false;
            this.loadModelIcon(_loc7_,PetDictionaryDataServer.usesFightSnapshotIcon(param1),PetDictionaryDataServer.getPetAvatarFallbackModelUrl(param1));
         }
         else
         {
            this._icon.visible = true;
            this._modelIconLayer.mask = null;
            this._icon.mask = null;
            this._iconMask.visible = false;
            this._icon.setBoundary(Number.NaN,Number.NaN);
            this._icon.setIconUrl(_loc7_);
         }
         _loc3_ = PetDictionaryDataServer.getPetFlag(param1);
         if(_loc3_ == 0 || _loc3_ == 1)
         {
            this._textFormat.color = 65535;
            this._petIdTxt.setTextFormat(this._textFormat);
            this._isGainedMC.visible = true;
            this._isGainedMC.gotoAndStop(2);
         }
         else
         {
            DisplayObjectUtil.recoverDisplayObject(this._icon);
            if(_loc3_ == 2)
            {
               this._isGainedMC.visible = true;
               this._isGainedMC.gotoAndStop(1);
            }
         }
         if(PetDictionaryDataServer.isSkinResource(param1))
         {
            this._isGainedMC.visible = false;
         }
         else
         {
            this._isGainedMC.visible = true;
         }
         if(PetConfig.isPetNew(param1))
         {
            this._isNewMC.visible = true;
         }
      }
      
      public function clear() : void
      {
         this.clearModelIcon();
         this._icon.dispose();
         this._isGainedMC.visible = false;
         this._isNewMC.visible = false;
         this._isOpenMC.visible = false;
         this._petIdTxt.text = "";
         this._petNameTxt.text = "";
      }
      
      private function onOfficialIconSettled(param1:uint, param2:uint) : void
      {
         var _loc3_:String = null;
         if(param2 != this._modelIconSerial || this.resourceID != param1 || this._icon.icon != null)
         {
            return;
         }
         _loc3_ = PetDictionaryDataServer.getPetAvatarFallbackModelUrl(param1);
         if(_loc3_ == null || _loc3_.length == 0)
         {
            return;
         }
         this._iconMask.visible = true;
         this._modelIconLayer.mask = this._iconMask;
         this._icon.visible = false;
         this.loadModelIcon(_loc3_,true);
      }
      
      private function loadModelIcon(param1:String, param2:Boolean = false, param3:String = null) : void
      {
         var serial:uint = 0;
         var url:String = param1;
         if(url == null || url.length == 0)
         {
            return;
         }
         serial = ++this._modelIconSerial;
         this._modelIconUrl = url;
         this._modelIconPortraitCrop = param2;
         this._modelIconFallbackUrl = param3;
         this._modelIconUsingFallback = false;
         this._modelIconType = "phasor";
         this._modelIconComplete = function(param1:ContentInfo):void
         {
            onModelIconLoaded(param1,serial);
         };
         this._modelIconError = function(param1:ContentInfo):void
         {
            onModelIconError(param1,serial);
         };
         CacheManager.getContent(url,this._modelIconType,this._modelIconComplete,this._modelIconError);
      }
      
      private function onModelIconLoaded(param1:ContentInfo, param2:uint) : void
      {
         if(param2 != this._modelIconSerial)
         {
            return;
         }
         if(param1 == null || param1.content == null)
         {
            this.tryPetModelIcon(param2);
            return;
         }
         this.showModelIcon(param1.content as DisplayObject,this._modelIconType == "pet");
      }
      
      private function onModelIconError(param1:ContentInfo, param2:uint) : void
      {
         if(param2 != this._modelIconSerial)
         {
            return;
         }
         this.tryPetModelIcon(param2);
      }
      
      private function tryPetModelIcon(param1:uint) : void
      {
         if(param1 != this._modelIconSerial)
         {
            return;
         }
         if(this._modelIconType != "pet")
         {
            this._modelIconType = "pet";
            CacheManager.getContent(this._modelIconUrl,this._modelIconType,this._modelIconComplete,this._modelIconError);
            return;
         }
         this.tryFallbackModelIcon();
      }
      
      private function tryFallbackModelIcon() : Boolean
      {
         if(this._modelIconUsingFallback || this._modelIconFallbackUrl == null || this._modelIconFallbackUrl.length == 0 || this._modelIconFallbackUrl == this._modelIconUrl)
         {
            return false;
         }
         if(this._modelIconContent != null)
         {
            this._modelIconContent.removeEventListener(Event.ENTER_FRAME,this.onModelIconFrame);
         }
         while(this._modelIconLayer.numChildren > 0)
         {
            this._modelIconLayer.removeChildAt(0);
         }
         this._modelIconContent = null;
         this._modelIconUsingFallback = true;
         this._modelIconUrl = this._modelIconFallbackUrl;
         this._modelIconPortraitCrop = true;
         this._modelIconType = "phasor";
         CacheManager.getContent(this._modelIconUrl,this._modelIconType,this._modelIconComplete,this._modelIconError);
         return true;
      }
      
      private function showModelIcon(param1:DisplayObject, param2:Boolean) : void
      {
         if(param1 == null)
         {
            return;
         }
         this._modelIconContent = param1;
         this._modelIconLayer.addChild(param1);
         if(param2)
         {
            this._modelIconWaitFrames = 0;
            param1.addEventListener(Event.ENTER_FRAME,this.onModelIconFrame);
         }
         else
         {
            this.stopCurrentFrames(param1);
            this.snapshotModelIcon(param1);
         }
      }
      
      private function onModelIconFrame(param1:Event) : void
      {
         var _loc2_:Rectangle = null;
         if(this._modelIconContent == null)
         {
            return;
         }
         ++this._modelIconWaitFrames;
         _loc2_ = this._modelIconContent.getBounds(this._modelIconContent);
         if(this._modelIconWaitFrames >= 2 && _loc2_.width > 1 && _loc2_.height > 1 || this._modelIconWaitFrames >= 30)
         {
            this._modelIconContent.removeEventListener(Event.ENTER_FRAME,this.onModelIconFrame);
            this.stopCurrentFrames(this._modelIconContent);
            this.snapshotModelIcon(this._modelIconContent);
         }
      }
      
      private function snapshotModelIcon(param1:DisplayObject) : void
      {
         var content:DisplayObject = param1;
         var bounds:Rectangle = null;
         var targetWidth:Number = this._iconTargetWidth;
         var targetHeight:Number = this._iconTargetHeight;
         var scale:Number = Number(NaN);
         var matrix:Matrix = null;
         var bitmap:Bitmap = null;
         if(content == null || targetWidth <= 1 || targetHeight <= 1)
         {
            return;
         }
         content.scaleX = content.scaleY = 1;
         content.x = content.y = 0;
         bounds = content.getBounds(content);
         if(bounds.width <= 1 || bounds.height <= 1)
         {
            this.tryFallbackModelIcon();
            return;
         }
         if(this._modelIconPortraitCrop && this.snapshotPortraitModelIcon(content,bounds,targetWidth,targetHeight))
         {
            return;
         }
         scale = Math.min(targetWidth / bounds.width,targetHeight / bounds.height);
         matrix = new Matrix();
         matrix.scale(scale,scale);
         matrix.translate(-bounds.x * scale + (targetWidth - bounds.width * scale) / 2,-bounds.y * scale + (targetHeight - bounds.height * scale) / 2);
         if(this._modelIconBitmap != null)
         {
            this._modelIconBitmap.dispose();
         }
         this._modelIconBitmap = new BitmapData(Math.max(1,int(Math.ceil(targetWidth))),Math.max(1,int(Math.ceil(targetHeight))),true,0);
         try
         {
            this._modelIconBitmap.draw(content,matrix,null,null,null,true);
         }
         catch(drawError:*)
         {
            this._modelIconBitmap.dispose();
            this._modelIconBitmap = null;
            if(this.tryFallbackModelIcon())
            {
               return;
            }
            this.fitModelIcon(content);
            return;
         }
         while(this._modelIconLayer.numChildren > 0)
         {
            this._modelIconLayer.removeChildAt(0);
         }
         bitmap = new Bitmap(this._modelIconBitmap,"auto",true);
         this._modelIconContent = bitmap;
         this._modelIconLayer.addChild(bitmap);
      }
      
      private function snapshotPortraitModelIcon(param1:DisplayObject, param2:Rectangle, param3:Number, param4:Number) : Boolean
      {
         var _loc5_:Number = Math.min(1,320 / Math.max(param2.width,param2.height));
         var _loc6_:int = Math.max(1,int(Math.ceil(param2.width * _loc5_)));
         var _loc7_:int = Math.max(1,int(Math.ceil(param2.height * _loc5_)));
         var _loc8_:BitmapData = null;
         var _loc9_:Matrix = new Matrix();
         var _loc10_:Vector.<uint> = null;
         var _loc11_:int = _loc6_ + 1;
         var _loc12_:Vector.<Number> = new Vector.<Number>(_loc11_ * (_loc7_ + 1),true);
         var _loc13_:int = _loc6_;
         var _loc14_:int = _loc7_;
         var _loc15_:int = -1;
         var _loc16_:int = -1;
         var _loc17_:int = 0;
         var _loc18_:int = 0;
         var _loc19_:int = 0;
         var _loc20_:uint = 0;
         var _loc21_:Number = 0;
         var _loc22_:Number = 0;
         var _loc23_:int = 0;
         var _loc24_:int = 0;
         var _loc25_:int = 0;
         var _loc26_:int = 0;
         var _loc27_:int = 0;
         var _loc28_:int = 0;
         var _loc29_:int = 0;
         var _loc30_:int = 0;
         var _loc31_:int = 0;
         var _loc32_:int = 0;
         var _loc33_:Number = 0;
         var _loc34_:Number = -1;
         var _loc35_:Number = 0;
         var _loc36_:Number = 0;
         var _loc37_:Number = 0;
         var _loc38_:Number = 0;
         var _loc39_:Number = 0;
         var _loc40_:Matrix = null;
         var _loc41_:BitmapData = null;
         var _loc42_:Bitmap = null;
         _loc9_.scale(_loc5_,_loc5_);
         _loc9_.translate(-param2.x * _loc5_,-param2.y * _loc5_);
         try
         {
            _loc8_ = new BitmapData(_loc6_,_loc7_,true,0);
            _loc8_.draw(param1,_loc9_,null,null,null,true);
            _loc10_ = _loc8_.getVector(_loc8_.rect);
            _loc19_ = 0;
            _loc18_ = 0;
            while(_loc18_ < _loc7_)
            {
               _loc21_ = 0;
               _loc17_ = 0;
               while(_loc17_ < _loc6_)
               {
                  _loc20_ = uint(_loc10_[_loc19_++] >>> 24);
                  _loc22_ = _loc20_ >= 16 ? _loc20_ : 0;
                  _loc21_ += _loc22_;
                  _loc12_[(_loc18_ + 1) * _loc11_ + _loc17_ + 1] = _loc12_[_loc18_ * _loc11_ + _loc17_ + 1] + _loc21_;
                  if(_loc22_ > 0)
                  {
                     if(_loc17_ < _loc13_)
                     {
                        _loc13_ = _loc17_;
                     }
                     if(_loc18_ < _loc14_)
                     {
                        _loc14_ = _loc18_;
                     }
                     if(_loc17_ > _loc15_)
                     {
                        _loc15_ = _loc17_;
                     }
                     if(_loc18_ > _loc16_)
                     {
                        _loc16_ = _loc18_;
                     }
                  }
                  _loc17_++;
               }
               _loc18_++;
            }
         }
         catch(sampleError:*)
         {
            if(_loc8_ != null)
            {
               _loc8_.dispose();
            }
            return false;
         }
         if(_loc15_ < _loc13_ || _loc16_ < _loc14_)
         {
            _loc8_.dispose();
            return false;
         }
         _loc23_ = _loc15_ - _loc13_ + 1;
         _loc24_ = _loc16_ - _loc14_ + 1;
         _loc25_ = Math.max(8,int(Math.ceil(Math.max(_loc23_,_loc24_) * 0.56)));
         _loc25_ = Math.min(_loc25_,Math.min(_loc6_,_loc7_));
         _loc26_ = Math.max(0,_loc13_ - _loc25_ + 1);
         _loc27_ = Math.min(_loc6_ - _loc25_,_loc15_);
         _loc28_ = Math.max(0,_loc14_ - _loc25_ + 1);
         _loc29_ = Math.min(_loc7_ - _loc25_,_loc16_);
         _loc30_ = Math.max(1,int(_loc25_ / 32));
         _loc37_ = (_loc13_ + _loc15_ + 1) / 2;
         _loc38_ = _loc14_ + _loc24_ * 0.38;
         _loc31_ = _loc28_;
         while(_loc31_ <= _loc29_)
         {
            _loc32_ = _loc26_;
            while(_loc32_ <= _loc27_)
            {
               _loc33_ = _loc12_[(_loc31_ + _loc25_) * _loc11_ + _loc32_ + _loc25_] - _loc12_[_loc31_ * _loc11_ + _loc32_ + _loc25_] - _loc12_[(_loc31_ + _loc25_) * _loc11_ + _loc32_] + _loc12_[_loc31_ * _loc11_ + _loc32_];
               _loc35_ = Math.abs(_loc32_ + _loc25_ / 2 - _loc37_) / Math.max(1,_loc23_ / 2);
               _loc36_ = Math.abs(_loc31_ + _loc25_ / 2 - _loc38_) / Math.max(1,_loc24_ / 2);
               _loc39_ = _loc33_ * (1 - Math.min(0.35,_loc35_ * 0.08 + _loc36_ * 0.22));
               if(_loc39_ > _loc34_)
               {
                  _loc34_ = _loc39_;
                  _loc17_ = _loc32_;
                  _loc18_ = _loc31_;
               }
               _loc32_ += _loc30_;
            }
            _loc31_ += _loc30_;
         }
         if(_loc34_ < 0)
         {
            _loc8_.dispose();
            return false;
         }
         _loc40_ = new Matrix();
         _loc40_.scale(80 / _loc25_,80 / _loc25_);
         _loc40_.translate(-_loc17_ * 80 / _loc25_,-_loc18_ * 80 / _loc25_);
         _loc41_ = new BitmapData(80,80,true,0);
         try
         {
            _loc41_.draw(_loc8_,_loc40_,null,null,null,true);
         }
         catch(portraitError:*)
         {
            _loc41_.dispose();
            _loc8_.dispose();
            return false;
         }
         _loc8_.dispose();
         if(this._modelIconBitmap != null)
         {
            this._modelIconBitmap.dispose();
         }
         this._modelIconBitmap = _loc41_;
         while(this._modelIconLayer.numChildren > 0)
         {
            this._modelIconLayer.removeChildAt(0);
         }
         _loc42_ = new Bitmap(this._modelIconBitmap,"auto",true);
         _loc42_.x = (param3 - 80) / 2;
         _loc42_.y = (param4 - 80) / 2;
         this._modelIconContent = _loc42_;
         this._modelIconLayer.addChild(_loc42_);
         return true;
      }
      
      private function fitModelIcon(param1:DisplayObject) : void
      {
         var _loc2_:Rectangle = null;
         var _loc3_:Number = this._iconTargetWidth;
         var _loc4_:Number = this._iconTargetHeight;
         var _loc5_:Number = Number(NaN);
         param1.scaleX = param1.scaleY = 1;
         param1.x = param1.y = 0;
         _loc2_ = param1.getBounds(param1);
         if(_loc2_.width <= 1 || _loc2_.height <= 1)
         {
            return;
         }
         _loc5_ = Math.min(_loc3_ / _loc2_.width,_loc4_ / _loc2_.height);
         param1.scaleX = param1.scaleY = _loc5_;
         param1.x = -_loc2_.x * _loc5_ + (_loc3_ - _loc2_.width * _loc5_) / 2;
         param1.y = -_loc2_.y * _loc5_ + (_loc4_ - _loc2_.height * _loc5_) / 2;
      }
      
      private function stopCurrentFrames(param1:DisplayObject) : void
      {
         var _loc2_:MovieClip = param1 as MovieClip;
         var _loc3_:DisplayObjectContainer = param1 as DisplayObjectContainer;
         var _loc4_:* = 0;
         if(_loc2_ != null)
         {
            _loc2_.stop();
         }
         if(_loc3_ != null)
         {
            _loc4_ = int(_loc3_.numChildren - 1);
            while(_loc4_ >= 0)
            {
               this.stopCurrentFrames(_loc3_.getChildAt(_loc4_));
               _loc4_--;
            }
         }
      }
      
      private function clearModelIcon() : void
      {
         ++this._modelIconSerial;
         if(this._modelIconUrl != null && this._modelIconComplete != null)
         {
            CacheManager.cancel(this._modelIconUrl,"phasor",this._modelIconComplete);
            CacheManager.cancel(this._modelIconUrl,"pet",this._modelIconComplete);
         }
         if(this._modelIconContent != null)
         {
            this._modelIconContent.removeEventListener(Event.ENTER_FRAME,this.onModelIconFrame);
         }
         while(this._modelIconLayer.numChildren > 0)
         {
            this._modelIconLayer.removeChildAt(0);
         }
         if(this._modelIconBitmap != null)
         {
            this._modelIconBitmap.dispose();
            this._modelIconBitmap = null;
         }
         this._modelIconContent = null;
         this._modelIconUrl = null;
         this._modelIconType = null;
         this._modelIconPortraitCrop = false;
         this._modelIconFallbackUrl = null;
         this._modelIconUsingFallback = false;
         this._modelIconComplete = null;
         this._modelIconError = null;
      }
   }
}

