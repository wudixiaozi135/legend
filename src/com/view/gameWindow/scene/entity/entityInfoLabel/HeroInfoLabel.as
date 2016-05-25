package com.view.gameWindow.scene.entity.entityInfoLabel
{
    import com.view.gameWindow.scene.entity.entityInfoLabel.interf.ILivingUnitInfoLabel;
    
    import flash.display.Bitmap;
    import flash.display.BitmapData;
    import flash.text.TextField;

    /**
     * Created by Administrator on 2015/2/14.
     */
    public class HeroInfoLabel extends LivingUnitInfoLabel implements ILivingUnitInfoLabel
    {
        public function HeroInfoLabel()
        {
            super();
        }

        public override function refreshNameTextPos(nameTxt:TextField, modelHeight:int):void
        {
            if (!_nameTxtBitmap)
            {
                _nameTxtBitmap = new Bitmap();
            }
            if (!_nameTxtBitmap.bitmapData)
            {
                _nameTxtBitmap.bitmapData = new BitmapData(nameTxt.width, nameTxt.height, true, 0x00000000);
                _nameTxtBitmap.bitmapData.draw(nameTxt);
            }
            if (!_nameTxtBitmap.parent)
            {
                addChild(_nameTxtBitmap);
            }

            if (_nameTxtBitmap)
            {
                if (_nameTxtBitmap.y != -modelHeight)
                {
                    _nameTxtBitmap.y = -modelHeight;
                }

                var xPos:Number = -_nameTxtBitmap.width / 2;
                if (_nameTxtBitmap.x != xPos)
                {
                    _nameTxtBitmap.x = xPos;
                }
            }
        }
    }
}
