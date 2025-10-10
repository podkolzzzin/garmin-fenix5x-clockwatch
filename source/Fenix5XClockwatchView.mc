import Toybox.Graphics;
import Toybox.Lang;
import Toybox.System;
import Toybox.WatchUi;
import Toybox.Time;
import Toybox.Time.Gregorian;
import Toybox.ActivityMonitor;
import Toybox.Activity;
import Toybox.Application;

class Fenix5XClockwatchView extends WatchUi.WatchFace {
    
    // Secondary timezone offset in hours from local time (can be changed by user)
    private var secondaryTimezoneOffset = -5; // Example: EST when local is UTC+3

    function initialize() {
        WatchFace.initialize();
    }

    // Helper function to get local timezone name from settings
    private function getLocalTimezoneName() as String {
        var localName = Application.Properties.getValue("LocalTimezoneName");
        return localName != null ? localName : "LOCAL";
    }

    // Helper function to get secondary timezone name from settings
    private function getSecondaryTimezoneName() as String {
        var secondaryName = Application.Properties.getValue("SecondaryTimezoneName");
        return secondaryName != null ? secondaryName : "EST";
    }

    // Load your resources here
    function onLayout(dc as Dc) as Void {
        // No layout needed - using manual drawing
    }

    // Called when this View is brought to the foreground. Restore
    // the state of this View and prepare it to be shown. This includes
    // loading resources into memory.
    function onShow() as Void {
    }

    // Update the view
    function onUpdate(dc as Dc) as Void {
        // Clear the screen
        dc.setColor(Graphics.COLOR_BLACK, Graphics.COLOR_BLACK);
        dc.clear();

        // Get current time for primary timezone (local)
        var clockTime = System.getClockTime();
        var primaryHours = clockTime.hour;
        var primaryMinutes = clockTime.min;
        
        // Calculate secondary timezone
        var secondaryTime = Time.now();
        var offsetSeconds = secondaryTimezoneOffset * 3600; // Convert hours to seconds
        var secondaryMoment = new Time.Moment(secondaryTime.value() + offsetSeconds);
        var secondaryClockTime = Gregorian.info(secondaryMoment, Time.FORMAT_SHORT);
        var secondaryHours = secondaryClockTime.hour;
        var secondaryMinutes = secondaryClockTime.min;

        // Format primary time
        var is24Hour = System.getDeviceSettings().is24Hour;
        var primaryTimeString = formatTime(primaryHours, primaryMinutes, is24Hour);
        var secondaryTimeString = formatTime(secondaryHours, secondaryMinutes, is24Hour);
        
        // Get the current date with Ukrainian names
        var today = Gregorian.info(Time.now(), Time.FORMAT_SHORT);
        var ukrainianDayName = getUkrainianDayName(today.day_of_week);
        var dateString = Lang.format("$1$ $2$.$3$", [ukrainianDayName, today.day.format("%02d"), today.month.format("%02d")]);

        // Layout calculations for better organization
        var centerX = dc.getWidth() / 2;
        var centerY = dc.getHeight() / 2;
        var leftX = centerX / 2;
        var rightX = centerX + centerX / 2;

        // Draw primary time (local) on the left side
        dc.setColor(Graphics.COLOR_LT_GRAY, Graphics.COLOR_TRANSPARENT);
        dc.drawText(leftX, centerY - 38, Graphics.FONT_TINY, getLocalTimezoneName(), Graphics.TEXT_JUSTIFY_CENTER);
        dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_TRANSPARENT);
        dc.drawText(leftX, centerY, Graphics.FONT_LARGE, primaryTimeString, Graphics.TEXT_JUSTIFY_CENTER);

