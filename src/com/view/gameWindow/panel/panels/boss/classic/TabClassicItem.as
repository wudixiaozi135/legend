package com.view.gameWindow.panel.panels.boss.classic
{
	import com.model.business.fileService.constants.ResourcePathConstants;
	import com.model.consts.StringConst;
	import com.model.consts.ToolTipConst;
	import com.model.gameWindow.rsr.RsrLoader;
	import com.view.gameWindow.panel.PanelConst;
	import com.view.gameWindow.panel.PanelMediator;
	import com.view.gameWindow.panel.panels.onhook.AutoSystem;
	import com.view.gameWindow.panel.panels.roleProperty.RoleDataManager;
	import com.view.gameWindow.scene.entity.constants.EntityTypes;
	import com.view.gameWindow.tips.rollTip.RollTipMediator;
	import com.view.gameWindow.tips.rollTip.RollTipType;
	import com.view.gameWindow.tips.toolTip.TipVO;
	import com.view.gameWindow.tips.toolTip.ToolTipManager;
	import com.view.gameWindow.util.FilterUtil;
	import com.view.gameWindow.util.SimpleStateButton;
	import com.view.gameWindow.util.TimerManager;
	import com.view.gameWindow.util.UrlPic;
	
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	import flash.filters.ColorMatrixFilter;
	import flash.text.TextField;

	public class TabClassicItem
	{
		private var _parent:TabClassicBossViewHandle;
		private var _skin:MovieClip;
		
		private var data:ClassicItemData;
		private var loader:UrlPic;
		protected  const _overFilter:ColorMatrixFilter = new ColorMatrixFilter([1.51024604372414,-0.425559412057497,0.0953133683333553,0,6.26999999999999,-0.141155127311352,1.40643028822174,-0.0852751609103901,0,6.27,-0.279839959843708,-0.21231284160452,1.67215280144823,0,6.27,0,0,0,1,0]);
		public function TabClassicItem(parent:TabClassicBossViewHandle,skin:MovieClip,rsloader:RsrLoader)
		{
			_parent = parent;
			_skin = skin;
			rsloader.load(_skin,ResourcePathConstants.IMAGE_PANEL_FOLDER_LOAD);
			var mcContent:MovieClip = _skin.getChildByName("mcContent") as MovieClip;
			loader = new UrlPic(mcContent);
			 
			_skin.mapTxt.addEventListener(MouseEvent.CLICK,onClickMapTxt);
			SimpleStateButton.addState(_skin.mapTxt);
			_skin.tagMc.addEventListener(MouseEvent.CLICK,onClickTagMc); 
			SimpleStateButton.addState(_skin.tagMc); 
			_skin.tagMc.addEventListener(MouseEvent.ROLL_OVER,onOverBmc);
			_skin.tagMc.addEventListener(MouseEvent.ROLL_OUT,onOutBmc);
			_skin.content.addEventListener(MouseEvent.ROLL_OVER,onOver);
			_skin.content.addEventListener(MouseEvent.ROLL_OUT,onOut);
			ToolTipManager.getInstance().attach(_skin.content);
		}
		
		private function onOverBmc(e:MouseEvent):void
		{
			_skin.content.mouseEnabled = false;
			_skin.tagMc.filters = [_overFilter];
			//new GlowFilter(0xffffff)
			//trace("onOverBmc 111111111111111");
		}
		
		private function onOutBmc(e:MouseEvent):void
		{
			_skin.content.mouseEnabled = true;
			_skin.tagMc.filters = [];
			//trace("onOutBmc 222222222222222222");
		}
		private function onOver(e:MouseEvent):void
		{
			//_skin.content.addEventListener(MouseEvent.ROLL_OUT,onOut);
			TimerManager.getInstance().remove(updateTime);
			if(0>=data.hp)
				return;
			_skin.mcContent.filters = [_overFilter];
			//new GlowFilter(0xffffff)
			//_skin.tagMc.visible = true;
			
		}
		
		private function onOut(e:MouseEvent):void
		{
			//_skin.content.addEventListener(MouseEvent.ROLL_OVER,onOver);
			TimerManager.getInstance().add(1000,updateTime);
			if(0>=data.hp)
				return;
			_skin.mcContent.filters = [];
			//_skin.tagMc.visible = false;
			
		}
		
		private function updateTime():void
		{
			data.revive_time --;
			if(0>=data.revive_time)
			{
				TimerManager.getInstance().remove(updateTime);
			}
		}
		internal function refresh(data:ClassicItemData):void
		{
			this.data = data;
			loader.load(data.url);
			var mapTxt:TextField = _skin.getChildByName("mapTxt") as TextField;
			var tagMc:MovieClip =  _skin.getChildByName("tagMc") as MovieClip;
			var mcContent:MovieClip = _skin.getChildByName("mcContent") as MovieClip;
			
			mapTxt.htmlText = "<u><a href='#'>"+ data.mapName +"</a></u>";		
			
			var tipVO:TipVO = new TipVO();
			
			tipVO.tipType = ToolTipConst.BOSS_TIP;
			tipVO.tipData = data;
			ToolTipManager.getInstance().hashTipInfo(_skin.content,tipVO);
			 
			if(data.hp>0)
			{
				mcContent.filters = [];
				tagMc.visible = true;
			}
			else
			{
				mcContent.filters = [grayFilters()];
				tagMc.visible = false;
			}
			
		/*	if(mcContent.resUrl !=data.url)
			{
				mcContent.resUrl = 'worldBoss/'+data.url+".png";
				//_parent.loadNewSource(mcContent);
			}*/
			 
		}
		 
		public function  grayFilters():ColorMatrixFilter
		{
			var mat:Array =[0.3086,0.6094,0.082,0,0,0.3086,0.6094,0.082,0,0,0.3086,0.6094,0.082,0,0,0,0,0,1,0];
			var colorMat:ColorMatrixFilter = new ColorMatrixFilter(mat);
			return colorMat;
		}
		
		private function onClickMapTxt(e:MouseEvent):void
		{
			if (RoleDataManager.instance.stallStatue)
			{
				RollTipMediator.instance.showRollTip(RollTipType.ERROR, StringConst.STALL_PANEL_0019);
				return;
			}
			if(0>=data.hp)
			{
				RollTipMediator.instance.showRollTip(RollTipType.ERROR,StringConst.BOSS_PANEL_0031);	
				return;
			}
			AutoSystem.instance.setTarget(data.monsterCfgData.group_id,EntityTypes.ET_MONSTER,data.map_monster_id);	
			PanelMediator.instance.closePanel(PanelConst.TYPE_BOSS);
			//AutoJobManager.getInstance().setAutoTargetData(data.monsterCfgData.group_id,EntityTypes.ET_MONSTER);
		}
		
		private function onClickTagMc(e:MouseEvent):void
		{
			
			_parent.gotoSceneBoss(data);

		}
		
		public function setVisible(flag:Boolean):void
		{
			_skin.visible = flag;	
		}
		internal function destroy():void
		{
			
			loader.destroy();
			loader = null;
			_skin.mapTxt.removeEventListener(MouseEvent.CLICK,onClickMapTxt);
			SimpleStateButton.removeState(_skin.mapTxt);
			_skin.tagMc.removeEventListener(MouseEvent.CLICK,onClickTagMc); 
			SimpleStateButton.removeState(_skin.tagMc); 
			_skin.tagMc.removeEventListener(MouseEvent.ROLL_OVER,onOverBmc);
			_skin.tagMc.removeEventListener(MouseEvent.ROLL_OUT,onOutBmc);
			_skin.content.removeEventListener(MouseEvent.ROLL_OVER,onOver);
			_skin.content.removeEventListener(MouseEvent.ROLL_OUT,onOut);
			ToolTipManager.getInstance().detach(_skin.content);
			TimerManager.getInstance().remove(updateTime);
			data = null;
			_skin = null;
		}
	}
}