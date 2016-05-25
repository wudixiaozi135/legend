package com.view.gameWindow.panel.panels.boss.world
{
	import com.model.business.fileService.constants.ResourcePathConstants;
	import com.model.consts.StringConst;
	import com.view.gameWindow.panel.panels.boss.BossDataManager;
	import com.view.gameWindow.panel.panels.boss.BossModelHandle;
	import com.view.gameWindow.panel.panels.boss.MCWorldBoss;
	import com.view.gameWindow.panel.panels.boss.McWorldBossItem;
	import com.view.gameWindow.panel.panels.onhook.AutoSystem;
	import com.view.gameWindow.scene.entity.constants.EntityTypes;
	import com.view.gameWindow.scene.entity.entityItem.autoJob.AutoJobManager;
	import com.view.gameWindow.scene.map.SceneMapManager;
	import com.view.gameWindow.tips.toolTip.ToolTipManager;
	import com.view.gameWindow.util.UrlPic;
	import com.view.gameWindow.util.UtilItemParse;
	import com.view.gameWindow.util.cell.IconCellEx;
	import com.view.gameWindow.util.cell.ThingsData;
	
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	import flash.filters.GlowFilter;

	public class TabWorldBossViewHandle
	{
		private var _tab:TabWorldBoss;
		private var _skin:MCWorldBoss;
		
		private var items:Array = [];
		private var mcArr:Array = [];
		private var awardsItem:Array = [];
		
		private var bossImage:UrlPic;
		private var bossMode:BossModelHandle;
		private var bool:Boolean = false;
		
		private var currentData:WorldBossItemData;
		public function TabWorldBossViewHandle(tab:TabWorldBoss)
		{
			_tab = tab;
			_skin = tab.skin as MCWorldBoss;
			init();
		}
		
		private function init():void
		{
			
		  for(var i:int =0 ;i<10;i++)
		  {
		  	var mc:McWorldBossItem = _skin['boss'+i] as McWorldBossItem;
			var item:WorldBossItem = new WorldBossItem(_tab,mc);
			items.push(item);	
		  }
		  
		  for(var j:int = 0;j<=19;j++)
		  {
			  var _mc:MovieClip = _skin['mcIcon'+j] as MovieClip;
			  mcArr.push(_mc);
			  var cell:IconCellEx = new IconCellEx(_mc.parent,_mc.x,_mc.y,_mc.width,_mc.height);
			  awardsItem.push(cell);
		  } 
		 //bossImage = new UrlPic(_skin.mcContent);
		 _skin.addEventListener(MouseEvent.CLICK,onCLick);
		 _skin.flyBtn.addEventListener(MouseEvent.ROLL_OUT,onOutFly);
		 _skin.flyBtn.addEventListener(MouseEvent.ROLL_OVER,onOverFly);
		 _skin.flyBtn.buttonMode = true;
		}
		
		private function onOutFly(e:MouseEvent):void
		{	 
			_skin.flyBtn.filters = [];
		}
		
		private function onOverFly(e:MouseEvent):void
		{
			_skin.flyBtn.filters = [new GlowFilter(0xffffff)];
		}
		public function refresh():void
		{
//			var manager:BossDataManager = BossDataManager.instance;
//			var data:WorldBossData = manager.worldData;
//			var len:int = data.items.length;
//			for(var i:int = 0;i<10;i++)
//			{
//				var item:WorldBossItem = items[i] as WorldBossItem;
//				/*if(len>i)
//				{
//					item.refresh(data.items[i]);
//				}*/
//				
//			 	if(data.items[i])
//				{
//					item.refresh(data.items[i]);
//				} 
//			}
//			
//			if(!bool)
//			{
//				dealFirstOne();
//				//setItemShow(data.firstData);
//				bool = true;
//			}
			
		}
		
		private function dealFirstOne():void
		{
			items[0].firstShow();
		}
		
		private function onCLick(e:MouseEvent):void
		{                
 			if(!currentData)
				return;
			
			if(0>=currentData.percent)
				return;
			
			switch(e.target) 
			{
				case _skin.flyBtn :
				{
					var mapId:int = SceneMapManager.getInstance().mapId;
					if(currentData.maps_noFlys.indexOf(String(mapId)) ==-1)
					{
						BossDataManager.instance.deliverBoss(currentData,3);
					}
					else
					{
						//AutoJobManager.getInstance().setAutoTargetData(currentData.group_id,EntityTypes.ET_MONSTER);
						AutoSystem.instance.setTarget(currentData.monsterCfgData.group_id,EntityTypes.ET_MONSTER,currentData.map_monster_id);	
					}
				}
				break;
				
				case _skin.mapTxt :
				{
					
					if(currentData.monsterCfgData2)
					{
						if(e.target.htmlText!="")
						{
							if(0>=currentData.revive_time)
								AutoSystem.instance.setTarget(currentData.monsterCfgData2.group_id,EntityTypes.ET_MONSTER,currentData.map_monster_id);	
							else
								AutoSystem.instance.setTarget(currentData.monsterCfgData2.group_id,EntityTypes.ET_MONSTER);	
							//AutoJobManager.getInstance().setAutoTargetData(currentData.monsterCfgData2.group_id,EntityTypes.ET_MONSTER);	
							
						}
					}
					
				}
				break;
					
			}
		}
		 
		public function setItemShow(data:WorldBossItemData):void
		{
			if(!data) return;
			currentData = data;
			//bossImage.load(ResourcePathConstants.IMAGE_BOSS_HEAD_LOAD+data.url+".png");
			if(bossMode)
				bossMode.destroy();

			bossMode = new BossModelHandle(_skin.bossContent);	
			bossMode.data = data.monsterCfgData;
			bossMode.changeModel();
			 
			_skin.nameTxt.text = data.bossName;
			_skin.mapTxt.htmlText = "<u><a href='#'>"+ data.mapName +"</a></u>";
			_skin.freshTimetxt.text = data.start_time_str;
			var awards:Vector.<ThingsData> =UtilItemParse.getThingsDatas(data.reward_items);	
			var now:Date = new Date();
			var len:int = awards.length;
			for(var i:int = 0; i<= 19;i++)
			{
				if(len>i)
				{
					_skin['mcIcon'+i].visible = true;
					IconCellEx.setItemByThingsData(awardsItem[i],awards[i]);
					ToolTipManager.getInstance().attach(awardsItem[i]);
				}
				else
				{
					_skin['mcIcon'+i].visible = false;
				}
			}
			
			if(data.monsterCfgData2)
			{
				
				var color:uint;		
				var str:String;
				color = data.percent ==100 ? 0x00ff00:0xff0000;
				_skin.levtxt.text ="LV " + data.monsterCfgData2.level.toString();
				if((now.hours*3600+now.minutes*60+now.seconds) > data.endTime )
				{
					if(data.percent > 0)
					{
						str = StringConst.BOSS_PANEL_0032;
					}
					else
					{
						str = StringConst.BOSS_PANEL_0027;
					}
					_skin.flyBtn.visible = false;
				}
				else
				{
					
					str = data.percent ==100 ?StringConst.BOSS_PANEL_0026 : (0>=data.percent ? StringConst.BOSS_PANEL_0027 : StringConst.BOSS_PANEL_0024+data.percent+"%");
					_skin.flyBtn.visible = true;
				}
				_skin.hpTxt.textColor = color;
				_skin.hpTxt.text = str;
				
			}
			else
			{
				_skin.hpTxt.textColor = 0x6a6a6a;
				_skin.hpTxt.text =StringConst.BOSS_PANEL_0007;
				_skin.flyBtn.visible = false;
			}
			
		}
		
		internal function destroy():void
		{
			
			if(bossMode)
			{
				bossMode.destroy();
				bossMode = null;
			}
			var item:WorldBossItem;
			 
			for each(item in items)
			{
				if(item)
				{
					item.destroy();
				}
			}
			var item2:IconCellEx
			for each(item2 in awardsItem)
			{
				if(item2)
				{
					ToolTipManager.getInstance().detach(item2);
				} 
			}
			bool = false;
			
			_skin.removeEventListener(MouseEvent.CLICK,onCLick);
			_skin.flyBtn.removeEventListener(MouseEvent.ROLL_OUT,onOutFly);
			_skin.flyBtn.removeEventListener(MouseEvent.ROLL_OVER,onOverFly);
			
			currentData = null;
			items.length = 0;	
			mcArr.length = 0;
			awardsItem.length =0;
			awardsItem = null;
			items = null;
			mcArr = null;
		}
						 
			 
		 
		
	}
}