package com.view.gameWindow.flyEffect.subs
{
    import com.model.frame.FrameManager;
    import com.model.frame.IFrame;

    /**
     * Created by Administrator on 2015/1/9.
     */
    public class HeroSkillEffectHandler implements IFrame
    {
        public static var isReady:Boolean;

        private var _effects:Array;

        public function HeroSkillEffectHandler()
        {
            _effects = [];
            isReady = true;
        }

        public function addEffect(effect:FlyEffectHeroSkillNew):void
        {
            if (_effects.length == 0)
            {
                FrameManager.instance.addObj(this);
            }
            _effects.push(effect);
        }

        public function playFlyEffect():void
        {
            var item:FlyEffectHeroSkillNew = _effects.shift();
            item.start();
            isReady = false;
        }

        public function updateTime(time:int):void
        {
            if (_effects.length && isReady)
            {
                playFlyEffect();
            }
            if (_effects.length == 0 && !isReady)
            {
                FrameManager.instance.removeObj(this);
            }
        }

        private static var _instance:HeroSkillEffectHandler = null;
        public static function get instance():HeroSkillEffectHandler
        {
            if (_instance == null)
            {
                _instance = new HeroSkillEffectHandler();
            }
            return _instance;
        }
    }
}
