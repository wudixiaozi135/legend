package com.view.gameWindow.mainUi.subuis.bottombar.sysAlert.team.iconAlert
{
    import com.model.business.fileService.constants.ResourcePathConstants;
    import com.model.gameWindow.rsr.RsrLoader;
    import com.view.gameWindow.mainUi.subuis.bottombar.iconAlert.McIconNum;

    /**
     * Created by Administrator on 2015/1/27.
     * 带数字的提示
     */
    public class IconAlertBase extends McIconNum
    {
        public function IconAlertBase()
        {
            initSkin();
        }

        private function initSkin():void
        {
			this.mouseEnabled = false;
            this.numBg.mouseEnabled = false;
            this.txtCount.mouseEnabled = false;
            this.txtCount.textColor = 0xffffff;
        }

        /**动态IconUrl,由子类重写*/
        protected function iconUrl():String
        {
            return null;
        }

        public function refreshNum(count:int):void
        {
            if (count > 1)
            {
                this.txtCount.text = count.toString();
                if (!numBg.visible)
                {
                    numBg.visible = true;
                }
                resetPosition();
            } else
            {
                if (numBg.visible)
                {
                    numBg.visible = false;
                }
                this.txtCount.text = "";
            }
        }

        protected function resetPosition():void
        {
            txtCount.x = 21;
        }

        /**
         * 显示
         * 注意路径在panel
         * */
        public function initView():void
        {
//            var rsrLoader:RsrLoader = new RsrLoader();
//            rsrLoader.load(this, ResourcePathConstants.IMAGE_MAINUI_FOLDER_LOAD);
        }

        public function destroy():void
        {
        }
    }
}
