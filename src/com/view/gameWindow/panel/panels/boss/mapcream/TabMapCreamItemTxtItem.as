package com.view.gameWindow.panel.panels.boss.mapcream
{
	import com.model.consts.StringConst;
	import com.model.gameWindow.rsr.RsrLoader;
	import com.view.gameWindow.panel.panels.boss.MCMapCreamBossTxtItem;
	import com.view.gameWindow.panel.panels.onhook.AutoSystem;
	import com.view.gameWindow.scene.entity.constants.EntityTypes;
	import com.view.gameWindow.scene.entity.entityItem.autoJob.AutoJobManager;
	import com.view.gameWindow.tips.rollTip.RollTipMediator;
	import com.view.gameWindow.tips.rollTip.RollTipType;
	
	import flash.events.Event;
	import flash.events.MouseEvent;

	public class TabMapCreamItemTxtItem
	{
		internal var _skin:MCMapCreamBossTxtItem;
		private var _parent:TabMapCreamBoss
		
		private var _order:int;
		private var data:MapCreamItemNode;
		private var isClick:Boolean = false;
		private var _index:int;

		public function set index(value:int):void
		{
			_index = value;
			/*if(_index%2==0)
			{
				_skin.bg0.visible = true;
				_skin.bg1.visible = false;
			}
			else
			{
				_skin.bg0.visible = false;
				_skin.bg1.visible = true;
			}*/
		}

		public function get skin():MCMapCreamBossTxtItem
		{
			return _skin;
		}
		
		public function TabMapCreamItemTxtItem(parent:TabMapCreamBoss,skin:MCMapCreamBossTxtItem)
		{
			_parent = parent;
			//_skin = new MCMapCreamBossTxtItem();
			_skin = skin;
			_skin.mouseChildren =false;
			_skin.useHandCursor = true;
			_skin.doubleClickEnabled = true;
			_skin.addEventListener(MouseEvent.CLICK,onCLick);
			_skin.addEventListener(MouseEvent.DOUBLE_CLICK,ondbCLick);
			_skin.addEventListener(MouseEvent.ROLL_OVER,onOver);
			_skin.addEventListener(MouseEvent.ROLL_OUT,onOut);
			_skin.addEventListener(Event.ADDED_TO_STAGE,onAdd);
			_skin.addEventListener(Event.REMOVED_FROM_STAGE,onRemove);
			_skin.mcState.visible = false;
			_skin.index.mouseEnabled = false;
			_skin.nametxt.mouseEnabled = false;
			_skin.lvTxt.mouseEnabled = false;
			_skin.percent.mouseEnabled = false;
		}
		private function onAdd(e:Event):void
		{
			_skin.stage.addEventListener(MouseEvent.CLICK,onStageClick);
		}
		
		private function onRemove(e:Event):void
		{
			_skin.stage.removeEventListener(MouseEvent.CLICK,onStageClick);
			_skin.removeEventListener(Event.ADDED_TO_STAGE,onAdd);
			_skin.removeEventListener(Event.REMOVED_FROM_STAGE,onRemove);
		}
		private function onOver(e:MouseEvent):void
		{
			//_skin.filters = [grayFilters()];	
			_skin.mcState.visible = true;
		}
		
		private function onOut(e:MouseEvent):void
		{
			if(!isClick)
			{
				//_skin.filters = [];
				_skin.mcState.visible = false;
			}
			
		}
		
		private function onStageClick(e:MouseEvent):void
		{
			if((e.target is MCMapCreamBossTxtItem) && e.target!=_skin)
			{
				//_skin.filters = [];
				//data.startTimer(true);
				_skin.mcState.visible = false;
				isClick = false;
			}
			
		}
		
		/*public function  grayFilters():ColorMatrixFilter
		{
			var mat:Array =[0.3086,0.6094,0.082,0,0,0.3086,0.6094,0.082,0,0,0.3086,0.6094,0.082,0,0,0,0,0,1,0];
			var colorMat:ColorMatrixFilter = new ColorMatrixFilter(mat);
			return colorMat;
		}*/
		public function onCLick(e:MouseEvent = null):void
		{
			_parent.viewHandle.changeShow(data);
			//data.startTimer(false);
			_skin.mcState.visible = true;
			isClick = true;
		}
		private function ondbCLick(e:MouseEvent):void
		{
			_parent.viewHandle.changeShow(data);
			if(0 >= data.percent)
			{
				RollTipMediator.instance.showRollTip(RollTipType.ERROR,StringConst.BOSS_PANEL_0030);	
				return;
			}
				
			//data.startTimer(false);
			AutoSystem.instance.setTarget(data.monsterCfgData.group_id,EntityTypes.ET_MONSTER,data.map_monster_id);	
			//AutoJobManager.getInstance().setAutoTargetData(data.monsterCfgData.group_id,EntityTypes.ET_MONSTER);
			//_parent.viewHandle.gotoSceneBoss(data);
			
		}
		
		internal function refresh(_data:MapCreamItemNode):void
		{
			var color:uint
			data = _data;
			_skin.index.text =StringConst.BOSS_PANEL_0005+StringConst["NUM_000"+_data.index];
			_skin.nametxt.text = _data.name;
			_skin.lvTxt.text = String(_data.lv)+'级';
			//revive_time
			if(_data.percent>0)
			{
				color = _data.percent == 100 ? 0x53B436:0xff0000;
				_skin.percent.textColor = color;
				_skin.percent.text =StringConst.BOSS_PANEL_0006+_data.percent.toString()+"%";
			}
			else
			{
				color = 0x6a6a6a;
				_skin.percent.textColor = color;
				_skin.percent.text =StringConst.BOSS_PANEL_0007;
			}
			
			if(isClick)
			{
				_parent.viewHandle.changeShow(data);
			}
		}
		internal function destroy():void
		{
			_index = 0;
			data = null;
			isClick = false;
			_skin.removeEventListener(MouseEvent.CLICK,onCLick);
			_skin.removeEventListener(MouseEvent.DOUBLE_CLICK,ondbCLick);
			_skin.removeEventListener(MouseEvent.ROLL_OVER,onOver);
			_skin.removeEventListener(MouseEvent.ROLL_OUT,onOut);
			if(_skin.parent)
			{
				_skin.parent.removeChild(_skin);
				_skin.x = 0;
				_skin.y = 0;
			}
			_skin = null; 
				
			 
		}
		
	}
}