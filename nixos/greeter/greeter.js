const greetd = await Service.import('greetd');
import App from 'resource:///com/github/Aylur/ags/app.js'

const input_label = Widget.Label({
    class_name: 'greeter-input-label',
    vexpand: true,
    hexpand: true,
    label: '0',
})

const password = Widget.Entry({
    class_name: 'greeter-password-entry',
    placeholder_text: 'Password',
    visibility: false,
    on_accept: () => {
        // currentkly only works for 1 user, as i dont have multiple users
        greetd.login("vnuxa", password.text || '', 'Hyprland')
            .catch(err => response.label = JSON.stringify(err))
    },
    on_change: () => {
        input_label.label = password.text.length.toString() || "0";
    },
})

const response = Widget.Label()

const win = Widget.Window({
    name: 'greeter',
    css: 'background-color: transparent;',
    class_name: 'greeter',
    anchor: ['top', 'left', 'right', 'bottom'],
    keymode: "on-demand",
    child: Widget.Box({
        class_name: 'greeter-box',
        hexpand: true,
        vexpand: false,
        children: [
            input_label,
            password,
            response,
        ],
    }),
    setup: self => self.hook(App, (_, window_name, visible) => {
        if (visible == true) {
            entry.grab_focus();
        }
    }),
})

export default {
    style: `${App.configDir}/style.css`,
    windows: [ win ]
};

