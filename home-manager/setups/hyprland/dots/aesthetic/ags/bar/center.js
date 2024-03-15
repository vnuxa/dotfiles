import Hyprland from 'resource:///com/github/Aylur/ags/service/hyprland.js';
import App from 'resource:///com/github/Aylur/ags/app.js';
import Widget from 'resource:///com/github/Aylur/ags/widget.js';

const dispatch = ws => Hyprland.sendMessage(`dispatch workspace ${ws}`);
export default () => Widget.EventBox({
    name: 'workspace-box',
    onScrollUp: () => dispatch('+1'),
    onScrollDown: () => dispatch('-1'),
    child: Widget.Box({
        class_name: 'workspaces_box',
        children: Array.from({ length: 10 }, (_, i) => i + 1).map(i => Widget.Button({
            class_name: 'workspace-button',
            attribute: i,
            label: `${i}`,
            on_clicked: () => dispatch(i),
        })),

        setup: self => self.hook(Hyprland, () => self.children.forEach(btn => {
            btn.visible = Hyprland.workspaces.some(ws => ws.id === btn.attribute);
            btn.label = Hyprland.active.workspace.id === btn.attribute ? '⦿' : '•';
            btn.toggleClassName('focused', Hyprland.active.workspace.id == btn.attribute);
        })),
    }),
});
