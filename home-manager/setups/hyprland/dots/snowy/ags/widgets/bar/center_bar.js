// importing 
import Hyprland from 'resource:///com/github/Aylur/ags/service/hyprland.js';
import Widget from 'resource:///com/github/Aylur/ags/widget.js';
import Notifications from 'resource:///com/github/Aylur/ags/service/notifications.js';
import { exec, execAsync } from 'resource:///com/github/Aylur/ags/utils.js';

// Removes everything after the last 
// em dash, en dash, minus, vertical bar, or middle dot    (note: maybe add open parenthesis?)
// For example:
// • Discord | #ricing-theming | r/unixporn — Mozilla Firefox    -->   • Discord | #ricing-theming 
// GJS Error · Issue #112 · Aylur/ags — Mozilla Firefox          -->   GJS Error · Issue #112 
function truncateTitle(str) {
    let lastDash = -1;
    let found = -1; // 0: em dash, 1: en dash, 2: minus, 3: vertical bar, 4: middle dot
    for (let i = str.length - 1; i >= 0; i--) {
        if (str[i] === '—') {
            found = 0;
            lastDash = i;
        }
        else if (str[i] === '–' && found < 1) {
            found = 1;
            lastDash = i;
        }
        else if (str[i] === '-' && found < 2) {
            found = 2;
            lastDash = i;
        }
        else if (str[i] === '|' && found < 3) {
            found = 3;
            lastDash = i;
        }
        else if (str[i] === '·' && found < 4) {
            found = 4;
            lastDash = i;
        }
    }
    if (lastDash === -1) return str;
    return str.substring(0, lastDash);
}

export const Notification = () => Widget.Box({
    className: 'notification',
    children: [
        Widget.Icon({
            icon: 'preferences-system-notifications-symbolic',
            connections: [
                [Notifications, self => self.visible = Notifications.popups.length > 0],
            ],
        }),
        Widget.Label({
            connections: [[Notifications, self => {
                self.label = Notifications.popups[0]?.summary || '';
            }]],
        }),
    ],
});

export const ClientTitle = () => Widget.Label({
    className: 'client-title',
    binds: [
        ['label', Hyprland.active.client, 'title'],
    ],
    connections: [
        [Hyprland.active.client, label => { // Hyprland.active.client
            label.label = Hyprland.active.client._title.length === 0 ? `Workspace ${Hyprland.active.workspace.id}` : truncateTitle(Hyprland.active.client._title);
        }]
    ],
});

export default () => Widget.Box({
    className: `center_bar`, 
    children: [
        Widget.Icon({
            icon: 'edit-symbolic',
            size: 25,
        }),
        ClientTitle(),
        // Notification(),
    ],
});