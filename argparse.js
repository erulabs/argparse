"use strict";
// Useage: argparse --whiches arguments -doer="we" matcher

var args = process.argv.slice(2);

var things_we_do = {
    "whiches": {
        "input": true
    },
    "doer": {
        "input": true
    },
    "matcher": {
        "input": false
    }
};

things_we_do.whiches.action = function (inputs) {
    console.log('the witches fucntion has been called with these inputs: ', inputs);
};

things_we_do.doer.action = function (inputs) {
    console.log('doer function has bene called with these inputs: ', inputs);
};

things_we_do.matcher.action = function () {
    console.log('matcher function has been called');
};

for (var i = 0; i < args.length; i++) {
    var arg = args[i];
    if(arg.indexOf('=') > -1) {
        var parts = []
        parts = arg.split('=')
        // console.log('found = and parts are now ', parts)
        var inputs = parts[1]
        arg = parts[0]
    }
    if (arg.substring(0,2) === "--") {
        var data_index = i + 1
        var data = args.splice(data_index, 1)
        // console.log('found data: ', data)
        var inputs = data
        // console.log('dashes matched')
        arg = arg.substring(2)
        // console.log(arg)
    } else if (arg.substring(0,1) === "-") {
        // console.log('dash matched')
        arg = arg.substring(1)
        // console.log(arg)
    } else {
        // console.log(arg)
    }
    if (typeof things_we_do[arg] !== 'undefined' && things_we_do[arg].input === true) {
        console.log(arg, 'takes input')
        things_we_do[arg]['action'](inputs)
    } else {
        console.log(arg, 'does not take input')
        things_we_do[arg]['action']()
    }
}

console.log(args)
