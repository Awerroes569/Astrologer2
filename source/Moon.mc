import Toybox.Application;
import Toybox.Graphics;
import Toybox.Lang;
import Toybox.System;
import Toybox.WatchUi;
import Toybox.Math;
import Toybox.SensorHistory;
import Toybox.Time.Gregorian;
import Toybox.Time;
import Toybox.Activity;
import Toybox.Math;

module Moon{

var FULLS=[[2022,8,12,1,35],
    [2022,9,10,9,59],
    [2022,10,9,20,54],
    [2022,11,8,11,2],
    [2022,12,8,4,8],
    [2023,1,6,23,7],   //2023
    [2023,2,5,18,28],
    [2023,3,7,12,40],  //3
    [2023,4,6,4,34],
    [2023,5,5,17,34],  
    [2023,6,4,3,41],    //6
    [2023,7,3,11,38],
    [2023,8,1,18,31],
    [2023,8,31,1,35], //9
    [2023,9,29,9,57],
    [2023,10,28,20,24],
    [2023,11,27,9,16],   //12
    [2023,12,27,0,33],
    [2024,1,25,17,54],   //2024
    [2024,2,24,12,30],
    [2024,3,25,7,0],    //3
    [2024,4,23,23,48],
    [2024,5,23,13,53],
    [2024,6,22,1,7],   //6
    [2024,7,21,10,17],
    [2024,8,19,18,25],
    [2024,9,18,2,34],   //9
    [2024,10,17,11,26],
    [2024,11,15,21,28],
    [2024,12,15,9,1],
    [2025,1,13,22,26],    //2025
    [2025,2,12,13,53],
    [2025,3,14,6,54],  //3
    [2025,4,13,0,22],
    [2025,5,12,16,55],
    [2025,6,11,7,43],   //6
    [2025,7,10,20,36],
    [2025,8,9,7,55],
    [2025,9,7,18,8],  //9
    [2025,10,7,3,47],
    [2025,11,5,13,19],
    [2025,12,4,23,14],
    [2026,1,3,10,2],   //2026
    [2026,2,1,22,9],
    [2026,3,3,11,37],   //3
    [2026,4,2,2,11],
    [2026,5,1,17,23],
    [2026,5,31,8,45],
    [2026,6,29,23,56],   //6
    [2026,7,29,14,35],
    [2026,8,28,4,18],
    [2026,9,26,16,49],   //9
    [2026,10,26,4,11],
    [2026,11,24,14,53],
    [2026,12,24,1,28], 
];

function creatingNow()
{
    var now = new Time.Moment(Time.now().value()); // UNIX epoch 631148400
    return now;
}

function readingMoment(moment)
{
    var options = {
    :year   => moment[0],
    :month  => moment[1],
    :day    => moment[2],
    :hour   => moment[3],
    :minute => moment[4]};

    return Gregorian.moment(options);
}

function printingMoment(moment)
{
    var gregory= Gregorian.utcInfo(moment, Time.FORMAT_SHORT);

    System.println(Lang.format("$1$-$2$-$3$-$4$-$5$", [
    gregory.year.format("%04u"),
    gregory.month.format("%02u"),
    gregory.day.format("%02u"),
    gregory.hour.format("%02u"),
    gregory.min.format("%02u")
    ]));
}

function findMoments(moments)
{
    var now=creatingNow().value();

    for(var i=0;i<moments.size()-1;i++)
    {
        var first=readingMoment(moments[i]);
        var second=readingMoment(moments[i+1]);

        var condition1=now-first.value()>0;
        var condition2=now-second.value()<0;
        

        if(condition1 and condition2)
        {
            printingMoment(first);
            return;
        }

    }
}

function findLastFullMoon(moments)
{
     var now=creatingNow().value();
     
     for(var i=0;i<moments.size()-1;i++)
    {
        var first=readingMoment(moments[i]);
        var second=readingMoment(moments[i+1]);

        var condition1=now-first.value()>0;
        var condition2=now-second.value()<0;

        if(condition1&&condition2)
        {
            return first;
        }
    }

    return 0;
}

function whereMoon(moments)
{
    var now=creatingNow().value();

    for(var i=0;i<moments.size()-1;i++)
    {
        var first=readingMoment(moments[i]);
        var second=readingMoment(moments[i+1]);

        var condition1=now-first.value()>0;
        var condition2=now-second.value()<0;

        if(condition1&&condition2)
        {
            var total=second.value()-first.value();
            return 360.0f*(now-first.value())/total;
        }        

    }

    return 0;

}

function getLatitude()
{

    return 0.0f;

}

function cutCircle(radius,height)
{
    if(radius<height)
    {
        return 0.0f;
    }

    var result=Math.sqrt(radius*radius-height*height);

    return result;
}   

function drawMoon(dcContext,axisX,axisY,radius,whereMoon)
{
    dcContext.setColor(Graphics.COLOR_BLACK, Graphics.COLOR_TRANSPARENT);

    var terminator=Math.cos(Math.toRadians(whereMoon));
    
    for(var i=0;i<radius;i++)
    {
        var lenght=cutCircle(radius,i);
        var tLenght=terminator*lenght;

        if(whereMoon>0&&whereMoon<180)
        {
            dcContext.drawLine(axisX+tLenght,axisY+i,axisX+lenght,axisY+i);
            dcContext.drawLine(axisX+tLenght,axisY-i,axisX+lenght,axisY-i);
        }
        else 
        {
            dcContext.drawLine(axisX-tLenght,axisY+i,axisX-lenght,axisY+i);
            dcContext.drawLine(axisX-tLenght,axisY-i,axisX-lenght,axisY-i);
        }
    }
}


}