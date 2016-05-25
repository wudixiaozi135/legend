package com.view.gameWindow.flyEffect.subs
{
    import com.model.consts.SlotType;
    import com.model.gameWindow.mem.MemEquipData;
    import com.model.gameWindow.mem.MemEquipDataManager;
    import com.view.gameWindow.flyEffect.FlyEffectBase;
    import com.view.gameWindow.mainUi.MainUiMediator;
    import com.view.gameWindow.mainUi.subclass.McMainUIBottom;
    import com.view.gameWindow.mainUi.subuis.bottombar.BottomBar;
    import com.view.gameWindow.mainUi.subuis.bottombar.actBar.ActionBarDataManager;
    import com.view.gameWindow.mainUi.subuis.herohead.HeroHead;
    import com.view.gameWindow.panel.PanelConst;
    import com.view.gameWindow.panel.PanelMediator;
    import com.view.gameWindow.panel.panelbase.IPanelBase;
    import com.view.gameWindow.panel.panels.bag.BagDataManager;
    import com.view.gameWindow.panel.panels.task.npctask.NpcTaskItemInfo;
    import com.view.gameWindow.panel.panels.task.npctask.NpcTaskPanel;
    import com.view.gameWindow.scene.entity.EntityLayerManager;
    import com.view.gameWindow.scene.entity.constants.EntityTypes;
    import com.view.gameWindow.scene.entity.entityItem.Entity;
    import com.view.gameWindow.scene.entity.entityItem.interf.IEntity;

    import flash.display.Bitmap;
    import flash.display.BitmapData;
    import flash.display.MovieClip;
    import flash.display.Sprite;
    import flash.geom.Point;

    public class FlyEffectReceiveThing extends FlyEffectBase
	{
		private var _args:Array;
		private var _entityId:int;
		private var _panelTyep:int;
		private var _barFlyKey:int = -1;
		private var _itemId:int;

		public function FlyEffectReceiveThing(layer:Sprite,args:Array)
		{
            super(layer);
			_args = args;
			initialize();
		}
		 
		private function initialize():void
		{
			if(!_args.length)
			{
				return;
			}
			if(_args[0] is int)
			{
				var entity:IEntity = EntityLayerManager.getInstance().getEntity(EntityTypes.ET_DROPITEM,_args[0]);
				if(!entity)
				{
					return;
				}
				getTargetByEntity(entity as Entity);
				getFromLctByEntity(entity as Entity);
				getToLct();
			}
			else if(_args[0] is String)
			{
				var panel:IPanelBase = PanelMediator.instance.openedPanel(_args[0],int(_args[1]));
				if(!panel)
					return;
				if(_args[0] == PanelConst.TYPE_TASK_ACCEPT_COMPLETE)
				{
					var index:int = _args[2];
					this.duration =  _args[3];
					getTargetByIndex(panel.skin['mcReward'+index]);
					getFromLctByIndex(panel.skin['mcReward'+index]);
					getToLct();
				} 
			}
			else if(_args[0] is Bitmap)
			{
				var bitmap:Bitmap = _args[0];
				this.duration =  _args[1];
				getTargetByBitmap(bitmap);
				getFromLctByBitmap(bitmap,_args.length >= 3 ? _args[2] : false);
				getToLct();
			}
			else if(_args[0] is Sprite)
			{
				var icon:Sprite = _args[0] as Sprite;
				if(icon)
				{
					this.duration =  _args[1];
					fromLct = icon.parent.localToGlobal(new Point(icon.x,icon.y));
					icon.parent.removeChild(icon);
					target = icon; 
					getToLct();
				}
			}
		}
		
		private function getTargetByBitmap(viewBitmap:Bitmap):void
		{
			if(3>=int(viewBitmap.name))//排除物品表id小于等于3的物品
				return;
			if(!viewBitmap.bitmapData)
			{
				return;
			}
			var clone:BitmapData = viewBitmap.bitmapData.clone();
			var bitmap:Bitmap = new Bitmap(clone);
			bitmap.width = viewBitmap.width;
			bitmap.height = viewBitmap.height;
			target = bitmap;
		}
		
		private function getFromLctByBitmap(bitmap:Bitmap,isNeedRemove:Boolean = false):void
		{
			if(!target || !bitmap.parent)
			{
				return;		
			}
			var point:Point = new Point(bitmap.x,bitmap.y);
			fromLct = bitmap.parent.localToGlobal(point);
			if(isNeedRemove)
			{
				bitmap.parent.removeChild(bitmap);
			}
		}
		
		private function getTargetByIndex(parent:MovieClip):void
		{
			var viewBitmap:Bitmap = Bitmap(parent.getChildAt(0));
			if(3>=int(viewBitmap.name))//排除物品表id小于等于3的物品
			{
				return;
			}
			var clone:BitmapData = viewBitmap.bitmapData.clone();
			var bitmap:Bitmap = new Bitmap(clone);
			bitmap.width = viewBitmap.width;
			bitmap.height = viewBitmap.height;
			target = bitmap;
		}
		
		private function getFromLctByIndex(parent:MovieClip):void
		{
			if(!target || !parent.parent)
			{
				return;
			}
			var viewBitmap:Bitmap = Bitmap(parent.getChildAt(0));
			var point:Point = new Point(viewBitmap.x,viewBitmap.y);
			fromLct = viewBitmap.parent.localToGlobal(point); 
		}
		
		private function getFromLctByEntity(entity:Entity):void
		{
			if(!target || !entity || !entity.parent)
				return;				
			var point:Point = new Point(entity.x-target.width*.5,entity.y-target.height*.5);
			fromLct = entity.parent.localToGlobal(point);
		}
		
		private function getTargetByEntity(entity:Entity):void
		{
			var viewBitmap:Bitmap = entity.viewBitmap;
			if(!viewBitmap || !viewBitmap.bitmapData)
			{
				return;
			}
			var clone:BitmapData = viewBitmap.bitmapData.clone();
			var bitmap:Bitmap = new Bitmap(clone);
			bitmap.width = viewBitmap.width;
			bitmap.height = viewBitmap.height;
			target = bitmap;
		}
		
		private function getToLct():void
		{
			if(_args.length>1)
			{
				var type:int= _args[1];
				if(type==SlotType.IT_EQUIP)
				{
					var memEquipData:MemEquipData = MemEquipDataManager.instance.memEquipData(_args[2],_args[3]);
					if(memEquipData!=null)
					{
						var checkEquipUseBourn:int = BagDataManager.instance.checkEquipUseBourn(memEquipData,memEquipData.equipCfgData);
						if(checkEquipUseBourn==BagDataManager.EQUIP_BAG_HERO||
							checkEquipUseBourn==BagDataManager.EQUIP_BAG_HERO_USE||
							checkEquipUseBourn==BagDataManager.EQUIP_USE_HERO)
						{
							var heroHead:HeroHead = MainUiMediator.getInstance().heroHead as HeroHead;
							if(heroHead==null)
							{

								return;
							}
							var herdPoint:Point = new Point(heroHead.x+45,heroHead.y+20);
							toLct = heroHead.parent.localToGlobal(herdPoint);
							return;
						}
					}
				}
			}
			
			var bottomBar:BottomBar = MainUiMediator.getInstance().bottomBar as BottomBar;
			if(!bottomBar)
			{
				return;
			}
			var skin:McMainUIBottom = bottomBar.skin as McMainUIBottom;
			if(!skin)
			{
				return;
			}
			var panel:NpcTaskPanel = PanelMediator.instance.openedPanel(_args[0],int(_args[1])) as NpcTaskPanel;
			if(panel)
			{
				var index:int = _args[2];
				var npcTaskItemInfo:NpcTaskItemInfo = panel.cellDataList[index];
				_barFlyKey = npcTaskItemInfo.barFlyKey;
				_itemId = npcTaskItemInfo.id;
			}
			var mc:MovieClip;
			if(_barFlyKey == -1)
			{
				mc = skin.btnBag;
			}
			else
			{
				mc = skin["btnKey"+_barFlyKey];
			}
			if(!mc || !target)
			{
				return;
			}
			var point:Point = new Point(mc.x+mc.width*.5-target.width*.5,mc.y+mc.height*.5-target.height*.5);
			toLct = mc.parent.localToGlobal(point);
		}
		
		override protected function onComplete():void
		{
			if(_args[0] is String)
			{
                if (_barFlyKey != -1)
				{
					ActionBarDataManager.instance.sendSetItemData(_barFlyKey,_itemId);
                }
			}
			if(_args.length>3)
			{
				super.onComplete();
				return;
			}
            if (_barFlyKey == -1)//背包
            {
//                GameDispatcher.dispatchEvent(GameEventConst.THING_INTO_BAG_EFFECT, {type: 2});//进背包不闪特效
            }
			super.onComplete();
		}
	}
}