package com.view.gameWindow.mainUi.subuis.musicSet
{
    import com.model.consts.StringConst;
    import com.view.gameWindow.mainUi.subuis.common.CheckItemBase;
    import com.view.gameWindow.mainUi.subuis.common.MenuCheck;
    import com.view.gameWindow.mainUi.subuis.musicSet.item.MusicVolumeItem;
    import com.view.newMir.sound.SoundManager;

    import flash.events.MouseEvent;
    import flash.text.TextField;

    /**
     * Created by Administrator on 2014/12/27.
     */
    public class MusicMenuCheck extends MenuCheck
    {
        private var _data:Array;
        private var _bgVolume:MusicVolumeItem;
        private var _effectVolume:MusicVolumeItem;

        public function MusicMenuCheck()
        {
            super();
        }

        override protected function initChildren():void
        {
            var volumeBg:TextField = new TextField();
            volumeBg.autoSize = "left";
            volumeBg.textColor = 0xffcc00;
            volumeBg.text = StringConst.MUSIC_SETTING_5;
            volumeBg.mouseEnabled = false;
            volumeBg.x = 0;
            volumeBg.y = 0;
            _container.addChild(volumeBg);

            _bgVolume = new MusicVolumeItem(3, 5, 25, 1);
            _container.addChild(_bgVolume);
            _bgVolume.setVolume(SoundManager.getInstance().bgSoundVolume);
            _bgVolume.changeVolumeHandler = changeVolumeBgHandler;
            _bgVolume.x = volumeBg.width + 5;
            _bgVolume.y = 0;

            var volumeEffect:TextField = new TextField();
            volumeEffect.autoSize = "left";
            volumeEffect.textColor = 0xffcc00;
            volumeEffect.text = StringConst.MUSIC_SETTING_6;
            volumeEffect.mouseEnabled = false;
            _container.addChild(volumeEffect);
            volumeEffect.x = _bgVolume.x + _bgVolume.width + 10;
            volumeEffect.y = (_bgVolume.height - volumeEffect.height) >> 2;

            _effectVolume = new MusicVolumeItem(3, 5, 25, 1);
            _container.addChild(_effectVolume);
            _effectVolume.setVolume(SoundManager.getInstance().effectSoundVolume);
            _effectVolume.changeVolumeHandler = changeVolumeEffectHandler;
            _effectVolume.x = volumeEffect.x + volumeEffect.width + 5;
        }

        override protected function addEvent():void
        {
            addEventListener(MouseEvent.ROLL_OUT, onRollHandler, false, 0, true);
        }

        private function changeVolumeBgHandler(volume:int):void
        {
            if (_bgVolume)
            {
                SoundManager.getInstance().bgSoundVolume = volume;
                _bgVolume.setVolume(volume);
            }
        }

        private function changeVolumeEffectHandler(volume:int):void
        {
            if (_effectVolume)
            {
                SoundManager.getInstance().effectSoundVolume = volume;
                _effectVolume.setVolume(volume);
            }
        }

        private function onRollHandler(event:MouseEvent):void
        {
            visible = false;
        }

        override public function set data(value:Array):void
        {
            _data = value;
            if (_data)
            {
                for (var i:int = 0, len:int = _data.length; i < len; i++)
                {
                    var item:CheckItemBase = _data[i];
                    dic[item.id] = item;
                    if (!_container.contains(item))
                        _container.addChild(item);
                }
                resetLayout();
            }
        }

        override public function get data():Array
        {
            return _data;
        }

        override protected function resetLayout():void
        {
            for (var i:int = 0, len:int = _data.length; i < len; i++)
            {
                var child:CheckItemBase = _data[i] as CheckItemBase;
                child.x = 0;
                child.y = (child.height + 1) * i + _bgVolume.height;
            }
            resetWH(_container.width, _container.height);
        }

        override public function destroy():void
        {
            super.destroy();
        }
    }
}
