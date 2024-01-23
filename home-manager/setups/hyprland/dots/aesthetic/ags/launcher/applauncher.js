import Widget from 'resource:///com/github/Aylur/ags/widget.js';
import App from 'resource:///com/github/Aylur/ags/app.js';
import Applications from 'resource:///com/github/Aylur/ags/service/applications.js';
import Variable from 'resource:///com/github/Aylur/ags/variable.js';

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

    // container holding buttons
    const list = Widget.Box({
        vertical: true,
        children: applications,
        spacing
    });

    // repopulate the box, so its sorted by frequently used applications
    function repopulate() {
        applications = Applications.query('').map(AppItem);
        list.children = applications;
    }

    // search entry
    const entry = Widget.Entry({
        hexpand: true,
        class_name: 'applauncher-entry',
        css: `margin-bottom: ${spacing}px`,

        // To launch first application on enter 
        // TODO: find out how to know if your holding the shift key too
        on_accept: ({ text }) => {
            const applist = Applications.query(text || '');

            if (applist[0]) {
                App.toggleWindow('applauncher');
                applist[0].launch();
            }
        },

        // filter out the list
        on_change: ({ text }) => applications.forEach(item => {
            item.visible = item.attribute.app.match(text);
        }),

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
                child: list,
            }),
        ],
        setup: self => self.hook(module_variable, () => {
            if (module_variable.value == true) {
                setTimeout(function() {
                    repopulate();
                    entry.text = '';
                    entry.grab_focus();
                }, 100);
            }
        }),
    });



    return Widget.Revealer({
        child: main_box,
        reveal_child: module_variable.bind(),
        transition: 'slide_up',
    })
    
}

