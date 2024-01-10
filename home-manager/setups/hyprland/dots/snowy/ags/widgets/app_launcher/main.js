import Widget from 'resource:///com/github/Aylur/ags/widget.js';
import App from 'resource:///com/github/Aylur/ags/app.js';
import Applications from 'resource:///com/github/Aylur/ags/service/applications.js';
import Variable from 'resource:///com/github/Aylur/ags/variable.js';

import search_addon from './search_addon.js';

const WINDOW_NAME = 'applauncher';



/** @param {import('resource:///com/github/Aylur/ags/service/applications.js').Application} app */
const AppItem = app => Widget.Button({
    className: `applauncher-item`,
    on_clicked: () => {
        App.closeWindow(WINDOW_NAME);
        app.launch();
    },
    setup: self => self.app = app,
    child: Widget.Box({
        children: [
            Widget.Icon({
                class_name: `applauncher-item-icon`,
                icon: app.icon_name || '',
                size: 42,
            }),
            Widget.Box({
                vertical: true,
                vpack: 'center',
                children: [
                    Widget.Label({
                        class_name: 'applauncher-item-title',
                        label: app.name,
                        xalign: 0,
                        vpack: 'center',
                        truncate: 'end',
                    }),
                    // short circuit if there is no description
                    !!app.description && Widget.Label({
                        class_name: 'applauncher-item-description',
                        label: app.description || '',
                        wrap: true,
                        xalign: 0,
                        justification: 'left',
                        vpack: 'center',
                    }),
                ],
            }),
        ],
    }),
});


const RegularItem = ({Icon, Title, Description}) => Widget.Button({
    className: `applauncher-item`,
    // setup: self => self.app = app,
    on_clicked: () => {
        App.toggleWindow(WINDOW_NAME);
    },

    child: Widget.Box({
        children: [
            Widget.Icon({
                className: `applauncher-item-icon`,
                icon: Icon || '',
                size: 42,
            }),
            Widget.Box({
                vertical: true,
                vpack: 'center',
                children: [
                    Widget.Label({
                        class_name: 'applauncher-item-title',
                        label: Title,
                        xalign: 0,
                        vpack: 'center',
                        truncate: 'end',
                    }),
                    
                    Widget.Label({
                        class_name: 'applauncher-item-description',
                        label: Description|| '',
                        wrap: true,
                        xalign: 0,
                        justification: 'left',
                        vpack: 'center',
                    }),
                ],
            }),
        ],
    }),
});
const previous_invis = Variable(false);
const displaying_regulars = Variable([]);
const latest_func = Variable(() => {});

const Applauncher = ({ width = 500, height = 500, spacing = 12 } = {}) => {
    const list = Widget.Box({
        class_name: `applauncher-list`,
        vertical: true,
        spacing,
    });

    const entry = Widget.Entry({
        hexpand: true,
        css: `margin-bottom: ${spacing}px;`,
        class_name: `applauncher-entry`,

        // set some text so on-change works the first time
        text: '-',

        // to launch the first item on Enter
        on_accept: ({ text }) => {
            const list = Applications.query(text || '');
            if (list[0]) {
                App.toggleWindow(WINDOW_NAME);
                list[0].launch();
            } else {
                App.toggleWindow(WINDOW_NAME);
                
                if (latest_func.value != null) {
                    latest_func.value();
                }
            }
        },

        // filter out the list
        on_change: ({ text }) => {
            let found_match = false;
            list.children.map(item => {
                if (item.app) {
                    item.visible = item.app.match(text);
                    if (found_match == false && item.app.match(text) == true) {
                        found_match = true;
                    }
                }
            });
            if (text.includes("nvim") || text.includes("ncode") ) {
                found_match = false;
            }
            if (found_match == false && text != '') {
                // item.visible = false;
                // print("hai :3",previous_invis.value, found_match && previous_invis.value == false && text != '');
                previous_invis.value = true;
                for (let i = 0; i < displaying_regulars.value.length; i++) {
                    list.remove(displaying_regulars.value[i]);
                }
                // before resetting the list, we kill everything
                // displaying_regulars.value = search_addon(text);
                let addon = search_addon(text)
                addon.map(data => {
                    let item = RegularItem(data[0]);
                    latest_func.value = data[1]
                    displaying_regulars.value.push(item)
                    list.add(item);
                    item.visible = true;
                })
                
                
                // print(displaying_regulars.value.length);
            } 
            if (text == '') {
                for (let i = 0; i < displaying_regulars.value.length; i++) {
                    list.remove(displaying_regulars.value[i]);
                }
            }
            if (found_match == true && previous_invis.value == true){
                // list.children = Applications.list.map(AppItem);
                displaying_regulars.value = [];
                previous_invis.value = false;
            }
        },
    });

    return Widget.Box({
        class_name: `applauncher-main`,
        vertical: true,
        css: `margin: ${spacing * 2}px;`,
        children: [
            entry,

            // wrap the list in a scrollable
            Widget.Scrollable({
                class_name: `applauncher-scrollbar`,
                hscroll: 'never',
                css: `
                    min-width: ${width}px;
                    min-height: ${height}px;
                `,
                child: list,
            }),
        ],

        // make entry.text empty on launch
        // and update the list's children so it is sorted by frequency
        connections: [[App, (_, name, visible) => {
            if (name !== WINDOW_NAME)
                return;
            list.children = Applications.list.map(AppItem);

            entry.text = '';
            if (visible)
                entry.grab_focus();
        }]],
    });
};

export default() => Widget.Window({
    class_name: `applauncher-window`,
    name: WINDOW_NAME,
    popup: true,
    visible: false,
    focusable: true,
    child: Applauncher({
        width: 500,
        height: 250,
        spacing: 12,
    }),
});

