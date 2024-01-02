// importing 
const { GLib, Gdk, Gtk } = imports.gi;
import Hyprland from 'resource:///com/github/Aylur/ags/service/hyprland.js';
import Widget from 'resource:///com/github/Aylur/ags/widget.js';
import Notifications from 'resource:///com/github/Aylur/ags/service/notifications.js';
import { exec, execAsync } from 'resource:///com/github/Aylur/ags/utils.js';
import Variable from 'resource:///com/github/Aylur/ags/variable.js';

const displaying_notif = Variable([]);
const all_notifications = Variable([]);
const previous_length = Variable(0);
function guessMessageType(summary) { // gives an icon from the summary title
    if (summary.includes('recording')) return 'screencast-recorded-symbolic';
    if (summary.includes('screenshot')) return 'gnome-screenshot-symbolic';
    if (summary.includes('time')) return 'clock-applet-symbolic';
    if (summary.includes('installed')) return 'browser-download-symbolic';
    if (summary.includes('update')) return 'update-symbolic';
    if (summary.startsWith('file')) return 'folder-symbolic';
    return 'chat-symbolic';
}


export const notification_title = ({notification_object, should_dissapear}) => {
    const destroy_itself = () => {
        print("destroying itself!! ");
        //TODO: animations for destroyin

        setTimeout(function() {
            whole_thing.destroy();
        }, 500)
    };
    const whole_thing = Widget.Box({
        className: 'notification-title',
        visible: true,
        properties: [
            ['should_dissapear', new Boolean(should_dissapear)],
            ['destroy_itself', () => {destroy_itself()}]
        ],
        
        children: [
            Widget.Icon({
                className: 'notification-object-image test-background',
                icon: notification_object['image'] || 'preferences-system-notifications-symbolic',//'preferences-system-notifications-symbolic',
                size: 28,
                // connections: [
                //     [Notifications, self => self.icon = guessMessageType(Notifications.popups[0]?.summary || '')],
                // ],
            }),

            Widget.CenterBox({
                className: 'osd-notifs test-background',
                vertical: true,
                hexpand: true,
                vexpand: true,
                startWidget: Widget.Label({
                    valign: Gtk.Align.CENTER,
                    justify: Gtk.Justification.FILL,
                    className: 'notification-object-title test-background',
                    label: notification_object['app-name'],
                }),
                centerWidget: Widget.Label({
                    className: 'notification-object-summary',
                    label: notification_object['summary'],
                }),
                endWidget: Widget.Label({
                    className: 'notification-object-body',
                    label: notification_object['body'],
                }),
                
            })
        ]
    });

    const revelear = Widget.Revealer({
        // reveal_child: false,
        child: whole_thing,
        transition_duration: 500,
        properties: [
            ['should_dissapear', new Boolean(should_dissapear)],
            ['destroy_itself', () => {destroy_itself()}]
        ],
        // transition: "crossfade",
        transition: "slide_down",
    })

    return revelear;
}

export default () => Widget.Box({
    className: `osd-notifs notification-bar`,
    vertical: true,
    vexpand: true,
    homogeneous: true,
    properties: [
        ['map', new Map()],

        ['dismiss', (self, notification_id, force = false) => {
            if (!notification_id || !self._map.has(notification_id)) //|| box._map.get(id)._hovered && !force)
                return;

            const notification_widget = self._map.get(notification_id);
            notification_widget.transition = "crossfade";
            notification_widget.revealChild = !notification_widget.revealChild;
            notification_widget._destroy_itself();
        }],

        ['notify', (self, notification_id) => {
            if (!notification_id || Notifications.dnd) return; // if notification id exists and dnd is not on
            if (!Notifications.getNotification(notification_id)) return; // if theres a notification object based on the id
            print('new notiffy', notification_id, Notifications.getNotification(notification_id))

            self._map.delete(notification_id);

            const notification_object = Notifications.getNotification(notification_id);
            const notification_widget = notification_title({
                notification_object: notification_object,
            });
            
            self._map.set(notification_id, notification_widget)
            self.pack_end(self._map.get(notification_id), false, false, 0);
            self.show_all();
            notification_widget.revealChild = !notification_widget.revealChild;
            print("got information from notification: ");
            print(notification_object['app-name']); 
            print(notification_object['summary']);
            print(notification_object['body']);
            print(notification_object['urgency']);
        }],
    ],
    connections: [
        [Notifications, (self, notification_id) => self._notify(self, notification_id), 'notified'],
        [Notifications, (self, notification_id) => self._dismiss(self, notification_id), 'dismissed'],
        [Notifications, (self, notification_id) => self._dismiss(self, notification_id, true), 'closed'],
    ],
    // child: Widget.Label(),
    // child: notification_title({notification_object: {summary: "what theh ell"}, should_dissapear: true}), //! FOR NOTIFICATIONS TO WORK THIS HAS TO BE LOADED SOMEWHERE
    // setup: (self) => { //? pointless but setup can be used to execute a method when soemthing is created
    //     print("ok so the children i have are", self.children.length)

});
