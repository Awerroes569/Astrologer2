import Toybox.Application;
import Toybox.Graphics;
import Toybox.Lang;
import Toybox.System;
import Toybox.WatchUi;
import Toybox.Math;
import Toybox.SensorHistory;
import Toybox.Time.Gregorian;
import Toybox.Activity;

class MBView extends WatchUi.WatchFace {

    var  center, dcR, zodiacs, version; 

    var GRAY=0xaaaaaa;
    
    var VIRALS=[18.3, //O
    			48.3, //1
    			77.9 , //2
    			107.5, //3
    			137.9, //4
    			168.7, //5
    			200.2, //6
    			230.8, //7
    			261.4, //8
    			291.0, //9
    			320.6, //10
    			350.2 //11
    			];
    var ALIAS_VERSION=320;
    var MAIN_GRAPHIC=240;
    var END_TRIAL_MOMENT= Gregorian.moment({
		:year => 2025,
		:month => 1,
		:day => 1,
		:hour =>0,
		:minute => 0,
		:second => 0
		});


    function initialize() {
        WatchFace.initialize(); 
        zodiacs=[Rez.Drawables.flag1,Rez.Drawables.flag2,Rez.Drawables.flag3,Rez.Drawables.flag4]; 
        version=System.getDeviceSettings().monkeyVersion;
        version=version[0]*100+version[1]*10+version[2];
    }

