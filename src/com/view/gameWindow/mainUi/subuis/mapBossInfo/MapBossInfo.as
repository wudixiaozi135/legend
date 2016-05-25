package com.view.gameWindow.mainUi.subuis.mapBossInfo
{
	import com.model.business.gameService.constants.GameServiceConstants;
	import com.model.consts.MapConst;
	import com.model.consts.StringConst;
	import com.model.gameWindow.rsr.RsrLoader;
	import com.pattern.Observer.IObserver;
	import com.view.gameWindow.mainUi.MainUi;
	import com.view.gameWindow.mainUi.subclass.McMapBossInfo;
	import com.view.gameWindow.panel.PanelConst;
	import com.view.gameWindow.panel.PanelMediator;
	import com.view.gameWindow.panel.panels.boss.BossData;
	import com.view.gameWindow.panel.panels.boss.BossDataManager;
	import com.view.gameWindow.scene.entity.EntityLayerManager;
	import com.view.gameWindow.scene.map.SceneMapManager;
	import com.view.gameWindow.util.HtmlUtils;
	import com.view.gameWindow.util.TimeUtils;
	import com.view.gameWindow.util.TimerManager;
	
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;

	
	public class MapBossInfo extends MainUi implements IMapBossInfo,IObserver
	{
		
		private var _isVisible:Boolean;
		private const BOSS:int = 3;
		private var _time:int;
		private var initMouseX:Number;
		private var initMouseY:Number;
		private var _isMoveing:Boolean;
		private var _panelRect:Rectangle;
		
		public function MapBossInfo()
		{
			super();
			EntityLayerManager.getInstance().attach(this);
			BossDataManager.instance.attach(this);
		}
		
		override public function initView():void
		{
			_skin = new McMapBossInfo();
			initText();
			super.initView();
			_skin.btnLook.buttonMode = true;
			_skin.btnLook.alpha = 0;		
		}
		
		private function initText():void
		{
			_skin.txt_00.mouseEnabled = false;
			_skin.txt_01.mouseEnabled = false;
			_skin.txt_00.text = StringConst.MAPBOSSINFO_0001;
			_skin.txt_01.htmlText = StringConst.MAPBOSSINFO_0002;
		}
		
		override protected function addCallBack(rsrLoader:RsrLoader):void
		{
			rsrLoader.addCallBack(skin.btnPick,function(mc:MovieClip):void
			{
				skin.btnPick.rotation = 90;
				skin.btnPick.selected = true;
				skin.btnPick.x += skin.btnPick.width;
			});
		}
		
		public function update(proc:int=0):void
		{
			var mapId:int = SceneMapManager.getInstance().mapId;
			if(proc == GameServiceConstants.SM_ENTER_MAP)
			{
				if(mapId == MapConst.EMOGUANGCHANG)
				{
					BossDataManager.instance.GetBossHPInfo();
					destroy();
					_skin.addEventListener(MouseEvent.CLICK,clickHandle);
					_skin.addEventListener(MouseEvent.ROLL_OVER,rollOverHandle);
					_skin.btn.addEventListener(MouseEvent.MOUSE_DOWN,downHandle);
					addChild(_skin);
				}
				else
				{
					if(contains(_skin))
					{
						destroy();
						removeChild(_skin);
						TimerManager.getInstance().remove(refreshTxt); 												
					}
				}
			}
			else if(proc == GameServiceConstants.SM_MAP_BOSS_HP_INFO)
			{
				TimerManager.getInstance().remove(refreshTxt);
				TimerManager.getInstance().add(1000,refreshTxt);
			}
		}
		
		private function downHandle(e:MouseEvent):void
		{
			_panelRect = new Rectangle(0,0,_skin.width,_skin.height);
			initMouseX = -mouseX;
			initMouseY = -mouseY;
			
			stage.addEventListener(MouseEvent.MOUSE_MOVE,moveHandle);
			stage.addEventListener(MouseEvent.MOUSE_UP,upHandle);
		}		
		
		private function moveHandle(e:MouseEvent):void
		{
			if (stage && _panelRect)
			{
				var tryX:int = stage.mouseX + initMouseX + _panelRect.x;
				var tryY:int = stage.mouseY + initMouseY + _panelRect.y;
				x = tryX - _panelRect.x;
				y = tryY - _panelRect.y;
				_isMoveing = true;
			}
		}
		
		private function upHandle(e:MouseEvent):void
		{
			stage.removeEventListener(MouseEvent.MOUSE_UP,upHandle);
			stage.removeEventListener(MouseEvent.MOUSE_MOVE,moveHandle);
		}		
		
		private  function rollOverHandle(event:MouseEvent):void
		{
			if(event.target == _skin.btn.parent)
			{
				_skin.mcInfoBg.visible = true;
				_skin.txt_02.visible = true;
				_skin.txt_03.visible = true;
				_skin.btnPick.selected = true;
			}
		}
		
		private function destroy():void
		{
			_skin.removeEventListener(MouseEvent.CLICK,clickHandle);
			_skin.removeEventListener(MouseEvent.ROLL_OVER,rollOverHandle);
		}
		
		protected function clickHandle(event:MouseEvent):void
		{
			if(event.target == _skin.btnLook)
			{
				PanelMediator.instance.openPanel(PanelConst.TYPE_MAP);
			}
			else if(event.target == _skin.btnPick)
			{
				if(!_isMoveing)
				{
					if(_skin.btnPick.selected == false)
					{
						_skin.mcInfoBg.visible = false;
						_skin.txt_02.visible = false;
						_skin.txt_03.visible = false;
					}
					else
					{
						_skin.mcInfoBg.visible = true;
						_skin.txt_02.visible = true;
						_skin.txt_03.visible = true;
					}
				}
			}
			_isMoveing = false;
		}
		
		private function getReviveTime():String
		{
			var str:String;
			if(0 >= _time)
			{
				str = HtmlUtils.createHtmlStr(0x00ff00,"可击杀",12,false,8);/*StringConst.MAPBOSSINFO_0003 + "\n";*/
			}
			else
			{
				str =HtmlUtils.createHtmlStr(0xffcc00,TimeUtils.formatClock1(_time) + " " + StringConst.MAPBOSSINFO_0004,12,false,8);/*TimeUtils.formatClock1(_time) + " " + StringConst.MAPBOSSINFO_0004 + "\n";*/
			}
			return str;
		}

		private function refreshTxt():void
		{
//			_skin.txt_02.htmlText = "";
//			_skin.txt_03.htmlText = "";
			var bossDatas:Vector.<BossData> = BossDataManager.instance.getBossInfoByMapId(MapConst.EMOGUANGCHANG);
			var infoString:String = "";
			var timeString:String = "";
			var isAllCanKill:Boolean = true;
			bossDatas.sort(sortReviveTime);
			for each(var bossData:BossData in bossDatas)
			{
				_time = bossData.dealReviveTime();
				infoString += HtmlUtils.createHtmlStr(0xd4a460,bossData.mapMstCfgData.name,12,false,8)+"\n";
				timeString += getReviveTime()+"\n";
				if(_time > 0)
				{
					isAllCanKill = false;
				}
			}
			_skin.txt_02.htmlText = infoString;
			_skin.txt_03.htmlText = timeString;
			if(isAllCanKill == true)
			{
				TimerManager.getInstance().remove(refreshTxt); 
			}
		}
		
		private function sortReviveTime(a:BossData,b:BossData):int
		{
			if(a.dealReviveTime() < b.dealReviveTime()||(a.dealReviveTime()==b.dealReviveTime()&&a.map_monster_id<b.map_monster_id))
			{
				return -1;
			}
			else
			{
				return 1;
			}
		}
	}
}