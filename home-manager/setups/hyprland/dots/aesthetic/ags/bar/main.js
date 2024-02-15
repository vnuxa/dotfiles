import Hyprland from 'resource:///com/github/Aylur/ags/service/hyprland.js';
import App from 'resource:///com/github/Aylur/ags/app.js';
import Widget from 'resource:///com/github/Aylur/ags/widget.js';
import Center from './center.js';
import Left from './left.js';
import Right from './right.js';


export default ({ monitor } = {}) => Widget.Window({
    name: "bottom-bar",
    class_name: 'bar',
    monitor,
    anchor: [ 'bottom', 'left', 'right' ],
    exclusivity: 'exclusive',
    child: Widget.CenterBox({
        class_name: 'workspaces-bar',

        start_widget: Left(),
        center_widget: Center(),
        end_widget: Right(),
    })
    // child: Center(),



})