    // Load your resources here
    function onLayout(dc as Dc) as Void {
        setLayout(Rez.Layouts.WatchFace(dc));
        center = [dc.getWidth()/2, dc.getHeight()/2];   
        dcR = dc;
        dcR.clear();
        dcR.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_WHITE);
         if (version>=ALIAS_VERSION)
        {
            dcR.setAntiAlias(true);
        }
    }

    // Called when this View is brought to the foreground. Restore
    // the state of this View and prepare it to be shown. This includes
    // loading resources into memory.
    function onShow() as Void {
    }

    // Update the view
    function onUpdate(dc as Dc) as Void {
        dcR.setColor(Graphics.COLOR_BLACK, Graphics.COLOR_WHITE);
        dcR.clear();
        if (isTrialValid())
        {
            drawBackground();
        }
        else
        {
            dcR.setColor(Graphics.COLOR_BLACK, Graphics.COLOR_TRANSPARENT);
            dcR.drawText(dcR.getWidth()/2, dcR.getHeight()/2.5, Graphics.FONT_LARGE, "Trial expired",Graphics.TEXT_JUSTIFY_CENTER);
        }
        dcR.setColor(Graphics.COLOR_BLACK, Graphics.COLOR_TRANSPARENT);
    }

    // Called when this View is removed from the screen. Save the
    // state of this View here. This includes freeing resources from
    // memory.
    function onHide() as Void {
    }

    // The user has just looked at their watch. Timers and animations may be started here.
    function onExitSleep() as Void {
    }

    // Terminate any active timers and prepare for slow updates.
    function onEnterSleep() as Void {
    }
    
    function drawBackground(){
        var today = Gregorian.info(Time.now(), Time.FORMAT_SHORT);
        var day = today.day;
        var month=today.month;
        var bigRotation=Pointers.drawPointerHour();
        var smallRotation=Pointers.drawPointerMin();
        var clockTime = System.getClockTime();
        var minutes=clockTime.min;  

        if(minutes>5 and minutes<12)
        {
            creatingPlanet(dcR,center[0],center[1],"Earth",50,20,15);
            creatingPlanet(dcR,center[0],center[1],"Saturn",95,24,22);
        }
        else if(minutes>17 and minutes<24)
        {
            creatingPlanet(dcR,center[0],center[1],"Earth",50,20,15);
            creatingPlanet(dcR,center[0],center[1],"Jupiter",95,24,22);
        }
        else if(minutes>29 and minutes<36)
        {
            creatingPlanet(dcR,center[0],center[1],"Earth",50,21,15);
            creatingPlanet(dcR,center[0],center[1],"Mars",95,19,22);
        }
        else if(minutes>41 and minutes<48)
        {
            creatingPlanet(dcR,center[0],center[1],"Earth2",95,23,15);
            creatingPlanet(dcR,center[0],center[1],"Venus",50,20,22);
        }
        else if(minutes>53)
        {
            creatingPlanet(dcR,center[0],center[1],"Earth2",95,23,15);
            creatingPlanet(dcR,center[0],center[1],"Mercury",50,20,22);
        }
        else 
        {
            if(minutes<31)
            {
                creatingZodiac(dcR,center[0],center[1],day,month,GRAY);
                creatingPlanet(dcR,center[0],center[1],"Earth",50,18,15);
            }
            else 
            {
                creatingEarthMoon(dcR,center[0],center[1],"Earth",75,18,15);
            }
        }

        Pointers.drawPointer2(dcR,center[0],center[1],95,35,bigRotation,23,4);
        Pointers.drawPointer2(dcR,center[0],center[1],115,35,smallRotation,15,4);

        creatingSunSymbol(dcR, center[0], center[1], 4);

        dcR.setPenWidth(1);
        }
      

    function creatingSpiral(dcContext,shortRadius,longRadius,angles,pen)
    {
            var spirals=angles;

            var axisX=dcContext.getWidth()/2;
            var axisY=dcContext.getHeight()/2;

            var radiuses=checkRadiuses(dcContext,shortRadius,longRadius);

            var short=radiuses[0].toNumber();
            var long=radiuses[1].toNumber();

            dcContext.setColor(Graphics.COLOR_BLACK, Graphics.COLOR_TRANSPARENT);
            dcContext.setPenWidth(pen);
            dcContext.drawCircle(axisX, axisY, short);
            dcContext.drawCircle(axisX, axisY, long);

            for(var i=0;i<spirals.size();i++)
            {
                var degree=1.0f*180-spirals[i];
                var closer=createPointFromAngle(axisX,axisY,short+pen/2,degree);
                var further=createPointFromAngle(axisX,axisY,long-pen/2,degree);
                dcContext.drawLine(closer[0],closer[1],further[0],further[1]);
            }


    }

    function checkRadiuses(dcContext,shortRadius,longRadius)
    {
        var short=shortRadius<longRadius?shortRadius:longRadius;
        var long=shortRadius>=longRadius?shortRadius:longRadius;
        var result=[short,long];
        
        short=verifyRadius(dcContext,short);
        long=verifyRadius(dcContext,long);

        return [short,long];

    }
    
    function verifyRadius(dcContext,radius)
    {
        var width=dcContext.getWidth();
        var height=dcContext.getHeight();
        var maxRadius=(width>height?height:width)/2;
        
        if (radius>maxRadius)
        {
            return maxRadius;
        }

        if(radius<0)
        {
            return 0;
        }

        return radius;
    }
    
    function creatingCorona(dcContext,axisX,axisY,longLenght,shortLenght,base)
    {
    	var baseAngle=0;
        
    	for(var i=0;i<4;i++)
    	{
    		var top=createPointFromAngle(axisX,axisY,longLenght,baseAngle);
        	var left=createPointFromAngle(axisX,axisY,shortLenght,baseAngle+base);
        	var right=createPointFromAngle(axisX,axisY,shortLenght,baseAngle-base);
        	var points=[top,left,right];

        	dcContext.fillPolygon(points);

            var pointsToLeft=[
                    [top[0]-2*(top[0]-axisX),top[1]],
                    [left[0]-2*(left[0]-axisX),left[1]],
                    [right[0]-2*(right[0]-axisX),right[1]]
                    ];

            dcContext.fillPolygon(pointsToLeft);

            var pointsToCross=[
                    [top[0]-2*(top[0]-axisX),top[1]-2*(top[1]-axisY)],
                    [left[0]-2*(left[0]-axisX),left[1]-2*(left[1]-axisY)],
                    [right[0]-2*(right[0]-axisX),right[1]-2*(right[1]-axisY)]
                    ];

            dcContext.fillPolygon(pointsToCross);

            var pointsToTop=[
                    [top[0],top[1]-2*(top[1]-axisY)],
                    [left[0],left[1]-2*(left[1]-axisY)],
                    [right[0],right[1]-2*(right[1]-axisY)]
                    ];

            dcContext.fillPolygon(pointsToTop);
        	
        	baseAngle+=30;
        	
        	
    	}
    }

    function creatingZodiac(dcContext,axisX,axisY,day,month,pointingColor)
    {
        // 1 POINT CURRENT SIGN
        var sign=Zodiac.whichSign(day, month);
        dcContext.setColor(pointingColor,Graphics.COLOR_TRANSPARENT);
        var signSpan=Zodiac.ARCS.get(sign);

        dcContext.setPenWidth(50);
        var span=6;
        dcContext.drawArc(axisX,axisY,95,Graphics.ARC_COUNTER_CLOCKWISE,signSpan[0],signSpan[1]);
        dcContext.setPenWidth(1);

        //2 ZODIAC GRAPHIC
        drawZodiacGraphic(dcContext,zodiacs,center);
        //toDisplay=null;
        dcContext.setColor(Graphics.COLOR_BLACK, Graphics.COLOR_TRANSPARENT);
        
        //dcContext.drawBitmap(20, 20, WatchUi.loadResource(Rez.Drawables.flag));

        //dcContext.setColor(Graphics.COLOR_BLACK, Graphics.COLOR_TRANSPARENT);

        //3 SPIRAL FOR ZODIACS
        creatingSpiral(dcContext,70,120,VIRALS,2);
 	
    }

    function drawZodiacGraphic(dcContext,graphics,resolution)
    {
        var bigCorrection=[resolution[0]-120,resolution[1]-120];
        var corrections=[[120,0],[120,120],[0,120],[0,0]];
        
        for(var i=0;i<graphics.size();i++)
        {
            var toLoad=WatchUi.loadResource(graphics[i]);
            dcContext.drawBitmap(bigCorrection[0]+corrections[i][0], bigCorrection[1]+corrections[i][1], toLoad);
            toLoad=null;
        }
        
    }

    function creatingPlanet(dcContext,axisX,axisY,planet,lenght,radius,graphicSize)
    {
        var positionPlanet=Planets.xyPlanet(axisX,axisY,Planets.currentPosition(planet)-90,lenght);

        dcContext.setPenWidth(1);
        dcContext.setColor(Graphics.COLOR_BLACK, Graphics.COLOR_TRANSPARENT);

        var thisPlanet=Planets.planets.get(planet);
        var arch=thisPlanet.get("arch");
        var title=thisPlanet.get("title");
        var where=thisPlanet.get("whereTitle");

        if(positionPlanet[1]>axisY.toFloat()) 
        {            
            dcContext.drawArc(axisX,axisY,lenght,Graphics.ARC_CLOCKWISE,arch,180-arch);
            var toDisplay=WatchUi.loadResource(title[0]);
            dcR.drawBitmap(axisX+where[0][0],axisY+ where[0][1], toDisplay);
            toDisplay=null;
        }
        else 
        {
            dcContext.drawArc(axisX,axisY,lenght,Graphics.ARC_COUNTER_CLOCKWISE,360-arch,180+arch);
            var toDisplay=WatchUi.loadResource(title[1]);
            dcR.drawBitmap(axisX+where[1][0],axisY+ where[1][1], toDisplay);
            toDisplay=null;
        }

        title=null;
        where=null;

        // PLANET

        dcR.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_TRANSPARENT);
        dcR.fillCircle(positionPlanet[0], positionPlanet[1], radius);

        dcR.setColor(Graphics.COLOR_BLACK, Graphics.COLOR_TRANSPARENT);
        dcR.fillCircle(positionPlanet[0], positionPlanet[1], radius-2);  
        
        dcR.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_TRANSPARENT);
        dcR.fillCircle(positionPlanet[0], positionPlanet[1], radius-4);

        var shift=graphicSize/2;

        if (planet.equals("Earth"))
        {
            creatingEarthSymbol(dcR,positionPlanet[0],positionPlanet[1],10,2);
        }
        else if (planet.equals("Earth2"))
        {
            creatingEarthSymbol(dcR,positionPlanet[0],positionPlanet[1],10,2);
        }
        else if (planet.equals("Mars"))
        {
            creatingMarsSymbol(dcR,positionPlanet[0],positionPlanet[1],4);
        }
        else if (planet.equals("Venus"))
        {
            creatingVenusSymbol(dcR,positionPlanet[0],positionPlanet[1],4);
        }
        else if (planet.equals("Mercury"))
        {
            creatingMercurySymbol(dcR,positionPlanet[0],positionPlanet[1],4);
        }
        else if (planet.equals("Saturn"))
        {
            creatingSaturnSymbol(dcR,positionPlanet[0],positionPlanet[1],4);
        }
        else if (planet.equals("Jupiter"))
        {
            creatingJupiterSymbol(dcR,positionPlanet[0],positionPlanet[1],4);
        } 	
    }

