package com.taomee.seer2.module.app.newPetDictionary
{
   import com.taomee.seer2.core.sound.SoundManager;
   import com.taomee.seer2.core.utils.URLUtil;
   import flash.display.Sprite;
   
   public class NewPetDicsListAndDetailPanel extends Sprite
   {
      
      private var _listPanel:NewPetDicsPetListPanel;
      
      private var _detailPanel:NewPetDicsPetDetailPanel;
      
      private var _data:Vector.<int>;
      
      public function NewPetDicsListAndDetailPanel()
      {
         super();
         this.createChildren();
         this.initEventListener();
      }
      
      private function createChildren() : void
      {
         this._listPanel = new NewPetDicsPetListPanel();
         addChild(this._listPanel);
         this._detailPanel = new NewPetDicsPetDetailPanel();
         addChild(this._detailPanel);
         this._detailPanel.x = 452;
         this._detailPanel.y = -51;
      }
      
      private function initEventListener() : void
      {
         this._listPanel.addEventListener("showPetDetail",this.onShowPetDetailPanel);
      }
      
      private function onShowPetDetailPanel(param1:NewPetDicsEvent) : void
      {
         var _loc2_:int = int(param1.getPetResourceId());
         if(_loc2_ != this._detailPanel.petResourceId)
         {
            this._detailPanel.setData(_loc2_);
            SoundManager.play(URLUtil.getPetSound(_loc2_));
         }
      }
      
      public function get detailPanel() : NewPetDicsPetDetailPanel
      {
         return this._detailPanel;
      }
      
      public function setData(param1:Vector.<int>) : void
      {
         this._data = param1;
         this._listPanel.setData(param1);
         if(Boolean(param1) && param1.length >= 2)
         {
            this._detailPanel.setData(param1[1]);
         }
      }
      
      public function dispose() : void
      {
         this._listPanel.dispose();
      }
   }
}

