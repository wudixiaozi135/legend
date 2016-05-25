package com.view.gameWindow.panel.panels.skill
{
	import com.model.configData.ConfigDataManager;
	import com.model.configData.cfgdata.SkillCfgData;
	import com.model.consts.JobConst;
	import com.pattern.Observer.IObserver;
	import com.view.gameWindow.panel.panels.hero.HeroDataManager;
	import com.view.gameWindow.panel.panels.roleProperty.RoleDataManager;
	import com.view.gameWindow.panel.panels.skill.constants.SkillConstants;
	import com.view.gameWindow.panel.panels.specialRing.SpecialRingDataManager;
	
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	import flash.utils.Dictionary;

	/**
	 * 技能栏处理类
	 * @author Administrator
	 */	
	public class PanelSkillItemHandle implements IObserver
	{
		private var _panel:PanelSkill;
		private var _skin:McPanelSkill;
		private var _items:Vector.<PanelSkillItem>;
		private var _panelSkillItemDragHandle:PanelSkillItemDragHandle;
		
		public function PanelSkillItemHandle(panel:PanelSkill)
		{
			_panel = panel;
			_skin = _panel.skin as McPanelSkill;
			initializer();
			SpecialRingDataManager.instance.attach(this);
		}
		
		private function initializer():void
		{
			var i:int,num:int;
			num = PanelSkillItem.pageNum;
			_items = new Vector.<PanelSkillItem>(num,true);
			for(i=0;i<num;i++)
			{
				var panelSkillItem:PanelSkillItem = new PanelSkillItem();
				panelSkillItem.x = 43;
				panelSkillItem.y = 87+i*64;
				_skin.addChild(panelSkillItem);
				_items[i] = panelSkillItem;
			}
			_skin.addEventListener(MouseEvent.CLICK,onClick);
			_panelSkillItemDragHandle = new PanelSkillItemDragHandle(_skin);
		}
		
		protected function onClick(event:MouseEvent):void
		{
			var movieClip:MovieClip = event.target as MovieClip;
			if(!movieClip)
			{
				return;
			}
			var panelSkillItem:PanelSkillItem = movieClip.parent as PanelSkillItem;
			if(!panelSkillItem)
			{
				return;
			}
			if(movieClip != panelSkillItem.btn)
			{
				return;
			}
			var entity_type:int = SkillDataManager.instance.entity_type;
			if(entity_type == SkillConstants.TYPE_ROLE)
			{
				panelSkillItem.openSkillSet();
			}
			else if(entity_type == SkillConstants.TYPE_HERO)
			{
				panelSkillItem.switchHeroSkillState()
			}
		}
		
		public function update(proc:int=0):void
		{
			refreshItems();
		}
		
		public function refreshItems():void
		{
			var page:int,pageNum:int,panelSkillItem:PanelSkillItem,i:int,index:int,cfgDt:SkillCfgData;
			page = _panel.clickHandle.page;
			pageNum = PanelSkillItem.pageNum;
			for each(panelSkillItem in _items)
			{
				index = (page-1)*pageNum+i;
				var cfgDts:Vector.<SkillCfgData> = lv1SkillCfgDatas;
				if(index < cfgDts.length)
				{
					cfgDt = cfgDts[index];
					panelSkillItem.refreshData(cfgDt);
					panelSkillItem.visible = true;
				}
				else
				{
					panelSkillItem.visible = false;
				}
				i++;
			}
		}
		/**取得对应职业类型的所有一级技能配置信息*/
		public function get lv1SkillCfgDatas():Vector.<SkillCfgData>
		{
			var cfgDatas:Vector.<SkillCfgData> = new Vector.<SkillCfgData>();
			var job:int = getJob();
			cfgDatas = cfgDatas.concat(lv1SkillCfgDatasByJob(job));
			cfgDatas = cfgDatas.concat(lv1SkillCfgDatasByJob(JobConst.TYPE_NO));
			cfgDatas.sort(function (item1:SkillCfgData,item2:SkillCfgData):Number
			{
				return item1.id - item2.id;
			});
			return cfgDatas;
		}
		
		private function lv1SkillCfgDatasByJob(job:int):Vector.<SkillCfgData>
		{
			var level:int = 1;
			var cfgDatas:Vector.<SkillCfgData> = new Vector.<SkillCfgData>();
			var entity_type:int = SkillDataManager.instance.entity_type;
			var skillCfgDatass:Dictionary = ConfigDataManager.instance.skillCfgDatas(job,entity_type),skillCfgDatas:Dictionary,skillCfgData:SkillCfgData;
			for each(skillCfgDatas in skillCfgDatass)
			{
				skillCfgData = skillCfgDatas[level] as SkillCfgData;
				if(skillCfgData && skillCfgData.view_type == entity_type)
				{
					cfgDatas.push(skillCfgData);
				}
			}
			return cfgDatas;
		}
		
		private function getJob():int
		{
			var entity_type:int = SkillDataManager.instance.entity_type;
			if(entity_type == SkillConstants.TYPE_ROLE)
			{
				var job:int = RoleDataManager.instance.job;
			}
			else if(entity_type == SkillConstants.TYPE_HERO)
			{
				job = HeroDataManager.instance.job;
			}
			else
			{
				job = RoleDataManager.instance.job;
				trace("PanelSkillItem.setSkillData entity_type:"+entity_type);
			}
			return job;
		}
		
		public function destory():void
		{
			SpecialRingDataManager.instance.detach(this);
			if(_panelSkillItemDragHandle)
			{
				_panelSkillItemDragHandle.destory();
			}
			_panelSkillItemDragHandle = null;
			_skin.removeEventListener(MouseEvent.CLICK,onClick);
			var panelSkillItem:PanelSkillItem;
			for each (panelSkillItem in _items) 
			{
				panelSkillItem.destory();
			}
			_items = null;
			_skin = null;
			_panel = null;
		}
	}
}