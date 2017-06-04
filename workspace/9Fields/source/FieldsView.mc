using Toybox.WatchUi as Ui;
using Toybox.Graphics as Gfx;
using Toybox.System as Sys;

class FieldsView extends Ui.DataField {

    hidden var Infos; 
    
    hidden var X0 = 36;	
    hidden var X1 = 104;	
    hidden var X2 = 172;	
    hidden var Y0 = 26;
    hidden var Y1 = 75;
    hidden var Y2 = 124;   
    
    hidden var mPowerCount;
    hidden var mAccumPowers = new [30];
    
    hidden var power3S; 
    hidden var currentSpeed;
    hidden var distanceTravel;
    hidden var currentElevation;
    hidden var currentCadence;
    hidden var currentHR;
    hidden var elapsedTime;
    hidden var gradient;
    hidden var timeOfDay;

    function initialize() 
    {
    	mPowerCount = 0;
    
        for(var i = 0 ; i < mAccumPowers.size() ; ++i)
        {
        	mAccumPowers[i] = 0;
        }
        
        power3S = 0;
        currentSpeed = 0;
    	distanceTravel = 0;
    	currentElevation = 0;
    	currentCadence = 0;
    	currentHR = 0;
    	gradient = 0;
    	
    	timeOfDay = "";
    	elapsedTime = "";
        
        DataField.initialize();
    }

    // Set your layout here. Anytime the size of obscurity of
    // the draw context is changed this will be called.
    function onLayout(dc) 
    {
        var obscurityFlags = DataField.getObscurityFlags();

        // Top left quadrant so we'll use the top left layout
        if (obscurityFlags == (OBSCURE_TOP | OBSCURE_LEFT)) {
            View.setLayout(Rez.Layouts.TopLeftLayout(dc));

        // Top right quadrant so we'll use the top right layout
        } else if (obscurityFlags == (OBSCURE_TOP | OBSCURE_RIGHT)) {
            View.setLayout(Rez.Layouts.TopRightLayout(dc));

        // Bottom left quadrant so we'll use the bottom left layout
        } else if (obscurityFlags == (OBSCURE_BOTTOM | OBSCURE_LEFT)) {
            View.setLayout(Rez.Layouts.BottomLeftLayout(dc));

        // Bottom right quadrant so we'll use the bottom right layout
        } else if (obscurityFlags == (OBSCURE_BOTTOM | OBSCURE_RIGHT)) {
            View.setLayout(Rez.Layouts.BottomRightLayout(dc));

        // Use the generic, centered layout
        } else {
            View.setLayout(Rez.Layouts.MainLayout(dc));
            var labelView = View.findDrawableById("label");
            labelView.locY = labelView.locY - 16;
            var valueView = View.findDrawableById("value");
            valueView.locY = valueView.locY + 7;
        }

        View.findDrawableById("label").setText("");
        return true;
    }

    // The given info object contains all the current workout
    // information. Calculate a value and save it locally in this method.
    function compute(info) 
    {
        // See Activity.Info in the documentation for available information.
        Infos = info;
        
        power3S = caculateAvgPerNSecondPower(info.currentPower, 3);
        currentSpeed = Infos.currentSpeed * 3.6f;
        distanceTravel = Infos.elapsedDistance;
    	currentElevation = Infos.altitude;
    	currentCadence = Infos.currentCadence;
    	currentHR = Infos.currentHeartRate;
    	//gradient = Infos.cu;
    	
    	timeOfDay = Sys.ClockTime.hour.toString();
    	elapsedTime = "";
	}
	
    // Display the value you computed here. This will be called
    // once a second when the data field is visible.
    function onUpdate(dc) 
    {
               
        // Set the background color
        View.findDrawableById("Background").setColor(getBackgroundColor());

        // Set the foreground color and value
        var foreColor;
        if (getBackgroundColor() == Gfx.COLOR_BLACK) 
        {
            foreColor = Gfx.COLOR_WHITE;
        } 
        else 
        {
            foreColor = Gfx.COLOR_BLACK;
        }
        
        View.onUpdate(dc); 
        
        if(Infos != null)
        {
        	//1
        	dc.setColor(foreColor, getBackgroundColor());
        	dc.drawText(X0, Y0, Gfx.FONT_SYSTEM_LARGE, power3S, Gfx.TEXT_JUSTIFY_CENTER | Gfx.TEXT_JUSTIFY_VCENTER);
        	
        	//2
        	dc.setColor(foreColor, getBackgroundColor());
        	dc.drawText(X1, Y0, Gfx.FONT_NUMBER_HOT, currentSpeed.format("%0.1f"), Gfx.TEXT_JUSTIFY_CENTER | Gfx.TEXT_JUSTIFY_VCENTER);
        	
        	//3
        	dc.setColor(foreColor, getBackgroundColor());
        	dc.drawText(X2, Y0, Gfx.FONT_SYSTEM_LARGE, "999", Gfx.TEXT_JUSTIFY_CENTER | Gfx.TEXT_JUSTIFY_VCENTER);
        	
        	//4
        	dc.setColor(foreColor, getBackgroundColor());
        	dc.drawText(X0, Y1, Gfx.FONT_NUMBER_HOT, "999", Gfx.TEXT_JUSTIFY_CENTER | Gfx.TEXT_JUSTIFY_VCENTER);
        	
        	//5
        	dc.setColor(foreColor, getBackgroundColor());
        	dc.drawText(X1, Y1, Gfx.FONT_NUMBER_HOT, "999", Gfx.TEXT_JUSTIFY_CENTER | Gfx.TEXT_JUSTIFY_VCENTER);
        	
        	//6
        	dc.setColor(foreColor, getBackgroundColor());
        	dc.drawText(X2, Y1, Gfx.FONT_NUMBER_HOT, "999", Gfx.TEXT_JUSTIFY_CENTER | Gfx.TEXT_JUSTIFY_VCENTER);
        	
        	//7
        	dc.setColor(foreColor, getBackgroundColor());
        	dc.drawText(X0, Y2, Gfx.FONT_SYSTEM_LARGE, "999", Gfx.TEXT_JUSTIFY_CENTER | Gfx.TEXT_JUSTIFY_VCENTER);
        	
        	//8
        	dc.setColor(foreColor, getBackgroundColor());
        	dc.drawText(X1, Y2, Gfx.FONT_NUMBER_HOT, "999", Gfx.TEXT_JUSTIFY_CENTER | Gfx.TEXT_JUSTIFY_VCENTER);
        	
        	//9
        	dc.setColor(foreColor, getBackgroundColor());
        	dc.drawText(X2, Y2, Gfx.FONT_SYSTEM_LARGE, timeOfDay, Gfx.TEXT_JUSTIFY_CENTER | Gfx.TEXT_JUSTIFY_VCENTER);
        }
    }
    
    function caculateAvgPerNSecondPower(currentPower, unitSeconds)
    {
    	if(mPowerCount < unitSeconds)
    	{
    		mAccumPowers[mPowerCount] = currentPower;
    		++mPowerCount;
    	}
    	else
    	{
    		for(var i = mPowerCount-1 ; i > 0 ; --i)
    		{
    			mAccumPowers[i-1] = mAccumPowers[i];
    		}
    		
    		mAccumPowers[mPowerCount-1] = currentPower;
    	}
    	
    	var result = 0;
    	for(var i = 0 ; i < unitSeconds ; ++i)
    	{
    		result += (mAccumPowers[i]==null ? 0 : mAccumPowers[i]);
    	}
    	
    	return result / unitSeconds;
    }
    
    function timeConvert(milSeconds)
    {
    	
    }
}
