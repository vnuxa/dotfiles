// importing 
import Hyprland from 'resource:///com/github/Aylur/ags/service/hyprland.js';
import SystemTray from 'resource:///com/github/Aylur/ags/service/systemtray.js';
import Widget from 'resource:///com/github/Aylur/ags/widget.js';
import Notifications from 'resource:///com/github/Aylur/ags/service/notifications.js';
import { exec, execAsync } from 'resource:///com/github/Aylur/ags/utils.js';

export const display_audio_volume = () => Widget.Label({
    className: 'audio-volume',
    label: 'Test',
    connections: [
        // this is what you should do
        [500, self => execAsync(['playerctl', 'volume'])
            .then(date => { self.label = `${Math.round(date * 100).toString()}%`;} ).catch(console.error)],
    ],

})

export const Clock = () => Widget.Label({
    className: 'clock',
    connections: [
        // this is what you should do
        [10000, self => execAsync(['date', '+%H:%M %b %e, %a %D.'])
            .then(date => self.label = date).catch(console.error)],
    ],
});

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

export default () => Widget.Box({
    className: `right_bar`, 
    hpack: 'end',
    children: [
        SysTray(),

        
        display_audio_volume(),
        Widget.Icon({
            icon: 'audio-volume-high-symbolic',
            size: 16,
        }),
        // Volume(),
        Clock(),
    ],
});