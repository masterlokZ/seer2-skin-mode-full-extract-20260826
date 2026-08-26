package com.taomee.seer2.module.app
{
   import com.taomee.seer2.app.component.IconDisplayer;
   import com.taomee.seer2.app.config.PetConfig;
   import com.taomee.seer2.app.config.pet.PetDefinition;
   import com.taomee.seer2.app.pet.data.PetInfo;
   import com.taomee.seer2.core.cache.CacheManager;
   import com.taomee.seer2.core.config.ClientConfig;
   import com.taomee.seer2.core.effects.MotionEffects;
   import com.taomee.seer2.core.loader.ContentInfo;
   import com.taomee.seer2.core.utils.DisplayObjectUtil;
   import com.taomee.seer2.core.utils.URLUtil;
   import com.taomee.seer2.module.app.UI.PetCellUI;
   import flash.display.Bitmap;
   import flash.display.BitmapData;
   import flash.display.DisplayObject;
   import flash.display.DisplayObjectContainer;
   import flash.display.Loader;
   import flash.display.MovieClip;
   import flash.display.Shape;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.IOErrorEvent;
   import flash.events.MouseEvent;
   import flash.events.SecurityErrorEvent;
   import flash.geom.Matrix;
   import flash.geom.Rectangle;
   import flash.net.URLRequest;
   import flash.text.TextField;
   
   public class PetCell extends Sprite
   {
      
      private static const AVATAR_CACHE_BUDGET_BYTES:uint = 64 * 1024 * 1024;
      
      private static var _avatarBitmapCache:Object = {};
      
      private static var _avatarBitmapCacheKeys:Vector.<String> = new Vector.<String>();
      
      private static var _avatarBitmapCacheBytes:uint = 0;
      
      private var _container:MovieClip;
      
      private var _nameTxt:TextField;
      
      private var _content:Sprite;
      
      private var _lightMc:MovieClip;
      
      private var _hotArea:Sprite;
      
      private var _selector:Sprite;
      
      private var _info:PetInfo;
      
      private var _skinId:uint;
      
      private var _icon:IconDisplayer;
      
      private var _iconMask:Shape;
      
      private var _modelIconLayer:Sprite;
      
      private var _modelIconContent:DisplayObject;
      
      private var _modelIconBitmap:BitmapData;
      
      private var _modelIconUrl:String;
      
      private var _modelIconType:String;
      
      private var _modelIconComplete:Function;
      
      private var _modelIconError:Function;
      
      private var _modelIconSerial:uint;
      
      private var _modelIconWaitFrames:int;
      
      private var _modelIconCacheKey:String;
      
      private var _modelIconResourceId:uint;
      
      private var _modelIconFallbackIndex:int;
      
      private var _modelIconLoader:Loader;
      
      private var _modelIconUncached:Boolean;
      
      private var _modelIconLoaderSerial:uint;
      
      private var _modelIconAvatarKind:String;
      
      private var _modelIconUsePortraitCrop:Boolean;
      
      private var _skinType:Boolean;
      
      private var _constrainIcon:Boolean;
      
      private var _displayName:String;
      
      public function PetCell()
      {
         super();
         this._skinType = false;
         this._container = new PetCellUI();
         addChild(this._container);
         this._nameTxt = this._container["nameTxt"];
         this._content = this._container["content"];
         this._lightMc = this._content["light"];
         if(Boolean(this._lightMc))
         {
            this._lightMc.gotoAndStop(1);
         }
         this._selector = this._content["selector"];
         this._icon = new IconDisplayer();
         this._icon.scaleY = this._icon.scaleX = 1.5;
         this._icon.x = this._icon.y = -40;
         this._content.addChildAt(this._icon,1);
         this._modelIconLayer = new Sprite();
         this._modelIconLayer.mouseEnabled = false;
         this._modelIconLayer.mouseChildren = false;
         this._modelIconLayer.x = -40;
         this._modelIconLayer.y = -40;
         this._content.addChildAt(this._modelIconLayer,2);
         this._iconMask = new Shape();
         this._iconMask.graphics.beginFill(16777215);
         this._iconMask.graphics.drawRect(-40,-40,80,80);
         this._iconMask.graphics.endFill();
         this._iconMask.visible = false;
         this._content.addChild(this._iconMask);
         this._container.mouseEnabled = false;
         this._container.mouseChildren = false;
         this._hotArea = DisplayObjectUtil.createHotArea(85,85);
         this._hotArea.buttonMode = true;
         addChild(this._hotArea);
         this._hotArea.addEventListener("mouseOver",this.onMouseOver);
         this._hotArea.addEventListener("mouseOut",this.onMouseOut);
      }
      
      private static function touchAvatarCacheKey(cacheKey:String) : void
      {
         var index:int = _avatarBitmapCacheKeys.indexOf(cacheKey);
         if(index >= 0)
         {
            _avatarBitmapCacheKeys.splice(index,1);
         }
         _avatarBitmapCacheKeys.push(cacheKey);
      }
      
      private function onMouseOver(evt:MouseEvent) : void
      {
         if(Boolean(this._lightMc))
         {
            this._lightMc.addEventListener("enterFrame",this.onLightMcEnter);
            this._lightMc.gotoAndPlay(1);
         }
         MotionEffects.execElastic(this._content);
      }
      
      private function onLightMcEnter(evt:Event) : void
      {
         if(this._lightMc.currentFrame == this._lightMc.totalFrames)
         {
            this._lightMc.removeEventListener("enterFrame",this.onLightMcEnter);
            this._lightMc.gotoAndStop(1);
         }
      }
      
      private function onMouseOut(evt:MouseEvent) : void
      {
         MotionEffects.resetScale(this._content);
      }
      
      public function reset() : void
      {
         DisplayObjectUtil.disableSprite(this);
         this._skinType = false;
         this._constrainIcon = false;
         this._displayName = "";
         this._modelIconAvatarKind = "icon";
         this._modelIconUsePortraitCrop = false;
         this.clearModelIcon();
         this._icon.visible = true;
         this._modelIconLayer.mask = null;
         this._icon.mask = null;
         this._iconMask.visible = false;
         this._icon.setBoundary(NaN,NaN);
         this._icon.removeIcon();
         this._nameTxt.text = "";
         this.mouseEnabled = false;
         this._info = null;
         this._skinId = 0;
         this.selected = false;
      }
      
      public function setPetInfo(info:PetInfo) : void
      {
         this.reset();
         this._skinType = false;
         this._info = info;
         if(this._info != null)
         {
            this.mouseEnabled = true;
            this.updateDisplay();
         }
      }
      
      public function setSkinInfo(petInfo:PetInfo, skinId:uint, constrainIcon:Boolean = false, displayName:String = "", avatarKind:String = "icon", deferPreview:Boolean = false, uncachedPreview:Boolean = false) : void
      {
         this.reset();
         this._skinType = true;
         this._constrainIcon = constrainIcon;
         this._displayName = displayName == null ? "" : displayName;
         this._modelIconAvatarKind = avatarKind == null ? "icon" : avatarKind.toLowerCase();
         this._modelIconUsePortraitCrop = this._modelIconAvatarKind == "fight";
         this._modelIconUncached = uncachedPreview;
         if(this._constrainIcon)
         {
            this._icon.setBoundary(53.3333333333333,53.3333333333333);
            this._iconMask.visible = true;
            this._icon.mask = this._iconMask;
         }
         this._icon.visible = false;
         this._modelIconLayer.mask = this._iconMask;
         this._iconMask.visible = true;
         this._info = petInfo;
         this._skinId = skinId;
         if(this._skinId != 0)
         {
            this.mouseEnabled = true;
            this.updateSimpleInfo();
            if(!deferPreview)
            {
               this.updateSkinDisplay();
            }
         }
      }
      
      public function loadDeferredSkinPreview() : void
      {
         if(this._skinType && this._skinId != 0)
         {
            this.updateSkinDisplay();
         }
      }
      
      private function updateSkinDisplay() : void
      {
         this.loadPreview(this._skinId);
         this.updateSimpleInfo();
      }
      
      private function updateDisplay() : void
      {
         this.loadPreview(this._info.resourceId);
         this.updateSimpleInfo();
      }
      
      private function updateSimpleInfo() : void
      {
         var definition:PetDefinition = null;
         if(this._skinType)
         {
            if(this._displayName.length > 0)
            {
               this._nameTxt.text = this._displayName;
            }
            else
            {
               definition = PetConfig.getPetDefinition(this._skinId);
               this._nameTxt.text = definition != null ? definition.name : "皮肤 " + this._skinId;
            }
         }
         else
         {
            definition = this._info == null ? null : PetConfig.getPetDefinition(this._info.resourceId);
            this._nameTxt.text = definition != null ? definition.name : "";
         }
      }
      
      private function loadPreview(resId:uint) : void
      {
         var url:String = String(URLUtil.getPetIcon(resId));
         if(this._skinType && this._constrainIcon)
         {
            url = ClientConfig.rootURL + "launcher/pet-skin-panel-avatar/" + resId + ".swf";
         }
         if(this._skinType)
         {
            this.loadModelIcon(url,resId);
         }
         else
         {
            this._icon.setIconUrl(url,this.onContentLoaded);
         }
      }
      
      private function loadModelIcon(url:String, resId:uint) : void
      {
         var serial:uint = 0;
         serial = 0;
         serial = 0;
         serial = ++this._modelIconSerial;
         this._modelIconResourceId = resId;
         this._modelIconFallbackIndex = -1;
         this._modelIconUrl = url;
         this._modelIconCacheKey = "panel-avatar:" + resId + ":" + this._modelIconAvatarKind + ":primary";
         if(this.showCachedModelIcon(this._modelIconCacheKey))
         {
            return;
         }
         this._modelIconType = this._modelIconUsePortraitCrop ? "pet" : "phasor";
         if(this._modelIconUncached && this._constrainIcon)
         {
            this.loadRawModelIcon(url,serial);
            return;
         }
         this._modelIconComplete = function(info:ContentInfo):void
         {
            onModelIconLoaded(info,serial);
         };
         this._modelIconError = function(info:ContentInfo):void
         {
            onModelIconError(info,serial);
         };
         CacheManager.getContent(url,this._modelIconType,this._modelIconComplete,this._modelIconError);
      }
      
      private function loadRawModelIcon(url:String, serial:uint) : void
      {
         this.clearRawModelLoader();
         this._modelIconLoaderSerial = serial;
         try
         {
            this._modelIconLoader = new Loader();
            this._modelIconLoader.contentLoaderInfo.addEventListener(Event.COMPLETE,this.onRawModelIconComplete);
            this._modelIconLoader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR,this.onRawModelIconError);
            this._modelIconLoader.contentLoaderInfo.addEventListener(SecurityErrorEvent.SECURITY_ERROR,this.onRawModelIconError);
            this._modelIconLoader.load(new URLRequest(url));
         }
         catch(error:Error)
         {
            this.onRawModelIconError(null);
         }
      }
      
      private function onRawModelIconComplete(param1:Event) : void
      {
         var content:DisplayObject = null;
         if(this._modelIconLoaderSerial != this._modelIconSerial || this._modelIconLoader == null)
         {
            return;
         }
         content = this._modelIconLoader.contentLoaderInfo.content as DisplayObject;
         if(content == null)
         {
            this.onModelIconError(null,this._modelIconSerial);
            return;
         }
         this.showModelIcon(content,this._modelIconUsePortraitCrop);
      }
      
      private function onRawModelIconError(param1:Event) : void
      {
         if(this._modelIconLoaderSerial == this._modelIconSerial)
         {
            this.onModelIconError(null,this._modelIconSerial);
         }
      }
      
      private function onModelIconLoaded(info:ContentInfo, serial:uint) : void
      {
         if(serial != this._modelIconSerial)
         {
            return;
         }
         if(info == null || info.content == null)
         {
            this.tryPetModelIcon(serial);
            return;
         }
         this.showModelIcon(info.content as DisplayObject,this._modelIconType == "pet");
      }
      
      private function onModelIconError(info:ContentInfo, serial:uint) : void
      {
         if(serial != this._modelIconSerial)
         {
            return;
         }
         this.tryPetModelIcon(serial);
      }
      
      private function tryPetModelIcon(serial:uint) : void
      {
         if(serial != this._modelIconSerial || this._modelIconType == "pet")
         {
            this.tryNextFallbackModel(serial);
            return;
         }
         this._modelIconType = "pet";
         if(this._modelIconUncached && this._constrainIcon)
         {
            this.loadRawModelIcon(this._modelIconUrl,serial);
            return;
         }
         CacheManager.getContent(this._modelIconUrl,this._modelIconType,this._modelIconComplete,this._modelIconError);
      }
      
      private function tryNextFallbackModel(serial:uint) : void
      {
         var kinds:Array = ["fight","normal","demo"];
         var kind:String = null;
         if(serial != this._modelIconSerial || this._modelIconResourceId == 0)
         {
            this.onContentLoaded();
            return;
         }
         this.clearCurrentModelContent();
         ++this._modelIconFallbackIndex;
         if(this._modelIconFallbackIndex >= kinds.length)
         {
            this.onContentLoaded();
            return;
         }
         kind = String(kinds[this._modelIconFallbackIndex]);
         this._modelIconUsePortraitCrop = true;
         this._modelIconUrl = "http://seer.61.com/launcher/pet-preview/" + kind + "/" + this._modelIconResourceId + ".swf";
         this._modelIconCacheKey = "panel-avatar:" + this._modelIconResourceId + ":" + kind;
         if(this.showCachedModelIcon(this._modelIconCacheKey))
         {
            return;
         }
         this._modelIconType = kind == "fight" ? "pet" : "phasor";
         if(this._modelIconUncached && this._constrainIcon)
         {
            this.loadRawModelIcon(this._modelIconUrl,serial);
            return;
         }
         CacheManager.getContent(this._modelIconUrl,this._modelIconType,this._modelIconComplete,this._modelIconError);
      }
      
      private function clearCurrentModelContent() : void
      {
         if(this._modelIconContent != null)
         {
            this._modelIconContent.removeEventListener(Event.ENTER_FRAME,this.onModelIconFrame);
         }
         while(this._modelIconLayer != null && this._modelIconLayer.numChildren > 0)
         {
            this._modelIconLayer.removeChildAt(0);
         }
         this._modelIconContent = null;
      }
      
      private function showCachedModelIcon(cacheKey:String) : Boolean
      {
         var cached:BitmapData = _avatarBitmapCache[cacheKey] as BitmapData;
         var bitmap:Bitmap = null;
         if(cached == null)
         {
            return false;
         }
         touchAvatarCacheKey(cacheKey);
         if(this._modelIconBitmap != null)
         {
            this._modelIconBitmap.dispose();
         }
         this._modelIconBitmap = cached.clone();
         bitmap = new Bitmap(this._modelIconBitmap,"auto",true);
         this._modelIconContent = bitmap;
         this._modelIconLayer.addChild(bitmap);
         this.onContentLoaded();
         return true;
      }
      
      private function cacheModelIcon(cacheKey:String, bitmapData:BitmapData) : void
      {
         var evictedKey:String = null;
         var evicted:BitmapData = null;
         var evictedBytes:uint = 0;
         var cachedCopy:BitmapData = null;
         var cachedBytes:uint = 0;
         if(cacheKey == null || cacheKey.length == 0 || bitmapData == null)
         {
            return;
         }
         if(_avatarBitmapCache[cacheKey] != null)
         {
            touchAvatarCacheKey(cacheKey);
            return;
         }
         cachedCopy = bitmapData.clone();
         cachedBytes = uint(cachedCopy.width * cachedCopy.height * 4);
         if(cachedBytes > AVATAR_CACHE_BUDGET_BYTES)
         {
            cachedCopy.dispose();
            return;
         }
         while(_avatarBitmapCacheKeys.length > 0 && _avatarBitmapCacheBytes + cachedBytes > AVATAR_CACHE_BUDGET_BYTES)
         {
            evictedKey = _avatarBitmapCacheKeys.shift();
            evicted = _avatarBitmapCache[evictedKey] as BitmapData;
            delete _avatarBitmapCache[evictedKey];
            if(evicted != null)
            {
               evictedBytes = uint(evicted.width * evicted.height * 4);
               _avatarBitmapCacheBytes = evictedBytes >= _avatarBitmapCacheBytes ? 0 : uint(_avatarBitmapCacheBytes - evictedBytes);
               evicted.dispose();
            }
         }
         _avatarBitmapCache[cacheKey] = cachedCopy;
         _avatarBitmapCacheKeys.push(cacheKey);
         _avatarBitmapCacheBytes += cachedBytes;
      }
      
      private function showModelIcon(content:DisplayObject, waitForVisibleFrame:Boolean) : void
      {
         var bounds:Rectangle = null;
         if(content == null)
         {
            this.tryNextFallbackModel(this._modelIconSerial);
            return;
         }
         this._modelIconContent = content;
         content.visible = false;
         this._modelIconLayer.addChild(content);
         this._modelIconWaitFrames = 0;
         if(!waitForVisibleFrame)
         {
            bounds = content.getBounds(content);
            if(bounds.width > 1 && bounds.height > 1)
            {
               this.stopCurrentFrames(content);
               this.snapshotModelIcon(content);
               return;
            }
         }
         content.addEventListener(Event.ENTER_FRAME,this.onModelIconFrame);
      }
      
      private function onModelIconFrame(event:Event) : void
      {
         var bounds:Rectangle = null;
         if(this._modelIconContent == null)
         {
            return;
         }
         ++this._modelIconWaitFrames;
         bounds = this._modelIconContent.getBounds(this._modelIconContent);
         if(this._modelIconWaitFrames >= (this._modelIconUsePortraitCrop ? 2 : 1) && bounds.width > 1 && bounds.height > 1 || this._modelIconWaitFrames >= 30)
         {
            this._modelIconContent.removeEventListener(Event.ENTER_FRAME,this.onModelIconFrame);
            this.stopCurrentFrames(this._modelIconContent);
            this.snapshotModelIcon(this._modelIconContent);
         }
      }
      
      private function snapshotModelIcon(content:DisplayObject) : void
      {
         var bounds:Rectangle = null;
         var visibleBounds:Rectangle = null;
         var targetWidth:Number = 80;
         var targetHeight:Number = 80;
         var scale:Number = Number.NaN;
         var matrix:Matrix = null;
         var bitmap:Bitmap = null;
         if(content == null)
         {
            this.tryNextFallbackModel(this._modelIconSerial);
            return;
         }
         content.visible = true;
         content.scaleX = content.scaleY = 1;
         content.x = content.y = 0;
         bounds = content.getBounds(content);
         if(bounds.width <= 1 || bounds.height <= 1)
         {
            content.visible = false;
            this.tryNextFallbackModel(this._modelIconSerial);
            return;
         }
         visibleBounds = this._modelIconUsePortraitCrop ? this.getPortraitModelBounds(content,bounds) : this.getPrimaryIconBounds(content,bounds);
         scale = Math.min(targetWidth / visibleBounds.width,targetHeight / visibleBounds.height);
         matrix = new Matrix();
         matrix.scale(scale,scale);
         matrix.translate(-visibleBounds.x * scale + (targetWidth - visibleBounds.width * scale) / 2,-visibleBounds.y * scale + (targetHeight - visibleBounds.height * scale) / 2);
         if(this._modelIconBitmap != null)
         {
            this._modelIconBitmap.dispose();
         }
         this._modelIconBitmap = new BitmapData(80,80,true,0);
         try
         {
            this._modelIconBitmap.draw(content,matrix,null,null,null,true);
         }
         catch(drawError:*)
         {
            this._modelIconBitmap.dispose();
            this._modelIconBitmap = null;
            content.visible = false;
            this.tryNextFallbackModel(this._modelIconSerial);
            return;
         }
         content.visible = false;
         this.releaseRawModelLoader();
         while(this._modelIconLayer.numChildren > 0)
         {
            this._modelIconLayer.removeChildAt(0);
         }
         bitmap = new Bitmap(this._modelIconBitmap,"auto",true);
         this._modelIconContent = bitmap;
         this._modelIconLayer.addChild(bitmap);
         this.cacheModelIcon(this._modelIconCacheKey,this._modelIconBitmap);
         this.onContentLoaded();
      }
      
      private function getVisibleModelBounds(content:DisplayObject, fallback:Rectangle) : Rectangle
      {
         var sample:BitmapData = null;
         sample = null;
         sample = null;
         var maxSample:Number = 320;
         var sampleScale:Number = Math.min(1,maxSample / Math.max(fallback.width,fallback.height));
         var sampleWidth:int = Math.max(1,Math.ceil(fallback.width * sampleScale));
         var sampleHeight:int = Math.max(1,Math.ceil(fallback.height * sampleScale));
         sample = null;
         var sampleMatrix:Matrix = new Matrix();
         var pixels:Vector.<uint> = null;
         var columnWeights:Vector.<Number> = new Vector.<Number>(sampleWidth,true);
         var rowWeights:Vector.<Number> = new Vector.<Number>(sampleHeight,true);
         var total:Number = 0;
         var index:int = 0;
         var x:int = 0;
         var y:int = 0;
         var alpha:uint = 0;
         var weight:Number = 0;
         var lowerTarget:Number = 0;
         var upperTarget:Number = 0;
         var running:Number = 0;
         var left:int = 0;
         var right:int = sampleWidth - 1;
         var top:int = 0;
         var bottom:int = sampleHeight - 1;
         var pad:Number = 2 / sampleScale;
         var result:Rectangle = null;
         sampleMatrix.scale(sampleScale,sampleScale);
         sampleMatrix.translate(-fallback.x * sampleScale,-fallback.y * sampleScale);
         try
         {
            sample = new BitmapData(sampleWidth,sampleHeight,true,0);
            sample.draw(content,sampleMatrix,null,null,null,true);
            pixels = sample.getVector(sample.rect);
            for(y = 0; y < sampleHeight; y++)
            {
               for(x = 0; x < sampleWidth; x++)
               {
                  alpha = uint(pixels[index++] >>> 24);
                  if(alpha >= 16)
                  {
                     weight = Number(alpha);
                     columnWeights[x] += weight;
                     rowWeights[y] += weight;
                     total += weight;
                  }
               }
            }
         }
         catch(sampleError:*)
         {
            if(sample != null)
            {
               sample.dispose();
            }
            return fallback;
         }
         sample.dispose();
         if(total <= 0)
         {
            return fallback;
         }
         lowerTarget = total * 0.005;
         upperTarget = total * 0.995;
         running = 0;
         for(x = 0; x < sampleWidth; x++)
         {
            running += columnWeights[x];
            if(running >= lowerTarget)
            {
               left = x;
               break;
            }
         }
         running = 0;
         for(x = 0; x < sampleWidth; x++)
         {
            running += columnWeights[x];
            if(running >= upperTarget)
            {
               right = x;
               break;
            }
         }
         running = 0;
         for(y = 0; y < sampleHeight; y++)
         {
            running += rowWeights[y];
            if(running >= lowerTarget)
            {
               top = y;
               break;
            }
         }
         running = 0;
         for(y = 0; y < sampleHeight; y++)
         {
            running += rowWeights[y];
            if(running >= upperTarget)
            {
               bottom = y;
               break;
            }
         }
         if(right <= left || bottom <= top)
         {
            return fallback;
         }
         result = new Rectangle(fallback.x + left / sampleScale - pad,fallback.y + top / sampleScale - pad,(right - left + 1) / sampleScale + pad * 2,(bottom - top + 1) / sampleScale + pad * 2);
         return result;
      }
      
      private function getPrimaryIconBounds(content:DisplayObject, fallback:Rectangle) : Rectangle
      {
         var visibleBounds:Rectangle = null;
         var sample:BitmapData = null;
         visibleBounds = this.getVisibleModelBounds(content,fallback);
         var maxSample:Number = 320;
         var sampleScale:Number = Math.min(1,maxSample / Math.max(fallback.width,fallback.height));
         var sampleWidth:int = Math.max(1,Math.ceil(fallback.width * sampleScale));
         var sampleHeight:int = Math.max(1,Math.ceil(fallback.height * sampleScale));
         sample = null;
         var sampleMatrix:Matrix = new Matrix();
         var pixels:Vector.<uint> = null;
         var visited:Vector.<Boolean> = null;
         var queue:Vector.<int> = new Vector.<int>();
         var components:Array = [];
         var index:int = 0;
         var queueHead:int = 0;
         var current:int = 0;
         var x:int = 0;
         var y:int = 0;
         var neighborX:int = 0;
         var neighborY:int = 0;
         var neighborIndex:int = 0;
         var alpha:uint = 0;
         var mass:Number = 0;
         var left:int = 0;
         var right:int = 0;
         var top:int = 0;
         var bottom:int = 0;
         var component:Object = null;
         var best:Object = null;
         var bestMass:Number = 0;
         var selectedLeft:int = 0;
         var selectedRight:int = 0;
         var selectedTop:int = 0;
         var selectedBottom:int = 0;
         var mergeGap:int = 0;
         var changed:Boolean = false;
         var clusterWidth:Number = 0;
         var clusterHeight:Number = 0;
         var visibleSampleWidth:Number = visibleBounds.width * sampleScale;
         var visibleSampleHeight:Number = visibleBounds.height * sampleScale;
         var pad:Number = 2 / sampleScale;
         sampleMatrix.scale(sampleScale,sampleScale);
         sampleMatrix.translate(-fallback.x * sampleScale,-fallback.y * sampleScale);
         try
         {
            sample = new BitmapData(sampleWidth,sampleHeight,true,0);
            sample.draw(content,sampleMatrix,null,null,null,true);
            pixels = sample.getVector(sample.rect);
         }
         catch(sampleError:*)
         {
            if(sample != null)
            {
               sample.dispose();
            }
            return visibleBounds;
         }
         sample.dispose();
         visited = new Vector.<Boolean>(pixels.length,true);
         index = 0;
         while(index < pixels.length)
         {
            if(visited[index] || uint(pixels[index] >>> 24) < 16)
            {
               index++;
            }
            else
            {
               queue.length = 0;
               queue.push(index);
               visited[index] = true;
               queueHead = 0;
               mass = 0;
               x = index % sampleWidth;
               y = int(index / sampleWidth);
               left = right = x;
               top = bottom = y;
               while(queueHead < queue.length)
               {
                  current = queue[queueHead++];
                  x = current % sampleWidth;
                  y = int(current / sampleWidth);
                  alpha = uint(pixels[current] >>> 24);
                  mass += Number(alpha);
                  left = Math.min(left,x);
                  right = Math.max(right,x);
                  top = Math.min(top,y);
                  bottom = Math.max(bottom,y);
                  neighborY = Math.max(0,y - 1);
                  while(neighborY <= Math.min(sampleHeight - 1,y + 1))
                  {
                     neighborX = Math.max(0,x - 1);
                     while(neighborX <= Math.min(sampleWidth - 1,x + 1))
                     {
                        neighborIndex = neighborY * sampleWidth + neighborX;
                        if(!visited[neighborIndex] && uint(pixels[neighborIndex] >>> 24) >= 16)
                        {
                           visited[neighborIndex] = true;
                           queue.push(neighborIndex);
                        }
                        neighborX++;
                     }
                     neighborY++;
                  }
               }
               component = {
                  "left":left,
                  "right":right,
                  "top":top,
                  "bottom":bottom,
                  "mass":mass
               };
               components.push(component);
               if(mass > bestMass)
               {
                  bestMass = mass;
                  best = component;
               }
               index++;
            }
         }
         if(best == null || components.length < 2)
         {
            return visibleBounds;
         }
         selectedLeft = int(best.left);
         selectedRight = int(best.right);
         selectedTop = int(best.top);
         selectedBottom = int(best.bottom);
         mergeGap = Math.max(3,Math.round(Math.max(selectedRight - selectedLeft + 1,selectedBottom - selectedTop + 1) * 0.2));
         do
         {
            changed = false;
            for each(component in components)
            {
               if(Number(component.mass) >= bestMass * 0.004)
               {
                  if(int(component.right) >= selectedLeft - mergeGap && int(component.left) <= selectedRight + mergeGap && int(component.bottom) >= selectedTop - mergeGap && int(component.top) <= selectedBottom + mergeGap)
                  {
                     left = Math.min(selectedLeft,int(component.left));
                     right = Math.max(selectedRight,int(component.right));
                     top = Math.min(selectedTop,int(component.top));
                     bottom = Math.max(selectedBottom,int(component.bottom));
                     if(left != selectedLeft || right != selectedRight || top != selectedTop || bottom != selectedBottom)
                     {
                        selectedLeft = left;
                        selectedRight = right;
                        selectedTop = top;
                        selectedBottom = bottom;
                        changed = true;
                     }
                  }
               }
            }
         }
         while(changed);
         clusterWidth = selectedRight - selectedLeft + 1;
         clusterHeight = selectedBottom - selectedTop + 1;
         if(clusterWidth <= 1 || clusterHeight <= 1 || visibleSampleWidth <= clusterWidth * 1.45 && visibleSampleHeight <= clusterHeight * 1.45)
         {
            return visibleBounds;
         }
         return new Rectangle(fallback.x + selectedLeft / sampleScale - pad,fallback.y + selectedTop / sampleScale - pad,clusterWidth / sampleScale + pad * 2,clusterHeight / sampleScale + pad * 2);
      }
      
      private function getPortraitModelBounds(content:DisplayObject, fallback:Rectangle) : Rectangle
      {
         var sample:BitmapData = null;
         var maxSample:Number = 320;
         var sampleScale:Number = Math.min(1,maxSample / Math.max(fallback.width,fallback.height));
         var sampleWidth:int = Math.max(1,Math.ceil(fallback.width * sampleScale));
         var sampleHeight:int = Math.max(1,Math.ceil(fallback.height * sampleScale));
         sample = null;
         var sampleMatrix:Matrix = new Matrix();
         var pixels:Vector.<uint> = null;
         var integralWidth:int = sampleWidth + 1;
         var integral:Vector.<Number> = new Vector.<Number>((sampleWidth + 1) * (sampleHeight + 1),true);
         var x:int = 0;
         var y:int = 0;
         var pixelIndex:int = 0;
         var alpha:Number = 0;
         var left:int = sampleWidth;
         var right:int = -1;
         var top:int = sampleHeight;
         var bottom:int = -1;
         var total:Number = 0;
         var integralIndex:int = 0;
         var longest:int = 0;
         var windowSide:int = 0;
         var step:int = 0;
         var minX:int = 0;
         var maxX:int = 0;
         var minY:int = 0;
         var maxY:int = 0;
         var candidateX:int = 0;
         var candidateY:int = 0;
         var x2:int = 0;
         var y2:int = 0;
         var mass:Number = 0;
         var centerBias:Number = 0;
         var upperBias:Number = 0;
         var score:Number = 0;
         var bestScore:Number = Number.NEGATIVE_INFINITY;
         var bestX:int = 0;
         var bestY:int = 0;
         var bboxCenterX:Number = 0;
         var relativeY:Number = 0;
         var relativeX:Number = 0;
         var paddedSide:Number = 0;
         var paddedX:Number = 0;
         var paddedY:Number = 0;
         sampleMatrix.scale(sampleScale,sampleScale);
         sampleMatrix.translate(-fallback.x * sampleScale,-fallback.y * sampleScale);
         try
         {
            sample = new BitmapData(sampleWidth,sampleHeight,true,0);
            sample.draw(content,sampleMatrix,null,null,null,true);
            pixels = sample.getVector(sample.rect);
            for(y = 0; y < sampleHeight; y++)
            {
               for(x = 0; x < sampleWidth; x++)
               {
                  alpha = Number(pixels[pixelIndex++] >>> 24);
                  if(alpha < 16)
                  {
                     alpha = 0;
                  }
                  else
                  {
                     left = Math.min(left,x);
                     right = Math.max(right,x);
                     top = Math.min(top,y);
                     bottom = Math.max(bottom,y);
                     total += alpha;
                  }
                  integralIndex = (y + 1) * integralWidth + x + 1;
                  integral[integralIndex] = alpha + integral[integralIndex - 1] + integral[integralIndex - integralWidth] - integral[integralIndex - integralWidth - 1];
               }
            }
         }
         catch(sampleError:*)
         {
            if(sample != null)
            {
               sample.dispose();
            }
            return this.getVisibleModelBounds(content,fallback);
         }
         sample.dispose();
         if(total <= 0 || right <= left || bottom <= top)
         {
            return this.getVisibleModelBounds(content,fallback);
         }
         longest = Math.max(right - left + 1,bottom - top + 1);
         windowSide = Math.max(16,Math.round(longest * 0.58));
         windowSide = Math.min(windowSide,Math.min(sampleWidth,sampleHeight));
         step = Math.max(1,Math.floor(windowSide / 14));
         minX = Math.max(0,left - windowSide + 1);
         maxX = Math.min(sampleWidth - windowSide,right);
         minY = Math.max(0,top - windowSide + 1);
         maxY = Math.min(sampleHeight - windowSide,bottom);
         if(maxX < minX)
         {
            minX = maxX = Math.max(0,Math.min(sampleWidth - windowSide,Math.round((left + right - windowSide + 1) / 2)));
         }
         if(maxY < minY)
         {
            minY = maxY = Math.max(0,Math.min(sampleHeight - windowSide,Math.round((top + bottom - windowSide + 1) / 2)));
         }
         bboxCenterX = (left + right + 1) / 2;
         candidateY = minY;
         while(candidateY <= maxY)
         {
            candidateX = minX;
            while(candidateX <= maxX)
            {
               x2 = candidateX + windowSide;
               y2 = candidateY + windowSide;
               mass = integral[y2 * integralWidth + x2] - integral[candidateY * integralWidth + x2] - integral[y2 * integralWidth + candidateX] + integral[candidateY * integralWidth + candidateX];
               relativeY = Math.max(0,Math.min(1,(candidateY + windowSide / 2 - top) / Math.max(1,bottom - top + 1)));
               relativeX = Math.abs(candidateX + windowSide / 2 - bboxCenterX) / Math.max(1,longest / 2);
               upperBias = total * 0.14 * (1 - relativeY);
               centerBias = total * 0.06 * Math.min(1,relativeX);
               score = mass + upperBias - centerBias;
               if(score > bestScore)
               {
                  bestScore = score;
                  bestX = candidateX;
                  bestY = candidateY;
               }
               candidateX += step;
            }
            candidateY += step;
         }
         paddedSide = Math.min(Math.min(sampleWidth,sampleHeight),windowSide * 1.08);
         paddedX = Math.max(0,Math.min(sampleWidth - paddedSide,bestX - (paddedSide - windowSide) / 2));
         paddedY = Math.max(0,Math.min(sampleHeight - paddedSide,bestY - (paddedSide - windowSide) / 2));
         return new Rectangle(fallback.x + paddedX / sampleScale,fallback.y + paddedY / sampleScale,paddedSide / sampleScale,paddedSide / sampleScale);
      }
      
      private function fitModelIcon(content:DisplayObject) : void
      {
         var bounds:Rectangle = content.getBounds(content);
         var scale:Number = Number.NaN;
         if(bounds.width <= 1 || bounds.height <= 1)
         {
            return;
         }
         scale = Math.min(80 / bounds.width,80 / bounds.height);
         content.scaleX = content.scaleY = scale;
         content.x = -bounds.x * scale + (80 - bounds.width * scale) / 2;
         content.y = -bounds.y * scale + (80 - bounds.height * scale) / 2;
      }
      
      private function stopCurrentFrames(target:DisplayObject) : void
      {
         var clip:MovieClip = target as MovieClip;
         var container:DisplayObjectContainer = target as DisplayObjectContainer;
         var index:int = 0;
         if(clip != null)
         {
            clip.stop();
         }
         if(container != null)
         {
            index = container.numChildren - 1;
            while(index >= 0)
            {
               this.stopCurrentFrames(container.getChildAt(index));
               index--;
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
         this.clearRawModelLoader();
         if(this._modelIconContent != null)
         {
            this._modelIconContent.removeEventListener(Event.ENTER_FRAME,this.onModelIconFrame);
         }
         while(this._modelIconLayer != null && this._modelIconLayer.numChildren > 0)
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
         this._modelIconComplete = null;
         this._modelIconError = null;
         this._modelIconCacheKey = null;
         this._modelIconResourceId = 0;
         this._modelIconFallbackIndex = -1;
         this._modelIconUncached = false;
      }
      
      private function clearRawModelLoader() : void
      {
         if(this._modelIconLoader == null)
         {
            return;
         }
         this._modelIconLoader.contentLoaderInfo.removeEventListener(Event.COMPLETE,this.onRawModelIconComplete);
         this._modelIconLoader.contentLoaderInfo.removeEventListener(IOErrorEvent.IO_ERROR,this.onRawModelIconError);
         this._modelIconLoader.contentLoaderInfo.removeEventListener(SecurityErrorEvent.SECURITY_ERROR,this.onRawModelIconError);
         try
         {
            this._modelIconLoader.close();
         }
         catch(error:Error)
         {
         }
         try
         {
            this._modelIconLoader.unloadAndStop(true);
         }
         catch(unloadError:Error)
         {
         }
         this._modelIconLoader = null;
      }
      
      private function releaseRawModelLoader() : void
      {
         this.clearRawModelLoader();
      }
      
      private function onContentLoaded() : void
      {
         DisplayObjectUtil.enableSprite(this);
         this.dispatchEvent(new Event("modelIconReady"));
      }
      
      public function set selected(value:Boolean) : void
      {
         this._selector.visible = value;
      }
      
      public function get petInfo() : PetInfo
      {
         return this._info;
      }
      
      public function get skinId() : uint
      {
         return this._skinId;
      }
   }
}

