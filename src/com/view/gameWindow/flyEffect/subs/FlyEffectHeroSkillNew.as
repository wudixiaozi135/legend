package com.view.gameWindow.flyEffect.subs
{
    import com.greensock.TweenLite;
    import com.greensock.TweenMax;
    import com.model.business.fileService.UrlBitmapDataLoader;
    import com.model.business.fileService.constants.ResourcePathConstants;
    import com.model.business.fileService.interf.IUrlBitmapDataLoaderReceiver;
    import com.model.configData.cfgdata.SkillCfgData;
    import com.model.consts.StringConst;
    import com.view.gameWindow.flyEffect.FlyEffectBase;
    import com.view.gameWindow.mainUi.MainUiMediator;
    import com.view.gameWindow.mainUi.subclass.McMainUIBottom;
    import com.view.gameWindow.mainUi.subuis.bottombar.BottomBar;
    import com.view.gameWindow.scene.entity.EntityLayerManager;
    import com.view.gameWindow.scene.entity.entityItem.Hero;
    import com.view.gameWindow.scene.entity.entityItem.interf.IHero;
    
    import flash.display.Bitmap;
    import flash.display.BitmapData;
    import flash.display.Sprite;
    import flash.geom.Point;

    public class FlyEffectHeroSkillNew extends FlyEffectBase implements IUrlBitmapDataLoaderReceiver
    {
        private var _skillCfg:SkillCfgData;
        private var _bmpLoader:UrlBitmapDataLoader;

        public function FlyEffectHeroSkillNew(layer:Sprite, cfg:SkillCfgData)
        {
            super(layer);
            _skillCfg = cfg;
        }

        public function start():void
        {
            initialize();
        }

        private function initialize():void
        {
            if (_skillCfg)
            {
                _bmpLoader = new UrlBitmapDataLoader(this);
                var url:String = ResourcePathConstants.IMAGE_ICON_SKILL_FOLDER_LOAD + _skillCfg.icon + ResourcePathConstants.POSTFIX_PNG;
                _bmpLoader.loadBitmap(url);
            }
        }

        override protected function onComplete():void
        {
			var myHero:IHero = EntityLayerManager.getInstance().myHero;
			if(myHero!=null)
			{
				var randomIndex:int= Math.random()*StringConst.HERO_SAY_0003.length;
				myHero.say(StringConst.HERO_SAY_0003[randomIndex]);
			}
			
            if (_bmpLoader)
            {
                _bmpLoader.destroy();
                _bmpLoader = null;
            }
            if (_skillCfg)
                _skillCfg = null;

            if (target)
            {
				TweenMax.killTweensOf(target);
                if (layer.contains(target))
                    layer.removeChild(target);
                target = null;
            }
            HeroSkillEffectHandler.isReady = true;
        }

        public function urlBitmapDataReceive(url:String, bitmapData:BitmapData, info:Object):void
        {
            target = new Bitmap(bitmapData);
            fromLct = new Point(layer.stage.stageWidth * .5, 80);//起点
            duration = 2;

            doFirst();
        }

        private function doFirst():void
        {
            if (!layer.contains(target))
            {
                layer.addChild(target);
                target.x = layer.stage.stageWidth * .5 + 150 + layer.numChildren * 50;
                target.y = -100;
            }

			TweenMax.to(target, .6, {
                x: fromLct.x, y: fromLct.y, scaleX: 1.5, scaleY: 1.5, onComplete: function ():void
                {
                    fly();
                }
            });
        }

        override public function fly():void
        {
            var hero:Hero = EntityLayerManager.getInstance().myHero as Hero;
            if (hero && hero.parent)
            {
				if(toLct!=null)
				{
					duration-=0.02;
					TweenMax.killTweensOf(target);
				}
                toLct = hero.parent.localToGlobal(new Point(hero.x - 20, hero.y - 50));
                TweenMax.to(target, duration,{
                    x: toLct.x,
                    y: toLct.y,
                    scaleX: 0.4,
                    scaleY: 0.4,
					onUpdate:fly,
                    onComplete: onComplete
                });
            } else
            {
                if (target && layer.contains(target))
                {
					TweenMax.killTweensOf(target);
                    layer.removeChild(target);
                    target = null;
					var myHero:IHero = EntityLayerManager.getInstance().myHero;
					if(myHero!=null)
					{
						var randomIndex:int= Math.random()*StringConst.HERO_SAY_0003.length;
						myHero.say(StringConst.HERO_SAY_0003[randomIndex]);
					}
                }
            }
        }

        public function urlBitmapDataProgress(url:String, progress:Number, info:Object):void
        {
        }

        public function urlBitmapDataError(url:String, info:Object):void
        {
        }
    }
}