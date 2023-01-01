import Toybox.Time.Gregorian;
import Toybox.Time;
import Toybox.System;
import Toybox.Math;
import Toybox.Graphics;
    
    
import Toybox.System;

module Pointers{  
    
    function drawPointerHour(){
    	var clockTime = System.getClockTime();
        var degree=180-(clockTime.hour+clockTime.min/60d)*30;

        return degree;
    }
    
    function drawPointerMin(){
    	var clockTime = System.getClockTime();
        var degree=180-clockTime.min*6;

        return degree;
    }

    function drawPointer1(dcContext,axisX,axisY,further,closer,rotation,correction,pen)
    {
        var top=createPointFromAngle(axisX,axisY,further,rotation);
        var left=createPointFromAngle(axisX,axisY,closer,rotation+correction);
        var right=createPointFromAngle(axisX,axisY,closer,rotation-correction);

        dcContext.setPenWidth(pen);

        dcContext.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_TRANSPARENT);

        dcContext.drawLine(left[0],left[1],top[0],top[1]);
        dcContext.drawLine(right[0],right[1],top[0],top[1]);
        dcContext.drawLine(right[0],right[1],left[0],left[1]);
        
        dcContext.setPenWidth(pen-2);

        dcContext.setColor(Graphics.COLOR_BLACK, Graphics.COLOR_TRANSPARENT);

        dcContext.drawLine(left[0],left[1],top[0],top[1]);
        dcContext.drawLine(right[0],right[1],top[0],top[1]);
        dcContext.drawLine(right[0],right[1],left[0],left[1]);

        dcContext.setColor(0xaaaaaa, Graphics.COLOR_TRANSPARENT);

        dcContext.fillPolygon([top,left,right]);
    }

    function drawPointer2(dcContext,axisX,axisY,further,closer,rotation,correction,pen)
    {
        var top=createPointFromAngle(axisX,axisY,further,rotation);
        var left=createPointFromAngle(axisX,axisY,closer,rotation+correction);
        var right=createPointFromAngle(axisX,axisY,closer,rotation-correction);

        dcContext.setPenWidth(pen);

        dcContext.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_TRANSPARENT);

        dcContext.drawLine(left[0],left[1],top[0],top[1]);
        dcContext.drawLine(right[0],right[1],top[0],top[1]);
        dcContext.drawLine(right[0],right[1],left[0],left[1]);

        dcContext.setColor(Graphics.COLOR_BLACK, Graphics.COLOR_TRANSPARENT);

        dcContext.fillPolygon([top,left,right]);
    }

    function createPointFromAngle(axisX,axisY,lenght,rotation)
	{
		var newX=(axisX+lenght*Math.cos(Math.toRadians(rotation))).toNumber();
        var newY=(axisY+lenght*Math.sin(Math.toRadians(rotation))).toNumber();
        
        return [newY,newX];
	}
}