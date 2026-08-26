package com.taomee.seer2.module.app.versionOnePetBagPanel
{
   import com.taomee.seer2.app.activeCount.ActiveCountManager;
   import com.taomee.seer2.app.arena.data.FightResultInfo;
   import com.taomee.seer2.app.arena.data.RevenueInfo;
   import com.taomee.seer2.app.config.EvolveConfig;
   import com.taomee.seer2.app.config.GadConfig;
   import com.taomee.seer2.app.config.PetRideShopConfig;
   import com.taomee.seer2.app.config.StoneConfig;
   import com.taomee.seer2.app.config.info.StoneInfo;
   import com.taomee.seer2.app.config.pet.PetDefinition;
   import com.taomee.seer2.app.event.LogicEvent;
   import com.taomee.seer2.app.guide.manager.GuideManager;
   import com.taomee.seer2.app.inventory.ItemManager;
   import com.taomee.seer2.app.inventory.events.ItemEvent;
   import com.taomee.seer2.app.inventory.item.PetItem;
   import com.taomee.seer2.app.manager.FightResultPanelWrapper;
   import com.taomee.seer2.app.net.CommandSet;
   import com.taomee.seer2.app.net.Connection;
   import com.taomee.seer2.app.net.parser.Parser_1142;
   import com.taomee.seer2.app.pet.data.PetInfo;
   import com.taomee.seer2.app.pet.data.PetInfoManager;
   import com.taomee.seer2.app.pet.events.PetInfoEvent;
   import com.taomee.seer2.app.popup.AlertManager;
   import com.taomee.seer2.app.popup.ServerMessager;
   import com.taomee.seer2.app.processor.quest.handler.main.quest99.QuestMapHandler_99_80491;
   import com.taomee.seer2.app.quest.QuestManager;
   import com.taomee.seer2.app.swap.SwapManager;
   import com.taomee.seer2.app.swap.info.SwapInfo;
   import com.taomee.seer2.app.swap.special.SpecialInfo;
   import com.taomee.seer2.core.inventory.Item;
   import com.taomee.seer2.core.module.ModuleEvent;
   import com.taomee.seer2.core.module.ModuleManager;
   import com.taomee.seer2.core.net.LittleEndianByteArray;
   import com.taomee.seer2.core.net.MessageEvent;
   import com.taomee.seer2.core.scene.events.ModelLocator;
   import com.taomee.seer2.core.utils.DisplayObjectUtil;
   import com.taomee.seer2.core.utils.URLUtil;
   import com.taomee.seer2.module.app.appraisal.AppraisalResultPanel;
   import com.taomee.seer2.module.app.petBag.helper.PetBagLearningPointHelper;
   import com.taomee.seer2.module.app.versionOnePetBagPanel.util.PetItemCell;
   import flash.display.MovieClip;
   import flash.display.SimpleButton;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.KeyboardEvent;
   import flash.events.MouseEvent;
   import flash.geom.Point;
   import flash.geom.Rectangle;
   import flash.text.TextField;
   import flash.utils.ByteArray;
   import flash.utils.IDataInput;
   import org.taomee.utils.Tick;
   
   public class PetItemBagPanel extends Sprite
   {
      
      private static const PAGE_SIZE:uint = 36;
      
      private static const PET_ITEM_TYPE_VECTOR:Vector.<int> = Vector.<int>([2,7,8,10,11,12,13,14,19,20,15,16,18,24]);
      
      private static const FOR_LIST:Array = [204644];
      
      private static const FILTER_TYPE:Array = [[0],[11,7,16],[8,12],[14,20,19],[2,17,18],[10],[-1]];
      
      private static const doubleExpList:Array = [200574,200575,200576,200577,200578,200579];
      
      private static const shopItemList:Array = [201010,201011,201012];
      
      private var _bagPanel:PetBagPanel;
      
      private var _petTabPanel:PetTabPanel;
      
      private var _container:MovieClip;
      
      private var _nextBtn:SimpleButton;
      
      private var _prevBtn:SimpleButton;
      
      private var _pageTxt:TextField;
      
      private var _recovery:SimpleButton;
      
      private var _itemContainer:Sprite;
      
      private var _petItemCellVec:Vector.<PetItemCell>;
      
      private var _petItemDataVec:Vector.<Item>;
      
      private var _qualityItemNum:TextField;
      
      private var _searchTxt:TextField;
      
      private var _searchBtn:SimpleButton;
      
      private var _tabList:Vector.<MovieClip>;
      
      private var _pageIndex:uint;
      
      private var _pageCount:uint;
      
      private var _petInfo:PetInfo;
      
      private var _appResultPanel:AppraisalResultPanel;
      
      private var _curSortIndex:int = 0;
      
      private var _curStyle:int;
      
      private var _keepPage:Boolean;
      
      private var _currentUseItemId:int;
      
      private var petItem:PetItem;
      
      private var useNum:int = 1;
      
      private var _oldPetInfo:PetInfo;
      
      private var _data:ByteArray;
      
      private var _isRecover:Boolean = false;
      
      public function PetItemBagPanel(param1:PetBagPanel, param2:PetTabPanel)
      {
         super();
         this._bagPanel = param1;
         this._petTabPanel = param2;
         this.createChildren();
         this.initEvent();
      }
      
      private function createChildren() : void
      {
         var _loc1_:int = 0;
         var _loc2_:PetItemCell = null;
         this._container = new PetItemBagUI();
         addChild(this._container);
         this._container.x = 856;
         this._container.y = 54;
         this._nextBtn = this._container["pageBar"]["nextBtn"];
         this._prevBtn = this._container["pageBar"]["prevBtn"];
         this._pageTxt = this._container["pageBar"]["pageTxt"];
         this._pageTxt.text = "";
         this._itemContainer = new Sprite();
         this._itemContainer.x = 622;
         this._itemContainer.y = 115;
         addChild(this._itemContainer);
         var _loc3_:int = 6;
         var _loc4_:int = 51;
         var _loc5_:int = 51;
         this._petItemCellVec = new Vector.<PetItemCell>();
         _loc1_ = 0;
         while(_loc1_ < 36)
         {
            _loc2_ = new PetItemCell();
            _loc2_.x = _loc4_ * (_loc1_ % _loc3_) - 8;
            _loc2_.y = _loc5_ * int(_loc1_ / _loc3_);
            this._itemContainer.addChild(_loc2_);
            _loc2_.addEventListener("itemUse",this.onPetItemUse);
            this._petItemCellVec.push(_loc2_);
            _loc1_++;
         }
         this._searchTxt = this._container["searchTxt"];
         this._searchTxt.text = "输入关键词";
         this._searchBtn = this._container["searchBtn"];
         this._tabList = new Vector.<MovieClip>();
         _loc1_ = 0;
         while(_loc1_ < 7)
         {
            this._tabList.push(this._container["tab" + _loc1_]);
            this._tabList[_loc1_].buttonMode = true;
            this._tabList[_loc1_].gotoAndStop(1);
            _loc1_++;
         }
      }
      
      private function initEvent() : void
      {
         var _loc1_:MovieClip = null;
         this._prevBtn.addEventListener("click",this.onPrevBtnClick);
         this._nextBtn.addEventListener("click",this.onNextBtnClick);
         this._searchTxt.addEventListener("keyDown",this.onKeyDown);
         this._searchTxt.addEventListener("mouseDown",this.onMouseDown);
         this._searchBtn.addEventListener("click",this.onSearchBtn);
         for each(_loc1_ in this._tabList)
         {
            _loc1_.addEventListener("click",this.onTabClick);
         }
      }
      
      private function onTabClick(param1:MouseEvent) : void
      {
         this._tabList[this._curSortIndex].gotoAndStop(1);
         if(Boolean(param1))
         {
            this._curSortIndex = this._tabList.indexOf(param1.currentTarget as MovieClip);
         }
         this._tabList[this._curSortIndex].gotoAndStop(2);
         if(param1 != null)
         {
            this._curStyle = 0;
         }
         this.updateItem();
      }
      
      private function onKeyDown(param1:KeyboardEvent) : void
      {
         var _loc2_:String = this._searchTxt.text;
         _loc2_ = _loc2_.replace("\n","");
         if(param1.keyCode == 13)
         {
            this._searchTxt.text = _loc2_;
            this.onSearchBtn(null);
         }
      }
      
      private function onMouseDown(param1:MouseEvent) : void
      {
         if(param1.currentTarget.text == "输入关键词")
         {
            param1.currentTarget.text = "";
         }
      }
      
      private function onSearchBtn(param1:MouseEvent) : void
      {
         var _loc2_:String = this._searchTxt.text;
         var _loc3_:Array = _loc2_.split(/[\s,\/!\\]+/);
         if(_loc3_.length == 0)
         {
            AlertManager.showAlert("请输入要搜索的关键字~");
            return;
         }
         this._curStyle = 1;
         this.updateItem();
      }
      
      private function onRecovery(param1:MouseEvent = null) : void
      {
         var evt:MouseEvent = param1;
         ModuleManager.addEventListener("QualityItemRecoveryPanel","hide",(function():*
         {
            var onRecoveryHide:* = undefined;
            return onRecoveryHide = function(param1:ModuleEvent):void
            {
               ModuleManager.removeEventListener("GoSchoolSignPanel","hide",onRecoveryHide);
            };
         })());
         ModuleManager.showAppModule("QualityItemRecoveryPanel");
      }
      
      private function onPetItemUse(param1:Event) : void
      {
         var item:Item = null;
         var evt:Event = param1;
         item = null;
         var cell:PetItemCell = null;
         var itemArr:Array = null;
         var indexArr:Array = null;
         var countArr:Array = null;
         var vipIndex:int = 0;
         var ob:Object = null;
         var itemIDs:Array = null;
         var counts:Array = null;
         var swapIDs:Array = null;
         var index:int = 0;
         var obj:Object = null;
         var specialItems:Array = null;
         var data:* = undefined;
         var currentCell:PetItemCell = evt.currentTarget as PetItemCell;
         item = currentCell.item;
         if(item.category == 2)
         {
            this.petItem = PetItem(item);
            if(this.petItem.type == 2)
            {
               if(this._petInfo.hp < this._petInfo.maxHp)
               {
                  this.usePetItem(this.petItem);
               }
               else
               {
                  AlertManager.showAlert("这只精灵不需要恢复体力");
               }
            }
            else if(this.petItem.type == 7 || this.petItem.type == 11)
            {
               if(this._petInfo.level < 100)
               {
                  if(this.petItem.experience == 0)
                  {
                     this.useNum = 1;
                     this.usePetItem(this.petItem);
                  }
                  else
                  {
                     this.showUseNumPane(currentCell);
                  }
               }
               else
               {
                  AlertManager.showAlert("你的精灵已经是最高等级");
               }
            }
            else if(this.petItem.type == 8)
            {
               itemArr = [200234,200235,200236,200637,201037,201038,200239,200240,200241];
               indexArr = [1440,1440,1440,1440,1440,1440,1440,1440,1440];
               countArr = [10,15,20,5,40,510,40,510,5];
               if(itemArr.indexOf(this.petItem.referenceId) != -1)
               {
                  vipIndex = itemArr.indexOf(this.petItem.referenceId);
                  ob = {};
                  ob.type = 5;
                  ob.index = indexArr[vipIndex];
                  ob.cost = 0;
                  ob.count = countArr[vipIndex];
                  ob.fun = null;
                  ModuleManager.toggleModule(URLUtil.getAppModule("VipPetBagPanel"),"正在打开vip精灵面板...",ob);
                  return;
               }
               if(PetBagLearningPointHelper.canChangeLearningPointByItem(this.petItem.referenceId))
               {
                  if(this._petInfo.learningInfo.pointAtk == 0 && this._petInfo.learningInfo.pointDefence == 0 && this._petInfo.learningInfo.pointSpecialAtk == 0 && this._petInfo.learningInfo.pointSpecialDefence == 0 && this._petInfo.learningInfo.pointHp == 0 && this._petInfo.learningInfo.pointSpeed == 0)
                  {
                     AlertManager.showAlert("这只精灵不需要重置学习力");
                  }
                  else
                  {
                     AlertManager.showConfirm("你确定要为这只精灵重置学习力吗？",function():void
                     {
                        _currentUseItemId = petItem.referenceId;
                        DisplayObjectUtil.disableSprite(this as Sprite);
                        PetInfoManager.addEventListener("petPropertiesChange",onPetPropertiesChange);
                        PetBagLearningPointHelper.changeLearningPointByItem(_petInfo.catchTime,_currentUseItemId);
                     });
                  }
               }
               else
               {
                  itemIDs = [200256];
                  counts = [720];
                  swapIDs = [4483];
                  index = itemIDs.indexOf(this.petItem.referenceId);
                  if(index != -1)
                  {
                     obj = {};
                     obj.type = 6;
                     obj.index = swapIDs[index];
                     obj.cost = 0;
                     obj.count = counts[index];
                     obj.fun = null;
                     ModuleManager.toggleModule(URLUtil.getAppModule("VipPetBagPanel"),"正在打开vip精灵面板...",obj);
                     return;
                  }
                  this.useAppraisalItem(this.petItem);
               }
            }
            else if(this.petItem.type == 10)
            {
               if(EvolveConfig.canEvolve(this._petInfo.resourceId,this._petInfo.level,item.referenceId))
               {
                  this.branchEvolute(this._petInfo.catchTime,item.referenceId);
               }
               else
               {
                  switch(int(EvolveConfig.getMonEvolveError(this._petInfo.resourceId,this._petInfo.level,item.referenceId)))
                  {
                     case 0:
                        AlertManager.showAlert("该精灵无法使用此芯片！");
                        break;
                     case 1:
                        AlertManager.showAlert("该精灵无法使用此芯片！");
                        break;
                     case 2:
                        AlertManager.showAlert("精灵等级达到<font color=\'#ff0000\'>" + EvolveConfig.getEvolveLevel(this._petInfo.resourceId) + "级</font>才可以使用进化芯片");
                        break;
                     default:
                        AlertManager.showAlert("该精灵无法使用此芯片！");
                  }
               }
            }
            else if(this.petItem.type == 12)
            {
               specialItems = [201119,208354];
               if(specialItems.indexOf(item.referenceId) != -1)
               {
                  data = {};
                  data.petInfo = this._petInfo;
                  data.callBack = function(param1:int):void
                  {
                     var index:int = param1;
                     SwapManager.swapItem(4558,1,function(param1:IDataInput):void
                     {
                        reducePetItem(item.referenceId);
                        _petInfo.character = index;
                        updatePetBag();
                     },null,new SpecialInfo(2,_petInfo.catchTime,index));
                  };
                  ModuleManager.showAppModule("CharaSelectPanel",data);
               }
               else
               {
                  this.changeCharecter(this._petInfo.catchTime,item.referenceId);
               }
            }
            else if(this.petItem.type == 18)
            {
               AlertManager.showConfirm("你确定要对这只精灵使用" + item.name + "吗？",function():void
               {
                  usePetItem(petItem);
               });
            }
            else if(this.petItem.type == 13)
            {
               this.showMedal(this.petItem.referenceId);
            }
            else if(this.petItem.type == 14)
            {
               this.showGad(this.petItem.referenceId);
            }
            else if(this.petItem.type == 24)
            {
               this.showPetRide(this.petItem.referenceId);
            }
            else if(this.petItem.type == 19)
            {
               this.showDecoration(this.petItem.referenceId);
            }
            else if(this.petItem.type == 20)
            {
               this.showStone(this.petItem.referenceId);
            }
            else if(this.petItem.type == 15)
            {
               this.exchangePetSoul(this.petItem);
            }
            else if(this.petItem.type == 16)
            {
               if(this.petItem.referenceId == 201012 && Object(this._petInfo.learningInfo).pointTotal() >= 510)
               {
                  AlertManager.showAlert("这只精灵的学习力已经满了");
                  return;
               }
               if(this.petItem.referenceId == 201010 || this.petItem.referenceId == 201011)
               {
                  if(this._petInfo.level >= 100)
                  {
                     AlertManager.showAlert("你的精灵已经是最高等级");
                     return;
                  }
               }
               AlertManager.showConfirm("你确定要对这只精灵使用" + item.name + "吗？",function():void
               {
                  usePetItem(petItem);
               });
            }
            else
            {
               this.usePetItem(this.petItem);
            }
         }
         for each(cell in this._petItemCellVec)
         {
            if(cell == currentCell)
            {
               cell.isSelected = true;
            }
            else
            {
               cell.isSelected = false;
            }
         }
      }
      
      private function exchangePetSoul(param1:PetItem) : void
      {
         var petItem:PetItem = param1;
         SwapManager.swapItem(petItem.swapId,1,function(param1:IDataInput):void
         {
            var _loc2_:SwapInfo = new SwapInfo(param1);
            reducePetItem(petItem.referenceId);
         });
      }
      
      private function showUseNumPane(param1:PetItemCell) : void
      {
         ItemManager.addEventListener1("batch_use",this.usePetProp);
         var _loc2_:Object = {};
         _loc2_.petinfo = this._petInfo;
         _loc2_.item = param1.item;
         ModuleManager.toggleModule(URLUtil.getAppModule("BatchPanel"),"正在打开使用道具界面",_loc2_);
      }
      
      private function usePetProp(param1:ItemEvent) : void
      {
         ItemManager.removeEventListener1("batch_use",this.usePetProp);
         this.useNum = param1.content;
         this.usePetItem(this.petItem);
      }
      
      private function showMedal(param1:uint) : void
      {
         var _loc2_:Object = {};
         _loc2_.fun = this.reducePetItem;
         _loc2_.itemId = param1;
         switch(int(param1) - 200536)
         {
            case 0:
               _loc2_.index = 1;
               ModuleManager.toggleModule(URLUtil.getAppModule("QuestSelectRewardPanel"),"正在打开主线任务奖励面板...",_loc2_);
               break;
            case 1:
               _loc2_.index = 2;
               ModuleManager.toggleModule(URLUtil.getAppModule("QuestSelectRewardPanel"),"正在打开主线任务奖励面板...",_loc2_);
               break;
            case 2:
               _loc2_.index = 3;
               ModuleManager.toggleModule(URLUtil.getAppModule("QuestSelectRewardPanel"),"正在打开主线任务奖励面板...",_loc2_);
         }
      }
      
      private function showGad(param1:uint) : void
      {
         var obj:Object = null;
         var id:uint = param1;
         obj = null;
         obj = {};
         obj.fun = this.updateItem;
         obj.is1079 = false;
         if(Boolean(id == 200664) && Boolean(PetInfoManager.getResPetInfo(820)) && PetInfoManager.getResPetInfo(387) == null)
         {
            SwapManager.swapItem(3473,1,function(param1:IDataInput):void
            {
               new SwapInfo(param1,false);
               entryGad(obj,208228);
            });
         }
         else
         {
            this.entryGad(obj,id);
         }
      }
      
      private function entryGad(param1:Object, param2:uint) : void
      {
         var _loc3_:PetDefinition = null;
         var _loc4_:PetInfo = null;
         var _loc5_:PetInfo = null;
         var _loc6_:Array = GadConfig.formIdGetGadInfo(param2);
         param1.petId = _loc6_[0];
         param1.swapId = _loc6_[1];
         param1.sId = 0;
         param1.id = param2;
         var _loc7_:Vector.<PetInfo> = Vector.<PetInfo>([]);
         for each(_loc5_ in PetInfoManager.getTotalBagPetInfo())
         {
            if(_loc5_.bunchId == param1.petId)
            {
               _loc7_.push(_loc5_);
            }
            else if(param1.petId == 147)
            {
               _loc7_.push(_loc5_);
            }
            else if(_loc5_.resourceId == 388 && (param2 == 203038 || param2 == 200659))
            {
               _loc7_.push(_loc5_);
            }
         }
         if(_loc7_.length <= 0)
         {
            AlertManager.showAlert("对不起，你的出战背包中没有该精灵");
            return;
         }
         _loc7_.length = 0;
         _loc7_ = null;
         if(param1.petId != undefined)
         {
            ModuleManager.addEventListener("GadSelectPetPanel","dispose",this.onGadDispose);
            ModuleManager.toggleModule(URLUtil.getAppModule("GadSelectPetPanel"),"正在打开纹章兑换面板...",param1);
         }
      }
      
      private function onGadDispose(param1:ModuleEvent) : void
      {
         if(param1.name == "GadSelectPetPanel")
         {
            ModuleManager.removeEventListener("GadSelectPetPanel","dispose",this.onGadDispose);
            this.updatePetBag();
         }
      }
      
      private function showPetRide(param1:uint) : void
      {
         var _loc2_:Object = null;
         var _loc3_:PetInfo = null;
         var _loc4_:Boolean = false;
         var _loc5_:int = 0;
         var _loc6_:int = 0;
         var _loc7_:Boolean = false;
         _loc2_ = {};
         _loc2_.callBack = this.updateItem;
         _loc2_.id = param1;
         _loc2_.swapId = PetRideShopConfig.getSwapIdByItemId(param1);
         var _loc8_:Vector.<PetInfo> = new Vector.<PetInfo>([]);
         for each(_loc3_ in PetInfoManager.getTotalBagPetInfo())
         {
            _loc4_ = Boolean(PetRideShopConfig.isCanRidePet(_loc3_.resourceId));
            _loc5_ = int(PetRideShopConfig.getFreeChipIdByPetId(_loc3_.resourceId));
            _loc6_ = int(PetRideShopConfig.getMiBiChipIdByPetId(_loc3_.resourceId));
            _loc7_ = _loc3_.petRideChipId == 0 ? true : false;
            if(_loc4_ == true && (_loc5_ > 0 || _loc6_ > 0) && _loc7_)
            {
               _loc8_.push(_loc3_);
            }
         }
         if(_loc8_.length <= 0)
         {
            AlertManager.showAlert("您的背包中没有该精灵或该精灵已经拥有骑乘晶片");
            return;
         }
         ModuleManager.addEventListener("PetRideSelectPetPanel","dispose",this.onPetRideDispose);
         ModuleManager.toggleModule(URLUtil.getAppModule("PetRideSelectPetPanel"),"正在打开面板...",_loc2_);
      }
      
      private function onPetRideDispose(param1:ModuleEvent) : void
      {
         if(param1.name == "PetRideSelectPetPanel")
         {
            ModuleManager.removeEventListener("PetRideSelectPetPanel","dispose",this.onPetRideDispose);
            this.updatePetBag();
         }
      }
      
      private function showDecoration(param1:uint) : void
      {
         var _loc2_:Object = null;
         var _loc3_:PetDefinition = null;
         var _loc4_:PetInfo = null;
         var _loc5_:PetInfo = null;
         _loc2_ = {};
         _loc2_.fun = this.updateItem;
         var _loc6_:Array = GadConfig.formIdGetGadInfo(param1);
         _loc2_.petId = _loc6_[0];
         _loc2_.swapId = _loc6_[1];
         _loc2_.sId = 0;
         var _loc7_:Vector.<PetInfo> = Vector.<PetInfo>([]);
         for each(_loc5_ in PetInfoManager.getAllBagPetInfo())
         {
            if(_loc5_.bunchId == _loc2_.petId)
            {
               _loc7_.push(_loc5_);
            }
         }
         if(_loc7_.length <= 0)
         {
            AlertManager.showAlert("对不起，你的出战背包中没有该精灵");
            return;
         }
         _loc7_.length = 0;
         _loc7_ = null;
         if(_loc2_.petId != undefined)
         {
            ModuleManager.addEventListener("DecorationsSelectPetPanel","AddDecorationStrongOk",this.onSucessDecorationsPanel);
            ModuleManager.toggleModule(URLUtil.getAppModule("DecorationsSelectPetPanel"),"正在打开饰品兑换面板...",_loc2_);
         }
      }
      
      private function showStone(param1:uint) : void
      {
         var _loc2_:PetDefinition = null;
         var _loc3_:PetInfo = null;
         var _loc4_:PetInfo = null;
         var _loc5_:StoneInfo = StoneConfig.getInfo(param1);
         var _loc6_:Vector.<PetInfo> = Vector.<PetInfo>([]);
         for each(_loc4_ in PetInfoManager.getAllBagPetInfo())
         {
            if(_loc4_.bunchId == _loc5_.petId)
            {
               _loc6_.push(_loc4_);
            }
         }
         if(_loc6_.length <= 0)
         {
            AlertManager.showAlert("对不起，你的出战背包中没有该精灵");
            return;
         }
         if(_loc5_ != null)
         {
            ModuleManager.addEventListener("StoneSelectPetPanel","StoneStrongOK",this.onSucessStonePanel);
            ModuleManager.toggleModule(URLUtil.getAppModule("StoneSelectPetPanel"),"正在打开强化石面板...",_loc5_);
         }
      }
      
      private function onSucessStonePanel(param1:ModuleEvent) : void
      {
         ModuleManager.removeEventListener("StoneSelectPetPanel","StoneStrongOK",this.onSucessStonePanel);
         this.updatePetBag();
      }
      
      private function onSucessDecorationsPanel(param1:ModuleEvent) : void
      {
         ModuleManager.removeEventListener("DecorationsSelectPetPanel","AddDecorationStrongOk",this.onSucessDecorationsPanel);
         this.updatePetBag();
      }
      
      private function onPetPropertiesChange(param1:PetInfoEvent) : void
      {
         if(param1.info.catchTime == this._petInfo.catchTime)
         {
            ServerMessager.addMessage(this._petInfo.name + "的学习力被重置了可以重新分配");
            DisplayObjectUtil.enableSprite(this);
            PetInfoManager.removeEventListener("petPropertiesChange",this.onPetPropertiesChange);
            this.reducePetItem(this._currentUseItemId);
            this.setData(this._petInfo);
         }
      }
      
      private function branchEvolute(param1:uint, param2:int) : void
      {
         this.reducePetItem(param2);
         this._isRecover = false;
         PetInfoManager.addEventListener("petExperenceChange",this.onBranchEvolution);
         Connection.addCommandListener(CommandSet.BRANCH_EVOLUTION_1117,this.onEvolution);
         Connection.send(CommandSet.BRANCH_EVOLUTION_1117,param1,param2);
      }
      
      private function onEvolution(param1:MessageEvent) : void
      {
         Connection.removeCommandListener(CommandSet.BRANCH_EVOLUTION_1117,this.onEvolution);
         this._data = param1.message.getRawData();
         var _loc2_:uint = this._data.readUnsignedInt();
         if(_loc2_ == 0)
         {
            this._data.readUnsignedInt();
            this._isRecover = true;
         }
      }
      
      private function changeCharecter(param1:uint, param2:int) : void
      {
         Connection.addCommandListener(CommandSet.CHANGE_CHARECTER_1169,this.onChangeCharecter);
         Connection.addErrorHandler(CommandSet.CHANGE_CHARECTER_1169,this.onError1169);
         Connection.send(CommandSet.CHANGE_CHARECTER_1169,param1,param2);
      }
      
      private function onError1169(param1:MessageEvent) : void
      {
         Connection.removeCommandListener(CommandSet.CHANGE_CHARECTER_1169,this.onChangeCharecter);
         Connection.removeErrorHandler(CommandSet.CHANGE_CHARECTER_1169,this.onError1169);
         if(param1.message.statusCode == 200020)
         {
            AlertManager.showAlert("此精灵不能使用这个物品!");
         }
      }
      
      private function onChangeCharecter(param1:MessageEvent) : void
      {
         var _loc2_:ByteArray = null;
         var _loc3_:* = 0;
         var _loc4_:* = null;
         Connection.removeErrorHandler(CommandSet.CHANGE_CHARECTER_1169,this.onError1169);
         Connection.removeCommandListener(CommandSet.CHANGE_CHARECTER_1169,this.onChangeCharecter);
         _loc2_ = param1.message.getRawDataCopy();
         PetInfo.readBaseInfo(this._petInfo,_loc2_);
         _loc3_ = _loc2_.readUnsignedInt();
         this.reducePetItem(_loc3_);
         this.updatePetBag();
         this._petTabPanel.changeTab(0);
      }
      
      private function onBranchEvolution(param1:PetInfoEvent) : void
      {
         var _loc2_:FightResultPanelWrapper = null;
         var _loc3_:FightResultInfo = param1.content.resultInfo;
         if(_loc3_.endReason == 106)
         {
            PetInfoManager.removeEventListener("petExperenceChange",this.onBranchEvolution);
            _loc2_ = new FightResultPanelWrapper();
            _loc2_.show(Vector.<PetInfo>([this._petInfo]),null,_loc3_);
            _loc2_.addEventListener("complete",this.updateEvolution);
         }
      }
      
      private function updateEvolution(param1:Event) : void
      {
         if(this._isRecover == true)
         {
            PetInfo.readPetInfo(this._petInfo,this._data);
         }
         this.updatePetBag();
      }
      
      private function updatePetBag(param1:Event = null) : void
      {
         if(Boolean(this._bagPanel))
         {
            this._bagPanel.updateSelectedPet();
         }
         if(Boolean(this._petTabPanel))
         {
            this._petTabPanel.updatePet();
         }
      }
      
      private function useAppraisalItem(param1:PetItem) : void
      {
         var petBagItemPanel:PetItemBagPanel = null;
         var confirmHandler:Function = null;
         var petItem:PetItem = param1;
         petBagItemPanel = null;
         confirmHandler = null;
         var gotoAppraisal:Function = function(param1:uint):void
         {
            if(param1 != 200230 && param1 != 201035)
            {
               AlertManager.showConfirm("确定重新随机精灵资质吗？有资质变差的风险哦！",confirmHandler);
            }
            else
            {
               AlertManager.showConfirm("稳定提高1点资质，珍惜使用哦！",confirmHandler);
            }
         };
         confirmHandler = function():void
         {
            DisplayObjectUtil.disableSprite(petBagItemPanel);
            reducePetItem(petItem.referenceId);
            _currentUseItemId = petItem.referenceId;
            _oldPetInfo = clone(_petInfo);
            Connection.addCommandListener(CommandSet.ITEM_APPRISAL_1116,onUsedApprisalPetItem);
            Connection.send(CommandSet.ITEM_APPRISAL_1116,petItem.referenceId,_petInfo.catchTime);
         };
         AlertManager.showAlert("老的资质物品已经不能使用了哦，兑换新物品吧！",function():void
         {
            onRecovery();
         });
      }
      
      public function clone(param1:PetInfo) : PetInfo
      {
         var _loc2_:PetInfo = new PetInfo();
         _loc2_.atk = param1.atk;
         _loc2_.potential = param1.potential;
         _loc2_.defence = param1.defence;
         _loc2_.specialAtk = param1.specialAtk;
         _loc2_.specialDefence = param1.specialDefence;
         _loc2_.speed = param1.speed;
         _loc2_.hp = param1.hp;
         return _loc2_;
      }
      
      private function checkMainPet(param1:PetInfo) : Boolean
      {
         var _loc2_:Array = [1,2,4,5,7,8];
         if(_loc2_.indexOf(param1.resourceId) != -1)
         {
            return true;
         }
         return false;
      }
      
      private function onUsedApprisalPetItem(param1:MessageEvent) : void
      {
         var data:IDataInput = null;
         var petInfo:PetInfo = null;
         var apprisalPetInfo:PetInfo = null;
         var anim:MovieClip = null;
         var event:MessageEvent = param1;
         petInfo = null;
         apprisalPetInfo = null;
         anim = null;
         var onAnimiEnd:Function = null;
         onAnimiEnd = function(param1:Event):void
         {
            var event:Event = param1;
            if(Boolean(_bagPanel))
            {
               _bagPanel.removeChild(anim);
            }
            if(_currentUseItemId == 200230)
            {
               AlertManager.showAlert("恭喜你！" + petInfo.name + "的资质+1！",function():void
               {
                  showResultPanel(apprisalPetInfo,petInfo);
               });
            }
            else
            {
               showResultPanel(apprisalPetInfo,petInfo);
            }
         };
         Connection.removeCommandListener(CommandSet.ITEM_APPRISAL_1116,this.onUsedApprisalPetItem);
         data = event.message.getRawData().clone();
         petInfo = PetInfo.readPetInfo_1116(new PetInfo(),data);
         DisplayObjectUtil.enableSprite(this);
         apprisalPetInfo = this._petInfo;
         anim = new ApprisalAni();
         anim.addEventListener("animiEnd",onAnimiEnd);
         if(Boolean(this._bagPanel))
         {
            anim.x = 325;
            this._bagPanel.addChild(anim);
         }
         anim.gotoAndPlay(2);
      }
      
      private function showResultPanel(param1:PetInfo, param2:PetInfo) : void
      {
         if(this._appResultPanel == null)
         {
            this._appResultPanel = new AppraisalResultPanel(this._petTabPanel);
            this._appResultPanel.x = 275;
            this._appResultPanel.y = 140;
         }
         PetInfo.updateBaseInfo(param1,param2);
         param1.potential = param2.potential;
         param1.flag = param2.flag;
         this.updatePetBag();
         this._appResultPanel.updatePet(param1,this._oldPetInfo);
         this._bagPanel.addChild(this._appResultPanel);
      }
      
      private function usePetItem(param1:PetItem) : void
      {
         DisplayObjectUtil.disableSprite(this);
         PetInfoManager.addEventListener("petExperenceChange",this.onPetExperenceChange);
         Connection.addCommandListener(CommandSet.FIGHT_USE_MEDICINE_1048,this.onUsedPetItem);
         Connection.addErrorHandler(CommandSet.FIGHT_USE_MEDICINE_1048,this.onUsedPetError);
         Connection.send(CommandSet.FIGHT_USE_MEDICINE_1048,this._petInfo.catchTime,param1.referenceId,this.useNum);
      }
      
      private function onUsedPetError(param1:MessageEvent) : void
      {
         DisplayObjectUtil.enableSprite(this);
         if(param1.message.statusCode == 205)
         {
            AlertManager.showAlert("精灵不喜欢吃这个");
         }
         if(param1.message.statusCode == 206)
         {
            AlertManager.showAlert("你已经使用过相同道具咯！");
         }
         if(param1.message.statusCode == 207)
         {
            AlertManager.showAlert("你已经使用过相同道具咯！");
         }
         if(param1.message.statusCode == 208)
         {
            AlertManager.showAlert("已经有两倍学习力");
         }
         if(param1.message.statusCode == 5010)
         {
            AlertManager.showAlert("这只精灵已经吃过同类型的药剂");
         }
         if(param1.message.statusCode == 200020)
         {
            AlertManager.showAlert("这只精灵不能使用此物品");
         }
         this.useNum = 1;
      }
      
      private function onPetExperenceChange(param1:PetInfoEvent) : void
      {
         var _loc2_:RevenueInfo = param1.content.revenueInfo;
         var _loc3_:FightResultInfo = param1.content.resultInfo;
         if(_loc3_.endReason == 102)
         {
            new FightResultPanelWrapper(this.updatePetBag).show(Vector.<PetInfo>([this._petInfo]),_loc2_,_loc3_);
         }
      }
      
      private function onUsedPetItem(param1:MessageEvent) : void
      {
         var _loc2_:LittleEndianByteArray = null;
         var _loc3_:PetInfo = null;
         _loc2_ = param1.message.getRawData().clone();
         var _loc4_:uint = uint(_loc2_.readUnsignedInt());
         this.reducePetItem(_loc4_);
         var _loc5_:uint = uint(_loc2_.readUnsignedInt());
         var _loc6_:uint = uint(_loc2_.readUnsignedInt());
         _loc3_ = PetInfoManager.getPetInfoFromBag(_loc5_);
         if(_loc3_ != null && _loc3_.hp != _loc6_)
         {
            _loc3_.hp = _loc6_;
            PetInfoManager.dispatchEvent("petCure",_loc3_);
         }
         Tick.instance.addTimeout(100,this.onDelayTimer);
         this.useNum = 1;
         if(doubleExpList.indexOf(_loc4_) > -1)
         {
            ServerMessager.addMessage("使用物品成功,获得所有精灵半小时双倍经验增益效果。");
         }
         if(shopItemList.indexOf(_loc4_) > -1)
         {
            ServerMessager.addMessage("使用道具成功");
         }
      }
      
      private function reducePetItem(param1:uint) : void
      {
         var _loc2_:PetItemCell = null;
         ItemManager.reduceItemQuantity(param1,this.useNum);
         var _loc3_:Item = ItemManager.getItemByReferenceId(param1);
         for each(_loc2_ in this._petItemCellVec)
         {
            _loc2_.isSelected = false;
            if(Boolean(_loc2_.item) && Boolean(_loc3_) && _loc2_.item.referenceId == param1)
            {
               _loc2_.setData(_loc3_);
            }
         }
         if(!_loc3_)
         {
            this.updateItem();
         }
      }
      
      private function onDelayTimer() : void
      {
         DisplayObjectUtil.enableSprite(this);
         this.clearItemCommandListener();
      }
      
      private function clearItemCommandListener() : void
      {
         PetInfoManager.removeEventListener("petExperenceChange",this.onPetExperenceChange);
         Connection.removeCommandListener(CommandSet.FIGHT_USE_MEDICINE_1048,this.onUsedPetItem);
         Connection.removeErrorHandler(CommandSet.FIGHT_USE_MEDICINE_1048,this.onUsedPetError);
      }
      
      private function onPrevBtnClick(param1:MouseEvent) : void
      {
         --this._pageIndex;
         this.updateDisplay();
      }
      
      private function onNextBtnClick(param1:MouseEvent) : void
      {
         ++this._pageIndex;
         this.updateDisplay();
      }
      
      public function setData(param1:PetInfo) : void
      {
         this._petInfo = param1;
         ModuleManager.removeEventListener("BuyPropPanel","dispose",this.onDispose);
         ModuleManager.addEventListener("BuyPropPanel","dispose",this.onDispose);
         ItemManager.requestItemList(this.onGetPetItemList);
      }
      
      public function dispose() : void
      {
         ModuleManager.removeEventListener("BuyPropPanel","dispose",this.onDispose);
      }
      
      private function onDispose(param1:ModuleEvent) : void
      {
         this.updateItem();
      }
      
      public function keepPage(param1:Boolean) : void
      {
         this._keepPage = param1;
      }
      
      private function onGetPetItemList() : void
      {
         this.onTabClick(null);
      }
      
      private function updateQualityVal() : void
      {
         ActiveCountManager.requestActiveCountList(FOR_LIST,function(param1:Parser_1142):void
         {
            _qualityItemNum.text = param1.infoVec[0].toString();
         });
      }
      
      private function updateItem() : void
      {
         if(this._curStyle == 0)
         {
            this._petItemDataVec = this.getCurPetRelateByType();
         }
         else
         {
            this._petItemDataVec = this.getCurPetRelateByName();
         }
         this._pageCount = Math.ceil(this._petItemDataVec.length / 36);
         if(this._pageCount == 0)
         {
            this._pageCount = 1;
         }
         if(!this._keepPage)
         {
            this._pageIndex = 0;
            this._keepPage = true;
         }
         if(this._pageIndex > this._pageCount - 1)
         {
            this._pageIndex = this._pageCount - 1;
         }
         this.updateDisplay();
      }
      
      private function getCurPetRelateByType() : Vector.<Item>
      {
         var _loc1_:Vector.<int> = null;
         var _loc2_:PetItem = null;
         var _loc3_:int = 0;
         var _loc4_:PetItem = null;
         var _loc5_:int = 0;
         var _loc6_:* = new Vector.<Item>();
         var _loc7_:Vector.<Item> = this.getAllRelateVec();
         if(this._curSortIndex == 0)
         {
            _loc6_ = _loc7_;
         }
         else if(this._curSortIndex == 6)
         {
            _loc1_ = Vector.<int>([11,7,16,8,12,14,20,19,2,17,18,10]);
            for each(_loc2_ in _loc7_)
            {
               _loc3_ = int(_loc2_.type);
               if(_loc1_.indexOf(_loc3_) == -1)
               {
                  _loc6_.push(_loc2_);
               }
            }
         }
         else
         {
            for each(_loc4_ in _loc7_)
            {
               _loc5_ = int(_loc4_.type);
               if(this.isHaveType(FILTER_TYPE[this._curSortIndex] as Array,_loc5_))
               {
                  _loc6_.push(_loc4_);
               }
            }
         }
         return _loc6_;
      }
      
      private function isHaveType(param1:Array, param2:int) : Boolean
      {
         var _loc3_:int = 0;
         var _loc4_:Boolean = false;
         for each(_loc3_ in param1)
         {
            if(_loc3_ == param2)
            {
               _loc4_ = true;
               break;
            }
         }
         return _loc4_;
      }
      
      private function getCurPetRelateByName() : Vector.<Item>
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         var _loc3_:Vector.<Item> = new Vector.<Item>();
         var _loc4_:Vector.<Item> = this.getAllRelateVec();
         var _loc5_:String = this._searchTxt.text;
         var _loc6_:Array = _loc5_.split(/[\s,\/!\\]+/);
         _loc1_ = 0;
         while(_loc1_ < _loc4_.length)
         {
            _loc2_ = 0;
            while(true)
            {
               if(_loc2_ >= _loc6_.length)
               {
                  break;
               }
               if(_loc6_[_loc2_] != "")
               {
                  if(_loc4_[_loc1_].name.search(_loc6_[_loc2_]) != -1 || _loc4_[_loc1_].tip.search(_loc6_[_loc2_]) != -1)
                  {
                     _loc3_.push(_loc4_[_loc1_]);
                     break;
                  }
               }
               _loc2_++;
            }
            _loc1_++;
         }
         if(_loc3_.length <= 0)
         {
            AlertManager.showAlert("没有你要搜索的物品");
            this._curStyle = 0;
         }
         return _loc3_;
      }
      
      private function getAllRelateVec() : Vector.<Item>
      {
         var petItem:PetItem = null;
         var type:int = 0;
         var itemVec:Vector.<Item> = new Vector.<Item>();
         var petRelateVec:Vector.<PetItem> = ItemManager.getPetRelateVec();
         var clearItemArr:Array = [200231,201026,201033,201037,201029];
         for each(petItem in petRelateVec)
         {
            type = int(petItem.type);
            if(PET_ITEM_TYPE_VECTOR.indexOf(type) != -1 && clearItemArr.indexOf(petItem.referenceId) == -1)
            {
               itemVec.push(petItem);
            }
         }
         itemVec.sort(function(param1:Item, param2:Item):int
         {
            if(param1.referenceId == 200254)
            {
               return -1;
            }
            if(param2.referenceId == 200254)
            {
               return -1;
            }
            if(param1.getTime > param2.getTime)
            {
               return -1;
            }
            if(param1.getTime < param2.getTime)
            {
               return 1;
            }
            return 0;
         });
         return itemVec;
      }
      
      private function updateDisplay() : void
      {
         this.updateItemVec();
         this.updateButtonStatus();
         this._pageTxt.text = this._pageIndex + 1 + "/" + this._pageCount;
         this.newGuideShow();
      }
      
      private function newGuideShow() : void
      {
         var _loc1_:Rectangle = null;
         if(Boolean(QuestManager.isAccepted(99)) && !QuestManager.isStepComplete(99,3) && Boolean(QuestMapHandler_99_80491.isClickQuest99_3))
         {
            _loc1_ = new Rectangle(0,0,49,49);
            GuideManager.instance.addTarget(_loc1_,0);
            GuideManager.instance.addGuide2Target(_loc1_,0,20,new Point(723,217),false,false,9,false,true,false,990,560);
            GuideManager.instance.startGuide(20);
            ModuleManager.addEventListener("BatchPanel","setup",this.onBatchSetup);
            ModuleManager.addEventListener("BatchPanel","dispose",this.onBatchDispose);
         }
      }
      
      private function onBatchSetup(param1:ModuleEvent) : void
      {
         ModuleManager.removeEventListener("BatchPanel","setup",this.onBatchSetup);
         GuideManager.instance.pause();
         var _loc2_:Rectangle = new Rectangle(0,0,84,36);
         GuideManager.instance.addTarget(_loc2_,0);
         GuideManager.instance.addGuide2Target(_loc2_,0,21,new Point(555,427),false,false,9,false,true,false,422,290);
         GuideManager.instance.startGuide(21);
      }
      
      private function onBatchDispose(param1:ModuleEvent) : void
      {
         ModuleManager.removeEventListener("BatchPanel","dispose",this.onBatchDispose);
         GuideManager.instance.close();
         ModuleManager.closeForName("PetBagPanel");
         ModelLocator.getInstance().dispatchEvent(new LogicEvent("newGuideBroad3"));
      }
      
      private function updateItemVec() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         var _loc3_:int = this._pageIndex * 36;
         _loc1_ = 0;
         while(_loc1_ < 36)
         {
            _loc2_ = _loc3_ + _loc1_;
            if(_loc2_ < this._petItemDataVec.length)
            {
               this._petItemCellVec[_loc1_].setData(this._petItemDataVec[_loc2_]);
            }
            else
            {
               this._petItemCellVec[_loc1_].setData(null);
            }
            _loc1_++;
         }
      }
      
      private function updateButtonStatus() : void
      {
         DisplayObjectUtil.enableButton(this._prevBtn);
         DisplayObjectUtil.enableButton(this._nextBtn);
         if(this._pageIndex == 0)
         {
            DisplayObjectUtil.disableButton(this._prevBtn);
         }
         if(this._pageIndex == this._pageCount - 1)
         {
            DisplayObjectUtil.disableButton(this._nextBtn);
         }
      }
      
      private function gerParser() : int
      {
         if(this._petInfo.resourceId == 3)
         {
            return 3;
         }
         if(this._petInfo.resourceId == 6)
         {
            return 4;
         }
         if(this._petInfo.resourceId == 9)
         {
            return 3;
         }
         return 0;
      }
      
      private function getPosition() : int
      {
         if(this._petInfo.resourceId == 3)
         {
            return 4;
         }
         if(this._petInfo.resourceId == 6)
         {
            return 5;
         }
         if(this._petInfo.resourceId == 9)
         {
            return 3;
         }
         return 0;
      }
   }
}

