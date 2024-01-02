// importing 
import Hyprland from 'resource:///com/github/Aylur/ags/service/hyprland.js';
import Widget from 'resource:///com/github/Aylur/ags/widget.js';
import Mpris from 'resource:///com/github/Aylur/ags/service/mpris.js';
import Audio from 'resource:///com/github/Aylur/ags/service/audio.js';
import { exec, execAsync } from 'resource:///com/github/Aylur/ags/utils.js';

export const Workspaces = () => Widget.Box({
    className: 'workspaces',

    // setup: self => self
    //     .on('hyprland::active::workspaces', self => {
    //         // generate an array [1..10] then make buttons from the index
    //         const arr = Array.from({ length: 10 }, (_, i) => i + 1);
    //         self.children = arr.map(i => Widget.Button({
    //             onClicked: () => execAsync(`hyprctl dispatch workspace ${i}`),
    //             onScrollUp: () => execAsync(`hyprctl dispatch workspace ${Hyprland.active.workspace.id + 1}`), 
    //             onScrollDown: () => execAsync(`hyprctl dispatch workspace ${Hyprland.active.workspace.id - 1}`), 
    //             child: Widget.Label(`${i}`),
    //             className: Hyprland.active.workspace.id == i ? 'focused' : '',
    //         }));
    //     })
    connections: [[Hyprland.active.workspace, self => {
        // generate an array [1..10] then make buttons from the index
        const arr = Array.from({ length: 10 }, (_, i) => i + 1);
        self.children = arr.map(i => Widget.Button({
            onClicked: () => execAsync(`hyprctl dispatch workspace ${i}`),
            onScrollUp: () => execAsync(`hyprctl dispatch workspace ${Hyprland.active.workspace.id + 1}`), 
            onScrollDown: () => execAsync(`hyprctl dispatch workspace ${Hyprland.active.workspace.id - 1}`), 
            child: Widget.Label(`${i}`),
            className: Hyprland.active.workspace.id == i ? 'focused' : '',
        }));
    }]],
});
export const Media = () => Widget.Button({
    className: 'media',
    onPrimaryClick: () => Mpris.getPlayer('')?.playPause(),
    onScrollUp: () => { Mpris.getPlayer('').volume += 0.025 }, //Mpris.getPlayer('')?.next(),
    onScrollDown: () => { Mpris.getPlayer('').volume -= 0.025 },
    child: Widget.Label({
        connections: [[Mpris, self => {
            const mpris = Mpris.getPlayer('');
            // mpris player can be undefined
            if (mpris)
                self.label = `♫ ${mpris.trackArtists.join(', ')} - ${mpris.trackTitle}`;
            else
                self.label = '';
        }]],
    }),
});

export default () => Widget.Box({
    className: `left_bar`, 
    hpack: 'start',
    children: [
        Workspaces(),
        Media(),
    ],
});
