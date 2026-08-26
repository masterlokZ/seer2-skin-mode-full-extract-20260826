package com.taomee.seer2.app.processor.quest.handler.main.quest11
{
   import com.taomee.seer2.app.actor.Actor;
   import com.taomee.seer2.app.actor.ActorManager;
   import com.taomee.seer2.app.dialog.NpcDialog;
   import com.taomee.seer2.app.processor.quest.QuestProcessor;
   import com.taomee.seer2.app.processor.quest.handler.QuestMapHandler;
   import com.taomee.seer2.app.processor.quest.handler.main.quest11.interactive.BadPeople;
   import com.taomee.seer2.app.processor.quest.handler.main.quest11.interactive.BloodBar;
   import com.taomee.seer2.app.quest.QuestManager;
   import com.taomee.seer2.app.utils.MovieClipUtil;
   import com.taomee.seer2.core.utils.DisplayObjectUtil;
   import com.taomee.seer2.core.utils.URLUtil;
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.events.MouseEvent;
   
   public class QuestMapHandler_11_212 extends QuestMapHandler
   {
      
      private var _animation_1:MovieClip;
      
      private var _animation_2:MovieClip;
      
      private var _animation_3:MovieClip;
      
      private var _animation_4:MovieClip;
      
      private var _badPeople_1:BadPeople;
      
      private var _badPeople_2:BadPeople;
      
      private var _badPeople_3:BadPeople;
      
      private var _badPeople_4:BadPeople;
      
      private var _duoluoMC:MovieClip;
      
      private var _badiMC:MovieClip;
      
      private var _greenBloodBar:BloodBar;
      
      private var _npc_10_11:MovieClip;
      
      private var _breakNum:int;
      
      public function QuestMapHandler_11_212(param1:QuestProcessor)
      {
         super(param1);
      }
      
      override public function processMapComplete() : void
      {
         super.processMapComplete();
         if(QuestManager.isStepComplete(_quest.id,2) && !QuestManager.isStepComplete(_quest.id,5))
         {
            this.doQuest();
         }
      }
      
      private function doQuest() : void
      {
         if(!QuestManager.isStepComplete(_quest.id,3))
         {
            this._animation_1 = _processor.resLib.getMovieClip("animation_1");
            this._animation_1.x = 734;
            this._animation_1.y = 314;
            this._animation_1.gotoAndStop(1);
            _map.front.addChild(this._animation_1);
            this._animation_2 = _processor.resLib.getMovieClip("animation_2");
            this._animation_2.x = 220;
            this._animation_2.y = 180;
            _map.front.addChild(this._animation_2);
            MovieClipUtil.playMc(this._animation_2,1,this._animation_2.totalFrames,function():void
            {
               removeAnimation_2();
               _animation_1.gotoAndStop(2);
               _animation_1.buttonMode = true;
               _animation_1.addEventListener("click",onAnimationClick);
            },true);
         }
         else if(!QuestManager.isStepComplete(_quest.id,4))
         {
            this.breakOut();
         }
         else if(!QuestManager.isStepComplete(_quest.id,5))
         {
            this.speekStory();
         }
      }
      
      private function onAnimationClick(param1:MouseEvent) : void
      {
         var evt:MouseEvent = param1;
         this.removeAnimation_1();
         MovieClipUtil.playFullScreen(URLUtil.getQuestFullScreenAnimation("11_0"),function():void
         {
            NpcDialog.show(10,"巴蒂",[[3,"说什么呐！没打怎么就投降！"]],["糟糕！！！！"],[function():void
            {
               QuestManager.completeStep(_quest.id,3);
               breakOut();
            }]);
         });
      }
      
      private function breakOut() : void
      {
         this._animation_3 = _processor.resLib.getMovieClip("animation_3");
         this._animation_3.x = 221;
         this._animation_3.y = 313;
         _map.front.addChild(this._animation_3);
         this._breakNum = 0;
         MovieClipUtil.playMc(this._animation_3,1,this._animation_3.totalFrames,function():void
         {
            _npc_10_11 = _processor.resLib.getMovieClip("mc_1");
            _npc_10_11.gotoAndStop(4);
            _npc_10_11.addFrameScript(3,function():void
            {
               _npc_10_11.addFrameScript(3,null);
               _duoluoMC = _npc_10_11["duoluo"];
               _duoluoMC.gotoAndStop(1);
               _badiMC = _npc_10_11["badi"];
               _badiMC.gotoAndStop(1);
            });
            _map.front.addChild(_npc_10_11);
            NpcDialog.show(10,"巴蒂",[[4,"队长！快使用头部射击！（不同的颜色代表的属性也不同！记得属性相克！）"]],[" 准备反击！！！"],[function():void
            {
               var _loc1_:* = undefined;
               _greenBloodBar = new BloodBar(2,50,_processor.resLib);
               _badPeople_1 = new BadPeople(_animation_3["redBadPeople_1"],new BloodBar(1,10,_processor.resLib),191,400,1,_greenBloodBar,_processor.resLib);
               _badPeople_2 = new BadPeople(_animation_3["redBadPeople_2"],new BloodBar(1,10,_processor.resLib),523,390,1,_greenBloodBar,_processor.resLib);
               _badPeople_3 = new BadPeople(_animation_3["blueBadPeople_1"],new BloodBar(1,10,_processor.resLib),229,276,2,_greenBloodBar,_processor.resLib);
               _badPeople_4 = new BadPeople(_animation_3["blueBadPeople_2"],new BloodBar(1,10,_processor.resLib),327,268,2,_greenBloodBar,_processor.resLib);
               _badPeople_1.bloodBar.addEventListener("bloodOver",onBloodOver);
               _badPeople_2.bloodBar.addEventListener("bloodOver",onBloodOver);
               _badPeople_3.bloodBar.addEventListener("bloodOver",onBloodOver);
               _badPeople_4.bloodBar.addEventListener("bloodOver",onBloodOver);
               _greenBloodBar.addEventListener("bloodOver",onGreenBloodOver);
               _loc1_ = ActorManager.getActor();
               _greenBloodBar.x = -158;
               _greenBloodBar.y = -175;
               _loc1_.addChild(_greenBloodBar);
               _processor.showMouseHintAt(640,530);
            }]);
         });
      }
      
      private function onBloodOver(param1:Event) : void
      {
         var evt:Event = param1;
         ++this._breakNum;
         if(this._breakNum >= 4)
         {
            this.removeInteractive();
            _processor.hideMouseClickHint();
            MovieClipUtil.playMc(this._duoluoMC,1,this._duoluoMC.totalFrames,function():void
            {
               _duoluoMC.gotoAndStop(1);
               QuestManager.completeStep(_quest.id,4);
               speekStory();
            });
         }
      }
      
      private function onGreenBloodOver(param1:Event) : void
      {
         var cuteMc:MovieClip = null;
         var evt:Event = param1;
         cuteMc = _processor.resLib.getMovieClip("cureMC");
         var actor:Actor = ActorManager.getActor();
         actor.addChild(cuteMc);
         MovieClipUtil.playMc(cuteMc,1,cuteMc.totalFrames,function():void
         {
            DisplayObjectUtil.removeFromParent(cuteMc);
            if(_greenBloodBar)
            {
               _greenBloodBar.updataBlood(-50);
            }
            MovieClipUtil.playMc(_badiMC,1,_badiMC.totalFrames,function():void
            {
               _badiMC.gotoAndStop(1);
            });
         });
      }
      
      private function addAnimation_4() : void
      {
         this._animation_4 = _processor.resLib.getMovieClip("animation_4");
         this._animation_4.x = 700;
         this._animation_4.y = 325;
         _map.front.addChild(this._animation_4);
      }
      
      private function speekStory() : void
      {
         /*
          * Decompilation error
          * Timeout (1 minute) was reached
          * Instruction count: 20
          */
         throw new flash.errors.IllegalOperationError("Not decompiled due to timeout");
      }
      
      private function playMC(param1:Function) : void
      {
         var callBack:Function = param1;
         var mc:MovieClip = this._animation_4["mc"] as MovieClip;
         MovieClipUtil.playMc(mc,1,mc.totalFrames,function():void
         {
            callBack();
         },true);
      }
      
      override public function processMapDispose() : void
      {
         this.removeAnimation_1();
         this.removeAnimation_2();
         this.removeInteractive();
         this.removeAnimation_3();
         this.removeAnimation_4();
         if(this._npc_10_11)
         {
            DisplayObjectUtil.removeFromParent(this._npc_10_11);
            this._npc_10_11 = null;
         }
         super.processMapDispose();
      }
      
      private function removeAnimation_1() : void
      {
         if(this._animation_1)
         {
            DisplayObjectUtil.removeFromParent(this._animation_1);
            this._animation_1.removeEventListener("click",this.onAnimationClick);
            this._animation_1 = null;
         }
      }
      
      private function removeAnimation_2() : void
      {
         if(this._animation_2)
         {
            DisplayObjectUtil.removeFromParent(this._animation_2);
            this._animation_2 = null;
         }
      }
      
      private function removeAnimation_3() : void
      {
         if(this._animation_3)
         {
            DisplayObjectUtil.removeFromParent(this._animation_3);
            this._animation_3 = null;
         }
      }
      
      private function removeInteractive() : void
      {
         if(this._badPeople_1)
         {
            this._badPeople_1.bloodBar.removeEventListener("bloodOver",this.onBloodOver);
            this._badPeople_2.bloodBar.removeEventListener("bloodOver",this.onBloodOver);
            this._badPeople_3.bloodBar.removeEventListener("bloodOver",this.onBloodOver);
            this._badPeople_4.bloodBar.removeEventListener("bloodOver",this.onBloodOver);
            this._badPeople_1.dispose();
            this._badPeople_2.dispose();
            this._badPeople_3.dispose();
            this._badPeople_4.dispose();
            this._badPeople_1 = null;
            this._badPeople_2 = null;
            this._badPeople_3 = null;
            this._badPeople_4 = null;
         }
         if(this._greenBloodBar)
         {
            DisplayObjectUtil.removeFromParent(this._greenBloodBar);
            this._greenBloodBar.removeEventListener("bloodOver",this.onGreenBloodOver);
            this._greenBloodBar = null;
         }
      }
      
      private function removeAnimation_4() : void
      {
         if(this._animation_4)
         {
            DisplayObjectUtil.removeFromParent(this._animation_4);
            this._animation_4 = null;
         }
      }
   }
}

