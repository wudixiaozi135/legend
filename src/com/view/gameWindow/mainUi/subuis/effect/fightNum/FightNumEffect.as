package com.view.gameWindow.mainUi.subuis.effect.fightNum
{
    import com.model.business.fileService.constants.ResourcePathConstants;
    import com.model.consts.EffectConst;
    import com.pattern.Observer.IObserver;
    import com.view.gameWindow.mainUi.MainUi;
    import com.view.gameWindow.panel.panels.roleProperty.RoleDataManager;
    import com.view.gameWindow.scene.stateAlert.StateAlertManager;
    import com.view.gameWindow.util.NumPic;
    import com.view.gameWindow.util.UIEffectLoader;
    import com.view.gameWindow.util.UrlPic;

    import flash.display.MovieClip;
    import flash.display.Sprite;

    public class FightNumEffect extends MainUi implements IFightNumEffect,IObserver
	{
		private const FIGHT:String = "rolehead/fightPower.png";
		private var _urlPicfight:UrlPic;
		private var _sprite:Sprite;
		private var _uiEffectLoader:UIEffectLoader;
		private var _oldFightNum:String;
		private var _fightNum:String;
		private var _mc:MovieClip;
		private var timerId:uint;
		
		public function FightNumEffect()
		{
			super();
			init();
			RoleDataManager.instance.attach(this);
            mouseEnabled = false;
		}
		
		public function update(proc:int=0):void
		{
			if( RoleDataManager.instance.oldFightNum < RoleDataManager.instance.getRoleMaxAttack())
			{
				var numPic:NumPic = new NumPic();
				_oldFightNum = String(RoleDataManager.instance.oldFightNum);
				if(_oldFightNum == "0")
				{
					return;
				}
				while(_sprite.numChildren)
				{
					_sprite.removeChildAt(0);
				}
				if(_uiEffectLoader)
				{
					_uiEffectLoader.destroy();
				}
				_mc = new MovieClip();
				_sprite.addChild(_mc);
				_mc.x = 80;
				_mc.y = 2;
				_urlPicfight = new UrlPic(_sprite);
				_fightNum = String(RoleDataManager.instance.getRoleMaxAttack());
				_urlPicfight.load(ResourcePathConstants.IMAGE_MAINUI_FOLDER_LOAD + FIGHT);
				numPic.init("fight_",_fightNum,_mc,function():void
				{
					_uiEffectLoader = new UIEffectLoader(_sprite,80,0,1,1,EffectConst.RES_FIGHTNUMEFFECT,function():void
					{
						var stateAlertManage:StateAlertManager = StateAlertManager.getInstance();
						stateAlertManage.showUiAlert(_sprite,StateAlertManager.GREEN,int(_fightNum) - int(_oldFightNum),true,"",150,0);
					},true);
				});	

			}
		}		
		
		override public function initView():void
		{
			
		}
		
		private function init():void
		{
			_sprite = new Sprite();
            _sprite.mouseEnabled = false;
            _sprite.mouseChildren = false;
			addChild(_sprite);
		}
		
		public function swfError(url:String, info:Object):void
		{
			destroyLoader(int(info));
		}
		
		public function swfProgress(url:String, progress:Number, info:Object):void
		{
			
		}
		
		public function swfReceive(url:String, swf:Sprite, info:Object):void
		{
			/*var index:int = int(info);
			_mcVector = new Vector.<MovieClip>;
			_mcVector.length = _arrNum.length;
			if(_numContain)
			{
				_mc = swf.getChildAt(0) as MovieClip;
				if(_mc)
				{
					_mc.mouseChildren = false;
					_mc.mouseEnabled = false;
					_mc.x = index*_numWidth + 80;
					_mc.y = 10;
					_mc.numLayer.y = -_arrNum[index]*_numHeight;
					_numContain.addChild(_mc);
				}
			}
			if(_numContain.numChildren == _arrNum.length)
			{
					_isPlay = true;
			}*/
		}
		
		public function playEffect():void
		{
			/*if(_numContain.numChildren == 0)
			{
				return;
			}
			if(_isPlay)
			{
				var time:int = getTimer()/1000;
				_mcVector[3].alpha = int(time%2);
				trace("FightNumEffect.playEffect() _numContain.numChildren:"+_numContain.numChildren);
				trace("FightNumEffect.playEffect() _mcVector[3].alpha:"+_mcVector[3].alpha);
				var _numLength:int = _mcVector.length;
				for(var j:int = _numLength-1; j>0;j--)
				{
					if(_mcVector[j].numLayer.y != -(10+int(_arrNewNum[j]))*_numHeight)
					{
						_mcVector[j].numLayer.y -= 1;
						return;
					}
				}
				_isPlay = false;
				_mcVector = null;*/
//			}
		}
		
		public function destroyLoader(i:int):void
		{
			/*if(_urlSwfLoaders[i])
			{
				_urlSwfLoaders[i].destroy();
				_urlSwfLoaders[i] = null;
			}*/
		}
		
		public function destroyCallBack():void
		{
			/*if(_callBack != null)
			{
				_callBack = null;
			}
			if(_argument != null)
			{
				_argument = null;
			}*/
		}
	}
}