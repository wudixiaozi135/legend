package com.view.gameWindow.scene.entity.entityInfoLabel
{
	import com.model.consts.ConstHeroMode;
	import com.model.consts.EffectConst;
	import com.view.gameWindow.scene.entity.entityInfoLabel.interf.IFirstHeroInfoLabel;
	import com.view.gameWindow.util.UIEffectLoader;

	import flash.display.Sprite;

	public class FirstHeroInfoLabel extends HeroInfoLabel implements IFirstHeroInfoLabel
	{
		private var _uiEffect:UIEffectLoader;
		private var _heroMode:int;
		private var _uiEffectContainer:Sprite;
		public function FirstHeroInfoLabel()
		{
			super();
			addChild(_uiEffectContainer = new Sprite());
			_uiEffectContainer.mouseChildren = false;
			_uiEffectContainer.mouseEnabled = false;
		}

        public function refreshHeroModePos():void
		{
            var posX:Number = 0, posY:Number = 0;
			var offW:int = 7;//10为特殊虚宽
			if (_nameTxtBitmap)
			{
                posX = _nameTxtBitmap.x + offW;
                posY = _nameTxtBitmap.y - 3;
                if (_uiEffectContainer.x != posX)
                {
                    _uiEffectContainer.x = posX;
                }
                if (_uiEffectContainer.y != posY)
                {
                    _uiEffectContainer.y = posY;
                }
			}
		}
		
		public function get heroMode():int
		{
			return _heroMode;
		}
		
		public function set heroMode(value:int):void
		{
			if (_heroMode != value)
			{
				_heroMode = value;
				destroyUiEffect();
				
				if (_heroMode == ConstHeroMode.HM_HOLD)
				{
					_uiEffect = new UIEffectLoader(_uiEffectContainer, 0, 0, 1, 1, EffectConst.RES_HERO_MODE_DEFEND);
				}
				else if (_heroMode == ConstHeroMode.HM_ACTIVE)
				{
					_uiEffect = new UIEffectLoader(_uiEffectContainer, 0, 0, 1, 1, EffectConst.RES_HERO_MODE_ATTACK);
				}
			}
		}
		
		private function destroyUiEffect():void
		{
			if (_uiEffect)
			{
				_uiEffect.destroy();
				_uiEffect = null;
			}
		}
	}
}