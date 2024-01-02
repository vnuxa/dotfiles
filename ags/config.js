// importing 

import { App, Utils } from './imports.js';

// widgets
import Bar from './widgets/bar/main.js';
import Applauncher from './widgets/app_launcher/main.js';
import notification_center from './widgets/notification_center/main.js';
import load_notification from './widgets/notification_center/load_notification.js';
import calendar_panel from './widgets/panels/calendar/main.js';
// import battery_panel from './widgets/panels/battery/main.js'
// widgets can be only assigned as a child in one container
// so to make a reuseable widget, just make it a function
// then you can use it by calling simply calling it



// exporting the config so ags can manage the windows
export default {
    style: App.configDir + '/style.css',
    windows: [
        Bar(),
        Applauncher(),
        notification_center(),
        calendar_panel(),
        // ModuleCalendar(),
        // battery_panel(),
        // load_notification(),
        // you can call it, for each monitor
        // Bar({ monitor: 0 }),
        // Bar({ monitor: 1 })
    ],
};
