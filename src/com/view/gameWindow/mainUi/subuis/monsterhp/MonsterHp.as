package com.view.gameWindow.mainUi.subuis.monsterhp
{
    import com.greensock.TweenMax;
    import com.greensock.easing.Circ;
    import com.model.business.gameService.constants.GameServiceConstants;
    import com.model.configData.cfgdata.MonsterCfgData;
    import com.model.consts.StringConst;
    import com.pattern.Observer.IObserver;
    import com.view.gameWindow.mainUi.MainUi;
    import com.view.gameWindow.mainUi.subclass.McMonsterHp;
    import com.view.gameWindow.panel.panels.buff.BuffDataManager;
    import com.view.gameWindow.panel.panels.buff.BuffListView;
    import com.view.gameWindow.scene.entity.EntityLayerManager;
    import com.view.gameWindow.scene.entity.entityItem.autoJob.AutoJobManager;
    import com.view.gameWindow.scene.entity.entityItem.interf.IEntity;
    import com.view.gameWindow.scene.entity.entityItem.interf.IMonster;

    public class MonsterHp extends MainUi implements IMonsterHp,IObserver
	{
		private var _monster:IMonster;
		private var buff:BuffListView;
		private var _monsterCfgData:MonsterCfgData;
		
		public function MonsterHp()
		{
			super();
			EntityLayerManager.getInstance().attach(this);
			BuffDataManager.instance.attach(this);
		}
		
		override public function initView():void
		{
			_skin = new McMonsterHp();
			addChild(_skin);
			super.initView();
			buff = new BuffListView(25);
			buff.x = 20;
			buff.y = 28;
			addChild(buff);
		}
		
		public function update(proc:int = 0):void
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
		
		public function refreshHp():void
		{
			var iMonster:IMonster = (AutoJobManager.getInstance().selectEntity) as IMonster;
			if(iMonster==null)
			{
				destroy();
				return;
			}
			
			var monsterCfgData:MonsterCfgData = iMonster.mstCfgData;
			if(monsterCfgData.quality!=1)
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
				TweenMax.killTweensOf(_skin._mask2);
				var cur:Number =Number(( iMonster.hp/iMonster.maxHp).toFixed(4));
				_skin._mask.scaleX=cur;
				_skin._mask2.scaleX=cur;
			}
			_monster=iMonster;
			_monsterCfgData=monsterCfgData;
			updateHP();
		}	
		
		private function updateHP():void
		{
			var _name:String = _monsterCfgData.name;
			var _level:int = _monsterCfgData.level;
			var _maxHp:int = _monsterCfgData.maxhp;
			var _hp:int = _monster.hp;
			_skin.txt_00.text = _name+"\t"+String(_level)+StringConst.MONSTER_HP_0001;
			_skin.txt_01.text = String(_hp)+"/"+String(_maxHp);
			
			var cur:Number =Number(( _hp/_maxHp).toFixed(4));
			TweenMax.to(_skin._mask, 0.3*(1-cur), {scaleX: cur});
			
			if(	TweenMax.isTweening(_skin._mask2))
			{
				return;
			}
			var sc:Number=Number(_skin._mask2.scaleX.toFixed(4));
			var dur:Number = Math.abs(cur-sc)*1;
			if(dur>0.001)
			{
				TweenMax.to(_skin._mask2, 0.3, {scaleX: cur,ease:Circ.easeInOut,onComplete:onComplete});
			}
		}
		
		private function onComplete():void
		{
			refreshHp();
		}
		
		private function destroy():void
		{
			this.visible=false;
			_monster=null;
		}
		
		private function show():void
		{
			this.visible=true;
		}
		
		private function updateBuff():void
		{
			var iself:IEntity = AutoJobManager.getInstance().selectEntity;
			if(iself)
			{
				buff.data = BuffDataManager.instance.getBuffList(iself.entityType,iself.entityId);
			}
		}
	}
}