import Widget from 'resource:///com/github/Aylur/ags/widget.js';
import App from 'resource:///com/github/Aylur/ags/app.js';
import Gdk from "gi://Gdk";

export const tab_bar_background = ({ module_variables = {}, size = {}, modules = [] }) => {
    let previous_index = "applauncher"; // defaults to applauncher
    const module_keys = Object.keys(module_variables);
    let index_num = 0;


    function change_to(app_name) { 
        module_variables[previous_index].setValue(false);
        module_variables[app_name].setValue(true);
        index_num = module_keys.indexOf(app_name);
        previous_index = app_name;
    }
    function switch_through() {
        index_num += 1;
        if (index_num == module_keys.length) {
            index_num = 0;
        }
        module_variables[previous_index].setValue(false);
        module_variables[module_keys[index_num]].setValue(true);
        previous_index = module_keys[index_num];
    }


    const tab_item = app_name => Widget.Button({
        class_name: 'tab-bar-button',
        child: Widget.Label(app_name),
        on_primary_click: () => change_to(app_name),
    });


    const tab_objects = module_keys.map(tab_item);
    let window_visibility = false;

    const tab_background = Widget.Box({
        class_name: "tab-bar-background",
        vertical: true,
        vpack: "fill",
        children: tab_objects,
        setup: self => self.hook(App, (_, window_name, visible) => {
            if (window_name !== 'applauncher')
                return;

            // shows window animation whenever opening
            module_variables[previous_index].setValue(visible);
            window_visibility = visible;
        }),
        
    }).on("key-press-event", (_, event) => { // Adds tab to switch modules
            if (window_visibility != true) return;
            const keyval = event.get_keyval()[1];
            
            if ((keyval == Gdk.KEY_Tab) && (event.get_state()[1] == Gdk.ModifierType.CONTROL_MASK)) {
                switch_through();
            }
    });


    return Widget.CenterBox({
        class_name: 'launcher-background',
        start_widget: Widget.CenterBox({
            hpack: 'start',
            class_name: 'tab-bar-background',
            // css: 'background-color: rgb(255,0,0);',
            vertical: true,
            center_widget: tab_background,
        }),
        center_widget: Widget.Overlay({
            pass_through: true,
            child: Widget.Box({
                css: `
                    min-width: ${size.width}px; 
                `, // width does not automatically expand
            }),
            overlays: modules.map(item => { // create centered modules
                return Widget.CenterBox({
                    vpack: 'center',
                    vertical: true,
                    center_widget: item,
                });
            }),
            
        }),

    });


}
