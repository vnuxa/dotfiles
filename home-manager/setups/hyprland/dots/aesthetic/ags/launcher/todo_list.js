const { Gio, GLib } = imports.gi;
import Widget from 'resource:///com/github/Aylur/ags/widget.js';
import App from 'resource:///com/github/Aylur/ags/app.js';
import Variable from 'resource:///com/github/Aylur/ags/variable.js';
import * as Utils from 'resource:///com/github/Aylur/ags/utils.js';
import Pango from 'gi://Pango';
import md_to_pango from './../library/md_to_pango.js';

function fileExists(filePath) {
    let file = Gio.File.new_for_path(filePath);
    return file.query_exists(null);
}
export default ({width = 500, height = 500, module_variable = Variable(false) }) => {
    let note_json = [];
    const note_path = `${GLib.get_user_cache_dir()}/ags/user/todo.json`
    let notes_index = 0;

    if(!fileExists(note_path)) { // if file doenst exist, make it
        Utils.exec(`bash -c 'mkdir -p ${GLib.get_user_cache_dir()}/ags/user/'`);
        Utils.exec(`touch ${note_path}`);
        Utils.writeFile("[]", note_path).then(() => {
            note_json = JSON.parse(Utils.readFile(note_path))
        }).catch(print);
    } else {
        const file_contents = Utils.readFile(note_path);
        note_json = JSON.parse(file_contents);
    }

    const add_json = (content) => {
        note_json.push({ content });
        Utils.writeFile(JSON.stringify(note_json), note_path)
            .catch(print);
    }
    const remove_json = (index) => {
        note_json.splice(index, 1);
        Utils.writeFile(JSON.stringify(note_json), note_path)
            .catch(print);
    }

    const note = ( text, new_note ) => { 
        if (new_note == true) {
            add_json(text);
        }
        notes_index += 1;
        const box = Widget.Box({
            class_name: 'todo-note-background',
            hexpand: false,
            children: [
                Widget.Button({
                    class_name: 'todo-note-button',
                    child: Widget.Label("-"),
                    on_primary_click: () => {
                        notes_index -= 1;
                        remove_json(notes_index);
                        list.remove(box);
                    }
                }),
                Widget.Label({
                    class_name: 'todo-note-text',
                    label: md_to_pango(text),
                    wrap: true,
                    hexpand: false,
                    wrap_mode: Pango.WrapMode.WORD_CHAR,
                    justification: 'left',
                    use_markup: true,
                }),
            ]
        })
        return box
        
    }
    const list = Widget.Box({
        vertical: true,
        class_name: 'todo-list',
        children: note_json.map(text => note( text.content, false )),
    });

    const entry = Widget.Entry({
        hexpand: true,
        class_name: 'todolist-entry',
        on_accept: ({ text }) => {
            list.add(note(text, true));
            entry.text = '';
        }
    });

    const main_box = Widget.Box({
        vertical: true,
        class_name: 'module-background',
        children: [
            Widget.Scrollable({
                hscroll: 'never',
                css: `
                    min-width: ${width}px;
                    min-height: ${height}px;
                `,
                child: list,
            }),
            Widget.Box({
                class_name: 'todo-entry-background',
                children: [
                    Widget.Label({
                        class_name: 'todo-entry-label',
                        label: '> ',
                    }),
                    entry,
                ],
            })
        ]
    });

    return Widget.Revealer({
        child: main_box,
        reveal_child: module_variable.bind(),
        transition: 'slide_up',
    });
}
