package com.taomee.seer2.module.app.starMagic
{
   import com.taomee.seer2.app.starMagic.StarInfo;
   import com.taomee.seer2.app.starMagic.StarMagicConfig;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.text.TextField;
   
   public class StarMagicTip extends Sprite
   {
      
      private var _mc:MovieClip;
      
      private var starInfo:StarInfo;
      
      public function StarMagicTip()
      {
         super();
         this._mc = new StarTip();
         this.addChild(this._mc);
      }
      
      public function update(param1:StarInfo) : void
      {
         this.starInfo = param1;
         if(this.starInfo == null)
         {
            return;
         }
         var _loc2_:StarInfo = StarMagicConfig.getInfo(param1.buffId,param1.type);
         if(Boolean(_loc2_))
         {
            this._mc["nameT"].text = "" + _loc2_.nameT;
            if(param1.buffId > 2)
            {
               this._mc.gotoAndStop(1);
               this._mc["shuxing"].text = "" + _loc2_.effdesc;
               if(this.starInfo.level < _loc2_.maxLevel)
               {
                  this._mc["exp"].text = "" + param1.exp + "/" + _loc2_.nextExpArr[this.starInfo.level];
               }
               else
               {
                  this._mc["exp"].text = "满级";
               }
               if(_loc2_.buffSwf <= 4 || _loc2_.buffSwf == 8)
               {
                  this._mc["value"].text = "" + _loc2_.effvalue[0][this.starInfo.level];
                  this._mc["value"].x = (this._mc["shuxing"] as TextField).x + (this._mc["shuxing"] as TextField).textWidth + 10;
               }
               else
               {
                  this._mc["value"].text = "" + _loc2_.effvalue[0][this.starInfo.level] + "%";
                  this._mc["value"].x = (this._mc["shuxing"] as TextField).x + (this._mc["shuxing"] as TextField).textWidth + 10;
               }
               this._mc["sell"].text = "" + _loc2_.sell_exp;
               this._mc["level"].text = "LV." + this.starInfo.level;
            }
            else
            {
               this._mc.gotoAndStop(2);
            }
         }
      }
   }
}

