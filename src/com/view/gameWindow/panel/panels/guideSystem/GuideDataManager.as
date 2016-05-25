package com.view.gameWindow.panel.panels.guideSystem
{
	import com.model.business.gameService.constants.GameServiceConstants;
	import com.model.business.gameService.serverMessageManager.subManages.DistributionManager;
	import com.model.business.gameService.socketManager.ClientSocketManager;
	import com.model.configData.ConfigDataManager;
	import com.model.configData.cfgdata.GuideCfgData;
	import com.model.dataManager.DataManagerBase;
	import com.pattern.Observer.IObserverEx;
	import com.view.gameWindow.panel.panels.guideSystem.constants.GuideCondTypes;
	import com.view.gameWindow.panel.panels.hero.HeroDataManager;
	import com.view.gameWindow.panel.panels.onhook.AutoSystem;
	import com.view.gameWindow.panel.panels.roleProperty.RoleDataManager;
	import com.view.gameWindow.panel.panels.task.TaskDataManager;
	import com.view.gameWindow.panel.panels.task.item.AutoTaskItem;
	import com.view.gameWindow.panel.panels.taskStar.data.PanelTaskStarDataManager;
	import com.view.gameWindow.scene.entity.EntityLayerManager;
	import com.view.gameWindow.scene.entity.constants.EntityTypes;
	import com.view.gameWindow.scene.map.SceneMapManager;
	import com.view.gameWindow.scene.movie.MovieManager;
	
	import de.polygonal.ds.TreeIterator;
	import de.polygonal.ds.TreeNode;
	
	import flash.utils.ByteArray;
	import flash.utils.Dictionary;
	import flash.utils.Endian;
	
	
	/**
	 * @author wqhk
	 * 2014-12-9
	 */
	public class GuideDataManager extends DataManagerBase implements IObserverEx
	{
		private static var _instance:GuideDataManager;
		
		public static function get instance():GuideDataManager
		{
			if(!_instance)
			{
				_instance = new GuideDataManager();
			}
			
			return _instance;
		}
		
		private var typeStore:Dictionary = new Dictionary();//cond_type
		private var treeNoteStore:Dictionary;//key:guideId 前置引导中用到
		private var rootNoteStore:Dictionary;//key:guideId 前置引导中用到
		private var currentStartGuideList:Array = [];
		
		public function GuideDataManager()
		{
			super();
			
			RoleDataManager.instance.attach(this);
			HeroDataManager.instance.attach(this);
			EntityLayerManager.getInstance().attach(this);
			TaskDataManager.instance.attach(this);
			PanelTaskStarDataManager.instance.attach(this);
			
			DistributionManager.getInstance().register(GameServiceConstants.SM_MOVIE_START,this);
			DistributionManager.getInstance().register(GameServiceConstants.SM_NEW_GUIDE,this);
			DistributionManager.getInstance().register(GameServiceConstants.SM_JOINT_SKILL_GUIDE,this);
			DistributionManager.getInstance().register(GameServiceConstants.SM_EQUIP_TYPE_GET,this);
			DistributionManager.getInstance().register(GameServiceConstants.SM_HERO_HOLD_GUIDE,this);
			
			initCfgData();
			parseSerialGuide();
		}
		
		private function getCfg(id:int):GuideCfgData
		{
			return ConfigDataManager.instance.guideCfgData(id);
		}
		
		public function getSerialGuideRoot(id:int):GuideCfgData
		{
			var cfg:GuideCfgData = getCfg(id);
			if(treeNoteStore[id])
			{
				var note:TreeNode = treeNoteStore[id];
				var itr:TreeIterator = note.getTreeIterator();
				itr.root();
				if(itr.data)
				{
					return itr.data as GuideCfgData;
				}
			}
			
			return null;
		}
		
		public function initCfgData():void
		{
			var dict:Dictionary = ConfigDataManager.instance.guideCfgDatas();
			
			for each(var item:GuideCfgData in dict)
			{
				if(item.cond_type == GuideCondTypes.GCT_ABANDON)
				{
					continue;
				}
				
				if(!typeStore[item.cond_type])
				{
					typeStore[item.cond_type] = [];
				}
				
				typeStore[item.cond_type].push(item);
			}
		}
		
		
		/**
		 * 系列引导 (有前置的引导)
		 */
		public function parseSerialGuide():void
		{
			var list:Array = getList(GuideCondTypes.GCT_GUIDE_FINISH);
			treeNoteStore = new Dictionary();
			rootNoteStore = new Dictionary();
			
			var node:TreeNode;
			var parent:TreeNode;
			
			for each(var item:GuideCfgData in list)
			{
				var guideId:int = parseInt(item.cond_param);
				
				if(guideId > 0)
				{
					var pre:GuideCfgData = getCfg(guideId);
					if(pre)
					{
						parent = treeNoteStore[guideId];
						
						if(!parent)
						{
							parent = new TreeNode(pre);
							treeNoteStore[guideId] = parent;
						}
						
						if(pre.cond_type != GuideCondTypes.GCT_GUIDE_FINISH)
						{
							rootNoteStore[pre.id] = parent;
						}
						
						if(!treeNoteStore[item.id])
						{
							node  = new TreeNode(item,parent);
							treeNoteStore[item.id] = node;
						}
					}
				}
			}
			
			//删除根节点是 GuideCondTypes.GCT_ABANDON的数据
			for(var gid:* in rootNoteStore)
			{
				var n:TreeNode = rootNoteStore[gid];
				
				if(GuideCfgData(n.data).cond_type == GuideCondTypes.GCT_ABANDON)
				{
					var iter:TreeIterator = n.getTreeIterator();
					var c:GuideCfgData;
					
					while(iter.hasNext())
					{
						c = TreeNode(iter.next()).data;
						delete treeNoteStore[c.id];
					}
					
					delete treeNoteStore[gid];
					delete rootNoteStore[gid];
				}
			}
		}
		
		public function getList(type:int):Array
		{
			return typeStore[type];
		}
		
		
		override public function resolveData(proc:int, data:ByteArray):void
		{
			if(proc == GameServiceConstants.SM_MOVIE_START)
			{
				resolveMovieStart(data);
			}
			else if(proc == GameServiceConstants.SM_NEW_GUIDE)
			{
				resolveDeadInfo(data);
			}
			else if(proc == GameServiceConstants.SM_JOINT_SKILL_GUIDE)
			{
				GuideSystem.instance.updateJointAttack();
			}
			else if(proc == GameServiceConstants.SM_EQUIP_TYPE_GET)
			{
				resovleEquipType(data);
			}
			else if(proc == GameServiceConstants.SM_HERO_HOLD_GUIDE)
			{
				GuideSystem.instance.updateHeroHoldMode();
			}
			
			super.resolveData(proc,data);
		}
		
		private var _isEquipTypeInfoFirst:Boolean = true;
		private function resovleEquipType(data:ByteArray):void
		{
			var code:int = data.readInt();
			
			var mask:int = 1;
			for(var i:int = 0; i < 32; ++i)
			{
				if(code & mask)
				{
					GuideSystem.instance.updateEquipType(i,_isEquipTypeInfoFirst);
				}
				mask = mask<<1;
			}
				
			if(_isEquipTypeInfoFirst)
			{
				_isEquipTypeInfoFirst = false;
			}
		}
		
		private function resolveDeadInfo(data:ByteArray):void
		{
			var p:int = data.readByte();
			var h:int = data.readByte();
			
			if(p == 1 && h == 1)
			{
				GuideSystem.instance.updateFirstDead(3);
			}
			else if(p == 1)
			{
				GuideSystem.instance.updateFirstDead(1);
			}
			else if(h == 1)
			{
				GuideSystem.instance.updateFirstDead(2);
			}
		}
		
		private function resolveMovieStart(data:ByteArray):void
		{
			var movieId:int = data.readInt();
			
			MovieManager.instance.startMovie(movieId);
		}
		
		public function update(proc:int=0):void
		{
			switch(proc)
			{
				//因为星级任务的解锁 涉及任务刷新所以还是放回roledatamanager和task写一起
//				case GameServiceConstants.SM_CHR_INFO:
//					doLvUP(RoleDataManager.instance.oldLv,RoleDataManager.instance.lv);
//					break;
				case GameServiceConstants.SM_HERO_INFO:
				case GameServiceConstants.SM_HERO_BASIC_INFO:
					doLvUpHero(HeroDataManager.instance.oldLv,HeroDataManager.instance.lv,HeroDataManager.instance.oldRe,HeroDataManager.instance.grade);
					break;
				case GameServiceConstants.SM_ENTER_MAP:
					doEnterMap(SceneMapManager.getInstance().mapId);
					break;
			}
		}
		
		public function updateData(proc:int,data:*):void
		{
			var list:Array;
			switch(proc)
			{
				case GameServiceConstants.SM_TASK_LIST:
				case GameServiceConstants.SM_TASK_PROGRESS:
				case GameServiceConstants.SM_TASK_RECEIVED:
				case GameServiceConstants.SM_TASK_SUBMITTED:
				case GameServiceConstants.SM_TASK_STAR_INFO:
				case GameServiceConstants.SM_TASK_GIVEUPED:
					list = data as Array;
					if(list)
					{
						doUpdateTask(list);
					}
					break;
			}
			
		}
		
		public function doUpdateTask(list:Array):void
		{
			for each(var data:AutoTaskItem in list)
			{
				if(data)
				{
					GuideSystem.instance.updateTaskState(data.taskId,data.state);
				}
			}
		}
		
		
		private function doEnterMap(mapId:int):void
		{
			if(mapId > 0)
			{
				GuideSystem.instance.updateEnterSceneState(mapId);
				
				//副本战斗，出副本断掉自动战斗
				if(AutoSystem.instance.isAutoFight())
				{
					AutoSystem.instance.stopAutoFight();
				}
			}
		}
		
		private function doLvUP(lv:int,lvNew:int):void
		{
//			if(lv == 0)
//			{
//				GuideSystem.instance.updateLevelState(EntityTypes.ET_PLAYER,lvNew,false);
//			}
//			else if(lv < lvNew)
//			{
//				for(var i:int = lv + 1;i <= lvNew; ++i)
//				{
//					GuideSystem.instance.updateLevelState(EntityTypes.ET_PLAYER,i,true);
//				}
//			}
		}
		
		private function doLvUpHero(lv:int,newLv:int,re:int,newRe:int):void
		{
			if(lv == 0)
			{
				if(newRe == 0)
				{
					GuideSystem.instance.updateLevelState(EntityTypes.ET_HERO,newLv,newRe,false);
				}
			}
			else if(lv < newLv)
			{
				if(newRe == 0)
				{
					for(var i:int = lv + 1;i <= newLv; ++i)
					{
						GuideSystem.instance.updateLevelState(EntityTypes.ET_HERO,i,newRe,true);
					}
				}
			}
		}
		
		public function sendGetFamilyGuideMail():void
		{
			var data:ByteArray = new ByteArray;
			data.endian = Endian.LITTLE_ENDIAN;
			data.writeInt(0);
			ClientSocketManager.getInstance().asyncCall(GameServiceConstants.CM_GET_FAMILY_GUIDE_MAIL,data);
		}
		
	}
}