function creatingEarthMoon(dcContext,axisX,axisY,planet,lenght,radius,graphicSize)
    {
        var positionPlanet=Planets.xyPlanet(axisX,axisY,Planets.currentPosition(planet)-90,lenght);
        var positionMoonPhase=Planets.xyPlanet(axisX,axisY,Planets.currentPosition(planet)-90+180,lenght);

        dcContext.setPenWidth(1);
        dcContext.setColor(Graphics.COLOR_BLACK, Graphics.COLOR_TRANSPARENT);

        var thisPlanet=Planets.planets.get(planet);
        var arch=90;

        if(positionPlanet[1]>axisY)
        {
            dcContext.drawArc(axisX,axisY,lenght,Graphics.ARC_CLOCKWISE,arch,180-arch);
        }
        else 
        {
            dcContext.drawArc(axisX,axisY,lenght,Graphics.ARC_COUNTER_CLOCKWISE,360-arch,180+arch);
        } 

        dcR.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_TRANSPARENT);
        dcR.fillCircle(positionPlanet[0],positionPlanet[1],31);
        dcR.setColor(Graphics.COLOR_BLACK, Graphics.COLOR_TRANSPARENT);
        dcR.fillCircle(positionPlanet[0],positionPlanet[1],30);
        dcR.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_TRANSPARENT);
        dcR.fillCircle(positionPlanet[0],positionPlanet[1],29);
        
        dcR.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_TRANSPARENT);
        dcR.fillCircle(positionPlanet[0], positionPlanet[1], radius);

        dcR.setColor(Graphics.COLOR_BLACK, Graphics.COLOR_TRANSPARENT);
        dcR.fillCircle(positionPlanet[0], positionPlanet[1], radius-2);  
        
        dcR.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_TRANSPARENT);
        dcR.fillCircle(positionPlanet[0], positionPlanet[1], radius-4);

        var shift=graphicSize/2;

        creatingEarthSymbol(dcR,positionPlanet[0],positionPlanet[1],10,2);

        var momentFM=Moon.findLastFullMoon(Moon.FULLS);
        var initialPosition=Planets.currentPositionForMoment("Earth",momentFM);
        var currentPosition=Planets.currentPosition(planet)+Moon.whereMoon(Moon.FULLS);

        var moonPosition=Planets.xyPlanet(positionPlanet[0],positionPlanet[1],currentPosition-90,30);

        dcR.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_TRANSPARENT);
        dcR.fillCircle(moonPosition[0], moonPosition[1],12);
        dcR.setColor(Graphics.COLOR_BLACK, Graphics.COLOR_TRANSPARENT);
        dcR.fillCircle(moonPosition[0], moonPosition[1],11);
        dcR.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_TRANSPARENT);
        dcR.fillCircle(moonPosition[0], moonPosition[1],9);

        creatingMoonSymbol(dcR,moonPosition[0], moonPosition[1],1);

        dcR.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_TRANSPARENT);
        dcR.fillCircle(positionMoonPhase[0],positionMoonPhase[1],31);
        dcR.setColor(Graphics.COLOR_BLACK, Graphics.COLOR_TRANSPARENT);
        dcR.fillCircle(positionMoonPhase[0],positionMoonPhase[1],30);
        dcR.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_TRANSPARENT);
        dcR.fillCircle(positionMoonPhase[0],positionMoonPhase[1],28);

        Moon.drawMoon(dcR,positionMoonPhase[0],positionMoonPhase[1],30,Moon.whereMoon(Moon.FULLS));	
    }

    function creatingEarthSymbol(dcContext,axisX,axisY,higher,lower)
    {
        dcContext.setColor(Graphics.COLOR_BLACK, Graphics.COLOR_TRANSPARENT);

        dcContext.fillRectangle(axisX-lower,axisY-higher,2*lower,2*higher);
        dcContext.fillRectangle(axisX-higher,axisY-lower,2*higher,2*lower);
        dcContext.setPenWidth(lower*2);
        dcContext.drawCircle(axisX,axisY,higher);
        dcContext.setPenWidth(1);
    }

    function creatingMarsSymbol(dcContext,axisX,axisY,pen)
    {
        dcContext.setColor(Graphics.COLOR_BLACK, Graphics.COLOR_TRANSPARENT);

        dcR.setPenWidth(pen); 
        var middleX=axisX-3;
        var middleY=axisY+3;
        dcR.drawCircle(middleX, middleY, 7);
        dcR.drawLine(middleX+5,middleY-5,middleX+5+5,middleY-5-5);
        var first=[middleX+5+8,middleY-5-8];
        var second=[middleX+4+5-4,middleY-4-5-4];
        var third=[middleX+4+5+4,middleY-4-5+4];
        dcR.fillPolygon([first,second,third]);
        dcContext.setPenWidth(1);
    }

    function creatingVenusSymbol(dcContext,axisX,axisY,pen)
    {
        dcContext.setColor(Graphics.COLOR_BLACK, Graphics.COLOR_TRANSPARENT);

        dcR.setPenWidth(pen);
        var middleX=axisX;
        var middleY=axisY-5;
        dcR.drawCircle(middleX, middleY, 7);
        dcContext.fillRectangle(middleX-pen/2,middleY+7,pen,11);
        dcContext.fillRectangle(middleX-6,middleY+5+7-pen/2,12,pen);

        dcContext.setPenWidth(1);
    }

    function creatingMercurySymbol(dcContext,axisX,axisY,pen)
    {
        dcContext.setColor(Graphics.COLOR_BLACK, Graphics.COLOR_TRANSPARENT);

        dcR.setPenWidth(pen); 
        var middleX=axisX;
        var middleY=axisY-3;
        dcR.drawCircle(middleX, middleY, 7);
        dcContext.fillRectangle(middleX-pen/2,middleY+7,pen,11);
        dcContext.fillRectangle(middleX-6,middleY+5+7-pen/2,12,pen);

        var topLeftLower=[middleX-5,middleY-5];
        var topLeftHigher=[middleX-5-3,middleY-5-3];
        dcContext.drawLine(topLeftLower[0],topLeftLower[1],topLeftHigher[0],topLeftHigher[1]);

        var topRightLower=[middleX+5,middleY-5];
        var topRightHigher=[middleX+5+3,middleY-5-3];
        dcContext.drawLine(topRightLower[0],topRightLower[1],topRightHigher[0],topRightHigher[1]);

        dcContext.setPenWidth(1);
    }

    function creatingSaturnSymbol(dcContext,axisX,axisY,pen)
    {
        dcContext.setColor(Graphics.COLOR_BLACK, Graphics.COLOR_TRANSPARENT);

        dcR.setPenWidth(pen);  
        var middleX=axisX-5;
        var middleY=axisY-13;
        dcR.fillRectangle(middleX-pen/2,middleY,pen,23);
        dcR.fillRectangle(middleX-6,middleY,12,pen);
        dcR.drawArc(middleX+5,middleY+12,5,Graphics.ARC_CLOCKWISE,180,315);
        dcR.drawArc(middleX+5+7,middleY+12+6,4,Graphics.ARC_COUNTER_CLOCKWISE,135,360);

        dcContext.setPenWidth(1);
    }

    function creatingJupiterSymbol(dcContext,axisX,axisY,pen)
    {
        dcContext.setColor(Graphics.COLOR_BLACK, Graphics.COLOR_TRANSPARENT);

        dcR.setPenWidth(pen);
        var middleX=axisX-5;
        var middleY=axisY-5;
        dcR.drawArc(middleX,middleY,5,Graphics.ARC_CLOCKWISE,180,315);
        dcR.drawLine(middleX+4,middleY+4,middleX+4-8,middleY+4+8);
        dcR.fillRectangle(middleX+4-8-2,middleY+4+8,23,4);
        dcR.fillRectangle(middleX+9,middleY-5,4,24);

        dcContext.setPenWidth(1);
    }

    function creatingMoonSymbol(dcContext,axisX,axisY,pen)
    {
        dcContext.setColor(Graphics.COLOR_BLACK, Graphics.COLOR_TRANSPARENT);

        dcR.setPenWidth(pen);  
        var middleX=axisX+3;
        var middleY=axisY;
        dcR.drawArc(middleX,middleY,5,Graphics.ARC_CLOCKWISE,300,60);
        dcR.drawArc(middleX-3,middleY,7,Graphics.ARC_CLOCKWISE,320,40);

        dcContext.setPenWidth(1);
    }

    function creatingSunSymbol(dcContext,axisX,axisY,pen)
    {
        dcContext.setColor(Graphics.COLOR_BLACK, Graphics.COLOR_TRANSPARENT);

        dcContext.setPenWidth(pen);  
        var middleX=axisX;
        var middleY=axisY;

        dcContext.setColor(Graphics.COLOR_BLACK, Graphics.COLOR_TRANSPARENT);
        creatingCorona(dcContext,middleX,middleY,30,17,14);
        
        dcContext.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_TRANSPARENT);        
        dcContext.fillCircle(middleX, middleY,20);
        
        dcContext.setColor(Graphics.COLOR_BLACK, Graphics.COLOR_TRANSPARENT);        
        dcContext.fillCircle(middleX, middleY, 18);
        
        dcContext.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_TRANSPARENT);        
        dcContext.fillCircle(middleX, middleY,14);
        
        dcContext.setColor(Graphics.COLOR_BLACK, Graphics.COLOR_TRANSPARENT);      
        dcContext.fillCircle(middleX, middleY, 5);

        dcContext.setPenWidth(1);
    }
    
    function createPointFromAngle(axisX,axisY,lenght,rotation)
	{
		var newX=(axisX+lenght*Math.cos(Math.toRadians(rotation))).toNumber();
        var newY=(axisY+lenght*Math.sin(Math.toRadians(rotation))).toNumber();
        
        return [newY,newX];
	}

    function isTrialValid()
    {
        var now=Moon.creatingNow();
        if (now.value()-END_TRIAL_MOMENT.value()>0)
        {
            return false;
        }
        else
        {
            return true;
        }
    }
		
}
