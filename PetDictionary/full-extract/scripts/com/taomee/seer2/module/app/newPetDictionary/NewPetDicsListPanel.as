package com.taomee.seer2.module.app.newPetDictionary
{
   import com.taomee.seer2.app.config.PetConfig;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   
   public class NewPetDicsListPanel extends Sprite
   {
      
      private const Row_Column:uint = 3;
      
      private const Cell_Width_Height:int = 92;
      
      private const HDistance:int = 20;
      
      private const VDistance:int = 30;
      
      private var _cellVec:Vector.<NewPetDicsListCell>;
      
      private var _petResouceVec:Vector.<int>;
      
      private var _isSpeak:Boolean;
      
      public function NewPetDicsListPanel()
      {
         super();
         this.initCellVec();
      }
      
      private function initCellVec() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         var _loc3_:NewPetDicsListCell = null;
         this._cellVec = new Vector.<NewPetDicsListCell>();
         _loc1_ = 0;
         while(_loc1_ < 3)
         {
            _loc2_ = 0;
            while(_loc2_ < 4)
            {
               _loc3_ = new NewPetDicsListCell();
               _loc3_.addEventListener("click",this.onCellClick);
               _loc3_.x = 112 * _loc2_ - 35;
               _loc3_.y = 122 * _loc1_ + 15;
               addChild(_loc3_);
               this._cellVec.push(_loc3_);
               _loc2_++;
            }
            _loc1_++;
         }
      }
      
      public function setData(param1:Vector.<int>, param2:Boolean = false) : void
      {
         this._isSpeak = param2;
         this._petResouceVec = param1;
         this.refresh();
      }
      
      private function refresh() : void
      {
         this.clearCells();
         this.setCellData();
      }
      
      private function clearCells() : void
      {
         var _loc1_:int = 0;
         var _loc2_:NewPetDicsListCell = null;
         _loc1_ = 0;
         while(_loc1_ < this._cellVec.length)
         {
            _loc2_ = this._cellVec[_loc1_];
            _loc2_.clear();
            _loc1_++;
         }
      }
      
      private function setCellData() : void
      {
         var _loc1_:int = 0;
         var _loc2_:NewPetDicsListCell = null;
         var _loc3_:uint = 12;
         _loc1_ = 0;
         while(_loc1_ < _loc3_)
         {
            _loc2_ = this._cellVec[_loc1_];
            if(_loc1_ < this._petResouceVec.length)
            {
               _loc2_.setData(this._petResouceVec[_loc1_],this._isSpeak);
            }
            else
            {
               _loc2_.setData(0,this._isSpeak);
            }
            _loc1_++;
         }
      }
      
      private function onCellClick(param1:MouseEvent) : void
      {
         var _loc2_:NewPetDicsListCell = param1.currentTarget as NewPetDicsListCell;
         if(PetConfig.getPetDefinition(_loc2_.resourceID) != null)
         {
            dispatchEvent(new NewPetDicsEvent("showPetDetail",_loc2_.resourceID));
         }
      }
   }
}

