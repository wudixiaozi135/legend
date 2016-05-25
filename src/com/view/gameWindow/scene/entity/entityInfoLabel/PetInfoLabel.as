package com.view.gameWindow.scene.entity.entityInfoLabel
{
    import flash.display.Bitmap;
    import flash.display.BitmapData;
    import flash.text.TextField;

    /**
     * Created by Administrator on 2015/3/12.
     */
    public class PetInfoLabel extends LivingUnitInfoLabel
    {
        public function PetInfoLabel()
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
		
		public override function refreshNameTextContent(nameTxt:TextField):void
		{
			if (!_nameTxtBitmap)
			{
				return;
			}
			if (!_nameTxtBitmap.bitmapData)
			{
				return;
				
			}
			if (!_nameTxtBitmap.parent)
			{
				return;
			}
			_nameTxtBitmap.bitmapData.dispose();
			_nameTxtBitmap.bitmapData = new BitmapData(nameTxt.width, nameTxt.height, true, 0x00000000);
			_nameTxtBitmap.bitmapData.draw(nameTxt);
		}
		
    }
}
