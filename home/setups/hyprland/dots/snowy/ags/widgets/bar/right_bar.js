// importing 
import Hyprland from 'resource:///com/github/Aylur/ags/service/hyprland.js';
import App from 'resource:///com/github/Aylur/ags/app.js';
import SystemTray from 'resource:///com/github/Aylur/ags/service/systemtray.js';
import Widget from 'resource:///com/github/Aylur/ags/widget.js';
import Notifications from 'resource:///com/github/Aylur/ags/service/notifications.js';
import { exec, execAsync } from 'resource:///com/github/Aylur/ags/utils.js';
// import Battery from 'resource:///com/github/Aylur/ags/service/battery.js';

export const display_audio_volume = () => Widget.Label({
    className: 'audio-volume',
    label: 'Test',
    connections: [
        // this is what you should do
        [500, self => execAsync(['playerctl', 'volume'])
            .then(date => { self.label = `${Math.round(date * 100).toString()}%`;} ).catch(console.error)],
    ],

})

export const Clock = () => Widget.Button({
    on_primary_click: () => App.toggleWindow("calendar-popup"),
    // className: 'clock',
    child: Widget.Label({
        className: 'clock',
        connections: [
            // this is what you should do
            [10000, self => execAsync(['date', '+%H:%M %b %e, %a %d/%m/%Y.'])
                .then(date => self.label = date).catch(console.error)],
        ],
    }),
})

export const SysTray = () => Widget.Box({
    className: `system_tray`,
    connections: [[SystemTray, self => {
        self.children = SystemTray.items.map(item => Widget.Button({
            child: Widget.Icon({ binds: [['icon', item, 'icon']] }),
            onPrimaryClick: (_, event) => item.activate(event),
            onSecondaryClick: (_, event) => item.openMenu(event),
            binds: [['tooltip-markup', item, 'tooltip-markup']],
        }));
    }]],
});
const revIcon = Widget.Label({
    className: "systraybtn",
    label: "<",
});

const TrayItems = () => Widget.Box({
    className: "trayIcons",
    connections: [
        [
            SystemTray,
            (self) => {
                self.children = SystemTray.items.map((item) =>
                    Widget.Button({
                        className: "trayIcon",
                        child: Widget.Icon({ binds: [["icon", item, "icon"]] }),
                        on_primary_click: (_, event) => item.activate(event),
                        onSecondaryClick: (_, event) => item.openMenu(event),
                        binds: [["tooltip-markup", item, "tooltip-markup"]],
                    })
                );
            },
        ],
    ],
});

const trayRevealer = Widget.Revealer({
    transition: "slide_left",
    child: TrayItems(),
});

export const Tray = () => Widget.EventBox({
    on_primary_click: (self) => {
        trayRevealer.revealChild = !trayRevealer.revealChild;
        revIcon.label = trayRevealer.revealChild ? '>': '<';
    },
    child: Widget.Box({
        className: "tray",
        children: [
            trayRevealer,
            revIcon,
        ],
    }),
});
//TODO: make it so that instead of using an icon for batter ywidget, use text (like a lightning symbol for charging)
//and something else for decharging (MAYBE TRY TO USE THE TIME PREDICTION), maybe if you click on it you get more info
// about the propreties that ags battery service provides
//
// export const Battery_Widget_Circular = () =>  Widget.CircularProgress({
//     className: `battery-widget`,
//     child: Widget.Icon({
//         binds: [['icon', Battery, 'icon-name']],
//     }),
//     binds: [
//         ['value', Battery, 'percent', p => p > 0 ? p / 100 : 0],
//         ['class-name', Battery, 'charging', c => c ? 'charging' : ''],
//     ],
// })

// export const Battery_Widget = () => Widget.Button({
//     className: `battery-button, media`,
//     // onPrimaryClick: (_, event) => App.toggleWindow("battery-popup"),
//     onPrimaryClick: (_, event) => Widget.Menu({
//         children: [
//             Widget.MenuItem({
//                 child: Widget.Label("Time remaining: " + new Date(Battery['time-remaining'] * 1000).toISOString().slice(11, 19).toString() )
//             }),
//         ], 
//     }).popup_at_pointer(event),
//
//     child: Widget.Box({
//         children: [
//             Widget.Label({
//                 binds: [
//                     ['label', Battery, 'percent', p => p.toString() + '%']
//                 ]
//             }),
//             Widget.Icon({
//                 size: 16,
//                 binds: [
//                     // ['icon', Battery, 'charging', value => value ? 'camera-flash-symbolic' : 'camera-flash-disabled-symbolic']
//                     ['icon', Battery, 'icon-name']
//                 ]
//             })
//         ]
//     })
//
// })

export default () => Widget.Box({
    className: `right_bar`, 
    hpack: 'end',
    children: [
        // SysTray(),
        Tray(),

        
        display_audio_volume(),
        Widget.Icon({
            icon: 'audio-volume-high-symbolic',
            size: 16,
        }),
        // Volume(),
        // Battery_Widget(),
        Clock(),
    ],
});
