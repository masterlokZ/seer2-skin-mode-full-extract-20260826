package com.taomee.seer2.module.app.versionOnePetBagPanel.util
{
   import com.taomee.seer2.app.component.IconDisplayer;
   import com.taomee.seer2.core.config.ClientConfig;
   import flash.display.Bitmap;
   import flash.display.BitmapData;
   import flash.display.DisplayObject;
   import flash.display.DisplayObjectContainer;
   import flash.display.MovieClip;
   import flash.display.Shape;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.IOErrorEvent;
   import flash.events.SecurityErrorEvent;
   import flash.geom.Matrix;
   import flash.geom.Rectangle;
   import flash.net.URLLoader;
   import flash.net.URLRequest;
   import flash.utils.clearTimeout;
   import flash.utils.setTimeout;
   
   public class PetIconPreviewViewport extends Sprite
   {
      
      private static var _routeLoader:URLLoader;
      
      private static var _routeTimeout:uint;
      
      private static const ROUTE_MANIFEST_PATH:String = "launcher/custom-skin-routes.xml";
      
      private static const MAX_UPSCALE:Number = 1.5;
      
      private static var _routeState:int = 0;
      
      private static var _fightDerivedIconRoutes:Object = {};
      
      private static var _officialIconRoutes:Object = {};
      
      private static var _modelRouteTypes:Object = {};
      
      private static var _routeCallbacks:Array = [];
      
      private var _viewportWidth:Number;
      
      private var _viewportHeight:Number;
      
      private var _contentLayer:Sprite;
      
      private var _maskShape:Shape;
      
      private var _loader:IconDisplayer;
      
      private var _snapshot:Bitmap;
      
      private var _activeUrl:String;
      
      public function PetIconPreviewViewport(param1:Number, param2:Number)
      {
         super();
         this._viewportWidth = param1;
         this._viewportHeight = param2;
         this.mouseEnabled = false;
         this.mouseChildren = false;
         this._contentLayer = new Sprite();
         this._contentLayer.mouseEnabled = false;
         this._contentLayer.mouseChildren = false;
         addChild(this._contentLayer);
         this._loader = new IconDisplayer();
         this._loader.mouseEnabled = false;
         this._loader.mouseChildren = false;
         this._contentLayer.addChild(this._loader);
         this._maskShape = new Shape();
         this._maskShape.graphics.beginFill(16777215,1);
         this._maskShape.graphics.drawRect(0,0,this._viewportWidth,this._viewportHeight);
         this._maskShape.graphics.endFill();
         addChild(this._maskShape);
         this._contentLayer.mask = this._maskShape;
         this._contentLayer.scrollRect = new Rectangle(0,0,this._viewportWidth,this._viewportHeight);
      }
      
      public static function resolveFightDerivedIconRoute(param1:uint, param2:Function) : void
      {
         if(param2 == null)
         {
            return;
         }
         if(_routeState == 2)
         {
            param2(_fightDerivedIconRoutes[String(param1)] === true);
            return;
         }
         _routeCallbacks.push({
            "resourceId":param1,
            "callback":param2
         });
         if(_routeState == 1)
         {
            return;
         }
         loadRouteManifest();
      }
      
      public static function resolveOfficialIconRoute(param1:uint, param2:Function) : void
      {
         if(param2 == null)
         {
            return;
         }
         if(_routeState == 2)
         {
            param2(_officialIconRoutes[String(param1)] === true);
            return;
         }
         _routeCallbacks.push({
            "resourceId":param1,
            "callback":param2,
            "officialIcon":true
         });
         if(_routeState == 1)
         {
            return;
         }
         loadRouteManifest();
      }
      
      public static function resolveModelRouteType(param1:uint, param2:Function) : void
      {
         if(param2 == null)
         {
            return;
         }
         if(_routeState == 2)
         {
            param2(String(_modelRouteTypes[String(param1)] || ""));
            return;
         }
         _routeCallbacks.push({
            "resourceId":param1,
            "callback":param2,
            "modelRoute":true
         });
         if(_routeState == 1)
         {
            return;
         }
         loadRouteManifest();
      }
      
      private static function loadRouteManifest() : void
      {
         _routeState = 1;
         _fightDerivedIconRoutes = {};
         _officialIconRoutes = {};
         _modelRouteTypes = {};
         try
         {
            _routeLoader = new URLLoader();
            _routeLoader.addEventListener(Event.COMPLETE,onRouteManifestComplete);
            _routeLoader.addEventListener(IOErrorEvent.IO_ERROR,onRouteManifestError);
            _routeLoader.addEventListener(SecurityErrorEvent.SECURITY_ERROR,onRouteManifestError);
            _routeTimeout = setTimeout(onRouteManifestTimeout,3000);
            _routeLoader.load(new URLRequest(ClientConfig.rootURL + ROUTE_MANIFEST_PATH + "?time=" + new Date().time));
         }
         catch(error:Error)
         {
            settleRouteManifest(null);
         }
      }
      
      private static function onRouteManifestComplete(param1:Event) : void
      {
         var event:Event = param1;
         var routes:Object = {};
         var document:XML = null;
         var route:XML = null;
         var resourceId:uint = 0;
         var iconPresentation:String = null;
         var officialIcons:Object = {};
         var modelRoutes:Object = {};
         var modelType:String = null;
         try
         {
            document = new XML(String(_routeLoader.data));
            if(String(document.name()) != "launcherSkinRoutes")
            {
               throw new Error("invalid launcher route root");
            }
            for each(route in document.route)
            {
               resourceId = uint(route.@id);
               iconPresentation = String(route.@iconPresentation).toLowerCase();
               modelType = routeFlag(route.@fight) ? "fight" : (routeFlag(route.@normal) ? "normal" : "");
               if(resourceId > 0 && modelType != "")
               {
                  modelRoutes[String(resourceId)] = modelType;
               }
               if(resourceId > 0 && routeFlag(route.@officialIdOverride))
               {
                  officialIcons[String(resourceId)] = true;
               }
               else if(resourceId > 0 && routeFlag(route.@icon) && iconPresentation == "frozen-avatar")
               {
                  routes[String(resourceId)] = true;
               }
            }
            settleRouteManifest(routes,officialIcons,modelRoutes);
         }
         catch(error:Error)
         {
            settleRouteManifest(null,null);
         }
      }
      
      private static function onRouteManifestError(param1:Event) : void
      {
         settleRouteManifest(null,null);
      }
      
      private static function onRouteManifestTimeout() : void
      {
         settleRouteManifest(null,null);
      }
      
      private static function routeFlag(param1:*) : Boolean
      {
         var _loc2_:String = String(param1).toLowerCase();
         return _loc2_ == "1" || _loc2_ == "true";
      }
      
      private static function settleRouteManifest(param1:Object, param2:Object = null, param3:Object = null) : void
      {
         var _loc3_:Array = null;
         var _loc4_:Object = null;
         if(_routeState == 2)
         {
            return;
         }
         clearRouteLoader();
         _fightDerivedIconRoutes = param1 == null ? {} : param1;
         _officialIconRoutes = param2 == null ? {} : param2;
         _modelRouteTypes = param3 == null ? {} : param3;
         _routeState = 2;
         _loc3_ = _routeCallbacks;
         _routeCallbacks = [];
         for each(_loc4_ in _loc3_)
         {
            try
            {
               if(_loc4_.modelRoute === true)
               {
                  _loc4_.callback(String(_modelRouteTypes[String(_loc4_.resourceId)] || ""));
               }
               else if(_loc4_.officialIcon === true)
               {
                  _loc4_.callback(_officialIconRoutes[String(_loc4_.resourceId)] === true);
               }
               else
               {
                  _loc4_.callback(_fightDerivedIconRoutes[String(_loc4_.resourceId)] === true);
               }
            }
            catch(error:Error)
            {
            }
         }
      }
      
      private static function clearRouteLoader() : void
      {
         if(_routeTimeout != 0)
         {
            clearTimeout(_routeTimeout);
            _routeTimeout = 0;
         }
         if(_routeLoader != null)
         {
            _routeLoader.removeEventListener(Event.COMPLETE,onRouteManifestComplete);
            _routeLoader.removeEventListener(IOErrorEvent.IO_ERROR,onRouteManifestError);
            _routeLoader.removeEventListener(SecurityErrorEvent.SECURITY_ERROR,onRouteManifestError);
            try
            {
               _routeLoader.close();
            }
            catch(error:Error)
            {
            }
            _routeLoader = null;
         }
      }
      
      public function setIconUrl(param1:String, param2:Function = null) : void
      {
         var expectedUrl:String = null;
         var url:String = param1;
         var onComplete:Function = param2;
         expectedUrl = url;
         this.clearSnapshot();
         this._activeUrl = expectedUrl;
         this._loader.visible = true;
         this._loader.setIconUrl(expectedUrl,function():void
         {
            onIconLoaded(expectedUrl,onComplete);
         });
      }
      
      private function onIconLoaded(param1:String, param2:Function) : void
      {
         var _loc3_:DisplayObject = null;
         if(param1 != this._activeUrl)
         {
            return;
         }
         _loc3_ = this._loader.icon;
         if(_loc3_ != null)
         {
            this.disableMouseTree(_loc3_);
            this.freezeFirstFrame(_loc3_);
            this.fitContent(_loc3_);
            this.captureSnapshot();
         }
         if(param2 != null)
         {
            param2();
         }
      }
      
      private function fitContent(param1:DisplayObject) : void
      {
         var content:DisplayObject = param1;
         var bounds:Rectangle = null;
         var fittedBounds:Rectangle = null;
         var fitScale:Number = 1;
         try
         {
            bounds = content.getBounds(this._loader);
         }
         catch(error:Error)
         {
            return;
         }
         if(bounds == null || bounds.width <= 0 || bounds.height <= 0)
         {
            return;
         }
         fitScale = Math.min(MAX_UPSCALE,this._viewportWidth / bounds.width,this._viewportHeight / bounds.height);
         content.scaleX *= fitScale;
         content.scaleY *= fitScale;
         try
         {
            fittedBounds = content.getBounds(this._loader);
         }
         catch(error:Error)
         {
            return;
         }
         if(fittedBounds == null || fittedBounds.width <= 0 || fittedBounds.height <= 0)
         {
            return;
         }
         content.x += (this._viewportWidth - fittedBounds.width) * 0.5 - fittedBounds.x;
         content.y += (this._viewportHeight - fittedBounds.height) * 0.5 - fittedBounds.y;
      }
      
      private function captureSnapshot() : void
      {
         var bitmapData:BitmapData = null;
         bitmapData = null;
         var paintedBounds:Rectangle = null;
         try
         {
            bitmapData = new BitmapData(Math.ceil(this._viewportWidth),Math.ceil(this._viewportHeight),true,0);
            bitmapData.draw(this._loader,new Matrix(),null,null,new Rectangle(0,0,this._viewportWidth,this._viewportHeight),true);
            paintedBounds = bitmapData.getColorBoundsRect(4278190080,0,false);
            if(paintedBounds.width <= 0 || paintedBounds.height <= 0)
            {
               bitmapData.dispose();
               return;
            }
            this._snapshot = new Bitmap(bitmapData,"auto",true);
            this._contentLayer.addChild(this._snapshot);
            this._loader.visible = false;
         }
         catch(error:Error)
         {
            if(bitmapData != null)
            {
               bitmapData.dispose();
            }
            this._loader.visible = true;
         }
      }
      
      private function freezeFirstFrame(param1:DisplayObject) : void
      {
         var _loc2_:MovieClip = param1 as MovieClip;
         var _loc3_:DisplayObjectContainer = param1 as DisplayObjectContainer;
         var _loc4_:* = 0;
         if(_loc2_ != null)
         {
            try
            {
               _loc2_.gotoAndStop(1);
            }
            catch(error:Error)
            {
            }
         }
         if(_loc3_ != null)
         {
            _loc4_ = int(_loc3_.numChildren - 1);
            while(_loc4_ >= 0)
            {
               this.freezeFirstFrame(_loc3_.getChildAt(_loc4_));
               _loc4_--;
            }
         }
      }
      
      private function disableMouseTree(param1:DisplayObject) : void
      {
         var _loc2_:DisplayObjectContainer = param1 as DisplayObjectContainer;
         var _loc3_:* = 0;
         if(param1 is Sprite)
         {
            Sprite(param1).mouseEnabled = false;
         }
         if(_loc2_ != null)
         {
            _loc2_.mouseChildren = false;
            _loc3_ = int(_loc2_.numChildren - 1);
            while(_loc3_ >= 0)
            {
               this.disableMouseTree(_loc2_.getChildAt(_loc3_));
               _loc3_--;
            }
         }
      }
      
      public function removeIcon() : void
      {
         this._activeUrl = null;
         this.clearSnapshot();
         this._loader.visible = true;
         this._loader.removeIcon();
      }
      
      private function clearSnapshot() : void
      {
         if(this._snapshot != null)
         {
            if(this._snapshot.parent != null)
            {
               this._snapshot.parent.removeChild(this._snapshot);
            }
            if(this._snapshot.bitmapData != null)
            {
               this._snapshot.bitmapData.dispose();
            }
            this._snapshot = null;
         }
      }
      
      public function dispose() : void
      {
         this.removeIcon();
         this._loader.dispose();
      }
   }
}

