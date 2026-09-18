package com.taomee.seer2.module.app
{
   import com.taomee.seer2.app.actor.ActorManager;
   import com.taomee.seer2.app.component.PetDemoDisplayer;
   import flash.net.SharedObject;
   import com.taomee.seer2.app.config.PetConfig;
   import com.taomee.seer2.app.config.PetSkinConfig;
   import com.taomee.seer2.app.config.PetSkinDefineConfig;
   import com.taomee.seer2.app.config.pet.PetDefinition;
   import com.taomee.seer2.app.inventory.ItemManager;
   import com.taomee.seer2.app.inventory.events.ItemEvent;
   import com.taomee.seer2.app.pet.data.PetInfo;
   import com.taomee.seer2.app.pet.data.PetInfoManager;
   import com.taomee.seer2.app.popup.AlertManager;
   import com.taomee.seer2.core.config.ClientConfig;
   import com.taomee.seer2.core.module.Module;
   import com.taomee.seer2.core.utils.DisplayObjectUtil;
   import com.taomee.seer2.core.utils.URLUtil;
   import com.taomee.seer2.module.app.UI.PetSkinPanelUI;
   import flash.display.Bitmap;
   import flash.display.BitmapData;
   import flash.display.DisplayObject;
   import flash.display.DisplayObjectContainer;
   import flash.display.Loader;
   import flash.display.MovieClip;
   import flash.display.Shape;
   import flash.display.SimpleButton;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.IOErrorEvent;
   import flash.events.KeyboardEvent;
   import flash.events.MouseEvent;
   import flash.events.SecurityErrorEvent;
   import flash.geom.Point;
   import flash.geom.Rectangle;
   import flash.net.URLLoader;
   import flash.net.URLRequest;
   import flash.text.TextField;
   import flash.text.TextFormat;
   import flash.text.TextFormatAlign;
   import flash.ui.Keyboard;
   import flash.utils.ByteArray;
   import flash.utils.setTimeout;
   import org.taomee.utils.StringUtil;
   
   public class PetSkinPanel extends Module
   {
      
      private static const MORE_PAGE_SIZE:uint = 18;
      
      private static const MODEL_FIT_PADDING:Number = 6;
      
      private static const BUTTON_SHEET_BASE64:String = "iVBORw0KGgoAAAANSUhEUgAAAVAAAAAfCAMAAACGT2XmAAAAwFBMVEUBDBoBFSgAAAACN0wDRFkBDiAM9vkIt8oDTWQN1eEBEB4K5vEP4eUCLEAEVmsFZHkFdIcCJDoK2fAFhZgGvdIP/f4Gz+gQ/v4GlqYGwNMFboEs//8M6O4Fp7MEjaAI9/0KrsJV//8M3OYI4v0O/v4Hs8kIuM8JwNMAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAACQcZDNAAAAQHRSTlP//wD///+Vqf+r/5es//////+N/59yoRT/nv8Myv//orEG03Yi5tygAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAB6LNzAAAAyNJREFUeNrlWg13oyAQhOAaY0+EoKe2TZp+3v//h8eCRrTm0usrm7502voioFsmM4CybHVXb8hQ361svF9kwHjEYM2TEmRQT01zr0SCwKPwH3vYs8n5BKdrptVhO6HuG3JCU6VbozgBlGm5qVNT7FqjCeKZdqfb2vax2a4Ph3VsHNZb/PbYQyYNp+ifDdJKmT7IsuWFJom3k2W6Wr28ZtYchYPWuhgxOZnhH1WLsCHk6wsqVCYKOAlYKWSaSqk4EVSChG6l2CsZO1am9kLeOEKXG+T253PI+btL86GgTNOSxg89pZbQ30KWjEIuMtkGhOYsLvKRUELcIqF2ohq/WPeL37nHULiMQQv+As6ndeMR24AQ2YUIHRQ6G2lgXhzUw/lRiZ1UaAbxO+j+AxkQGpvPntGA0LEG3rUF+GyU45UjoZuMSjAhoYyaUIgcLlQoSQdtl2gVOrc8DJI6igrcGXfHuVCx6HgWssPdHbAl4C19KwjH0A0JoXOFUlqe8/gShbnlKfRyKct/hFD4QssnlyCUXqHRyHT+59evUPZhQr/C8eQK/TZj6DCl+BkIWHAYq94rcLa08nMWHhD23nBpQsnH0MjLJgiflK5TofyE5QEg2jKUllD4BoSiP7kzNsy8D6OzgR8/AcyWpOEjEgTgl57lyS3PyCy/uc5lU75s+VCJ4aoJTtEE5x76J09KV7wOXSS0NzzvbT+w4ew7DrBTJ8Nk0MUpPSjxL6aGdai+asvz/7M8fP5lE/yIJyUe+wXzwitTQoXmc0JPB7Tvo8/e7aOOJ39jr46TUk6gl4FQsj0e7QktqOIV/bM8RJeo08uwDk0Uo+kfU4nb9TREu6xgstIpVCQEESHxe0p2X74tBEX/hOj35XdCxDeF1kL4ffmNKG9Jhhe/61kbbgzJuHZrE1RMXbd6T5WpsueYOXIjCxN/X14qo0vcl8dcozN5Q18Em1th7m1uk0myTGaxEN452WNuU/MmaTK35JuNxlaP9Q0ZMBvusU7J4LPvmufuz7pad5iB1PlEpAr/qmNeUueLsaRaTFyqOldbDVdXXdXNG3TPmNv0FzwGWNbNjb0KAAAAAElFTkSuQmCC";
      
      private var _petName:TextField;
      
      private var _skinName:TextField;
      
      private var _ruleBtn:SimpleButton;
      
      private var _useBtn:SimpleButton;
      
      private var _preBtn:SimpleButton;
      
      private var _nextBtn:SimpleButton;
      
      private var _searchBtn:SimpleButton;
      
      private var _newSearchBtn:SimpleButton;
      
      private var _changeBtn:SimpleButton;
      
      private var _searchTxt:TextField;
      
      private var _searchBg:MovieClip;
      
      private var _noSkinTip:MovieClip;
      
      private var _rulePanel:MovieClip;
      
      private var _petDisplayer:PetDemoDisplayer;
      
      private var _skinDisplayer:PetDemoDisplayer;
      
      private var _currPetInfo:PetInfo;
      
      private var _currSkinId:uint;
      
      private var _petCellVec:Vector.<PetCell>;
      
      private var _skinCellVec:Vector.<PetCell>;
      
      private var _skinVec:Vector.<uint>;
      
      private var _skinPage:uint;
      
      private var _allSkinVec:Vector.<uint>;
      
      private var _modelLayer:Sprite;
      
      private var _petModelMask:Shape;
      
      private var _skinModelMask:Shape;
      
      private var _moreBtn:SimpleButton;
      
      private var _collapseBtn:SimpleButton;
      
      private var _morePanel:Sprite;
      
      private var _moreCells:Vector.<PetCell>;
      
      private var _morePage:uint;
      
      private var _morePageTxt:TextField;
      
      private var _morePrevBtn:SimpleButton;
      
      private var _moreNextBtn:SimpleButton;
      
      private var _moreFirstBtn:SimpleButton;
      
      private var _moreLastBtn:SimpleButton;
      
      private var _moreJumpTxt:TextField;
      
      private var _moreJumpBtn:SimpleButton;
      
      private var _closeBtn:DisplayObject;
      
      private var _dragSprite:DisplayObject;
      
      private var _buttonSheetLoader:Loader;
      
      private var _buttonTextureStarted:Boolean;
      
      private var _launcherSkinIds:Vector.<uint> = new Vector.<uint>();
      
      private var _launcherSkinNames:Object = {};
      
      private var _launcherSkinAvatarKinds:Object = {};
      
      private var _launcherSkinLoader:URLLoader;
      
      private var _petDisplayRevision:uint = 0;
      
      private var _skinDisplayRevision:uint = 0;
      
      private var _quickSelect:Boolean = true;
      
      private var _quickSelectBtn:Sprite;
      
      private var _quickSelectBox:Shape;
      
      private var _quickSelectTxt:TextField;
      
      private var _quickSelectHover:Boolean = false;
      
      private var _isUpdatingSkinVec:Boolean = false;
      
      public function PetSkinPanel()
      {
         super();
         _lifecycleType = "global";
      }
      
      override public function setup() : void
      {
         setMainUI(new PetSkinPanelUI());
         this.initMC();
         this.initEvent();
         this.loadLauncherSkinRegistry();
      }
      
      private function loadLauncherSkinRegistry() : void
      {
         this.clearLauncherSkinLoader();
         this._launcherSkinIds = new Vector.<uint>();
         this._launcherSkinNames = {};
         this._launcherSkinAvatarKinds = {};
         try
         {
            this._launcherSkinLoader = new URLLoader();
            this._launcherSkinLoader.addEventListener(Event.COMPLETE,this.onLauncherSkinRegistryReady);
            this._launcherSkinLoader.addEventListener(IOErrorEvent.IO_ERROR,this.onLauncherSkinRegistryError);
            this._launcherSkinLoader.addEventListener(SecurityErrorEvent.SECURITY_ERROR,this.onLauncherSkinRegistryError);
            this._launcherSkinLoader.load(new URLRequest(ClientConfig.rootURL + "launcher/pet-skin-panel-routes.xml?time=" + new Date().time));
         }
         catch(error:Error)
         {
            this.clearLauncherSkinLoader();
         }
      }
      
      private function onLauncherSkinRegistryReady(param1:Event) : void
      {
         var event:Event = param1;
         var manifest:XML = null;
         var list:XMLList = null;
         var node:XML = null;
         var id:uint = 0;
         var loaded:Vector.<uint> = new Vector.<uint>();
         try
         {
            manifest = new XML(String(this._launcherSkinLoader.data));
            if(String(manifest.name()) != "petSkinPanelRoutes")
            {
               throw new Error("Unexpected launcher skin route manifest");
            }
            list = manifest.skin;
            for each(node in list)
            {
               if(this.isLauncherRouteCapabilityEnabled(String(node.@demo)))
               {
                  id = uint(node.@id);
                  this.appendUniqueLauncherSkinId(loaded,id);
                  if(String(node.@name).length > 0)
                  {
                     this._launcherSkinNames[String(id)] = String(node.@name);
                  }
                  this._launcherSkinAvatarKinds[String(id)] = String(node.@avatarKind).toLowerCase() == "fight" ? "fight" : "icon";
               }
            }
            this._launcherSkinIds = loaded;
         }
         catch(error:Error)
         {
            this._launcherSkinIds = new Vector.<uint>();
            this._launcherSkinNames = {};
            this._launcherSkinAvatarKinds = {};
         }
         this.clearLauncherSkinLoader();
         if(this._currPetInfo != null)
         {
            if(this._morePanel != null && this._morePanel.visible && this._morePage == 0)
            {
               this._morePage = this.locateActiveSkinPage();
            }
            this.updateSkinVec(true);
         }
      }
      
      private function onLauncherSkinRegistryError(param1:Event) : void
      {
         this._launcherSkinIds = new Vector.<uint>();
         this._launcherSkinNames = {};
         this._launcherSkinAvatarKinds = {};
         this.clearLauncherSkinLoader();
      }
      
      private function clearLauncherSkinLoader() : void
      {
         if(this._launcherSkinLoader != null)
         {
            this._launcherSkinLoader.removeEventListener(Event.COMPLETE,this.onLauncherSkinRegistryReady);
            this._launcherSkinLoader.removeEventListener(IOErrorEvent.IO_ERROR,this.onLauncherSkinRegistryError);
            this._launcherSkinLoader.removeEventListener(SecurityErrorEvent.SECURITY_ERROR,this.onLauncherSkinRegistryError);
            try
            {
               this._launcherSkinLoader.close();
            }
            catch(error:Error)
            {
            }
         }
         this._launcherSkinLoader = null;
      }
      
      private function initMC() : void
      {
         var cell:PetCell = null;
         var i:int = 0;
         this._petName = _mainUI["petName"];
         this._skinName = _mainUI["skinName"];
         this._ruleBtn = _mainUI["ruleBtn"];
         this._useBtn = _mainUI["useBtn"];
         this._preBtn = _mainUI["preBtn"];
         this._nextBtn = _mainUI["nextBtn"];
         this._searchBtn = _mainUI["searchBtn"];
         this._newSearchBtn = _mainUI["newSearchBtn"];
         this._changeBtn = _mainUI["changeBtn"];
         this._searchTxt = _mainUI["searchTxt"];
         this._searchBg = _mainUI["searchBg"];
         this._noSkinTip = _mainUI["noSkinTip"];
         this._rulePanel = _mainUI["rulePanel"];
         this._closeBtn = _mainUI["closeBtn"] as DisplayObject;
         this._dragSprite = _mainUI["dragSprite"] as DisplayObject;
         this.setSearchVisible(false);
         this.createModelLayer();
         this.raiseInteractiveControls();
         this._searchTxt.text = "精灵/皮肤序号";
         this._petDisplayer = new PetDemoDisplayer();
         this._petDisplayer.x = 180;
         this._petDisplayer.y = 200;
         this._petDisplayer.mouseEnabled = false;
         this._petDisplayer.mouseChildren = false;
         this._petDisplayer.mask = this._petModelMask;
         this._modelLayer.addChild(this._petDisplayer);
         this._skinDisplayer = new PetDemoDisplayer();
         this._skinDisplayer.x = 520;
         this._skinDisplayer.y = 200;
         this._skinDisplayer.mouseEnabled = false;
         this._skinDisplayer.mouseChildren = false;
         this._skinDisplayer.mask = this._skinModelMask;
         this._modelLayer.addChild(this._skinDisplayer);
         this._currPetInfo = null;
         this._currSkinId = 0;
         this._petCellVec = new Vector.<PetCell>();
         i = 0;
         cell = null;
         while(i < 6)
         {
            cell = new PetCell();
            cell.x = 21 + 120 * i;
            cell.y = 395;
            addChild(cell);
            this._petCellVec.push(cell);
            i++;
         }
         this._skinCellVec = new Vector.<PetCell>();
         i = 0;
         cell = null;
         while(i < 4)
         {
            cell = new PetCell();
            cell.x = 755;
            cell.y = 35 + 110 * i;
            addChild(cell);
            this._skinCellVec.push(cell);
            i++;
         }
         try
         {
            this.createMoreUI();
         }
         catch(error:Error)
         {
            this._moreBtn = null;
            this._collapseBtn = null;
            this._morePanel = null;
         }
         DisplayObjectUtil.removeFromParent(_mainUI["rulePanel"]);
      }
      
      private function createModelLayer() : void
      {
         this._modelLayer = new Sprite();
         this._modelLayer.mouseEnabled = false;
         this._modelLayer.mouseChildren = false;
         this._petModelMask = this.createMaskShape(18,65,344,250);
         this._skinModelMask = this.createMaskShape(382,65,330,250);
         this._modelLayer.addChild(this._petModelMask);
         this._modelLayer.addChild(this._skinModelMask);
         _mainUI.addChild(this._modelLayer);
      }
      
      private function createMaskShape(param1:Number, param2:Number, param3:Number, param4:Number) : Shape
      {
         var _loc5_:Shape = new Shape();
         _loc5_.graphics.beginFill(16777215);
         _loc5_.graphics.drawRect(param1,param2,param3,param4);
         _loc5_.graphics.endFill();
         return _loc5_;
      }
      
      private function createMoreUI() : void
      {
         this._moreBtn = this.createTexturedButton(String.fromCharCode(26356,22810));
         this._moreBtn.x = 600;
         this._moreBtn.y = 340;
         addChild(this._moreBtn);
         this._collapseBtn = this.createTexturedButton(String.fromCharCode(25910,36215));
         this._collapseBtn.x = 300;
         this._collapseBtn.y = 2;
         this._collapseBtn.visible = false;
         this._morePanel = new Sprite();
         this._morePanel.x = 40;
         this._morePanel.y = 55;
         this.drawMorePanel();
         this._moreCells = new Vector.<PetCell>();
         this._moreFirstBtn = this.createSmallButton(String.fromCharCode(39318,39029),48);
         this._moreFirstBtn.x = 416;
         this._moreFirstBtn.y = 4;
         this._morePanel.addChild(this._moreFirstBtn);
         this._moreLastBtn = this.createSmallButton(String.fromCharCode(23614,39029),48);
         this._moreLastBtn.x = 468;
         this._moreLastBtn.y = 4;
         this._morePanel.addChild(this._moreLastBtn);
         this._moreJumpTxt = this.createPageInput();
         this._moreJumpTxt.x = 202;
         this._moreJumpTxt.y = 5;
         this._morePanel.addChild(this._moreJumpTxt);
         this._moreJumpBtn = this.createSmallButton(String.fromCharCode(36339,36716),48);
         this._moreJumpBtn.x = 248;
         this._moreJumpBtn.y = 4;
         this._morePanel.addChild(this._moreJumpBtn);
         this._morePageTxt = this.createLabel(518,8,72,24,14,TextFormatAlign.CENTER,6750207);
         this._morePanel.addChild(this._morePageTxt);
         this._morePrevBtn = this.createArrowButton("<");
         this._morePrevBtn.x = 595;
         this._morePrevBtn.y = 5;
         this._morePanel.addChild(this._morePrevBtn);
         this._moreNextBtn = this.createArrowButton(">");
         this._moreNextBtn.x = 625;
         this._moreNextBtn.y = 5;
         this._morePanel.addChild(this._moreNextBtn);
         this._morePanel.addChild(this._collapseBtn);
         this._quickSelect = this.readQuickSelectConfig();
         this.createQuickSelectButton();
         this._morePage = 0;
         this._morePanel.visible = false;
         addChild(this._morePanel);
      }
      
      private function drawMorePanel() : void
      {
         this._morePanel.graphics.clear();
         this._morePanel.graphics.lineStyle(2,14666223,0.95);
         this._morePanel.graphics.beginFill(263695,0.96);
         this._morePanel.graphics.drawRoundRect(0,0,680,330,14,14);
         this._morePanel.graphics.endFill();
         this._morePanel.graphics.lineStyle(1,1525726,0.9);
         this._morePanel.graphics.moveTo(14,34);
         this._morePanel.graphics.lineTo(666,34);
         var _loc1_:TextField = this.createLabel(18,5,80,25,18,TextFormatAlign.LEFT,6750207);
         _loc1_.text = String.fromCharCode(20840,37096,30382,32932);
         this._morePanel.addChild(_loc1_);
      }
      
      private function createLabel(param1:Number, param2:Number, param3:Number, param4:Number, param5:uint, param6:String, param7:uint) : TextField
      {
         var _loc8_:TextField = new TextField();
         var _loc9_:TextFormat = new TextFormat("Microsoft YaHei",param5,param7,true);
         _loc9_.align = param6;
         _loc8_.defaultTextFormat = _loc9_;
         _loc8_.width = param3;
         _loc8_.height = param4;
         _loc8_.x = param1;
         _loc8_.y = param2;
         _loc8_.selectable = false;
         _loc8_.mouseEnabled = false;
         return _loc8_;
      }
      
      private function createTexturedButton(param1:String) : SimpleButton
      {
         var _loc2_:SimpleButton = new SimpleButton();
         _loc2_.upState = this.createFallbackButtonState(param1,0);
         _loc2_.overState = this.createFallbackButtonState(param1,1);
         _loc2_.downState = this.createFallbackButtonState(param1,2);
         _loc2_.hitTestState = this.createFallbackButtonState(param1,0);
         _loc2_.useHandCursor = true;
         return _loc2_;
      }
      
      private function loadButtonTextures() : void
      {
         if(this._buttonTextureStarted || this._moreBtn == null || this._collapseBtn == null)
         {
            return;
         }
         this._buttonTextureStarted = true;
         try
         {
            this._buttonSheetLoader = new Loader();
            this._buttonSheetLoader.contentLoaderInfo.addEventListener(Event.COMPLETE,this.onButtonTextureReady);
            this._buttonSheetLoader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR,this.onButtonTextureError);
            this._buttonSheetLoader.contentLoaderInfo.addEventListener(SecurityErrorEvent.SECURITY_ERROR,this.onButtonTextureError);
            this._buttonSheetLoader.loadBytes(this.decodeBase64(BUTTON_SHEET_BASE64));
         }
         catch(error:Error)
         {
            this._buttonSheetLoader = null;
         }
      }
      
      private function onButtonTextureReady(param1:Event) : void
      {
         var _loc2_:Bitmap = this._buttonSheetLoader == null ? null : this._buttonSheetLoader.content as Bitmap;
         if(_loc2_ != null)
         {
            this.applyButtonTexture(this._moreBtn,String.fromCharCode(26356,22810),_loc2_.bitmapData);
            this.applyButtonTexture(this._collapseBtn,String.fromCharCode(25910,36215),_loc2_.bitmapData);
         }
         this.clearButtonTextureLoader();
      }
      
      private function onButtonTextureError(param1:Event) : void
      {
         this.clearButtonTextureLoader();
      }
      
      private function clearButtonTextureLoader() : void
      {
         if(this._buttonSheetLoader != null)
         {
            this._buttonSheetLoader.contentLoaderInfo.removeEventListener(Event.COMPLETE,this.onButtonTextureReady);
            this._buttonSheetLoader.contentLoaderInfo.removeEventListener(IOErrorEvent.IO_ERROR,this.onButtonTextureError);
            this._buttonSheetLoader.contentLoaderInfo.removeEventListener(SecurityErrorEvent.SECURITY_ERROR,this.onButtonTextureError);
         }
         this._buttonSheetLoader = null;
      }
      
      private function applyButtonTexture(param1:SimpleButton, param2:String, param3:BitmapData) : void
      {
         if(param1 == null)
         {
            return;
         }
         param1.upState = this.buildButtonStateFromSheet(param3,0,param2);
         param1.overState = this.buildButtonStateFromSheet(param3,1,param2);
         param1.downState = this.buildButtonStateFromSheet(param3,2,param2);
         param1.hitTestState = this.buildButtonStateFromSheet(param3,0,param2);
      }
      
      private function buildButtonStateFromSheet(param1:BitmapData, param2:int, param3:String) : Sprite
      {
         var _loc4_:Sprite = new Sprite();
         var _loc5_:BitmapData = new BitmapData(112,31,true,0);
         _loc5_.copyPixels(param1,new Rectangle(param2 * 112,0,112,31),new Point(0,0),null,null,true);
         var _loc6_:Bitmap = new Bitmap(_loc5_,"auto",true);
         _loc6_.smoothing = true;
         _loc4_.addChild(_loc6_);
         _loc4_.addChild(this.createButtonText(param3,0));
         _loc4_.mouseChildren = false;
         return _loc4_;
      }
      
      private function createFallbackButtonState(param1:String, param2:int) : Sprite
      {
         var _loc3_:Sprite = new Sprite();
         var _loc4_:uint = param2 == 1 ? 538244 : (param2 == 2 ? 132872 : 68153);
         _loc3_.graphics.lineStyle(1.5,param2 == 1 ? 6750207 : 14666223,1);
         _loc3_.graphics.beginFill(_loc4_,0.96);
         _loc3_.graphics.drawRoundRect(0,0,112,31,10,10);
         _loc3_.graphics.endFill();
         _loc3_.addChild(this.createButtonText(param1,param2));
         _loc3_.mouseChildren = false;
         return _loc3_;
      }
      
      private function createButtonText(param1:String, param2:int) : TextField
      {
         var _loc3_:TextField = this.createLabel(0,4,112,24,16,TextFormatAlign.CENTER,param2 == 2 ? 14666223 : 6750207);
         _loc3_.text = param1;
         return _loc3_;
      }
      
      private function createArrowButton(param1:String) : SimpleButton
      {
         var _loc2_:SimpleButton = new SimpleButton();
         _loc2_.upState = this.createArrowState(param1,0);
         _loc2_.overState = this.createArrowState(param1,1);
         _loc2_.downState = this.createArrowState(param1,2);
         _loc2_.hitTestState = this.createArrowState(param1,0);
         return _loc2_;
      }
      
      private function createSmallButton(param1:String, param2:Number) : SimpleButton
      {
         var _loc3_:SimpleButton = new SimpleButton();
         _loc3_.upState = this.createSmallButtonState(param1,param2,0);
         _loc3_.overState = this.createSmallButtonState(param1,param2,1);
         _loc3_.downState = this.createSmallButtonState(param1,param2,2);
         _loc3_.hitTestState = this.createSmallButtonState(param1,param2,0);
         return _loc3_;
      }
      
      private function createSmallButtonState(param1:String, param2:Number, param3:int) : Sprite
      {
         var _loc4_:Sprite = new Sprite();
         _loc4_.graphics.lineStyle(1,param3 == 1 ? 6750207 : 14666223,1);
         _loc4_.graphics.beginFill(param3 == 2 ? 68153 : 263695,1);
         _loc4_.graphics.drawRoundRect(0,0,param2,24,7,7);
         _loc4_.graphics.endFill();
         var _loc5_:TextField = this.createLabel(0,1,param2,22,13,TextFormatAlign.CENTER,6750207);
         _loc5_.text = param1;
         _loc4_.addChild(_loc5_);
         return _loc4_;
      }
      
      private function createPageInput() : TextField
      {
         var _loc1_:TextField = new TextField();
         var _loc2_:TextFormat = new TextFormat("Microsoft YaHei",14,6750207,true);
         _loc2_.align = TextFormatAlign.CENTER;
         _loc1_.defaultTextFormat = _loc2_;
         _loc1_.width = 42;
         _loc1_.height = 25;
         _loc1_.type = "input";
         _loc1_.restrict = "0-9";
         _loc1_.maxChars = 4;
         _loc1_.background = true;
         _loc1_.backgroundColor = 68153;
         _loc1_.border = true;
         _loc1_.borderColor = 1525726;
         _loc1_.text = "1";
         return _loc1_;
      }
      
      private function createArrowState(param1:String, param2:int) : Sprite
      {
         var _loc3_:Sprite = new Sprite();
         _loc3_.graphics.lineStyle(1,param2 == 1 ? 6750207 : 14666223,1);
         _loc3_.graphics.beginFill(param2 == 2 ? 68153 : 263695,1);
         _loc3_.graphics.drawRoundRect(0,0,26,24,7,7);
         _loc3_.graphics.endFill();
         var _loc4_:TextField = this.createLabel(0,1,26,22,15,TextFormatAlign.CENTER,6750207);
         _loc4_.text = param1;
         _loc3_.addChild(_loc4_);
         return _loc3_;
      }
      
      private function decodeBase64(param1:String) : ByteArray
      {
         var _loc2_:String = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/";
         var _loc3_:ByteArray = new ByteArray();
         var _loc4_:uint = 0;
         var _loc5_:int = 0;
         var _loc6_:int = 0;
         var _loc7_:int = 0;
         var _loc8_:String = null;
         _loc6_ = 0;
         while(_loc6_ < param1.length)
         {
            _loc8_ = param1.charAt(_loc6_);
            if(_loc8_ == "=")
            {
               break;
            }
            _loc7_ = _loc2_.indexOf(_loc8_);
            if(_loc7_ >= 0)
            {
               _loc4_ = uint(_loc4_ << 6 | uint(_loc7_));
               _loc5_ += 6;
               if(_loc5_ >= 8)
               {
                  _loc5_ -= 8;
                  _loc3_.writeByte(_loc4_ >> _loc5_ & 0xFF);
               }
            }
            _loc6_++;
         }
         _loc3_.position = 0;
         return _loc3_;
      }
      
      private function initEvent() : void
      {
         var cell:PetCell = null;
         var i:uint = 0;
         this._ruleBtn.addEventListener("click",function(param1:MouseEvent):void
         {
            addChild(_rulePanel);
         });
         this._rulePanel["closeBtn"].addEventListener("click",function(param1:MouseEvent):void
         {
            DisplayObjectUtil.removeFromParent(_rulePanel);
         });
         this._useBtn.addEventListener("click",this.onUse);
         this._preBtn.addEventListener("click",function(param1:MouseEvent):void
         {
            _skinPage = _skinPage == 0 ? 0 : uint(_skinPage - 1);
            updateSkinCell();
         });
         this._nextBtn.addEventListener("click",function(param1:MouseEvent):void
         {
            _skinPage = _skinPage * 4 + 4 >= _skinVec.length ? _skinPage : uint(_skinPage + 1);
            updateSkinCell();
         });
         if(this._moreBtn != null && this._collapseBtn != null && this._morePrevBtn != null && this._moreNextBtn != null && this._moreFirstBtn != null && this._moreLastBtn != null && this._moreJumpTxt != null && this._moreJumpBtn != null)
         {
            this._moreBtn.addEventListener("click",this.openMorePanel);
            this._collapseBtn.addEventListener("click",this.closeMorePanel);
            this._morePrevBtn.addEventListener("click",this.onMorePrevious);
            this._moreNextBtn.addEventListener("click",this.onMoreNext);
            this._moreFirstBtn.addEventListener("click",this.onMoreFirst);
            this._moreLastBtn.addEventListener("click",this.onMoreLast);
            this._moreJumpBtn.addEventListener("click",this.onMoreJump);
            this._moreJumpTxt.addEventListener(KeyboardEvent.KEY_DOWN,this.onMoreJumpKey);
            this._morePanel.addEventListener(MouseEvent.MOUSE_WHEEL,this.onMoreMouseWheel);
         }
         this._changeBtn.addEventListener("click",this.onChange);
         this._searchBtn.addEventListener("click",this.onSearch);
         this._searchTxt.addEventListener("focusIn",function(param1:*):void
         {
            _searchTxt.text = "";
         });
         this._searchTxt.addEventListener("focusOut",function(param1:*):void
         {
            if(_searchTxt.text == "")
            {
               _searchTxt.text = "精灵/皮肤序号";
            }
         });
         this._newSearchBtn.addEventListener("click",function(param1:MouseEvent):void
         {
            var e:MouseEvent = param1;
            AlertManager.showConfirm("实验功能:开启后通过搜索序号使用任意皮肤,但皮肤未做适配可能出现卡机bug,一切后果自行承担",function():void
            {
               setSearchVisible(true);
            });
         });
         i = 0;
         while(i < this._petCellVec.length)
         {
            cell = this._petCellVec[i];
            cell.addEventListener("click",this.selectPet);
            i += 1;
         }
         i = 0;
         while(i < this._skinCellVec.length)
         {
            cell = this._skinCellVec[i];
            cell.addEventListener("click",this.selectSkin);
            i += 1;
         }
      }
      
      private function updatePetVec(param1:ItemEvent) : void
      {
         var _loc2_:PetCell = null;
         var _loc3_:int = 0;
         var _loc4_:Vector.<PetInfo> = PetInfoManager.getAllBagPetInfo();
         _loc3_ = 0;
         _loc2_ = null;
         while(_loc3_ < this._petCellVec.length)
         {
            _loc2_ = this._petCellVec[_loc3_];
            _loc2_.selected = false;
            if(_loc3_ < _loc4_.length)
            {
               _loc2_.setPetInfo(_loc4_[_loc3_]);
            }
            else
            {
               _loc2_.reset();
            }
            _loc3_++;
         }
         this._currPetInfo = PetInfoManager.getFirstPetInfo();
         this._petCellVec[0].dispatchEvent(new MouseEvent("click"));
      }
      
      private function updateSkinVec(param1:Boolean = false) : void
      {
         this._isUpdatingSkinVec = true;
         try
         {
            this.internalUpdateSkinVec(param1);
         }
         finally
         {
            this._isUpdatingSkinVec = false;
         }
      }
      
      private function internalUpdateSkinVec(param1:Boolean = false) : void
      {
         var _loc2_:Array = null;
         var _loc3_:* = 0;
         var _loc4_:int = 0;
         var _loc5_:uint = 0;
         var _loc6_:uint = 1;
         var _loc7_:uint = 1;
         this._skinVec = new Vector.<uint>();
         this._allSkinVec = new Vector.<uint>();
         if(!param1)
         {
            this._skinPage = 0;
            this._morePage = 0;
         }
         _loc2_ = PetSkinDefineConfig.getPetSkinDefine(uint(this._currPetInfo.resourceId));
         if(_loc2_ != null)
         {
            this.appendOfficialSkinIds(_loc2_,this._allSkinVec);
         }
         this.appendLauncherSkinIds(this._allSkinVec);
         var basePetId:uint = uint(this._currPetInfo.resourceId);
         var hasBasePet:Boolean = false;
         var k:int = 0;
         while(k < this._allSkinVec.length)
         {
            if(this._allSkinVec[k] == basePetId)
            {
               hasBasePet = true;
               break;
            }
            k++;
         }
         if(!hasBasePet && basePetId > 0)
         {
            this._allSkinVec.unshift(basePetId);
         }
         if(this._allSkinVec.length > 0)
         {
            _loc3_ = uint(PetSkinConfig.getSkinId(uint(this._currPetInfo.resourceId)));
            if(_loc3_ == 0)
            {
               _loc3_ = uint(this._currPetInfo.resourceId);
            }
            _loc4_ = 0;
            while(_loc4_ < this._allSkinVec.length)
            {
               _loc5_ = this._allSkinVec[_loc4_];
               if(_loc5_ != _loc3_)
               {
                  this._skinVec.push(_loc5_);
               }
               _loc4_++;
            }
         }
         _loc6_ = Math.max(1,Math.ceil(this._skinVec.length / 4));
         _loc7_ = Math.max(1,Math.ceil(this._allSkinVec.length / MORE_PAGE_SIZE));
         if(this._skinPage >= _loc6_)
         {
            this._skinPage = _loc6_ - 1;
         }
         if(this._morePanel != null && this._morePanel.visible)
         {
            if(!param1)
            {
               this._morePage = this.locateActiveSkinPage();
            }
            else if(this._morePage >= _loc7_)
            {
               this._morePage = _loc7_ - 1;
            }
         }
         else if(this._morePage >= _loc7_)
         {
            this._morePage = _loc7_ - 1;
         }
         this.updateMoreCells();
         this.updateSkinCell();
      }
      
      private function appendOfficialSkinIds(param1:Array, param2:Vector.<uint>) : void
      {
         var _loc3_:int = 0;
         var _loc4_:uint = 0;
         _loc3_ = 0;
         while(_loc3_ < param1.length)
         {
            _loc4_ = uint(param1[_loc3_]);
            if(_loc4_ > 0)
            {
               param2.push(_loc4_);
            }
            _loc3_++;
         }
      }
      
      private function appendLauncherSkinIds(param1:Vector.<uint>) : void
      {
         var _loc2_:int = 0;
         _loc2_ = 0;
         while(_loc2_ < this._launcherSkinIds.length)
         {
            this.appendUniqueLauncherSkinId(param1,this._launcherSkinIds[_loc2_]);
            _loc2_++;
         }
      }
      
      private function getLauncherSkinName(param1:uint) : String
      {
         var value:String = this._launcherSkinNames[String(param1)];
         return value == null ? "" : value;
      }
      
      private function getLauncherSkinAvatarKind(param1:uint) : String
      {
         var value:String = this._launcherSkinAvatarKinds[String(param1)];
         return value == "fight" ? "fight" : "icon";
      }
      
      private function appendUniqueLauncherSkinId(param1:Vector.<uint>, param2:uint) : void
      {
         var _loc3_:int = 0;
         if(param2 == 0)
         {
            return;
         }
         _loc3_ = 0;
         while(_loc3_ < param1.length)
         {
            if(param1[_loc3_] == param2)
            {
               return;
            }
            _loc3_++;
         }
         param1.push(param2);
      }
      
      private function openMorePanel(param1:MouseEvent = null) : void
      {
         if(this._morePanel == null || this._moreBtn == null || this._collapseBtn == null)
         {
            return;
         }
         this.ensureMoreCells();
         this._morePage = this.locateActiveSkinPage();
         this._morePanel.visible = true;
         this._moreBtn.visible = false;
         this._collapseBtn.visible = true;
         this._modelLayer.visible = false;
         this.updateMoreCells();
         this._morePanel.parent.setChildIndex(this._morePanel,this._morePanel.parent.numChildren - 1);
         this._collapseBtn.parent.setChildIndex(this._collapseBtn,this._collapseBtn.parent.numChildren - 1);
      }
      
      private function ensureMoreCells() : void
      {
         var _loc1_:PetCell = null;
         var _loc2_:int = 0;
         if(this._moreCells == null)
         {
            this._moreCells = new Vector.<PetCell>();
         }
         if(this._moreCells.length > 0)
         {
            return;
         }
         _loc2_ = 0;
         while(_loc2_ < MORE_PAGE_SIZE)
         {
            _loc1_ = new PetCell();
            _loc1_.scaleX = _loc1_.scaleY = 0.86;
            _loc1_.x = 28 + _loc2_ % 6 * 108;
            _loc1_.y = 40 + int(_loc2_ / 6) * 96;
            _loc1_.addEventListener("click",this.selectMoreSkin);
            this._morePanel.addChild(_loc1_);
            this._moreCells.push(_loc1_);
            _loc2_++;
         }
      }
      
      private function closeMorePanel(param1:MouseEvent = null) : void
      {
         var cell:PetCell = null;
         var index:int = 0;
         if(this._morePanel == null || this._moreBtn == null || this._collapseBtn == null)
         {
            return;
         }
         this._morePanel.visible = false;
         this._moreBtn.visible = true;
         this._collapseBtn.visible = false;
         this._modelLayer.visible = true;
         if(this._moreCells != null)
         {
            cell = null;
            index = 0;
            while(index < this._moreCells.length)
            {
               cell = this._moreCells[index];
               if(cell != null)
               {
                  cell.reset();
                  this.setCellHighlight(cell,false);
               }
               index++;
            }
         }
      }
      
      private function onMorePrevious(param1:MouseEvent) : void
      {
         if(this._morePage > 0)
         {
            --this._morePage;
            this.updateMoreCells();
         }
      }
      
      private function onMoreNext(param1:MouseEvent) : void
      {
         if(this._allSkinVec != null && (this._morePage + 1) * MORE_PAGE_SIZE < this._allSkinVec.length)
         {
            ++this._morePage;
            this.updateMoreCells();
         }
      }
      
      private function onMoreFirst(param1:MouseEvent) : void
      {
         if(this._morePage != 0)
         {
            this._morePage = 0;
            this.updateMoreCells();
         }
      }
      
      private function onMoreLast(param1:MouseEvent) : void
      {
         var _loc2_:uint = this.getMorePageCount();
         if(this._morePage + 1 != _loc2_)
         {
            this._morePage = _loc2_ - 1;
            this.updateMoreCells();
         }
      }
      
      private function onMoreJump(param1:MouseEvent = null) : void
      {
         var _loc2_:int = this._moreJumpTxt == null ? 0 : int(this._moreJumpTxt.text);
         var _loc3_:uint = this.getMorePageCount();
         if(_loc2_ < 1)
         {
            _loc2_ = 1;
         }
         if(_loc2_ > _loc3_)
         {
            _loc2_ = int(_loc3_);
         }
         this._morePage = _loc2_ - 1;
         this.updateMoreCells();
         if(stage != null)
         {
            stage.focus = null;
         }
      }
      
      private function onMoreJumpKey(param1:KeyboardEvent) : void
      {
         if(param1.keyCode == Keyboard.ENTER)
         {
            this.onMoreJump();
            param1.stopPropagation();
         }
      }
      
      private function getMorePageCount() : uint
      {
         if(this._allSkinVec == null || this._allSkinVec.length == 0)
         {
            return 1;
         }
         return Math.ceil(this._allSkinVec.length / MORE_PAGE_SIZE);
      }
      
      private function onMoreMouseWheel(param1:MouseEvent) : void
      {
         if(this._morePanel == null || !this._morePanel.visible || param1.delta == 0)
         {
            return;
         }
         if(param1.delta < 0)
         {
            this.onMoreNext(param1);
         }
         else
         {
            this.onMorePrevious(param1);
         }
         param1.stopPropagation();
      }
      
      private function updateMoreCells() : void
      {
         var _loc1_:int = 0;
         var _loc2_:uint = 0;
         var _loc3_:uint = this.getMorePageCount();
         var _loc4_:PetCell = null;
         if(this._moreCells == null)
         {
            return;
         }
         var activeSkinId:uint = this.getActiveSkinId();
         _loc1_ = 0;
         while(_loc1_ < this._moreCells.length)
         {
            _loc4_ = this._moreCells[_loc1_];
            _loc4_.reset();
            _loc2_ = this._morePage * MORE_PAGE_SIZE + _loc1_;
            if(this._allSkinVec != null && _loc2_ < this._allSkinVec.length)
            {
               var cellSkinId:uint = this._allSkinVec[_loc2_];
               _loc4_.setSkinInfo(this._currPetInfo,cellSkinId,this.isLauncherSkinId(cellSkinId),this.getLauncherSkinName(cellSkinId),this.getLauncherSkinAvatarKind(cellSkinId),true,true);
               this.setCellHighlight(_loc4_,cellSkinId == activeSkinId);
            }
            else
            {
               this.setCellHighlight(_loc4_,false);
            }
            _loc1_++;
         }
         if(this._morePage >= _loc3_)
         {
            this._morePage = _loc3_ - 1;
         }
         this._morePageTxt.text = String(this._morePage + 1) + " / " + String(_loc3_) + "  (" + String(this._allSkinVec == null ? 0 : this._allSkinVec.length) + ")";
         if(this._moreJumpTxt != null)
         {
            this._moreJumpTxt.text = String(this._morePage + 1);
         }
         this._morePrevBtn.mouseEnabled = this._morePage > 0;
         this._morePrevBtn.alpha = this._morePrevBtn.mouseEnabled ? 1 : 0.35;
         this._moreNextBtn.mouseEnabled = this._allSkinVec != null && (this._morePage + 1) * MORE_PAGE_SIZE < this._allSkinVec.length;
         this._moreNextBtn.alpha = this._moreNextBtn.mouseEnabled ? 1 : 0.35;
         this._moreFirstBtn.mouseEnabled = this._morePage > 0;
         this._moreFirstBtn.alpha = this._moreFirstBtn.mouseEnabled ? 1 : 0.35;
         this._moreLastBtn.mouseEnabled = this._morePage + 1 < _loc3_;
         this._moreLastBtn.alpha = this._moreLastBtn.mouseEnabled ? 1 : 0.35;
         if(this._morePanel != null && this._morePanel.visible)
         {
            this.startMoreCellLoads();
         }
      }
      
      private function startMoreCellLoads() : void
      {
         var cell:PetCell = null;
         var index:int = 0;
         if(this._moreCells == null)
         {
            return;
         }
         while(index < this._moreCells.length)
         {
            cell = this._moreCells[index++];
            if(cell != null && cell.skinId != 0)
            {
               cell.loadDeferredSkinPreview();
            }
         }
      }
      
      private function createQuickSelectButton() : void
      {
         this._quickSelectBtn = new Sprite();
         this._quickSelectBtn.x = 104;
         this._quickSelectBtn.y = 4;
         this._quickSelectBtn.buttonMode = true;
         this._quickSelectBtn.useHandCursor = true;
         this._quickSelectBtn.mouseChildren = false;
         this._quickSelectBox = new Shape();
         this._quickSelectBtn.addChild(this._quickSelectBox);
         this._quickSelectTxt = this.createLabel(23,1,64,22,12,TextFormatAlign.LEFT,6750207);
         this._quickSelectTxt.text = String.fromCharCode(24555,36895,36873,25321);
         this._quickSelectBtn.addChild(this._quickSelectTxt);
         this._quickSelectBtn.addEventListener(MouseEvent.CLICK,this.onToggleQuickSelect);
         this._quickSelectBtn.addEventListener(MouseEvent.MOUSE_OVER,this.onQuickSelectOver);
         this._quickSelectBtn.addEventListener(MouseEvent.MOUSE_OUT,this.onQuickSelectOut);
         this.updateQuickSelectUI();
         this._morePanel.addChild(this._quickSelectBtn);
      }
      
      private function onToggleQuickSelect(param1:MouseEvent) : void
      {
         this._quickSelect = !this._quickSelect;
         this.writeQuickSelectConfig(this._quickSelect);
         this.updateQuickSelectUI();
      }
      
      private function onQuickSelectOver(param1:MouseEvent) : void
      {
         this._quickSelectHover = true;
         this.updateQuickSelectUI();
      }
      
      private function onQuickSelectOut(param1:MouseEvent) : void
      {
         this._quickSelectHover = false;
         this.updateQuickSelectUI();
      }
      
      private function updateQuickSelectUI() : void
      {
         if(this._quickSelectBtn == null || this._quickSelectBox == null || this._quickSelectTxt == null)
         {
            return;
         }
         this._quickSelectBtn.graphics.clear();
         var _loc1_:uint = 0;
         var _loc2_:uint = 0;
         var _loc3_:uint = 0;
         var _loc4_:uint = 0;
         var _loc5_:uint = 0;
         if(this._quickSelect)
         {
            _loc1_ = this._quickSelectHover ? 10092543 : 6750207;
            _loc2_ = this._quickSelectHover ? 726886 : 538244;
            _loc3_ = 6750207;
            _loc4_ = 68153;
            _loc5_ = 6750207;
         }
         else
         {
            _loc1_ = this._quickSelectHover ? 6710886 : 4473924;
            _loc2_ = this._quickSelectHover ? 657930 : 263695;
            _loc3_ = 5592405;
            _loc4_ = 263695;
            _loc5_ = 8947848;
         }
         this._quickSelectBtn.graphics.lineStyle(1,_loc1_,0.95);
         this._quickSelectBtn.graphics.beginFill(_loc2_,0.95);
         this._quickSelectBtn.graphics.drawRoundRect(0,0,90,24,7,7);
         this._quickSelectBtn.graphics.endFill();
         this._quickSelectBox.graphics.clear();
         this._quickSelectBox.graphics.lineStyle(1.2,_loc3_,1);
         this._quickSelectBox.graphics.beginFill(_loc4_,1);
         this._quickSelectBox.graphics.drawRoundRect(6,4,14,14,4,4);
         this._quickSelectBox.graphics.endFill();
         if(this._quickSelect)
         {
            this._quickSelectBox.graphics.lineStyle(2,6750207,1);
            this._quickSelectBox.graphics.moveTo(8,11);
            this._quickSelectBox.graphics.lineTo(12,15);
            this._quickSelectBox.graphics.lineTo(18,7);
         }
         var _loc6_:TextFormat = this._quickSelectTxt.defaultTextFormat;
         _loc6_.color = _loc5_;
         this._quickSelectTxt.defaultTextFormat = _loc6_;
         this._quickSelectTxt.text = String.fromCharCode(24555,36895,36873,25321);
      }
      
      private function getQuickSelectStorageKey() : String
      {
         try
         {
            if(ActorManager.actorInfo != null && ActorManager.actorInfo.id != 0)
            {
               return "quickSelect_" + ActorManager.actorInfo.id;
            }
         }
         catch(error:Error)
         {
         }
         return "quickSelect_global";
      }
      
      private function readQuickSelectConfig() : Boolean
      {
         return true;
      }
      
      private function writeQuickSelectConfig(param1:Boolean) : void
      {
         var _loc2_:SharedObject = null;
         var _loc3_:String = null;
         try
         {
            _loc2_ = SharedObject.getLocal("Seer2_PetSkin_Config");
            if(_loc2_ != null && _loc2_.data != null)
            {
               _loc3_ = this.getQuickSelectStorageKey();
               _loc2_.data[_loc3_] = param1;
               _loc2_.data["quickSelect"] = param1;
               _loc2_.flush();
            }
         }
         catch(error:Error)
         {
         }
      }
      
      private function getSkinDisplayName(param1:uint) : String
      {
         var _loc2_:String = this.getLauncherSkinName(param1);
         if(_loc2_ != null && _loc2_.length > 0)
         {
            return _loc2_;
         }
         var _loc3_:PetDefinition = PetConfig.getPetDefinition(param1);
         if(_loc3_ != null && _loc3_.name != null && _loc3_.name.length > 0)
         {
            return _loc3_.name;
         }
         return "皮肤 " + param1;
      }
      
      private function getActiveSkinId() : uint
      {
         if(this._currPetInfo == null)
         {
            return 0;
         }
         var activeSkinId:uint = uint(PetSkinConfig.getSkinId(uint(this._currPetInfo.resourceId)));
         if(activeSkinId == 0)
         {
            activeSkinId = uint(this._currPetInfo.resourceId);
         }
         return activeSkinId;
      }
      
      private function locateActiveSkinPage() : uint
      {
         var activeSkinId:uint = this.getActiveSkinId();
         if(this._allSkinVec == null || this._allSkinVec.length == 0 || activeSkinId == 0)
         {
            return 0;
         }
         var index:int = 0;
         while(index < this._allSkinVec.length)
         {
            if(this._allSkinVec[index] == activeSkinId)
            {
               return uint(index / MORE_PAGE_SIZE);
            }
            index++;
         }
         return 0;
      }
      
      private function createHighlightSprite() : Sprite
      {
         var spr:Sprite = new Sprite();
         spr.mouseEnabled = false;
         spr.mouseChildren = false;
         spr.graphics.clear();
         spr.graphics.lineStyle(4,65535,0.45);
         spr.graphics.drawRoundRect(-43.5,-43.5,87,87,8,8);
         spr.graphics.lineStyle(2.5,16766720,1);
         spr.graphics.drawRoundRect(-42,-42,84,84,6,6);
         spr.graphics.lineStyle(1,16777130,0.6);
         spr.graphics.drawRoundRect(-40.5,-40.5,81,81,4,4);
         spr.graphics.lineStyle(1,16766720,1);
         spr.graphics.beginFill(11081,0.95);
         spr.graphics.drawRoundRect(-41,-41,32,16,4,4);
         spr.graphics.endFill();
         var txt:TextField = this.createLabel(-41,-42,32,16,10,TextFormatAlign.CENTER,16766720);
         txt.text = String.fromCharCode(24403,21069);
         spr.addChild(txt);
         return spr;
      }
      
      private function setCellHighlight(cell:PetCell, isHighlight:Boolean) : void
      {
         if(cell == null)
         {
            return;
         }
         cell.selected = isHighlight;
         var container:DisplayObjectContainer = null;
         try
         {
            if(cell.numChildren > 0)
            {
               var ui:DisplayObjectContainer = cell.getChildAt(0) as DisplayObjectContainer;
               if(ui != null && "content" in ui && ui["content"] != null)
               {
                  container = ui["content"] as DisplayObjectContainer;
               }
            }
         }
         catch(error:Error)
         {
         }
         if(container == null)
         {
            container = cell;
         }
         var hl:Sprite = container.getChildByName("_activeHighlight") as Sprite;
         if(!isHighlight)
         {
            if(hl != null)
            {
               hl.visible = false;
            }
            return;
         }
         if(hl == null)
         {
            hl = this.createHighlightSprite();
            hl.name = "_activeHighlight";
            container.addChild(hl);
         }
         if(container == cell)
         {
            hl.x = 44;
            hl.y = 65;
         }
         else
         {
            hl.x = 0;
            hl.y = 0;
         }
         hl.visible = true;
         container.setChildIndex(hl,container.numChildren - 1);
      }
      
      private function applySkin(param1:uint) : void
      {
         if(this._currPetInfo == null || param1 == 0)
         {
            return;
         }
         this._currSkinId = param1;
         this.clearRightSkinSelection();
         PetSkinConfig.setPetSkin(uint(this._currPetInfo.resourceId),this._currSkinId);
         this.updatePetDisplay();
         this.updateSkinVec(true);
         if(this._morePanel != null && this._morePanel.visible)
         {
            this._morePanel.visible = true;
            this._moreBtn.visible = false;
            this._collapseBtn.visible = true;
            this._modelLayer.visible = false;
         }
      }
      
      private function selectMoreSkin(param1:MouseEvent) : void
      {
         var cell:PetCell = param1.currentTarget as PetCell;
         if(cell == null || cell.skinId == 0)
         {
            return;
         }
         var targetSkinId:uint = cell.skinId;
         this.applySkin(targetSkinId);
      }
      
      private function clearRightSkinSelection() : void
      {
         var _loc1_:int = 0;
         _loc1_ = 0;
         while(_loc1_ < this._skinCellVec.length)
         {
            this.setCellHighlight(this._skinCellVec[_loc1_],false);
            _loc1_++;
         }
      }
      
      private function isLauncherSkinId(param1:uint) : Boolean
      {
         var _loc2_:int = 0;
         _loc2_ = 0;
         while(_loc2_ < this._launcherSkinIds.length)
         {
            if(this._launcherSkinIds[_loc2_] == param1)
            {
               return true;
            }
            _loc2_++;
         }
         return false;
      }
      
      private function updateSkinCell() : void
      {
         var _loc1_:PetCell = null;
         var _loc2_:int = 0;
         DisplayObjectUtil.disableButton(this._nextBtn);
         DisplayObjectUtil.disableButton(this._preBtn);
         _loc2_ = 0;
         _loc1_ = null;
         while(_loc2_ < this._skinCellVec.length)
         {
            _loc1_ = this._skinCellVec[_loc2_];
            _loc1_.reset();
            this.setCellHighlight(_loc1_,false);
            _loc2_++;
         }
         var activeSkinId:uint = this.getActiveSkinId();
         if(this._skinVec.length > 0)
         {
            var targetPreviewSkinId:uint = 0;
            _loc2_ = 0;
            _loc1_ = null;
            while(_loc2_ < 4 && _loc2_ + this._skinPage * 4 < this._skinVec.length)
            {
               _loc1_ = this._skinCellVec[_loc2_];
               var rSkinId:uint = this._skinVec[_loc2_ + this._skinPage * 4];
               _loc1_.setSkinInfo(this._currPetInfo,rSkinId,this.isLauncherSkinId(rSkinId),this.getLauncherSkinName(rSkinId),this.getLauncherSkinAvatarKind(rSkinId));
               var isRightActive:Boolean = (rSkinId == activeSkinId);
               this.setCellHighlight(_loc1_,isRightActive);
               if(isRightActive)
               {
                  targetPreviewSkinId = rSkinId;
               }
               _loc2_++;
            }
            if(targetPreviewSkinId == 0)
            {
               targetPreviewSkinId = this._skinCellVec[0].skinId;
            }
            this._currSkinId = targetPreviewSkinId;
            this.updateSkinDisplay();
         }
         else
         {
            this._currSkinId = 0;
            this.updateSkinDisplay();
         }
         if(this._skinPage * 4 + 4 < this._skinVec.length)
         {
            DisplayObjectUtil.enableButton(this._nextBtn);
         }
         if(this._skinPage > 0)
         {
            DisplayObjectUtil.enableButton(this._preBtn);
         }
      }
      
      private function selectSkin(param1:MouseEvent) : void
      {
         var _loc2_:PetCell = param1.currentTarget as PetCell;
         if(_loc2_ == null || _loc2_.skinId == 0)
         {
            return;
         }
         var targetSkinId:uint = _loc2_.skinId;
         if(this._isUpdatingSkinVec)
         {
            this._currSkinId = targetSkinId;
            this.updateSkinDisplay();
            return;
         }
         this.applySkin(targetSkinId);
      }
      
      private function selectPet(param1:MouseEvent) : void
      {
         var _loc2_:PetCell = null;
         var _loc3_:int = 0;
         var isMorePanelOpen:Boolean = this._morePanel != null && this._morePanel.visible;
         _loc3_ = 0;
         _loc2_ = null;
         while(_loc3_ < this._petCellVec.length)
         {
            _loc2_ = this._petCellVec[_loc3_];
            _loc2_.selected = false;
            _loc3_++;
         }
         _loc2_ = param1.currentTarget as PetCell;
         _loc2_.selected = true;
         this._currPetInfo = _loc2_.petInfo;
         this.updateSkinVec(false);
         if(isMorePanelOpen)
         {
            this._morePage = this.locateActiveSkinPage();
            this.updateMoreCells();
         }
         this.updatePetDisplay();
         if(isMorePanelOpen)
         {
            this._morePanel.visible = true;
            this._moreBtn.visible = false;
            this._collapseBtn.visible = true;
            this._modelLayer.visible = false;
            if(this._morePanel.parent != null)
            {
               this._morePanel.parent.setChildIndex(this._morePanel,this._morePanel.parent.numChildren - 1);
            }
            if(this._collapseBtn.parent != null)
            {
               this._collapseBtn.parent.setChildIndex(this._collapseBtn,this._collapseBtn.parent.numChildren - 1);
            }
         }
      }
      
      private function updatePetDisplay() : void
      {
         var revision:uint = 0;
         revision = 0;
         revision = 0;
         revision = 0;
         var url:String = null;
         revision = ++this._petDisplayRevision;
         this._petName.text = PetConfig.getPetDefinition(uint(this._currPetInfo.resourceId)).name;
         DisplayObjectUtil.removeFromParent(this._petDisplayer);
         this.resetModelDisplayer(this._petDisplayer,180,200);
         url = String(URLUtil.getPetDemo(uint(this._currPetInfo.resourceId)));
         this._petDisplayer.newSetUrl(url,248,240,function():void
         {
            if(revision != _petDisplayRevision)
            {
               return;
            }
            _modelLayer.addChild(_petDisplayer);
            _petDisplayer.mask = _petModelMask;
            fitModelDisplayer(_petDisplayer,new Rectangle(18,65,344,250),180,200);
            raiseInteractiveControls();
         });
         this._changeBtn.visible = Boolean(this._currPetInfo.getPetDefinition()) && this._currPetInfo.getPetDefinition().chgMonId != 0;
         this._changeBtn.mouseEnabled = this._changeBtn.visible;
      }
      
      private function updateSkinDisplay() : void
      {
         var revision:uint = 0;
         revision = 0;
         revision = 0;
         revision = 0;
         var url:String = null;
         var launcherName:String = "";
         var definition:PetDefinition = null;
         revision = ++this._skinDisplayRevision;
         this._skinName.visible = false;
         this._noSkinTip.visible = true;
         DisplayObjectUtil.removeFromParent(this._skinDisplayer);
         this.resetModelDisplayer(this._skinDisplayer,520,200);
         DisplayObjectUtil.disableButton(this._useBtn);
         if(Boolean(this._currSkinId))
         {
            this._skinName.visible = true;
            this._noSkinTip.visible = false;
            DisplayObjectUtil.enableButton(this._useBtn);
            launcherName = this.getLauncherSkinName(this._currSkinId);
            definition = PetConfig.getPetDefinition(this._currSkinId);
            this._skinName.text = launcherName.length > 0 ? launcherName : (definition != null ? definition.name : "皮肤 " + this._currSkinId);
            url = String(URLUtil.getPetOriginDemo(this._currSkinId));
            this._skinDisplayer.newSetUrl(url,248,240,function():void
            {
               if(revision != _skinDisplayRevision)
               {
                  return;
               }
               _modelLayer.addChild(_skinDisplayer);
               _skinDisplayer.mask = _skinModelMask;
               fitModelDisplayer(_skinDisplayer,new Rectangle(382,65,330,250),520,200);
               raiseInteractiveControls();
            });
         }
         this.restoreUseButtonLayer();
      }
      
      private function resetModelDisplayer(param1:PetDemoDisplayer, param2:Number, param3:Number) : void
      {
         if(param1 == null)
         {
            return;
         }
         param1.scaleX = param1.scaleY = 1;
         param1.x = param2;
         param1.y = param3;
      }
      
      private function fitModelDisplayer(param1:PetDemoDisplayer, param2:Rectangle, defaultX:Number, defaultY:Number) : void
      {
         var displayer:PetDemoDisplayer = param1;
         var safeRect:Rectangle = param2;
         var bounds:Rectangle = null;
         var fitScale:Number = 1;
         var left:Number = safeRect != null ? safeRect.left + MODEL_FIT_PADDING : 0;
         var right:Number = safeRect != null ? safeRect.right - MODEL_FIT_PADDING : 0;
         var top:Number = safeRect != null ? safeRect.top + MODEL_FIT_PADDING : 0;
         var bottom:Number = safeRect != null ? safeRect.bottom - MODEL_FIT_PADDING : 0;
         if(displayer == null || safeRect == null || this._modelLayer == null || displayer.parent != this._modelLayer)
         {
            return;
         }
         displayer.scaleX = displayer.scaleY = 1;
         displayer.x = defaultX;
         displayer.y = defaultY;
         try
         {
            bounds = displayer.getBounds(this._modelLayer);
         }
         catch(error:Error)
         {
            return;
         }
         if(bounds == null || bounds.width <= 1 || bounds.height <= 1)
         {
            return;
         }
         if(bounds.width >= 800 && bounds.height >= 450)
         {
            displayer.scaleX = displayer.scaleY = 1;
            displayer.x = defaultX;
            displayer.y = defaultY;
            return;
         }
         var maxWidth:Number = right - left;
         var maxHeight:Number = bottom - top;
         if(bounds.width > maxWidth || bounds.height > maxHeight)
         {
            fitScale = Math.min(1,maxWidth / bounds.width,maxHeight / bounds.height);
            fitScale = Math.max(0.75,fitScale);
            displayer.scaleX = displayer.scaleY = fitScale;
            displayer.x = defaultX;
            displayer.y = defaultY;
            return;
         }
      }
      
      private function restoreUseButtonLayer() : void
      {
         if(this._useBtn == null || this._mainUI == null)
         {
            return;
         }
         if(this._useBtn.parent != this._mainUI)
         {
            DisplayObjectUtil.removeFromParent(this._useBtn);
            this._mainUI.addChild(this._useBtn);
         }
         this._mainUI.setChildIndex(this._useBtn,this._mainUI.numChildren - 1);
         this.raiseInteractiveControls();
         if(this._morePanel != null && this._morePanel.visible && this._morePanel.parent == this)
         {
            this.setChildIndex(this._morePanel,this.numChildren - 1);
         }
      }
      
      private function isLauncherRouteCapabilityEnabled(param1:String) : Boolean
      {
         var _loc2_:String = param1 == null ? "" : param1.toLowerCase();
         return _loc2_ == "1" || _loc2_ == "true";
      }
      
      private function raiseInteractiveControls() : void
      {
         this.raiseInteractiveControl(this._closeBtn);
         this.raiseInteractiveControl(this._dragSprite);
         this.raiseInteractiveControl(this._changeBtn);
         this.raiseInteractiveControl(this._preBtn);
         this.raiseInteractiveControl(this._nextBtn);
         this.raiseInteractiveControl(this._searchBtn);
         this.raiseInteractiveControl(this._newSearchBtn);
         this.raiseInteractiveControl(this._ruleBtn);
         this.raiseInteractiveControl(this._useBtn);
         if(this._morePanel != null && this._morePanel.parent == this)
         {
            this.setChildIndex(this._morePanel,this.numChildren - 1);
         }
      }
      
      private function raiseInteractiveControl(param1:DisplayObject) : void
      {
         if(param1 != null && param1.parent == this._mainUI)
         {
            this._mainUI.setChildIndex(param1,this._mainUI.numChildren - 1);
         }
      }
      
      private function onUse(param1:MouseEvent) : void
      {
         this.applySkin(this._currSkinId);
      }
      
      private function onSearch(param1:MouseEvent) : void
      {
         var _loc2_:* = 0;
         var _loc3_:PetDefinition = null;
         var _loc4_:PetCell = null;
         var _loc5_:int = 0;
         var _loc6_:String = String(StringUtil.trim(this._searchTxt.text));
         if(this._searchTxt.text != "" && this._searchTxt.text != "精灵/皮肤序号")
         {
            if(StringUtil.isInteger(_loc6_))
            {
               _loc2_ = uint(int(_loc6_));
            }
            else
            {
               AlertManager.showAlert("输入的不是数字或输入格式非法!");
            }
            _loc3_ = PetConfig.getPetDefinition(_loc2_);
            if(Boolean(_loc3_) || this.isLauncherSkinId(_loc2_))
            {
               _loc5_ = 0;
               _loc4_ = null;
               while(_loc5_ < this._skinCellVec.length)
               {
                  _loc4_ = this._skinCellVec[_loc5_];
                  _loc4_.selected = false;
                  _loc5_++;
               }
               this._currSkinId = _loc2_;
               this.updateSkinDisplay();
            }
            else
            {
               AlertManager.showAlert("未找到该序号的精灵/皮肤,请前往精灵图鉴查询");
            }
         }
      }
      
      private function onChange(param1:MouseEvent) : void
      {
         var _loc2_:uint = uint(this._currPetInfo.getPetDefinition().chgMonId);
         var _loc3_:Boolean = this._morePanel != null && this._morePanel.visible;
         if(_loc2_ != 0)
         {
            this._currPetInfo.resourceId = _loc2_;
         }
         this.updateSkinVec(true);
         this.updatePetDisplay();
         if(_loc3_)
         {
            this._morePanel.visible = true;
            this._moreBtn.visible = false;
            this._collapseBtn.visible = true;
            this._modelLayer.visible = false;
         }
      }
      
      private function setSearchVisible(param1:Boolean) : void
      {
         this._searchBtn.visible = param1;
         this._searchBtn.mouseEnabled = param1;
         this._searchTxt.visible = param1;
         this._searchTxt.mouseEnabled = param1;
         this._searchBg.visible = param1;
         this._newSearchBtn.visible = !param1;
         this._newSearchBtn.mouseEnabled = !param1;
      }
      
      override public function show() : void
      {
         super.show();
         setTimeout(this.loadButtonTextures,750);
         ItemManager.addEventListener1("requestSpecialItemSuccess",this.updatePetVec);
         ItemManager.requestSpecialItemList();
      }
   }
}

