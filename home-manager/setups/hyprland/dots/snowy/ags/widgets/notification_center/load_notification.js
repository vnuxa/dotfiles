import App from 'resource:///com/github/Aylur/ags/app.js';
import Widget from 'resource:///com/github/Aylur/ags/widget.js';
import { exec, execAsync } from 'resource:///com/github/Aylur/ags/utils.js';

// importing modules
// import Left from './left_bar.js';
import {notification_title} from './notification_popup.js';


// layout of the bar

export default ({ monitor } = {}) => Widget.Window({
    name: `notif-window-showpopup-${monitor}`, // name has to be unique
    className: 'notification-window',
    monitor,
    anchor: ['bottom'],
    exclusive: false,

    layer: 'overlay',
    visible: true,
    // popup: true,
    // child: Widget.CenterBox({
    //     // startWidget: Left(),
    //     centerWidget: notification_popup(),
    //     // endWidget: Right(),
    // }),
    // child: notification_popup(),
    child: notification_title({notification_object: {summary: "test"}, should_dissapear: true}),
    margins: [0,5,0,5] 

})