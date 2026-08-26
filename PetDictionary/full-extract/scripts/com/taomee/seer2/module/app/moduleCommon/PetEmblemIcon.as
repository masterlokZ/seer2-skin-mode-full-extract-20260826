package com.taomee.seer2.module.app.moduleCommon
{
   import com.taomee.seer2.app.component.IconDisplayer;
   import com.taomee.seer2.app.config.ItemConfig;
   import com.taomee.seer2.app.config.item.EmblemItemDefinition;
   import com.taomee.seer2.core.ui.toolTip.TooltipManager;
   import com.taomee.seer2.core.utils.URLUtil;
   import flash.display.Sprite;
   
   public class PetEmblemIcon extends Sprite
   {
      
      private var _icon:IconDisplayer;
      
      public function PetEmblemIcon()
      {
         super();
         this.initialize();
      }
      
      private function initialize() : void
      {
         this.createChildren();
      }
      
      private function createChildren() : void
      {
         this._icon = new IconDisplayer();
         TooltipManager.addCommonTip(this._icon,"");
         addChild(this._icon);
      }
      
      public function set id(param1:int) : void
      {
         var _loc2_:String = null;
         var _loc3_:String = null;
         var _loc4_:EmblemItemDefinition = null;
         if(param1 == 0)
         {
            this._icon.mouseEnabled = false;
            this._icon.mouseChildren = false;
            this._icon.buttonMode = false;
            this._icon.visible = false;
            return;
         }
         this._icon.mouseEnabled = true;
         this._icon.mouseChildren = true;
         this._icon.buttonMode = true;
         this._icon.visible = true;
         _loc2_ = String(URLUtil.getEmblemIcon(param1));
         this._icon.setIconUrl(_loc2_);
         _loc3_ = "";
         _loc4_ = ItemConfig.getEmblemDefinition(param1);
         if(_loc4_ != null)
         {
            _loc3_ = String(_loc4_.tip);
         }
         TooltipManager.changeTip(this._icon,_loc3_);
      }
   }
}

