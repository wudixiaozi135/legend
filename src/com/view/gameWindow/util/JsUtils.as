package com.view.gameWindow.util
{
    import com.model.business.fileService.constants.ResourcePathConstants;
    import com.model.business.flashVars.FlashVarsManager;
    import com.model.consts.StringConst;

    import flash.events.Event;
    import flash.external.ExternalInterface;
    import flash.net.FileReference;
    import flash.net.URLRequest;
    import flash.net.navigateToURL;

    /**
     * Created by Administrator on 2015/1/27.
     */
    public class JsUtils
    {
        public function JsUtils()
        {
        }

        public static function callRecharge():void
        {
            var url:String = FlashVarsManager.getInstance().payUrl;
            if (url)
            {
                navigateToURL(new URLRequest(url));
            } else
            {
//                navigateToURL(new URLRequest("http://192.168.1.109/pay.html"));
            }
        }

        public static function gotoForum():void
        {
            var url:String = FlashVarsManager.getInstance().forumUrl;
            if (url)
            {
                navigateToURL(new URLRequest(url));
            } else
            {
//                navigateToURL(new URLRequest("http://192.168.1.109"));
            }
        }


        public static function refreshGameWindow():void
        {
            navigateToURL(new URLRequest("javascript:window.location.reload(false);"), "_self");
        }

        /**获取当前浏览器的名称*/
        public static function getBrowserName():String
        {
            return ExternalInterface.call("function(){ return navigator.appName;}");
        }

        public static function addFavorite():void
        {
            commonAddFavorite();
        }

        /**这个较通用*/
        private static function commonAddFavorite():void
        {
            var file:FileReference = new FileReference();
            var onComplete:Function = function ():void
            {
                if (file)
                {
                    file.removeEventListener(Event.COMPLETE, onComplete);
                    file = null;
                    onComplete = null;
                }
            };

            var favoriteUrl:String = FlashVarsManager.getInstance().favoriteUrl;
            if (!favoriteUrl)
            {
//                favoriteUrl = "http://192.168.1.109";//临时使用
            }
            var data:String = "[InternetShortcut]\r\n" +
                    "URL='" + favoriteUrl + "'\r\n";

//            "IconFile=http://192.168.1.109\r\n"+//好像图标只能是本地的
//            "IconIndex=0";

            file.save(data, StringConst.GAME_NAME + ResourcePathConstants.POSTFIX_URL);
            file.addEventListener(Event.COMPLETE, onComplete, false, 0, true);
            data = null;
        }
    }
}
