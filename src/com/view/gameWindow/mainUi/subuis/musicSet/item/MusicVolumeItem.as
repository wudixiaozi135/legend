package com.view.gameWindow.mainUi.subuis.musicSet.item
{
    import flash.display.Sprite;
    import flash.events.MouseEvent;

    /**
     * Created by Administrator on 2014/12/28.
     */
    public class MusicVolumeItem extends Sprite
    {
        private static const BAR_NUM:int = 5;
        private var _barWidth:int;
        private var _barMinHeight:int;
        private var _barMaxHeight:int;
        private var _fColor:uint;
        private var _bColor:uint;
        private var _hgap:int;

        private var _changeVolumeHandler:Function;
        /*
         * @param barWidth 音效柱宽
         * @param barMinHeight 音效柱最的的高度
         * @param barMaxHeight 音效柱最大的高度
         * @param hgap 音效柱之间的间隔
         * @param fColor前景
         * @param bColor背景
         * */
        public function MusicVolumeItem(barWidth:int, barMinHeight:int, barMaxHeight:int, hgap:int, fColor:uint = 0xb08d2d, bColor:uint = 0x8c8e8c)
        {
            super();
            _barWidth = barWidth;
            _barMinHeight = barMinHeight;
            _barMaxHeight = barMaxHeight;
            _hgap = hgap;
            _fColor = fColor;
            _bColor = bColor;

            addEventListener(MouseEvent.MOUSE_MOVE, onRollHandler, false, 0, true);
        }

        private function onRollHandler(event:MouseEvent):void
        {
            if (_changeVolumeHandler != null)
            {
                var localX:int = event.localX;
                var pos:int = int(localX / int(width / 5));
                var volumeSize:int = pos * 20;
                _changeVolumeHandler(volumeSize);
            }
        }

        /*
         * @param volume 0-100
         * 音量大小
         * */
        public function setVolume(volume:int):void
        {
            var scale:int = int((volume * 5) / 100);
            var offX:int, offY:int;
            var offW:int, offH:int;
            offW = _barWidth;

            var halfY:int = _barMaxHeight * .5;
            var increaseHeight:int = (_barMaxHeight - _barMinHeight) / 5;

            this.graphics.clear();
            for (var i:int = 0; i < BAR_NUM; i++)
            {
                if (i < scale)
                {
                    this.graphics.beginFill(_fColor);
                } else
                {
                    this.graphics.beginFill(_bColor);
                }
                offX = i * (offW + _hgap);
                offY = halfY - i * increaseHeight;
                offH = increaseHeight * (i + 1);
                this.graphics.drawRect(offX, offY, offW, offH);
            }
        }

        public function get changeVolumeHandler():Function
        {
            return _changeVolumeHandler;
        }

        public function set changeVolumeHandler(value:Function):void
        {
            _changeVolumeHandler = value;
        }
    }
}