package com.view.gameWindow.panel.panels.skill.panelskillset
{
	import com.model.consts.StringConst;
	import com.model.gameWindow.rsr.RsrLoader;
	import com.view.gameWindow.mainUi.subuis.bottombar.actBar.ActionBarData;
	import com.view.gameWindow.mainUi.subuis.bottombar.actBar.ActionBarDataManager;
	import com.view.gameWindow.panel.PanelConst;
	import com.view.gameWindow.panel.PanelMediator;
	import com.view.gameWindow.panel.panelbase.PanelBase;
	import com.view.gameWindow.panel.panels.skill.McPanelSkillSet;
	import com.view.gameWindow.panel.panels.skill.SkillData;
	import com.view.gameWindow.panel.panels.skill.SkillDataManager;
	import com.view.gameWindow.util.Cover;
	
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	
	public class PanelSkillSet extends PanelBase implements IPanelSkillSet
	{
		private const l:int = 10;
		private var _iconItems:Vector.<SkillIconItem>;
		private var _cover:Cover;
		
		public function PanelSkillSet()
		{
			super();
			_iconItems = new Vector.<SkillIconItem>();
		}
		
		override protected function initSkin():void
		{
			_cover = new Cover(0x000000,.6);
			addChild(_cover);
			_skin = new McPanelSkillSet();
			addChild(_skin);
		}
		
		override protected function addCallBack(rsrLoader:RsrLoader):void
		{
			var mc:McPanelSkillSet = _skin as McPanelSkillSet;
			mc.txt.text = StringConst.SKILL_PANEL_0013;
			rsrLoader.addCallBack(mc.btnCancel,function (mc:MovieClip):void
			{
				var textField:TextField = mc.txt as TextField;
				textField.text = StringConst.SKILL_PANEL_0014;
				textField.textColor = 0xd4a460;
			});
		}
		
		override protected function initData():void
		{
			_skin.addEventListener(MouseEvent.CLICK,onClick);
			initSkillIcon();
		}
		
		override public function setPostion():void
		{
			super.setPostion();
		}
		
		private function initSkillIcon():void
		{
			var mc:McPanelSkillSet,i:int;
			mc = _skin as McPanelSkillSet;
			for(i=0;i<l;i++)
			{
				var mcIcon:MovieClip = mc["mcIcon"+i] as MovieClip;
				var skillIconItem:SkillIconItem = new SkillIconItem(mcIcon);
				_iconItems.push(skillIconItem);
				//
				var textField:TextField = mc["txt"+i] as TextField;
				textField.text = (i+1)+"";
			}
			mc.txt6.text = "q";
			mc.txt7.text = "w";
			mc.txt8.text = "e";
			mc.txt9.text = "r";
		}
		
		protected function onClick(event:MouseEvent):void
		{
			var mc:McPanelSkillSet = _skin as McPanelSkillSet;
			var target:MovieClip = event.target as MovieClip;
			switch(target)
			{
				case mc.btnCancel:
					PanelMediator.instance.switchPanel(PanelConst.TYPE_SKILL_SET);
					break;
				case mc.mcIcon0:
				case mc.mcIcon1:
				case mc.mcIcon2:
				case mc.mcIcon3:
				case mc.mcIcon4:
				case mc.mcIcon5:
				case mc.mcIcon6:
				case mc.mcIcon7:
				case mc.mcIcon8:
				case mc.mcIcon9:
					PanelMediator.instance.switchPanel(PanelConst.TYPE_SKILL_SET);
					var key:int = int(target.name.charAt(target.name.length-1));
					sendData(key);
					break;
			}
		}
		
		private function sendData(key:int):void
		{
			var selectSkillData:SkillData,actionBarData:ActionBarData;
			selectSkillData = SkillDataManager.instance.selectSkillData;
			ActionBarDataManager.instance.sendSetSkillData(key,selectSkillData.group_id);
		}
		
		override public function update(proc:int = 0):void
		{
			var actBarDatas:Vector.<ActionBarData> = ActionBarDataManager.instance.actBarDatas;
			if(!actBarDatas)
			{
				return;
			}
			var actionBarData:ActionBarData,i:int;
			for(i=0;i<l;i++)
			{
				actionBarData = actBarDatas[i];
				if(actionBarData && !actionBarData.isPreinstall)
				{
					_iconItems[i].loadPic(actionBarData.groupId);
				}
				else
				{
					_iconItems[i].setNull();
				}
			}
		}
		
		override public function destroy():void
		{
			if(_cover)
			{
				if(_cover.parent)
					_cover.parent.removeChild(_cover);
				_cover = null;
			}
			while(_iconItems && _iconItems.length)
			{
				var pop:SkillIconItem = _iconItems.pop();
				pop.destory();
				_iconItems = null;
			}
			_skin.removeEventListener(MouseEvent.CLICK,onClick);
			super.destroy();
		}
	}
}