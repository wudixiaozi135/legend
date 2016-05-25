package com.view.gameWindow.mainUi.subuis.rolehp
{
	import com.greensock.TweenMax;
	import com.greensock.easing.Circ;
	import com.model.business.fileService.UrlBitmapDataLoader;
	import com.model.business.fileService.constants.ResourcePathConstants;
	import com.model.business.fileService.interf.IUrlBitmapDataLoaderReceiver;
	import com.model.business.gameService.constants.GameServiceConstants;
	import com.model.configData.cfgdata.MonsterCfgData;
	import com.model.consts.JobConst;
	import com.pattern.Observer.IObserver;
	import com.view.gameWindow.mainUi.MainUi;
	import com.view.gameWindow.mainUi.subclass.McRoleHp;
	import com.view.gameWindow.panel.panels.buff.BuffDataManager;
	import com.view.gameWindow.panel.panels.buff.BuffListView;
	import com.view.gameWindow.panel.panels.stall.StallDataManager;
	import com.view.gameWindow.scene.entity.EntityLayerManager;
	import com.view.gameWindow.scene.entity.entityItem.Player;
	import com.view.gameWindow.scene.entity.entityItem.autoJob.AutoJobManager;
	import com.view.gameWindow.scene.entity.entityItem.interf.IEntity;
	import com.view.gameWindow.scene.entity.entityItem.interf.IPlayer;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;

	public class PlayerHP extends MainUi implements IObserver,IUrlBitmapDataLoaderReceiver
	{
		
		private var _player:IPlayer;
		private var _timeId:int;
		private var _playerIcon:Bitmap;
		private var _loadBitMap:UrlBitmapDataLoader;
		private var _iconUrl:String;
		private var _mouseHandler:PlayerHPMouseHandler;
		private var buff:BuffListView;
		private var _monsterCfgData:MonsterCfgData;
		
		public function PlayerHP()
		{
			super();
			BuffDataManager.instance.attach(this);
		}
		
		override public function initView():void
		{
			_skin = new McRoleHp();
			addChild(_skin);
			_playerIcon=new Bitmap();
			_playerIcon.x=37;
			_playerIcon.y=33;
			_skin.addChild(_playerIcon);
			_skin.txt1.mouseEnabled=false;
			_skin.txt2.mouseEnabled=false;
			_skin.txt3.mouseEnabled=false;
			_skin.txt4.mouseEnabled=false;
			super.initView();
			buff = new BuffListView(25);
			buff.x = 100;
			buff.y = 100;
			addChild(buff);
			_mouseHandler=new PlayerHPMouseHandler(_skin as McRoleHp);
			_skin.btn1.buttonMode = true;
			_skin.btn2.buttonMode = true;
			_skin.btn3.buttonMode = true;
			_skin.btn4.buttonMode = true;
			EntityLayerManager.getInstance().attach(this);
		}
		
		public function update(proc:int=0):void
		{
			if(proc == GameServiceConstants.SM_PLAYER_BUFF_LIST || proc == GameServiceConstants.SM_UNITS_BUFF_LIST)
			{
				if(this.visible)
				{
					updateBuff();
				}
			}else
			{
				refreshHp();
			}
		}
		
		private function updateBuff():void
		{
			var iself:IEntity = AutoJobManager.getInstance().selectEntity;
			if(iself)
			{
				buff.data = BuffDataManager.instance.getBuffList(iself.entityType,iself.entityId);
			}
		}
		
		public function refreshHp():void
		{
			var iPlayer:IPlayer = (AutoJobManager.getInstance().selectEntity) as IPlayer;
			
			if(iPlayer==null||iPlayer.isShow==false)
			{
				destroy();
				return;
			}
			show();
			
			if(iPlayer!=_player)
			{
				TweenMax.killTweensOf(_skin.hpMask2);
				var cur:Number =Number(( iPlayer.hp/iPlayer.maxHp).toFixed(4));
				_skin.hpMask.scaleX=cur;
				_skin.hpMask2.scaleX=cur;
			}
			_player=iPlayer;
			
			updateHP();
		}	
		
		private function updateHP():void
		{
			var _name:String;
			var _level:int;
			var _hp:int;
			var _maxHp:int;
			var job:int;
			var player:Player = _player as Player
			_name = player.entityName;
			_level = player.level;
			_maxHp = player.maxHp;
			_hp = _player.hp;
			job=player.job;
			_skin.txtName.text = _name;
			_skin.txtLv.text="Lv."+_level;
			_skin.txtJob.text=JobConst.jobName2(job);
			_skin.txt_01.text = String(_hp)+"/"+String(_maxHp);
			
			var cur:Number =Number(( _hp/_maxHp).toFixed(4));
			TweenMax.to(_skin.hpMask, 0.3*(1-cur), {scaleX: cur});
			
			if(	TweenMax.isTweening(_skin.hpMask2))
			{
				return;
			}
			var sc:Number=Number(_skin.hpMask2.scaleX.toFixed(4));
			var dur:Number = Math.abs(cur-sc)*2;
			if(dur>0.001)
			{
//				TweenMax.to(_skin.hpMask2, dur, {scaleX: cur,ease:Circ.easeIn,onComplete:onComplete});
				TweenMax.to(_skin.hpMask2, 1, {scaleX: cur,ease:Circ.easeInOut,onComplete:onComplete});
			}
			
			var url:String=ResourcePathConstants.IMAGE_CREATEROLE_FOLDER_LOAD+job+"_"+player.sex+ResourcePathConstants.POSTFIX_PNG;
			if(_iconUrl==url)return;
			_loadBitMap=new UrlBitmapDataLoader(this);
			_loadBitMap.loadBitmap(url);
			_iconUrl=url;
		}
		
		private function onComplete():void
		{
			refreshHp();
		}
		
		private function destroy():void
		{
			this.visible=false;
			StallDataManager.instance.closeOtherStallPanel();
			_mouseHandler&&_mouseHandler.hideMenu();
			_player=null;
		}
		
		private function show():void
		{
			this.visible=true;
		}
		
		public function urlBitmapDataError(url:String, info:Object):void
		{
			// TODO Auto Generated method stub
		}
		
		public function urlBitmapDataProgress(url:String, progress:Number, info:Object):void
		{
			// TODO Auto Generated method stub
			
		}
		
		public function urlBitmapDataReceive(url:String, bitmapData:BitmapData, info:Object):void
		{
			// TODO Auto Generated method stub
			_playerIcon.bitmapData=bitmapData;
			_playerIcon.smoothing=true;
			_playerIcon.scaleX=72/bitmapData.width;
			_playerIcon.scaleY=72/bitmapData.height;
			_loadBitMap.destroy();
			
		}
	}
}