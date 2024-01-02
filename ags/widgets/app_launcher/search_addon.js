import Widget from 'resource:///com/github/Aylur/ags/widget.js';
import App from 'resource:///com/github/Aylur/ags/app.js';
import Applications from 'resource:///com/github/Aylur/ags/service/applications.js';
import Variable from 'resource:///com/github/Aylur/ags/variable.js';
import { exec, execAsync } from 'resource:///com/github/Aylur/ags/utils.js';

const WINDOW_NAME = 'applauncher';



// Add math funcs
const { abs, sin, cos, tan, cot, asin, acos, atan, acot } = Math;
const pi = Math.PI;
// trigonometric funcs for deg
const sind = x => sin(x * pi / 180);
const cosd = x => cos(x * pi / 180);
const tand = x => tan(x * pi / 180);
const cotd = x => cot(x * pi / 180);
const asind = x => asin(x) * 180 / pi;
const acosd = x => acos(x) * 180 / pi;
const atand = x => atan(x) * 180 / pi;
const acotd = x => acot(x) * 180 / pi;

function startsWithNumber(str) {
    var pattern = /^\d/;
    return pattern.test(str);
}
function startsWithPrefix(str) { 
    var pattern = />/;
    return pattern.test(str);
}

export default (Text) => {
    
    // If the result starts with 1, calculate it via math
    if (startsWithNumber(Text)) { // Eval on typing is dangerous, this is a workaround.
        try {
            const fullResult = eval(Text);
            // resultsBox.add(CalculationResultButton({ result: fullResult, text: Text }));
            return [
                [
                    {
                        Icon: 'accessories-calculator-symbolic', 
                        Title: 'Math result:', 
                        Description: `${fullResult}`,
                        className: 'app-math'
                    },
                    () => { //OnActivate
                        execAsync(['bash', '-c', `wl-copy '${fullResult}'`, `&`]).catch(print); //Copy the math result to clipboard
                    },
                
                ]
            ]
        } catch (e) {
            // console.log(e);
        }
    } else if(Text.includes("nvim")) { //TODO: make it so that it will open neovim with a path
        var pattern = "nvim";
        const fullResult = Text.replace(pattern,'');
        return [
            [
                {
                    Icon: 'code-symbolic', 
                    Title: 'Neovim', 
                    Description: `Open neovim with: ${fullResult}`, // TODO read todo above
                    className: 'app-math'
                },
                () => { //OnActivate
                    execAsync(['bash', '-c', `kitty nvim ${fullResult}`, `&`]).catch(print); //Copy the math result to clipboard
                },
            
            ]
        ]
    }else if(Text.includes("ncode")) { //EXPLANATION: clone of the top until i delete konsole
        var pattern = "ncode";
        const fullResult = Text.replace(pattern,'');
        return [
            [
                {
                    Icon: 'code-symbolic', 
                    Title: 'Neovim', 
                    Description: `Open neovim with: ${fullResult}`, // TODO read todo above
                    className: 'app-math'
                },
                () => { //OnActivate
                    execAsync(['bash', '-c', `kitty nvim ${fullResult}`, `&`]).catch(print); //Copy the math result to clipboard
                },
            
            ]
        ]
    }  else if (startsWithPrefix(Text)) {
        var pattern = />/;
        const fullResult = Text.replace(/>/,'');
        return [
            [
                {
                    Icon: 'org.gnome.Console-symbolic', 
                    Title: 'Execute command', 
                    Description: `Run ${fullResult} as a command`,
                    className: 'app-math'
                },
                () => { //OnActivate
                    execAsync(['bash', '-c', `${fullResult}`, `&`]).catch(print); //Copy the math result to clipboard
                },
            
            ]
        ]
    }
    
    return [] //worst case scenario: return empty list
}

