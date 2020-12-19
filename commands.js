
const { mkMeme, names } = require('./imgflip');
const prefix = '!';
const helpStr = `
Commands:
    !meme [description] [top text] [bottom text] - make a meme
    !list - list top 50 memes
    !list2 - list top 50 - 100 memes

Syntax:
    !meme {meme name} <caption1> <caption2>...
    the braces are mandatory! (parser is just regex pls no bully)`;


let mkRndPrf = () => {
    let words = [ 'meme'
                , 'beep'
                , 'boop'
                , 'bloop'
                , 'wow'
                , 'here it is'
                , 'whoop, there it is'
                , 'fresh from the oven'
                , 'u ever heard of a robot before'
                , 'zoooooooooom'
                , 'nyooooooooooom'
                , 'MMMMMMMMMMMMMMMMMMMMMMMMEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWW'
                , 'emem'
                , 'haha lol'
                , 'oops i accidentally sent you a meme... haha'
                , 'whooops wrong chat'
                , 'unless...?'
                , 'maybemaybemaybe'
                , 'nliu.net'
                , 'uwu'
                , 'owo'
                , '[object Object]'
                , 'undefined'
                , 'await meme;'
                ];
    return words[~~(Math.random() * words.length)];
};
// let inBracks = /(?<cmd>!(meme|list|help)) ?{(?<name>.*)} ?(<(?<args>.*)>)*/g;
let brackRegex = /(?<cmd>!(meme|list[2-9]?|help)) ?({(?<name>.*)})? ?((?<args><.*>)*)?/g;
let argsRegex = /(<(?<argv>[^<>]*)>)+/g;

let matchCmd = (msg) => [...msg.content.matchAll(brackRegex)][0]?.groups;
let matchArgs = (args) => [...args.matchAll(argsRegex)].map(a => a?.groups?.argv);
let getFmt = (l, r) => 'valid templates: *[text box count]*\n' + [...names.keys()].slice(l, r).map(name => `**${name} [${names.get(name)[1]}]**`).join('\n');

let fmtMsg = (cmd, name, args) => {
    switch (cmd) {
        case '!meme':
            console.log('meme request: ', name, args);

            if (name) {
                    return mkMeme(name.toLowerCase(), matchArgs(args))
                        .then(url => [mkRndPrf(), {files:[url]}])
                        .catch(console.log.bind(console));
                    // return ['meme', { files: [url] }];
            } else {
                return 'error: no meme specified. Type `list` to see what\'s available.';
            }
        case '!list':
            return [getFmt(0, 50)];
        case '!list2':
            return [getFmt(50, 100)];
        case '!help':
            return [helpStr];
        default:
            return ['invalid command, you donkey'];
    }
};

const handleMsg = async (msg) => {
    try {
        if (!msg.content.startsWith(prefix) || msg.author.bot) return;

        let { cmd, name, args } = matchCmd(msg);
        let msgArgs = await fmtMsg(cmd, name, args);
        console.log(msgArgs);
        // msg.channel.send('FROM DEV: ' + msgArgs);
        msg.channel.send.apply(msg.channel, msgArgs);


    } catch (err) {
        msg.channel.send('unexpected error, big big sorry');
    }
}

module.exports = {
    handleMsg
}
