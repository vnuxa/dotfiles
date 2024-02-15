import Widget from 'resource:///com/github/Aylur/ags/widget.js';
import SystemTray from 'resource:///com/github/Aylur/ags/service/systemtray.js';

const tray_item = item => Widget.Button({
    class_name: 'tray-button',
    child: Widget.Icon().bind('icon', item, 'icon'),
    tooltipMarkup: item.bind('tooltip-markup'),
    on_primary_click: (_, event) => item.activate(event),
    on_secondary_click: (_, event) => item.openMenu(event),
})

const tray_items = Widget.Box()
    .bind('children', SystemTray, 'items', i => i.map(tray_item))

const revealer_icon = Widget.Label({
    class_name: 'system-tray-label',
    label: '<',
})
const trayRevealer = Widget.Revealer({
    transition: "slide_left",  //TODO: change animation, mayube som,ething that goes upward
    child: tray_items,
});


const tray = () => Widget.EventBox({
    on_primary_click: (self) => {
        trayRevealer.revealChild = !trayRevealer.revealChild;
        revealer_icon.label = trayRevealer.revealChild ? '>' : '<';
    },
    on_hover: (self) => {
        trayRevealer.revealChild = true;
        revealer_icon.label = '>';
    },
    on_hover_lost: (self) => {
        trayRevealer.revealChild = false;
        revealer_icon.label = '<';
    },
    child: Widget.Box({
        class_name: 'tray',
        children: [
            trayRevealer,
            revealer_icon
        ]
    })
})

//TODO: add a revelar for a system tray, maybe add a hotkey for it as well
export default () => Widget.Box({
    name: 'right-bar',
    hpack: 'end',
    class_name: 'right-bar',
    children: [
        tray(),
    ],
    
})
