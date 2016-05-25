package com.view.gameWindow.mainUi.subuis.autoSign
{
	import com.model.business.fileService.UrlSwfLoader;
	import com.model.business.fileService.constants.ResourcePathConstants;
	import com.model.business.fileService.interf.IUrlSwfLoaderReceiver;
	import com.model.consts.EffectConst;
	import com.view.gameWindow.mainUi.MainUi;
	
	import flash.display.MovieClip;
	import flash.display.Sprite;

	public class AutoSign extends MainUi implements IAutoSign,IUrlSwfLoaderReceiver
	{
		private var _typeEffect:String = "";
		private var _urlSwfLoader:UrlSwfLoader;
		private var _fightEffect:MovieClip;
		private var _findPathEffect:MovieClip;
		
		public const WIDTH:int = 200;
		public const HEIGHT:int = 100;
		public const MOVETOX:int = 120;
		public const MOVETOY:int = 170;
		
		
		public function AutoSign()
		{
			super();
			mouseEnabled = false;
			mouseChildren = false;
		}
		
		override public function initView():void
		{
			
		}
		
		//load 还没load完成时。
		private var isShowPath:Boolean = false;
		public function showFindPathEffect():void
		{
			if(isShowFight)
			{
				return;
			}
			
			if(isShowPath)
			{
				return;
			}
			isShowPath = true;
			
			if(_fightEffect && _fightEffect.parent)
			{
				return;
			}
			hideFightEffect();
			_typeEffect = EffectConst.RES_AUTOSIGN_FINDPATH;
			if(!_findPathEffect)
			{
				load();
			}
			else
			{
				_findPathEffect.play();
				addChild(_findPathEffect);
			}
		}
		
		public function hideFindPathEffect():void
		{
			if(!isShowPath)
			{
				return;
			}
			isShowPath = false;
			
			destroyLoader();
			if(_findPathEffect)
			{
				if(_findPathEffect.parent)
				{
					_findPathEffect.parent.removeChild(_findPathEffect);
				}
				_findPathEffect.stop();
			}
			if(_fightEffect && !_fightEffect.parent && _findPathEffect && !_findPathEffect.parent)
			{
				_typeEffect = "";
			}
		}
		
		private var isShowFight:Boolean = false;
		public function showFightEffect():void
		{
			if(isShowFight)
			{
				return;
			}
			isShowFight = true;
			
			hideFindPathEffect();
			_typeEffect = EffectConst.RES_AUTOSIGN_FIGHT;
			if(!_fightEffect)
			{
				load();
			}
			else
			{
				_fightEffect.play();
				addChild(_fightEffect);
			}
		}
		
		public function hideFightEffect():void
		{
			if(!isShowFight)
			{
				return;
			}
			isShowFight = false;
			
			destroyLoader();
			if(_fightEffect)
			{
				if(_fightEffect.parent)
				{
					_fightEffect.parent.removeChild(_fightEffect);
				}
				_fightEffect.stop();
			}
			if(_fightEffect && !_fightEffect.parent && _findPathEffect && !_findPathEffect.parent)
			{
				_typeEffect = "";
			}
		}
		
		private function load():void
		{
			if(!_urlSwfLoader)
			{
				_urlSwfLoader = new UrlSwfLoader(this);
				var url:String = ResourcePathConstants.IMAGE_EFFECT_FOLDER_LOAD + _typeEffect;
				_urlSwfLoader.loadSwf(url);
			}
		}
		
		public function swfError(url:String, info:Object):void
		{
			destroyLoader();
		}
		
		public function swfProgress(url:String, progress:Number, info:Object):void
		{
		}
		
		public function swfReceive(url:String, swf:Sprite, info:Object):void
		{
			var effect:MovieClip;
			effect = swf.getChildAt(0) as MovieClip;
			effect.mouseChildren = false;
			effect.mouseEnabled = false;
			effect.x = 0;
			effect.y = 0;
			effect.play();
			addChild(effect);
			if(_typeEffect == EffectConst.RES_AUTOSIGN_FINDPATH)
			{
				_findPathEffect = effect;
//				_findPathEffect.x = -50;
//				_findPathEffect.y = -326;
			}
			else if(_typeEffect == EffectConst.RES_AUTOSIGN_FIGHT)
			{
				_fightEffect = effect;
//				_fightEffect.x = -50;
//				_fightEffect.y = -326;
			}
			destroyLoader();
		}
		
		private function destroyLoader():void
		{
			if(_urlSwfLoader)
			{
				_urlSwfLoader.destroy();
				_urlSwfLoader = null;
			}
		}
		
		public function resize():void
		{
			
		}
		public function isInAuto():Boolean
		{
//			if((_findPathEffect && _findPathEffect.parent) || (_fightEffect && _fightEffect.parent))
			if(isShowFight || isShowPath)
			{
				return true;
			}
			else
			{
				return false;
			}
		}
	}
}