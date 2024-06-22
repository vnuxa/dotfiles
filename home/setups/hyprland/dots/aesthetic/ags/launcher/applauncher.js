import Widget from 'resource:///com/github/Aylur/ags/widget.js';
import App from 'resource:///com/github/Aylur/ags/app.js';
import Applications from 'resource:///com/github/Aylur/ags/service/applications.js';
import Variable from 'resource:///com/github/Aylur/ags/variable.js';
import { Fzf } from '../node_modules/fzf/dist/fzf.es.js';

/** @param {import('resource:///com/github/Aylur/ags/service/applications.js').Application} app */
const AppItem = app => Widget.Button({
    class_name: 'applauncher-item',
    on_clicked: () => {
        App.closeWindow('applauncher');
        app.launch();
    },
    attribute: { app }, 
    child: Widget.Box({
        children: [
            Widget.Icon({
                class_name: 'applauncher-item-icon',
                icon: app.icon_name || '',
                size: 42,
            }),
            Widget.Label({
                class_name: 'applauncher-item-title',
                label: app.name,
                xalign: 0,
                vpack: 'center',
                truncate: 'end',
            }),
        ],
    }),
})

export default ({ width = 500, height = 500, spacing = 3, module_variable = Variable(false) }) => {
    // list application buttons
    let applications = Applications.query('').map(AppItem);
    let fuzzy_results;

    const list = Widget.ListBox();

    const set_sort = (text) => {
        const fuzzy = new Fzf(Applications.list, {
            selector: (app) => app.name + app.executable,

            tiebreakers: [
                (a, b) => b.item.frequency - a.item.frequency,
            ]
        });

        fuzzy_results = fuzzy.find(text);
        list.set_sort_func((a, b) => {
            const row1 = a.get_children()[0].attribute.app.name;
            const row2 = b.get_children()[0].attribute.app.name;

            const s1 = fuzzy_results.find((r) => r.item.name === row1)?.score ?? 0;
            const s2 = fuzzy_results.find((r) => r.item.name === row2)?.score ?? 0;

            return s2 - s1;
        });
    }

    function repopulate() {
        const rows = list.get_children();

        rows.forEach((item) => {
            item.destroy();
        });

        const children = Applications.query('').flatMap((app) => AppItem(app));

        children.forEach((item) => {
            list.add(item);
        });

        list.show_all();
    }

    repopulate();

    const placeholder = Widget.Revealer({
        child: Widget.Label({
            label: "no matches found",
            class_name: 'placeholder'
        }),
    });

    const entry = Widget.Entry({
        text: '-', // setr some text so to make the on_change work
        hexpand: true,

        class_name: 'applauncher-entry',
        css: `margin-bottom: ${spacing}px`,

        on_accept: ({ text }) => {
            const app_list = Applications.query(text || '');

            if (app_list[0]) {
                App.closeWindow('applauncher');
                app_list[0].launch();
            }
        },

        on_change: ({ text }) => {
            if (text === null) {
                return;
            }

            set_sort(text);
            let visible_apps = 0;

            const rows = list.get_children(); 

            rows.forEach((row) => {
                row.changed();

                const item = row.get_children()[0];

                if (item.attribute.app) {
                    const is_matching = fuzzy_results.some((r) => {
                        return r.item.name === item.attribute.app.name;
                    });

                    row.visible = is_matching;

                    if (is_matching) {
                        ++visible_apps;
                    }
                }
            });

            placeholder.reveal_child = visible_apps <= 0;
        },
    });

    const main_box = Widget.Box({
        vertical: true,
        css: `margin: ${spacing * 2}px 0.5em;`,
        class_name: 'module-background',
        children: [
            entry,

            // wrap the entirel ist in a scrollable
            Widget.Scrollable({
                hscroll: 'never',
                css: `
                    min-width: ${width}px;
                    min-height: ${height}px;
                `,
                child: Widget.Box({ children: [ list, placeholder ], vertical: true }),
            }),
        ],
        setup: self => self.hook(module_variable, () => {
            if (module_variable.value != true) {
                repopulate();
                return;
            } 
            setTimeout(function() {

                if (module_variable.value == true) {
                    entry.text = '';
                    entry.grab_focus();
                } 
            }, 100);
        }),

        // setup: self => self.hook(module_variable, () => {
        //     if (module_variable.value == true) {
        //         setTimeout(function() {
        //             repopulate();
        //             entry.text = '';
        //             entry.grab_focus();
        //         }, 100);
        //     }
        // }),
    });



    return Widget.Revealer({
        child: main_box,
        reveal_child: module_variable.bind(),
        transition: 'slide_up',
    });
}
