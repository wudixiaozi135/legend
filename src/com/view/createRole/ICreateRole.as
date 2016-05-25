package com.view.createRole
{
	import com.view.newMir.INewMir;

	public interface ICreateRole
	{
		function resize(newWidth:int, newHeight:int):void;
		function refreshData():void;
		function dealName():void;
		function set newMir(value:INewMir):void;
		function destroy():void;
	}
}