        // Draw secondary timezone on the right side
        dc.setColor(Graphics.COLOR_LT_GRAY, Graphics.COLOR_TRANSPARENT);
        dc.drawText(rightX, centerY - 38, Graphics.FONT_TINY, getSecondaryTimezoneName(), Graphics.TEXT_JUSTIFY_CENTER);
        dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_TRANSPARENT);
        dc.drawText(rightX, centerY, Graphics.FONT_LARGE, secondaryTimeString, Graphics.TEXT_JUSTIFY_CENTER);

        // Draw vertical separator between timezones
        dc.setColor(Graphics.COLOR_LT_GRAY, Graphics.COLOR_TRANSPARENT);
        dc.setPenWidth(1);
        dc.drawLine(centerX, centerY - 52, centerX, centerY + 10);

        // Draw Bluetooth status icon centered below the separator
        drawBluetoothStatus(dc, centerX, centerY + 30);

        // Draw the date below timezones
        dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_TRANSPARENT);
        dc.drawText(centerX, 5, Graphics.FONT_SYSTEM_XTINY, dateString, Graphics.TEXT_JUSTIFY_CENTER);

        // Draw chord separator after date
        drawChordSeparator(dc, centerX, 30);

        // Draw steps and heart rate in one line after first separator
        drawStepsAndHeartRate(dc, centerX, 33);

        // Draw second separator after steps and heart rate
        drawChordSeparator(dc, centerX, 60);

        // Draw third separator before bottom elements (for symmetry)
        drawChordSeparator(dc, centerX, centerY + 50);

        // Draw last run and weekly distance in one line after third separator
        drawRunDistanceInfo(dc, centerX, centerY + 53);

        // Draw fourth separator before seconds (for complete symmetry)
        drawChordSeparator(dc, centerX, dc.getHeight() - 35);

        // Draw current seconds at the bottom
        drawSeconds(dc, centerX, dc.getHeight() - 32);

        // Draw additional elements (adjusted positions for round watch)
        drawBattery(dc);
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

    // Helper function to format time based on 12/24 hour preference
    private function formatTime(hours as Number, minutes as Number, is24Hour as Boolean) as String {
        var timeFormat = "$1$:$2$";
        var displayHours = hours;
        
        if (!is24Hour) {
            if (hours > 12) {
                displayHours = hours - 12;
            } else if (hours == 0) {
                displayHours = 12;
            }
        }
        
        return Lang.format(timeFormat, [displayHours.format("%02d"), minutes.format("%02d")]);
    }
    private function drawBattery(dc as Dc) as Void {
        var battery = System.getSystemStats().battery;
        
        // Set color based on battery level
        var batteryColor = Graphics.COLOR_GREEN;
        if (battery < 20) {
            batteryColor = Graphics.COLOR_RED;
        } else if (battery <= 50) {
            batteryColor = Graphics.COLOR_YELLOW;
        }
        
        // Calculate circle parameters for full watch border
        var centerX = dc.getWidth() / 2;
        var centerY = dc.getHeight() / 2;
        var radius = (dc.getWidth() / 2) - 4; // Leave margin from edge (moved 2px closer to center)
        var strokeWidth = 4; // Increased pen width from 2px to 4px
        
        // Draw background circle (dark gray) - full border
        dc.setColor(Graphics.COLOR_DK_GRAY, Graphics.COLOR_TRANSPARENT);
        dc.setPenWidth(strokeWidth);
        dc.drawCircle(centerX, centerY, radius);

        var batteryLevel = battery / 100.0;

        var startRadian = 90 + 180 * batteryLevel; // 180 * 0.2 = 36
        var endRadian = 270 + 180 * (1 - batteryLevel); // 180 + 36 = 216
        
        // Debug trace battery arc values
        System.println("Battery: " + battery + "% | Level: " + batteryLevel + " | Start: " + startRadian + " | End: " + endRadian);
        
        // Check if battery is critically low (10% or less) for blinking effect
        var shouldBlink = battery <= 10;
        var showArc = true;
        
        if (shouldBlink) {
            // Create blinking effect using seconds - blink every second
            var clockTime = System.getClockTime();
            var seconds = clockTime.sec;
            showArc = (seconds % 2) == 0; // Show arc on even seconds, hide on odd seconds
        }
        
        // Draw battery progress arc using built-in drawArc for better quality
        if (battery > 0 && showArc) {
            dc.setColor(batteryColor, Graphics.COLOR_TRANSPARENT);
            dc.setPenWidth(strokeWidth);
            // Use built-in drawArc method with radians directly
            dc.drawArc(centerX, centerY, radius, Graphics.ARC_COUNTER_CLOCKWISE, 90, startRadian);
            dc.drawArc(centerX, centerY, radius, Graphics.ARC_COUNTER_CLOCKWISE, endRadian, 450);
        }
        dc.setPenWidth(1);
    }

    // Helper function to draw chord separator line
    private function drawChordSeparator(dc as Dc, centerX as Number, y as Number) as Void {
        var lineLength = dc.getWidth(); // Full width of the screen
        var startX = 0;
        var endX = lineLength;
        
        dc.setColor(Graphics.COLOR_LT_GRAY, Graphics.COLOR_TRANSPARENT);
        dc.setPenWidth(1);
        dc.drawLine(startX, y, endX, y);
    }

    // Helper function to draw Bluetooth status
    private function drawBluetoothStatus(dc as Dc, centerX as Number, y as Number) as Void {
        var deviceSettings = System.getDeviceSettings();
        var isBluetoothConnected = false;
        
        // Check Bluetooth connection status
        if (deviceSettings has :connectionAvailable && deviceSettings.connectionAvailable != null) {
            isBluetoothConnected = deviceSettings.connectionAvailable;
        }
        
        // Only draw the icon if Bluetooth is connected
        if (isBluetoothConnected) {
            // Draw mathematical Bluetooth icon in blue
            IconRenderer.drawBluetooth(dc, centerX, y, 26, Graphics.COLOR_BLUE);
        }
        // If not connected, don't draw anything
    }

    // Helper function to draw steps and heart rate in one line
    private function drawStepsAndHeartRate(dc as Dc, centerX as Number, y as Number) as Void {
        // Get step count
        var info = ActivityMonitor.getInfo();
        var steps = info.steps != null ? info.steps : 0;
        var stepsString = steps.toString();
        
        // Get heart rate
        var heartRate = 0;
        try {
            var activityInfo = Activity.getActivityInfo();
            if (activityInfo != null && activityInfo.currentHeartRate != null) {
                heartRate = activityInfo.currentHeartRate;
            }
        } catch (e) {
            heartRate = 0;
        }
        var heartRateString = heartRate > 0 ? heartRate.toString() : "--";
        
        // Draw steps with icon on the left side
        IconRenderer.drawSteps(dc, centerX - 68, y + 12, 26, Graphics.COLOR_BLUE);
        dc.setColor(Graphics.COLOR_BLUE, Graphics.COLOR_TRANSPARENT);
        dc.drawText(centerX - 50, y - 5, Graphics.FONT_SMALL, stepsString, Graphics.TEXT_JUSTIFY_LEFT);
        
        // Draw heart rate with icon on the right side
        IconRenderer.drawHeart(dc, centerX + 32, y + 10, 28, Graphics.COLOR_RED);
        dc.setColor(Graphics.COLOR_RED, Graphics.COLOR_TRANSPARENT);
        dc.drawText(centerX + 50, y - 5, Graphics.FONT_SMALL, heartRateString, Graphics.TEXT_JUSTIFY_LEFT);
    }

    // Helper function to draw last run and weekly distance in one line
    private function drawRunDistanceInfo(dc as Dc, centerX as Number, y as Number) as Void {
        // Get weekly distance
        var weeklyDistance = getWeeklyRunDistance();
        var weeklyDistanceString = Lang.format("$1$км", [weeklyDistance.format("%.1f")]);
        
        // Get last run info
        var lastRunInfo = getLastRunInfo();
        
        // Draw weekly distance on the left side with orange color
        dc.setColor(Graphics.COLOR_ORANGE, Graphics.COLOR_TRANSPARENT);
        dc.drawText(centerX - 80, y, Graphics.FONT_TINY, weeklyDistanceString, Graphics.TEXT_JUSTIFY_LEFT);
        
        // Draw last run info on the right side with purple color
        dc.setColor(Graphics.COLOR_PURPLE, Graphics.COLOR_TRANSPARENT);
        dc.drawText(centerX + 80, y, Graphics.FONT_TINY, lastRunInfo, Graphics.TEXT_JUSTIFY_RIGHT);
    }

    // Helper function to draw current seconds at the bottom
    private function drawSeconds(dc as Dc, centerX as Number, y as Number) as Void {
        // Get current seconds
        var clockTime = System.getClockTime();
        var seconds = clockTime.sec;
        var secondsString = seconds.format("%02d");
        
        // Draw seconds in center with light gray color
        dc.setColor(Graphics.COLOR_LT_GRAY, Graphics.COLOR_TRANSPARENT);
        dc.drawText(centerX, y, Graphics.FONT_SYSTEM_XTINY, secondsString, Graphics.TEXT_JUSTIFY_CENTER);
    }

    // Get weekly run distance from activity data
    private function getWeeklyRunDistance() as Float {
        var weeklyDistance = 0.0;
        
        try {
            // Get activity info for fitness tracking
            var info = ActivityMonitor.getInfo();
            if (info != null) {
                // Try to access weekly distance if available
                if (info has :weeklyDistance && info.weeklyDistance != null) {
                    weeklyDistance = info.weeklyDistance / 1000.0; // Convert to km
                } else if (info.distance != null) {
                    // Fallback: Estimate based on daily distance
                    weeklyDistance = (info.distance / 1000.0) * 7.0;
                }
            }
        } catch (e) {
            // Handle any API exceptions gracefully
            weeklyDistance = 0.0;
        }
        
        return weeklyDistance;
    }

    // Helper function to get Ukrainian short day of week names with proper encoding
    private function getUkrainianDayName(dayOfWeek as Number) as String {
        switch (dayOfWeek) {
            case 1:
                return "НД"; // Sunday (Неділя)
            case 2:
                return "ПН"; // Monday (Понеділок)
            case 3:
                return "ВТ"; // Tuesday (Вівторок)
            case 4:
                return "СР"; // Wednesday (Середа)
            case 5:
                return "ЧТ"; // Thursday (Четвер)
            case 6:
                return "ПТ"; // Friday (П'ятниця)
            case 7:
                return "СБ"; // Saturday (Субота)
            default:
                return dayOfWeek.toString(); // Unknown
        }
    }

    // Get last run information
    private function getLastRunInfo() as String {
        // Let's create a simple method that shows what data we're actually getting
        var debugInfo = "";
        
        try {
            // Check ActivityMonitor.getInfo() data
            var info = ActivityMonitor.getInfo();
            if (info != null) {
                // Check distance field
                if (info has :distance && info.distance != null) {
                    var dist = info.distance;
                    debugInfo = Lang.format("D:$1$", [dist.format("%.1f")]);
                }
                
                // Check previousDayDistance field  
                if (info has :previousDayDistance && info.previousDayDistance != null) {
                    var prevDist = info.previousDayDistance;
                    if (debugInfo.length() > 0) {
                        debugInfo = debugInfo + " P:" + prevDist.format("%.1f");
                    } else {
                        debugInfo = Lang.format("P:$1$", [prevDist.format("%.1f")]);
                    }
                }
            }
        } catch (e) {
            debugInfo = "ERR1";
        }
        
        // If we have debug info, show it to help identify the source
        if (debugInfo.length() > 0) {
            return debugInfo;
        }
        
        // Try activity history as last resort
        try {
            var historyArray = ActivityMonitor.getHistory();
            if (historyArray != null && historyArray.size() > 0) {
                var activity = historyArray[0];
                if (activity != null && activity.distance != null) {
                    var histDist = activity.distance;
                    return Lang.format("H:$1$", [histDist.format("%.1f")]);
                }
            }
        } catch (e) {
            return "ERR2";
        }
        
        return "0км";
    }
}