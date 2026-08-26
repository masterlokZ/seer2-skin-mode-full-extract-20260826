package com.taomee.seer2.module.app.newPetDictionary
{
   import com.taomee.seer2.app.popup.AlertManager;
   import com.taomee.seer2.module.app.moduleCommon.PageBar;
   import flash.display.SimpleButton;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.text.TextField;
   
   public class NewPetDicsPetListPanel extends Sprite
   {
      
      private var _listPanel:NewPetDicsListPanel;
      
      private var _changePageBtnMC:PetListChangePageUI;
      
      private var _pageBar:PageBar;
      
      private var _selectPetID:int;
      
      private const PAGE_SIZE:uint = 12;
      
      private var _data:Vector.<int>;
      
      private var _quickTurnTxt:TextField;
      
      private var _goBtn:SimpleButton;
      
      private var _totalPage:uint;
      
      public function NewPetDicsPetListPanel()
      {
         super();
         this.createChildren();
         this.initEventListener();
      }
      
      public function reset() : void
      {
      }
      
      public function setData(param1:Vector.<int>) : void
      {
         this._data = param1;
         this.initPageBar();
         this.changePage();
      }
      
      private function initPageBar() : void
      {
         var _loc1_:SimpleButton = this._changePageBtnMC["preBtn"];
         var _loc2_:SimpleButton = this._changePageBtnMC["nextBtn"];
         this._totalPage = uint(Math.ceil(this._data.length / 12) == 0 ? 1 : uint(Math.ceil((this._data.length - 1) / 12)));
         var _loc3_:TextField = this._changePageBtnMC["currentPageTxt"];
         var _loc4_:TextField = this._changePageBtnMC["totalPageTxt"];
         if(!this._pageBar)
         {
            this._pageBar = new PageBar(_loc1_,_loc2_,this._totalPage,_loc3_,_loc4_);
            this._pageBar.addEventListener("pageChange",this.onPageChange);
         }
      }
      
      private function initEventListener() : void
      {
         this._listPanel.addEventListener("showPetDetail",this.onShowPetDetail);
         this._goBtn.addEventListener("click",this.onQuickChange);
         this._quickTurnTxt.addEventListener("focusIn",function(param1:Event):void
         {
            _quickTurnTxt.text = "";
         });
         this._quickTurnTxt.addEventListener("focusOut",function(param1:Event):void
         {
            if(_quickTurnTxt.text == "")
            {
               _quickTurnTxt.text = "快捷跳转";
            }
         });
      }
      
      private function createChildren() : void
      {
         this._changePageBtnMC = new PetListChangePageUI();
         addChild(this._changePageBtnMC);
         this._changePageBtnMC.x = 140;
         this._changePageBtnMC.y = 330;
         this._listPanel = new NewPetDicsListPanel();
         this._listPanel.x = 62;
         this._listPanel.y = -11;
         addChild(this._listPanel);
         this._quickTurnTxt = this._changePageBtnMC["quickTurnTxt"];
         this._goBtn = this._changePageBtnMC["goBtn"];
      }
      
      private function onPageChange(param1:Event) : void
      {
         this.changePage();
      }
      
      private function onQuickChange(param1:Event) : void
      {
         var _loc2_:* = undefined;
         if(this._quickTurnTxt.text == "" || this._quickTurnTxt.text == "快捷跳转")
         {
            AlertManager.showAlert("请输入页数");
         }
         else if(int(this._quickTurnTxt.text) > this._totalPage || int(this._quickTurnTxt.text) < 1)
         {
            AlertManager.showAlert("页数超出范围");
         }
         else
         {
            _loc2_ = new Vector.<int>();
            _loc2_ = this.getPageData(int(this._quickTurnTxt.text));
            this._listPanel.setData(_loc2_);
            this._pageBar.currentPage = int(this._quickTurnTxt.text);
         }
      }
      
      private function changePage() : void
      {
         var _loc1_:Vector.<int> = new Vector.<int>();
         _loc1_ = this.getPageData(this._pageBar.currentPage);
         this._listPanel.setData(_loc1_);
      }
      
      private function onShowPetDetail(param1:NewPetDicsEvent) : void
      {
         this._selectPetID = param1.getPetResourceId();
         this.showPetDetail();
      }
      
      private function showPetDetail() : void
      {
         dispatchEvent(new NewPetDicsEvent("showPetDetail",this._selectPetID));
      }
      
      private function getPageData(param1:int) : Vector.<int>
      {
         var _loc2_:int = 0;
         var _loc3_:Vector.<int> = null;
         var _loc4_:* = 0;
         if(Boolean(this._data))
         {
            _loc2_ = (param1 - 1) * 12 + 1;
            _loc3_ = new Vector.<int>();
            _loc4_ = _loc2_;
            while(_loc4_ < _loc2_ + 12)
            {
               if(_loc4_ < this._data.length)
               {
                  _loc3_.push(this._data[_loc4_]);
               }
               else
               {
                  _loc3_.push(0);
               }
               _loc4_++;
            }
            return _loc3_;
         }
         return null;
      }
      
      public function dispose() : void
      {
         if(Boolean(this._pageBar))
         {
            this._pageBar.removeEventListener("pageChange",this.onPageChange);
            this._pageBar.dispose();
            this._pageBar = null;
         }
      }
   }
}

