import Widget from 'resource:///com/github/Aylur/ags/widget.js';
import App from 'resource:///com/github/Aylur/ags/app.js';
import Variable from 'resource:///com/github/Aylur/ags/variable.js';
import { exec, execAsync } from 'resource:///com/github/Aylur/ags/utils.js';
import { getCalendarLayout } from "./../library/calendar_layout.js";

let calendar_json = getCalendarLayout(undefined, true);
let monthshift = 0;

const week_days = [ // MONDAY IS THE FIRST DAY OF THE WEEK :HESRIGHTYOUKNOW:
    { day: 'Mo', today: 0 },
    { day: 'Tu', today: 0 },
    { day: 'We', today: 0 },
    { day: 'Th', today: 0 },
    { day: 'Fr', today: 0 },
    { day: 'Sa', today: 0 },
    { day: 'Su', today: 0 },
]
function get_relative_month_date(x) {
    var currentDate = new Date(); // Get the current date
    var targetMonth = currentDate.getMonth() + x; // Calculate the target month
    var targetYear = currentDate.getFullYear(); // Get the current year

    // Adjust the year and month if necessary
    targetYear += Math.floor(targetMonth / 12);
    targetMonth = (targetMonth % 12 + 12) % 12;

    // Create a new date object with the target year and month
    var targetDate = new Date(targetYear, targetMonth, 1);

    // Set the day to the last day of the month to get the desired date
    // targetDate.setDate(0);

    return targetDate;
}

export default ({ module_variable = Variable(false) }) => {

    const calendar_button = (day, month_relative) => {
        return Widget.Button({
            class_name: `calendar-button ${month_relative == 1 ? 'calendar-today' : (month_relative == -1 ? 'calendar-other-month' : '')}`,
            child: Widget.Label({
                hpack: 'center',
                class_name: 'calendar-button-label',
                label: day.toString(),
            })
        })
    }
    const add_calendar_data = (self, calendar_json) => {
        self.children = calendar_json.map((row, i) => Widget.Box({
            // calendar row
            class_name: 'calendar-row',
            children: row.map((day, i) =>
                calendar_button(day.day, day.today)
            )
        }))
    }


    const calendar_header = Widget.Button({
        class_name: 'calendar-header',
        hpack: 'start',
        on_clicked: () => shift_calendar_to(0),
        setup: (button) => {
            button.label = `${new Date().toLocaleString('default', { month: 'long' })} ${new Date().getFullYear()}`;
        }
    })
    const calendar_number = Widget.Label({
        class_name: 'calendar-number',
        hpack: 'end',
        label: `${(new Date().getMonth() + 1).toString()}`,
    })
    function shift_calendar_to(x) {
        if (x == 0) monthshift = 0;
        else monthshift += x;
        var newDate;
        if (monthshift == 0) newDate = new Date();
        else newDate = get_relative_month_date(monthshift);

        calendar_json = getCalendarLayout(newDate, (monthshift == 0));
        calendar_header.label = `${monthshift == 0 ? '' : '• '}${newDate.toLocaleString('default', { month: 'long' })} ${newDate.getFullYear()}`;
        calendar_number.label = `${(newDate.getMonth() + 1).toString()}`;
        add_calendar_data(calendar_days, calendar_json);
    }
    const calendar_days = Widget.Box({ // calendar days
        hexpand: true,
        vertical: true,
        class_name: 'calendar-days',
        setup: (self) => {
            add_calendar_data(self, calendar_json)
        },
    })

    const calendar_box = Widget.EventBox({
        on_scroll_up: () => shift_calendar_to(-1),
        on_scroll_down: () => shift_calendar_to(1),
        child: Widget.Box({
            // make rows of days and stuf
            // dont forget Mo, Tu, Th, We  sort of stuff on the top row!
            hpack: 'center',
            hexpand: true, // may have to put hexpand and stuff in another box
            vertical: true,
            children: [
                Widget.Box({
                    homogeneous: true,
                    children: week_days.map((day, i) => calendar_button(day.day, day.today)),
                }),
                calendar_days
                
            ]
        })
    })

    const main_box = Widget.Box({
        vertical: true,
        class_name: 'module-background',
        children: [
            Widget.Label({
                hpack: 'center',
                class_name: 'clock',
                setup: self => self.poll(10000, self =>
                    execAsync(['date', '+%H:%M'])
                        .then(date => self.label = date).catch(console.error)
                )
            }),
            calendar_box,
            Widget.CenterBox({
                start_widget: calendar_header,
                end_widget: calendar_number,
            })
        ]
    })

    return Widget.Revealer({
        child: main_box,
        reveal_child: module_variable.bind(),
        transition: 'slide_up',
    })
}
