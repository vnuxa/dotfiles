import Widget from 'resource:///com/github/Aylur/ags/widget.js';
import  applauncher  from './applauncher.js';
import  { tab_bar_background } from './tab_bar.js';
import  calendar from './calendar.js';
import  todo_list from './todo_list.js';
import App from 'resource:///com/github/Aylur/ags/app.js';
import Variable from 'resource:///com/github/Aylur/ags/variable.js';

// You can navigate between the pressable menus with tab (or you can use mouse for that)
// To navigate btween app launcher items, you use shift + tab

const module_variables = {
    "applauncher": Variable(false),
    "calendar": Variable(false),
    "todolist": Variable(false),
}

export default () => Widget.Window({
    name: "applauncher",
    class_name: 'launcher-panel',
    // monitor,
    anchor: [ 'left', 'top', 'bottom', 'right'],
    exclusivity: 'ignore',
    popup: true,
    visible: false,
    focusable: true,
    child: Widget.Revealer({
        transition: 'crossfade',
        transition_duration: 175,
        setup: self => self.hook(App, (_, window_name, visible) => {
            self.reveal_child = visible;
        }),
        child: tab_bar_background({
            module_variables: module_variables,
            size: {
                width: 500,
            },
            modules: [
                applauncher({
                    width: 500,
                    height: 500,
                    spacing: 12,
                    module_variable: module_variables["applauncher"],
                }),
                calendar({
                    module_variable: module_variables["calendar"],
                }),
                todo_list({
                    width: 500,
                    height: 500,
                    module_variable: module_variables["todolist"],
                }),
            ],
        })
    })
})
