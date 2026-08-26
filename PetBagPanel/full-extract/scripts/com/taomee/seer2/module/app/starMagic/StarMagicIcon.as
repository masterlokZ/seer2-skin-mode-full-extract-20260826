package com.taomee.seer2.module.app.starMagic
{
   import com.taomee.seer2.app.starMagic.StarInfo;
   import com.taomee.seer2.app.starMagic.StarMagicConfig;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import flash.filters.GlowFilter;
   import flash.geom.Point;
   import flash.text.TextField;
   
   public class StarMagicIcon extends Sprite
   {
      
      public static var m_fliters:GlowFilter = new GlowFilter(0,1,4,4);
      
      public var index:int;
      
      private var _mc:MovieClip;
      
      public var _mc2:MovieClip;
      
      private var _id:int;
      
      private var _type:int;
      
      private var _power:int;
      
      private var _moveState:int = 0;
      
      private var _tx:int;
      
      private var _ty:int;
      
      private var _info:StarInfo;
      
      private var _tip:MovieClip;
      
      private var _textField:TextField;
      
      private var _levelField:TextField;
      
      public function StarMagicIcon(param1:int, param2:int)
      {
         super();
         this.buttonMode = true;
         this._id = param1;
         this._type = param2;
         this._info = new StarInfo();
         this._textField = new TextField();
         this._textField.x = 3;
         this._textField.y = 0;
         this._textField.height = 18;
         this._textField.filters = [m_fliters];
         this.addChild(this._textField);
         this._levelField = new TextField();
         this._levelField.x = 3;
         this._levelField.y = 30;
         this._levelField.height = 18;
         this._levelField.filters = [m_fliters];
         this.addChild(this._levelField);
         this.showIcon();
         this.mouseChildren = false;
      }
      
      public function updateDateInfo(param1:StarInfo) : void
      {
         if(Boolean(param1))
         {
            this._id = param1.buffId;
            this._type = param1.type;
            StarInfo.updateStarInfo(param1,this._info);
         }
         else
         {
            this._id = 0;
         }
         this.showIcon();
      }
      
      private function onMouseDown(param1:MouseEvent) : void
      {
         this.startDrag();
         this._moveState = 1;
      }
      
      private function onMouseUp(param1:MouseEvent) : void
      {
         this.stopDrag();
         this._moveState = 2;
      }
      
      private function setTextColor() : void
      {
         if(this._id == 1)
         {
            this._textField.textColor = 16777215;
            this._levelField.textColor = 16777215;
         }
         else if(this._id == 2)
         {
            this._textField.textColor = 16777215;
            this._levelField.textColor = 16777215;
         }
         else if(this._type == 0)
         {
            this._textField.textColor = 16777215;
            this._levelField.textColor = 16777215;
         }
         else if(this._type == 1)
         {
            this._textField.textColor = 65433;
            this._levelField.textColor = 16777215;
         }
         else if(this._type == 2)
         {
            this._textField.textColor = 776186;
            this._levelField.textColor = 16777215;
         }
         else if(this._type == 3)
         {
            this._textField.textColor = 14105826;
            this._levelField.textColor = 16777215;
         }
         else if(this._type == 4)
         {
            this._textField.textColor = 14153011;
            this._levelField.textColor = 16777215;
         }
      }
      
      private function showIcon() : void
      {
         if(Boolean(this._mc) && this.contains(this._mc))
         {
            this._mc.gotoAndStop(1);
            this.removeChild(this._mc);
            this._mc = null;
         }
         if(this._id == 0)
         {
            this._mc = new staricon0();
            this._mc.alpha = 0;
         }
         else
         {
            this._mc = this.getMovieClip();
            this._mc.alpha = 1;
         }
         if(!this._mc2)
         {
            this._mc2 = new staricon0();
            this._mc2.x = 15;
            this._mc2.y = 18;
            this._mc2.alpha = 0;
            this.addChild(this._mc2);
         }
         if(this._id >= 3)
         {
            this._mc.x = 19;
            this._mc.y = 24;
         }
         this.addChild(this._mc);
         this.setTextColor();
         if(this._id != 0)
         {
            this._textField.text = "" + StarMagicConfig.getInfoById(this._id).nameT;
            this._levelField.text = "LV." + this._info.level;
            if(this._info.level == 0)
            {
               this._levelField.text = "LV." + this._info.maxLevel;
            }
            this.setChildIndex(this._levelField,this.numChildren - 1);
            this.setChildIndex(this._textField,this.numChildren - 1);
         }
         else
         {
            this._textField.text = "";
            this._levelField.text = "";
         }
      }
      
      private function getMoveState() : int
      {
         return this._moveState;
      }
      
      public function moveState() : int
      {
         return this._moveState;
      }
      
      public function setmoveState(param1:int) : void
      {
         this._moveState = param1;
         if(!this._mc)
         {
            return;
         }
         if(this._moveState == 0)
         {
            this._mc.gotoAndStop(1);
         }
         else
         {
            this._mc.gotoAndStop(1);
         }
      }
      
      public function getInfo() : StarInfo
      {
         return this._info;
      }
      
      public function toPath(param1:int, param2:int) : void
      {
         this.setmoveState(3);
         this._tx = param1;
         this._ty = param2;
      }
      
      public function move() : void
      {
         var _loc1_:Point = null;
         if(this._moveState == 3)
         {
            _loc1_ = this.toPosition(this.x,this.y,this._tx,this._ty,25);
            this.x = _loc1_.x;
            this.y = _loc1_.y;
            if(Math.abs(this.x - this._tx) < 20 && Math.abs(this.y - this._ty) < 20)
            {
               this.alpha = 0;
               this._moveState = -1;
            }
         }
      }
      
      private function initTip() : void
      {
      }
      
      private function toPosition(param1:Number, param2:Number, param3:Number, param4:Number, param5:uint) : Point
      {
         var _loc6_:Number = NaN;
         var _loc7_:Point = new Point(param1,param2);
         var _loc8_:Point = new Point(param3,param4);
         var _loc9_:Point = new Point();
         _loc6_ = Math.atan2(_loc8_.y - _loc7_.y,_loc8_.x - _loc7_.x);
         var _loc10_:Number = _loc6_ * 180 / 3.141592653589793;
         var _loc11_:int = int(param5);
         var _loc12_:int = int(param5);
         if(Math.abs(param1 - _loc8_.x) <= param5)
         {
            _loc11_ = Math.abs(param1 - _loc8_.x);
         }
         if(Math.abs(param2 - _loc8_.y) <= param5)
         {
            _loc12_ = Math.abs(param2 - _loc8_.y);
         }
         _loc9_.x = param1 + _loc11_ * Math.cos(_loc6_);
         _loc9_.y = param2 + _loc12_ * Math.sin(_loc6_);
         return _loc9_;
      }
      
      public function get type() : int
      {
         return this._type;
      }
      
      public function get indexId() : int
      {
         return this._id;
      }
      
      public function getMovieClip() : MovieClip
      {
         var _loc1_:MovieClip = null;
         var _loc2_:StarInfo = StarMagicConfig.getInfoById(this._id);
         if(!_loc2_)
         {
            return new dsp();
         }
         if(this._id == 0)
         {
            _loc1_ = new staricon0();
            _loc1_.alpha = 0;
         }
         else if(this._id == 1)
         {
            _loc1_ = new ssp();
         }
         else if(this._id == 2)
         {
            _loc1_ = new dsp();
         }
         else if(this._type == 1)
         {
            if(_loc2_.buffSwf == 1)
            {
               _loc1_ = new wg_1();
            }
            else if(_loc2_.buffSwf == 2)
            {
               _loc1_ = new tg_1();
            }
            else if(_loc2_.buffSwf == 3)
            {
               _loc1_ = new wf_1();
            }
            else if(_loc2_.buffSwf == 4)
            {
               _loc1_ = new tf_1();
            }
            else if(_loc2_.buffSwf == 5)
            {
               _loc1_ = new bj_1();
            }
            else if(_loc2_.buffSwf == 6)
            {
               _loc1_ = new mz_1();
            }
            else if(_loc2_.buffSwf == 7)
            {
               _loc1_ = new sb_1();
            }
            else if(_loc2_.buffSwf == 8)
            {
               _loc1_ = new sm_1();
            }
            else if(_loc2_.buffSwf == 9)
            {
               _loc1_ = new pf_1();
            }
         }
         else if(this._type == 2)
         {
            if(_loc2_.buffSwf == 1)
            {
               _loc1_ = new wg_2();
            }
            else if(_loc2_.buffSwf == 2)
            {
               _loc1_ = new tg_2();
            }
            else if(_loc2_.buffSwf == 3)
            {
               _loc1_ = new wf_2();
            }
            else if(_loc2_.buffSwf == 4)
            {
               _loc1_ = new tf_2();
            }
            else if(_loc2_.buffSwf == 5)
            {
               _loc1_ = new bj_2();
            }
            else if(_loc2_.buffSwf == 6)
            {
               _loc1_ = new mz_2();
            }
            else if(_loc2_.buffSwf == 7)
            {
               _loc1_ = new sb_2();
            }
            else if(_loc2_.buffSwf == 8)
            {
               _loc1_ = new sm_2();
            }
            else if(_loc2_.buffSwf == 9)
            {
               _loc1_ = new kb_9();
            }
         }
         else if(this._type == 3)
         {
            if(_loc2_.buffSwf == 1)
            {
               _loc1_ = new wg_3();
            }
            else if(_loc2_.buffSwf == 2)
            {
               _loc1_ = new tg_3();
            }
            else if(_loc2_.buffSwf == 3)
            {
               _loc1_ = new wf_3();
            }
            else if(_loc2_.buffSwf == 4)
            {
               _loc1_ = new tf_3();
            }
            else if(_loc2_.buffSwf == 5)
            {
               _loc1_ = new bj_3();
            }
            else if(_loc2_.buffSwf == 6)
            {
               _loc1_ = new mz_3();
            }
            else if(_loc2_.buffSwf == 7)
            {
               _loc1_ = new sb_3();
            }
            else if(_loc2_.buffSwf == 8)
            {
               _loc1_ = new sm_3();
            }
            else if(_loc2_.buffSwf == 9)
            {
               _loc1_ = new sm_5();
            }
            else if(_loc2_.buffSwf == 10)
            {
               _loc1_ = new sm_6();
            }
         }
         else if(this._type == 4)
         {
            if(_loc2_.buffSwf == 1)
            {
               _loc1_ = new wg_4();
            }
            else if(_loc2_.buffSwf == 2)
            {
               _loc1_ = new tg_4();
            }
            else if(_loc2_.buffSwf == 3)
            {
               _loc1_ = new wf_4();
            }
            else if(_loc2_.buffSwf == 4)
            {
               _loc1_ = new tf_4();
            }
            else if(_loc2_.buffSwf == 5)
            {
               _loc1_ = new bj_4();
            }
            else if(_loc2_.buffSwf == 6)
            {
               _loc1_ = new mz_4();
            }
            else if(_loc2_.buffSwf == 7)
            {
               _loc1_ = new sb_4();
            }
            else if(_loc2_.buffSwf == 8)
            {
               _loc1_ = new sm_4();
            }
            else if(_loc2_.buffSwf == 9)
            {
               _loc1_ = new pf_4();
            }
            else if(_loc2_.buffSwf == 100)
            {
               _loc1_ = new qdzy_4();
            }
            else if(_loc2_.buffSwf == 101)
            {
               _loc1_ = new js_4();
            }
            else if(_loc2_.buffSwf == 102)
            {
               _loc1_ = new qdzy_102();
            }
            else if(_loc2_.buffSwf == 103)
            {
               _loc1_ = new jg_103();
            }
         }
         return _loc1_;
      }
   }
}

