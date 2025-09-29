import Toybox.Graphics;
import Toybox.Lang;
import Toybox.System;
import Toybox.WatchUi;
import Toybox.Time;
import Toybox.Time.Gregorian;
import Toybox.ActivityMonitor;
import Toybox.UserProfile;
import Toybox.Activity;

class Fenix5XClockwatchView extends WatchUi.WatchFace {
    
    // Secondary timezone offset in hours from local time (can be changed by user)
    private var secondaryTimezoneOffset = -5; // Example: EST when local is UTC+3

    function initialize() {
        WatchFace.initialize();
    }

    // Load your resources here
    function onLayout(dc as Dc) as Void {
        setLayout(Rez.Layouts.WatchFace(dc));
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
        var secondaryMoment = new Time.Moment(secondaryTime.value() + (secondaryTimezoneOffset * 3600));
        var secondaryClockTime = Gregorian.info(secondaryMoment, Time.FORMAT_SHORT);
        var secondaryHours = secondaryClockTime.hour;
        var secondaryMinutes = secondaryClockTime.min;

        // Format primary time
        var is24Hour = System.getDeviceSettings().is24Hour;
        var primaryTimeString = formatTime(primaryHours, primaryMinutes, is24Hour);
        var secondaryTimeString = formatTime(secondaryHours, secondaryMinutes, is24Hour);
        
        // Get the current date
        var today = Gregorian.info(Time.now(), Time.FORMAT_MEDIUM);
        var dateString = Lang.format("$1$ $2$ $3$", [today.day_of_week, today.month, today.day]);

        // Layout calculations for better organization
        var centerX = dc.getWidth() / 2;
        var centerY = dc.getHeight() / 2;

        // Draw primary time (local) - centered, large
        dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_TRANSPARENT);
        dc.drawText(centerX, centerY - 40, Graphics.FONT_LARGE, primaryTimeString, Graphics.TEXT_JUSTIFY_CENTER);

        // Draw secondary timezone label and time
        dc.setColor(Graphics.COLOR_LT_GRAY, Graphics.COLOR_TRANSPARENT);
        dc.drawText(centerX, centerY - 10, Graphics.FONT_TINY, "UTC" + (secondaryTimezoneOffset >= 0 ? "+" : "") + secondaryTimezoneOffset, Graphics.TEXT_JUSTIFY_CENTER);
        dc.drawText(centerX, centerY + 5, Graphics.FONT_SMALL, secondaryTimeString, Graphics.TEXT_JUSTIFY_CENTER);

        // Draw the date below timezones
        dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_TRANSPARENT);
        dc.drawText(centerX, centerY + 30, Graphics.FONT_SMALL, dateString, Graphics.TEXT_JUSTIFY_CENTER);

        // Draw additional elements
        drawBattery(dc);
        drawSteps(dc);
        drawWeeklyRunDistance(dc);
        drawLastRun(dc);
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

    // Helper function to draw battery indicator
    private function drawBattery(dc as Dc) as Void {
        var battery = System.getSystemStats().battery;
        var batteryString = Lang.format("$1$%", [battery.format("%.0f")]);
        
        dc.setColor(Graphics.COLOR_GREEN, Graphics.COLOR_TRANSPARENT);
        if (battery < 20) {
            dc.setColor(Graphics.COLOR_RED, Graphics.COLOR_TRANSPARENT);
        } else if (battery < 50) {
            dc.setColor(Graphics.COLOR_YELLOW, Graphics.COLOR_TRANSPARENT);
        }
        
        dc.drawText(20, 20, Graphics.FONT_TINY, batteryString, Graphics.TEXT_JUSTIFY_LEFT);
    }

    // Helper function to draw step count
    private function drawSteps(dc as Dc) as Void {
        var info = ActivityMonitor.getInfo();
        var steps = info.steps != null ? info.steps : 0;
        var stepsString = steps.toString();
        
        dc.setColor(Graphics.COLOR_BLUE, Graphics.COLOR_TRANSPARENT);
        dc.drawText(dc.getWidth() - 20, 20, Graphics.FONT_TINY, stepsString, Graphics.TEXT_JUSTIFY_RIGHT);
    }

    // Helper function to draw weekly run distance
    private function drawWeeklyRunDistance(dc as Dc) as Void {
        var weeklyDistance = getWeeklyRunDistance();
        var distanceString = Lang.format("$1$ km", [weeklyDistance.format("%.1f")]);
        
        dc.setColor(Graphics.COLOR_ORANGE, Graphics.COLOR_TRANSPARENT);
        dc.drawText(20, dc.getHeight() - 40, Graphics.FONT_TINY, distanceString, Graphics.TEXT_JUSTIFY_LEFT);
    }

    // Helper function to draw last run information
    private function drawLastRun(dc as Dc) as Void {
        var lastRunInfo = getLastRunInfo();
        
        dc.setColor(Graphics.COLOR_PURPLE, Graphics.COLOR_TRANSPARENT);
        dc.drawText(dc.getWidth() - 20, dc.getHeight() - 40, Graphics.FONT_TINY, lastRunInfo, Graphics.TEXT_JUSTIFY_RIGHT);
    }

    // Get weekly run distance from activity data
    private function getWeeklyRunDistance() as Float {
        var weeklyDistance = 0.0;
        
        try {
            // Get activity info for fitness tracking
            var info = ActivityMonitor.getInfo();
            if (info != null) {
                // Try to access weekly distance if available
                if (info.has(:weeklyDistance) && info.weeklyDistance != null) {
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

    // Get last run information
    private function getLastRunInfo() as String {
        try {
            var info = ActivityMonitor.getInfo();
            if (info != null) {
                // Check for recent activity distance
                if (info.distance != null && info.distance > 100) { // Minimum 100m to be a run
                    var lastDistance = info.distance / 1000.0; // Convert to km
                    if (lastDistance >= 0.1) { // Only show runs >= 100m
                        return Lang.format("$1$km", [lastDistance.format("%.1f")]);
                    }
                }
                
                // Check if there's any recent activity
                if (info.has(:moveBarLevel) && info.moveBarLevel != null && info.moveBarLevel > 0) {
                    return "Active";
                }
            }
        } catch (e) {
            // Handle any exceptions gracefully
        }
        
        return "No run";
    }
}