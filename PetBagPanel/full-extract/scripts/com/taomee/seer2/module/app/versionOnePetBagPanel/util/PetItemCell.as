package com.taomee.seer2.module.app.versionOnePetBagPanel.util
{
   import com.taomee.seer2.app.component.IconDisplayer;
   import com.taomee.seer2.app.component.ItemToolTip;
   import com.taomee.seer2.core.inventory.Item;
   import com.taomee.seer2.core.ui.UINumberGenerator;
   import com.taomee.seer2.core.utils.DisplayObjectUtil;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   
   public class PetItemCell extends Sprite
   {
      
      public static const ITEM_USE:String = "itemUse";
      
      private static const DEFAULT_SIZE:int = 45;
      
      private var _container:MovieClip;
      
      private var _iconDisplayer:IconDisplayer;
      
      private var _itemNumSpr:Sprite;
      
      private var _bgMc:MovieClip;
      
      private var _vipMc:MovieClip;
      
      private var _item:Item;
      
      public function PetItemCell()
      {
         super();
         this.initialize();
      }
      
      private function initialize() : void
      {
         this.createChildren();
         this.initEventListener();
      }
      
      private function createChildren() : void
      {
         this._container = new ItemCellUI();
         addChild(this._container);
         this._iconDisplayer = new IconDisplayer();
         addChild(this._iconDisplayer);
         this._itemNumSpr = new Sprite();
         this._itemNumSpr.x = 42;
         this._itemNumSpr.y = 25;
         addChild(this._itemNumSpr);
         this._bgMc = this._container["bgMc"];
         this._bgMc.gotoAndStop(1);
         this._vipMc = this._container["vipMc"];
         this._vipMc.visible = false;
         addChild(this._vipMc);
      }
      
      private function initEventListener() : void
      {
         this.mouseChildren = false;
         this.addEventListener("click",this.onMouseClick);
         this.addEventListener("mouseOver",this.onMouseOver);
         this.addEventListener("mouseOut",this.onMouseOut);
      }
      
      private function onMouseClick(param1:MouseEvent) : void
      {
         dispatchEvent(new Event("itemUse"));
      }
      
      private function onMouseOver(param1:MouseEvent) : void
      {
         ItemToolTip.show(this._item);
      }
      
      private function onMouseOut(param1:MouseEvent) : void
      {
         ItemToolTip.hide();
         trace("鼠标一开~");
      }
      
      public function setData(param1:Item) : void
      {
         this.reset();
         this._item = param1;
         if(this._item != null)
         {
            this.buttonMode = true;
            this.mouseEnabled = true;
            this.updateDisplay();
         }
      }
      
      private function reset() : void
      {
         this.buttonMode = false;
         this.mouseEnabled = false;
         this._iconDisplayer.removeIcon();
         DisplayObjectUtil.removeAllChildren(this._itemNumSpr);
         this._container.gotoAndStop(1);
         this._vipMc.visible = false;
      }
      
      private function updateDisplay() : void
      {
         this._iconDisplayer.setIconUrl(this._item.iconUrl,this.onLoadComplete);
         this._vipMc.visible = this._item.isVipOnly;
      }
      
      private function onLoadComplete() : void
      {
         this._iconDisplayer.scaleX = this._iconDisplayer.scaleY = 0.7;
         this._iconDisplayer.x = (45 - this._iconDisplayer.width) / 2;
         this._iconDisplayer.y = (45 - this._iconDisplayer.height) / 2;
         this.addItemNumber();
      }
      
      private function addItemNumber() : void
      {
         var _loc1_:Sprite = UINumberGenerator.generateItemNumber(this._item.quantity);
         _loc1_.x = -_loc1_.width;
         this._itemNumSpr.addChild(_loc1_);
         addChild(this._itemNumSpr);
      }
      
      public function set isSelected(param1:Boolean) : void
      {
         if(param1)
         {
            this._bgMc.gotoAndStop(2);
         }
         else
         {
            this._bgMc.gotoAndStop(1);
         }
      }
      
      public function get item() : Item
      {
         return this._item;
      }
   }
}

