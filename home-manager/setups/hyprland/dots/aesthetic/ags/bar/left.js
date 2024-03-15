import Widget from 'resource:///com/github/Aylur/ags/widget.js';
import Mpris from 'resource:///com/github/Aylur/ags/service/mpris.js';

const Player = () => Widget.Button({
    name: 'media-button',
    class_name: 'media-button',
    on_primary_click: () => Mpris.getPlayer('')?.playPause(),
    on_scroll_up: () => { Mpris.getPlayer('').volume += 0.025 }, //Mpris.getPlayer('')?.next(),
    on_scroll_down: () => { Mpris.getPlayer('').volume -= 0.025 },
    child: Widget.Label({
        class_name: 'media-label',
        setup: (self) => self.hook(Mpris, label => {
            const mpris = Mpris.getPlayer('');
            if (mpris)
                label.label = `♫ ${mpris.trackArtists.join(', ')} - ${mpris.trackTitle}`;
            else
                label.label = 'no media';
        }),
    })
})

export default () => Widget.Box({
    name: 'left-box',
    class_name: 'left-box',
    children: [ Player(), ],
})
