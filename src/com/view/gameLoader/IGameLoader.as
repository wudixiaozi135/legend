package com.view.gameLoader
{
	public interface IGameLoader
	{
		function get loadIndex():int;
		function showLoading(text:String,visible:Boolean = true):int;
		function setLoadVisible(index:int,visible:Boolean):void;
		function setLoading(index:int,progress:Number):void;
		function hideLoading(index:int):void;
	}
}