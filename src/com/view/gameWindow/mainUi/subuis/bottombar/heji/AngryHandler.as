package com.view.gameWindow.mainUi.subuis.bottombar.heji
{
	import com.model.business.gameService.constants.GameServiceConstants;
	import com.model.consts.EffectConst;
	import com.pattern.Observer.IObserver;
	import com.view.gameWindow.mainUi.subclass.McMainUIBottom;
	import com.view.gameWindow.mainUi.subuis.bottombar.BottomBar;
	import com.view.gameWindow.panel.panels.guideSystem.GuideSystem;
	import com.view.gameWindow.panel.panels.guideSystem.unlock.UnlockFuncId;
	import com.view.gameWindow.panel.panels.hejiSkill.HejiSkillDataManager;
	import com.view.gameWindow.panel.panels.hero.HeroDataManager;
	import com.view.gameWindow.panel.panels.roleProperty.RoleDataManager;
	import com.view.gameWindow.util.UIEffectLoader;
	import com.view.gameWindow.util.cooldown.SectorMaskEffect;
	
	import flash.display.MovieClip;
	import flash.display.Shape;
	import flash.utils.getTimer;

	public class AngryHandler implements IObserver
	{
		private var _bottomBar:BottomBar;
		private var _skin:McMainUIBottom;
		
		private var _angry:int;
		private var _angryTarget:int;
		private var _effectLoader:UIEffectLoader;
		private var _mask:Shape;
		
		private var _sectorMaskEffect:SectorMaskEffect;
		/**逆时针播发*/
		private var _isInverse:Boolean;

		public function AngryHandler(bottomBar:BottomBar)
		{
			_bottomBar = bottomBar;
			_skin = _bottomBar.skin as McMainUIBottom;
			/*trace("AngryHandler.AngryHandler(bottomBar) _skin.mcAngryValue.x:"+_skin.mcAngryValue.x+",_skin.mcAngryValue.y:"+_skin.mcAngryValue.y);*/
			initialize();
		}
		
		private function initialize():void
		{
			RoleDataManager.instance.attach(this);
			HeroDataManager.instance.attach(this);
			//
			var mcAngryValue:McAngryValue = _skin.mcAngryValue;
			mcAngryValue.mouseEnabled = false;
			mcAngryValue.mouseChildren = false;
			//
			_skin.btnHalo.visible = false;//合击光环按钮不显示
			_skin.txtHalo.mouseEnabled = false;
			//
			_sectorMaskEffect = new SectorMaskEffect(mcAngryValue.mcBg,refreshAngryEffect);
		}
		
		public function update(proc:int=0):void
		{
			var isUnlock:Boolean = GuideSystem.instance.isUnlock(UnlockFuncId.HERO);
			if(!isUnlock)
			{
				return;
			}
			var isBattle:Boolean;
			if(proc == GameServiceConstants.SM_HERO_INFO || proc == GameServiceConstants.SM_HERO_BASIC_INFO)
			{
				isBattle = HeroDataManager.instance.isHeroFight();
				if(!isBattle)
				{
					_angryTarget = _angry = 0;
					if(_sectorMaskEffect.isPlaying)
					{
						_sectorMaskEffect.stop();
					}
					else
					{
						HejiSkillDataManager.instance.isAngryFull = false;
						removeEffect();
						_sectorMaskEffect.clearGraphics();
					}
				}
				else
				{
					effectPlay();
				}
			}
			else if(proc == GameServiceConstants.SM_CHR_INFO)
			{
				isBattle = HeroDataManager.instance.isHeroFight();
				if(!isBattle)
				{
					return;
				}
				effectPlay();
			}
			else if(proc == GameServiceConstants.SM_ANGRY_CHANGE)
			{
				isBattle = HeroDataManager.instance.isHeroFight();
				if(!isBattle)
				{
					return;
				}
				effectJumpTo();
			}
		}
		
		private function effectPlay():void
		{
			var manager:RoleDataManager = RoleDataManager.instance;
			var angryMax:int = manager.angryMax;
//			trace("AngryHandler.effectPlay(angry) time:"+getTimer()+",angry:"+manager.angry);
			if(HejiSkillDataManager.instance.isAngryFullInUI && manager.angry != 0)
			{
				return;
			}
			var angry:int = _angry == 0 ? angryMax : 0;
			var _percent:Number = _angry/angryMax;
			_percent = _percent < 0 ? 0 : (_percent > 1 ? 1 : _percent);
			var initAngle:Number = -90+360*_percent;
			
			var percent:Number = angry/angryMax;
			percent = percent < 0 ? 0 : (percent > 1 ? 1 : percent);
			var overAngle:Number = -90+360*percent;
			
			_isInverse = initAngle > overAngle;
			var angerRecoverSpeed:int = manager.angerRecoverSpeed;//5秒恢复的怒气值
			var msPerPoint:Number = angerRecoverSpeed > 0 ? 5000/angerRecoverSpeed : 50;//每点怒气特效显示花费的时间
			var duration:int = _isInverse ? 250 : msPerPoint*(angry - _angry);
			/*trace("AngryHandler.effectPlay(angry) time:"+getTimer()+",_angry:"+_angry+",angry:"+angry+",duration:"+duration+",initAngle:"+initAngle+",overAngle:"+overAngle);*/
//			trace("AngryHandler.effectPlay(angry) time:"+getTimer()+",isPlaying:"+_sectorMaskEffect.isPlaying+",_isInverse:"+_isInverse);
			if(_sectorMaskEffect.isPlaying)//若正在播放
			{
				if(!_isInverse)
				{
					_sectorMaskEffect.setDuration(duration);
				}
				return;
			}
			_sectorMaskEffect.play(duration,initAngle,overAngle);
			HejiSkillDataManager.instance.isAngryPlaying = true;
			_angryTarget = angry;
			
			if(_isInverse)//若逆时针，直接移除特效
			{
				removeEffect();
			}
		}
		
		private function effectJumpTo():void
		{
			var manager:RoleDataManager = RoleDataManager.instance;
			if(_sectorMaskEffect.isPlaying)//若正在播放
			{
				if(!_isInverse)
				{
					var jumpAngry:int = manager.jumpAngry;
					var percent:Number = jumpAngry/manager.angryMax;
					percent = percent < 0 ? 0 : (percent > 1 ? 1 : percent);
					var jumpAngle:Number = -90+360*percent;
					_sectorMaskEffect.jumpTo(jumpAngle);
				}
			}
		}
		
		private function refreshAngryEffect():void
		{
			_angry = _angryTarget;
			if(_angry == 0)
			{
				_isInverse = false;
				HejiSkillDataManager.instance.isAngryFull = false;
				removeEffect();
				_sectorMaskEffect.clearGraphics();
			}
			else
			{
				HejiSkillDataManager.instance.isAngryFull = true;
				addEffect();
			}
			HejiSkillDataManager.instance.isAngryPlaying = false;
		}
			
		private function addEffect():void
		{
			if(!_effectLoader)
			{
				var mcBg:MovieClip = _skin.mcAngryValue.mcBg;
				var callBack:Function = function ():void
				{
					mcBg.visible = false;
				};
				var theX:int = mcBg.x+mcBg.width*.5+2;
				var theY:int = mcBg.y+mcBg.height*.5+1;
				_effectLoader = new UIEffectLoader(mcBg.parent,theX,theY,1,1,EffectConst.RES_HEJI,callBack);
			}
		}
		
		private function removeEffect():void
		{
			var mcBg:MovieClip = _skin.mcAngryValue.mcBg;
			mcBg.visible = true;
			if(_effectLoader)
			{
				_effectLoader.destroy();
			}
			_effectLoader = null;
		}
	}
}