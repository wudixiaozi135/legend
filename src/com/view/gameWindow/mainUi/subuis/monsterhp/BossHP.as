package com.view.gameWindow.mainUi.subuis.monsterhp
{
    import com.greensock.TweenMax;
    import com.greensock.easing.Circ;
    import com.model.business.fileService.UrlBitmapDataLoader;
    import com.model.business.fileService.constants.ResourcePathConstants;
    import com.model.business.fileService.interf.IUrlBitmapDataLoaderReceiver;
    import com.model.business.gameService.constants.GameServiceConstants;
    import com.model.configData.ConfigDataManager;
    import com.model.configData.cfgdata.BossCfgData;
    import com.model.configData.cfgdata.MonsterCfgData;
    import com.pattern.Observer.IObserver;
    import com.view.gameWindow.mainUi.MainUi;
    import com.view.gameWindow.mainUi.subclass.McBossHp;
    import com.view.gameWindow.mainUi.subuis.monsterhp.dropList.DropListView;
    import com.view.gameWindow.panel.panels.buff.BuffDataManager;
    import com.view.gameWindow.panel.panels.buff.BuffListView;
    import com.view.gameWindow.scene.entity.EntityLayerManager;
    import com.view.gameWindow.scene.entity.entityItem.autoJob.AutoJobManager;
    import com.view.gameWindow.scene.entity.entityItem.interf.IEntity;
    import com.view.gameWindow.scene.entity.entityItem.interf.IMonster;
    
    import flash.display.Bitmap;
    import flash.display.BitmapData;

    public class BossHP extends MainUi implements IMonsterHp,IObserver,IUrlBitmapDataLoaderReceiver
	{
		private var _monster:IMonster;
		private var _timeId:int;
		private var _bossIcon:Bitmap;
		private var _loadBitMap:UrlBitmapDataLoader;
		private var _iconUrl:String;
		private var buff:BuffListView;
		private var _drop:DropListView;
		private var _initBool:Boolean;
//        private var _block:Shape;
        private var _scaleHp:Number = 0;
        private var _monsterCfgData:MonsterCfgData;
		public function BossHP()
		{
			super();
			BuffDataManager.instance.attach(this);
		}
		
		override public function initView():void
		{
			_skin = new McBossHp();
			addChild(_skin);
			_bossIcon=new Bitmap();
			_bossIcon.x=22;
			_bossIcon.y=26;
			_skin.addChild(_bossIcon);
			buff = new BuffListView(25);
			buff.x = 100;
			buff.y = 70;
			addChild(buff);
			_drop = new DropListView();
			_drop.y = 70;
			addChild(_drop);

//            _block = new Shape();
//            _block.graphics.beginFill(0xffffff, .6);
//            _block.graphics.drawRect(0, 0, 3, _skin.hpMask.height);
//            _block.graphics.endFill();
//            _skin.addChild(_block);
//
//            _block.x = _skin.hpMask.x + _skin.txt_01.width - _block.width;
//            _block.y = _skin.hpMask.y;
//            _block.visible = false;

			super.initView();
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
				if(this.visible&&_monster && _initBool == false)
				{
					var monsterCfg:MonsterCfgData = ConfigDataManager.instance.monsterCfgData(_monster.monsterId);
					var bossCfg:BossCfgData = ConfigDataManager.instance.bossCfgDataByGroupId(monsterCfg.group_id);
					var leng:int;
					if(!bossCfg)
					{
						return;
					}
					_drop.data =bossCfg.reward_items;
					leng = _drop._listView.length;
					_drop.x = 320 - leng*28;
					_initBool = true;
				}
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
			var iMonster:IMonster = (AutoJobManager.getInstance().selectEntity) as IMonster;
			if(iMonster==null)
			{
				destroy();
				return;
			}
			
			var monsterCfgData:MonsterCfgData = iMonster.mstCfgData;
			if(monsterCfgData.quality==1)
			{
				destroy();
				return;
			}
			
			if(iMonster.isShow==false)
			{
				destroy();
				return;
			}
			
			show();
			
			if(iMonster!=_monster)
			{
				TweenMax.killTweensOf(_skin.hpMask2);
				var cur:Number =Number(( iMonster.hp/iMonster.maxHp).toFixed(4));
				_skin.hpMask.scaleX=cur;
				_skin.hpMask2.scaleX=cur;
				_initBool=false;
			}
			_monster=iMonster;
			_monsterCfgData=monsterCfgData;
			updateHP();
			
			var url:String=ResourcePathConstants.IMAGE_BOSS_HEAD_ICON+_monsterCfgData.head+ResourcePathConstants.POSTFIX_PNG;
			if(_iconUrl==url)return;
			_loadBitMap=new UrlBitmapDataLoader(this);
			_loadBitMap.loadBitmap(url);
			_iconUrl=url;
		}	
		
		private function updateHP():void
		{
			var _name:String = _monsterCfgData.name;
			var _level:int = _monsterCfgData.level;
			var _maxHp:int = _monsterCfgData.maxhp;
			var _hp:int = _monster.hp;
			_skin.txtName.text = _name;
			_skin.txtLv.text="Lv."+_level;
			_skin.txt_01.text = String(_hp)+"/"+String(_maxHp);
			
			var cur:Number =Number(( _hp/_maxHp).toFixed(4));
			TweenMax.to(_skin.hpMask, 0.3*(1-cur), {scaleX: cur});
			
			if(	TweenMax.isTweening(_skin.hpMask2))
			{
				return;
			}
			var sc:Number=Number(_skin.hpMask2.scaleX.toFixed(4));
			var dur:Number = Math.abs(cur-sc)*4;
			if(dur>0.001)
			{
				TweenMax.to(_skin.hpMask2, 0.5, {scaleX: cur,ease:Circ.easeInOut,onComplete:onComplete});
//				TweenMax.to(_skin.hpMask2, dur, {scaleX: cur,ease:Circ.easeIn,onComplete:onComplete});
			}
		}
		
		private function onComplete():void
		{
			refreshHp();
		}
		
		private function destroy():void
		{
			this.visible=false;
			_initBool=false;
			_monster=null;
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
			_bossIcon.bitmapData=bitmapData;
//			_bossIcon.scaleX=57/bitmapData.width;
//			_bossIcon.scaleY=56/bitmapData.height;
			_loadBitMap.destroy();
		}
	}
}