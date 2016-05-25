package com.view.gameWindow.mainUi.subuis.common
{
    import com.model.business.fileService.constants.ResourcePathConstants;
    import com.model.gameWindow.rsr.RsrLoader;
    
    import flash.display.MovieClip;
    import flash.display.Sprite;

    /**
     * Created by Administrator on 2014/12/27.
     */
    public class CheckItemBase extends Sprite
    {
        private var _id:String;
        private var _label:String;
        private var _checked:Boolean;
		
		private var _selectedFun:Function;
		private var _cancleSelectedFun:Function;
		
		protected var _skin:MovieClip;

        public function CheckItemBase()
        {
            super();
        }

        public function initView():void
        {
            var rsrLoader:RsrLoader = new RsrLoader();
            addCallBack(rsrLoader);
            rsrLoader.load(_skin, url);
        }

        protected function get url():String
        {
            return ResourcePathConstants.IMAGE_PANEL_FOLDER_LOAD;
        }

        protected function addCallBack(rsrLoader:RsrLoader):void
        {
			
        }

        public function get skin():MovieClip
        {
            return _skin;
        }

        public function destroy():void
        {

        }

        public function get label():String
        {
            return _label;
        }

        public function set label(value:String):void
        {
            _label = value;
        }

        public function get checked():Boolean
        {
            return _checked;
        }

        public function set checked(value:Boolean):void
        {
            _checked = value;
        }

        public function get id():String
        {
            return _id;
        }

        public function set id(value:String):void
        {
            _id = value;
        }
			
		public function get cancleSelectedFun():Function
		{
			return _cancleSelectedFun;
		}
		
		public function set cancleSelectedFun(value:Function):void
		{
			_cancleSelectedFun = value;
		}
		
		public function get selectedFun():Function
		{
			return _selectedFun;
		}
		
		public function set selectedFun(value:Function):void
		{
			_selectedFun = value;
		}
    }
}
