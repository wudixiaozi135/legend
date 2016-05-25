package com.view.selectRole
{
	import com.view.newMir.INewMir;

	public interface ISelectRole
	{
		function resize(newWidth:int, newHeight:int):void;
		function refreshData():void;
		function set newMir(value:INewMir):void;
		function destroy():void;
	}
}