package com.view.gameWindow.scene.entity.entityItem
{
    import com.model.business.gameService.constants.GameServiceConstants;
    import com.model.consts.ConstHeroMode;
    import com.pattern.Observer.IObserver;
    import com.view.gameWindow.panel.panels.hero.HeroDataManager;
    import com.view.gameWindow.scene.entity.entityInfoLabel.FirstHeroInfoLabel;
    import com.view.gameWindow.scene.entity.entityItem.interf.IFirstHero;

    public class FirstHero extends Hero implements IFirstHero, IObserver
	{
		private var _mode:int;
		
		public function FirstHero()
		{
			HeroDataManager.instance.attach(this);
			
			_mode = ConstHeroMode.HM_HIDE_IDLE;
			
			updateModeEffect(HeroDataManager.instance.mode);
		}
		
		public override function initInfoLabel():void
		{
			_infoLabel = new FirstHeroInfoLabel();
		}
		
		public function update(proc:int = 0):void
		{
			if (proc == GameServiceConstants.SM_HERO_BASIC_INFO)
			{
				updateModeEffect(HeroDataManager.instance.mode);
			}
		}
		
		private function updateModeEffect(mode:int):void
		{
			if (_mode != mode)
			{
				_mode = mode;
                var heroLabel:FirstHeroInfoLabel = _infoLabel as FirstHeroInfoLabel;
                heroLabel.heroMode = mode;
			}
		}
		
		protected override function refreshNameTxtPos():void
		{
			if (_nameTxt && (_entityModel && _entityModel.available || isHideModel))
			{
				var heroLabel:FirstHeroInfoLabel = _infoLabel as FirstHeroInfoLabel;
				heroLabel.refreshNameTextPos(_nameTxt, getHeadContentPosY());
                heroLabel.refreshHeroModePos();
			}
		}
		
		private function getHeadContentPosY():Number
		{
			var theY:Number = 0;
			if (_nameTxt)
			{
				if (!_nameInBody)
				{
					theY = modelHeight+24;
                } else
                {
                    theY = modelHeight * .5;
                }
			}
			else
			{
				theY = modelHeight * .5;
			}
			return theY;
		}
		
		public override function destory():void
		{
			super.destory();
			HeroDataManager.instance.detach(this);
		}
	}
}