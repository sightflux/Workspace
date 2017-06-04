using Toybox.WatchUi as Ui;
using Toybox.Application as App;
using Toybox.Graphics as Gfx;

class Background extends Ui.Drawable {

    hidden var mColor;

    function initialize() {
        var dictionary = {
            :identifier => "Background"
        };

        Drawable.initialize(dictionary);
    }

    function setColor(color) {
        mColor = color;
    }

    function draw(dc) {
        dc.setColor(Gfx.COLOR_BLACK, mColor);
        dc.clear();
        var xMax = 205;
        var yMax = 148;
        var xGap = 68;
        var yGap = 49;
        
        dc.drawLine(xGap, 0, xGap, yMax);
        dc.drawLine(xGap*2, 0, xGap*2, yMax);
        dc.drawLine(0, yGap, xMax, yGap);
        dc.drawLine(0, yGap*2, xMax, yGap*2);
    }

}
