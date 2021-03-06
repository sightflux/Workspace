using Toybox.WatchUi as Ui;
using Toybox.Graphics as Gfx;

class DualDataFieldView extends Ui.DataField {

    function initialize() {
    	mData1 = 0;
    	mData2 = 0;
        
        DataField.initialize();
    }

    hidden var mData1;
    hidden var mData2;
    
    hidden const FIELDNAME = "Power";
    hidden const LABEL1 = "Cur: ";
    hidden const LABEL2 = "Avg: ";
    
    function getTextColor() 
    {
    	return getBackgroundColor() == Gfx.COLOR_BLACK ? Gfx.COLOR_WHITE : Gfx.COLOR_BLACK;
    }

    //! The given info object contains all the current workout
    //! information. Calculate a value and save it locally in this method.
    function compute(info) {
        mData1 = info.currentPower;
        mData2 = info.averagePower;
    }

    //! Display the value you computed here. This will be called
    //! once a second when the data field is visible.
    function onUpdate(dc) 
    {
        // Set the background color
        View.findDrawableById("Background").setColor(getBackgroundColor());
        View.onUpdate(dc);
        
        dc.clear();
        
       	var valueView = View.findDrawableById("value");
        
        var curLabelDim = dc.getTextDimensions(LABEL1, Gfx.FONT_SMALL);
        var curValueDim = dc.getTextDimensions(Lang.format("$1$",[mData1]), Gfx.FONT_NUMBER_MILD);
        
        dc.setColor(getTextColor(), Gfx.COLOR_TRANSPARENT);
        
        dc.drawText(2, 0, Gfx.FONT_XTINY, FIELDNAME, Gfx.TEXT_JUSTIFY_LEFT);
        
        dc.drawText(valueView.locX - curLabelDim[0], valueView.locY + (curValueDim[1] - curLabelDim[1])/2, 
        			Gfx.FONT_SMALL, LABEL1, Gfx.TEXT_JUSTIFY_CENTER);
        dc.drawText(valueView.locX + 4, valueView.locY, 
        			Gfx.FONT_NUMBER_MILD, Lang.format("$1$",[mData1 != null ? mData1 : 0]), Gfx.TEXT_JUSTIFY_CENTER);
        
        dc.drawText(valueView.locX - curLabelDim[0], valueView.locY + (curValueDim[1] - curLabelDim[1])/2 + curLabelDim[1] + 10, 
        			Gfx.FONT_SMALL, LABEL2, Gfx.TEXT_JUSTIFY_CENTER);
        dc.drawText(valueView.locX + 4, valueView.locY + curLabelDim[1] + 10, 
        			Gfx.FONT_NUMBER_MILD, Lang.format("$1$",[mData2 != null ? mData2 : 0]), Gfx.TEXT_JUSTIFY_CENTER);
    }
    
    //! Set your layout here. Anytime the size of obscurity of
    //! the draw context is changed this will be called.
    function onLayout(dc) {
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
            labelView.locY = labelView.locY - 29;
            var valueView = View.findDrawableById("value");
            valueView.locY = valueView.locY - 6;
        }

        //View.findDrawableById("label").setText(Rez.Strings.label);
        return true;
    }
}
