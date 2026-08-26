package com.taomee.seer2.module.app.petDictionary
{
   import com.taomee.seer2.module.app.moduleCommon.PageBar;
   import com.taomee.seer2.module.app.petDictionary.config.PetDictionaryConfig;
   import com.taomee.seer2.module.app.petDictionary.config.configInfo.TrainRewardInfo;
   import com.taomee.seer2.module.app.petDictionary.event.PetDictionaryEvent;
   import com.taomee.seer2.module.app.petDictionary.trainReward.TrainRewardCell;
   import flash.display.MovieClip;
   import flash.display.SimpleButton;
   import flash.display.Sprite;
   import flash.events.Event;
   
   public class PetDictionaryTrainRewardPanel extends Sprite
   {
      
      private const PAGESIZE:int = 8;
      
      private var _pageBar:PageBar;
      
      private var _trainRewardVec:Vector.<TrainRewardInfo>;
      
      private var _trainCellVec:Vector.<TrainRewardCell>;
      
      private var _mainUI:MovieClip;
      
      public var _page:int;
      
      public function PetDictionaryTrainRewardPanel()
      {
         super();
         this.createChildren();
         this.createCells();
         this.onChangePage();
      }
      
      private function createChildren() : void
      {
         this._trainRewardVec = PetDictionaryConfig.trainRewardVec;
         this._mainUI = new PetsCollectionPanelUI();
         addChild(this._mainUI);
         var _loc1_:SimpleButton = this._mainUI["preBtn"];
         var _loc2_:SimpleButton = this._mainUI["nextBtn"];
         this._pageBar = new PageBar(_loc1_,_loc2_,Math.ceil(this._trainRewardVec.length / 8));
         this._pageBar.addEventListener("pageChange",this.onChangePage);
      }
      
      private function createCells() : void
      {
         var _loc1_:int = 0;
         var _loc2_:TrainRewardCell = null;
         this._trainCellVec = new Vector.<TrainRewardCell>();
         _loc1_ = 0;
         while(_loc1_ < 8)
         {
            _loc2_ = new TrainRewardCell();
            _loc2_.x = 57 + 208 * int(_loc1_ % 4);
            _loc2_.y = 77 + 208 * int(_loc1_ / 4);
            addChild(_loc2_);
            this._trainCellVec.push(_loc2_);
            _loc1_++;
         }
      }
      
      private function onChangePage(param1:Event = null) : void
      {
         this.setData();
         this._mainUI["preBtn"].visible = true;
         this._mainUI["nextBtn"].visible = true;
         if(this._pageBar.currentPage == 1)
         {
            this._mainUI["preBtn"].visible = false;
         }
         else if(this._pageBar.currentPage == 2)
         {
            this._mainUI["nextBtn"].visible = false;
         }
         dispatchEvent(new Event("TRAIN_PANEL_PAGE_CHANGE"));
      }
      
      private function setData() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = (this._pageBar.currentPage - 1) * 8;
         this._page = this._pageBar.currentPage;
         _loc1_ = 0;
         while(_loc1_ < this._trainCellVec.length)
         {
            if(_loc2_ + _loc1_ < this._trainRewardVec.length)
            {
               this._trainCellVec[_loc1_].visible = true;
               this._trainCellVec[_loc1_].setData(this._trainRewardVec[_loc2_ + _loc1_]);
               this._trainCellVec[_loc1_].updata();
            }
            else
            {
               this._trainCellVec[_loc1_].visible = false;
            }
            _loc1_++;
         }
      }
      
      public function update(param1:Boolean = false) : void
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         _loc2_ = 0;
         while(_loc2_ < this._trainCellVec.length)
         {
            this._trainCellVec[_loc2_].updata();
            _loc2_++;
         }
         if(param1)
         {
            _loc3_ = 0;
            while(_loc3_ < this._trainRewardVec.length)
            {
               if(this._trainRewardVec[_loc3_].flag != 1 && this._trainRewardVec[_loc3_].status == 1)
               {
                  dispatchEvent(new PetDictionaryEvent("trainPetShine"));
                  break;
               }
               _loc3_++;
            }
         }
      }
   }
}

