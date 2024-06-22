import App from 'resource:///com/github/Aylur/ags/app.js';
import Bar from './bar/main.js'
import Launcher from './launcher/main.js'

const css = `${App.configDir}/style.css`

export default {
    style: css,
    windows: [
        Bar(),
        Launcher(),
    ],
};
