
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
    let words = ['meme'
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
        , 'https://nliu.net'
        , 'uwu'
        , 'owo'
        , '[object Object]'
        , 'undefined'
        , 'await meme;'
        , 'fast n furious'
        , 'nnneeeeooooom'
        , 'https://www.github.com/dreamsmasher/memebot'
    ];
    return words[~~(Math.random() * words.length)];
};
const NONAME = 'error: no meme specified. Type `list` to see what\'s available.';
// let inBracks = /(?<cmd>!(meme|list|help)) ?{(?<name>.*)} ?(<(?<args>.*)>)*/g;
let brackRegex = /(?<cmd>!(meme|list[2-9]?|preview|help|lookup)) ?({(?<name>.*)})? ?((?<args><.*>)*)?/g;
let argsRegex = /(<(?<argv>[^<>]*)>)+/g;

let matchCmd = (msg) => [...msg.content.matchAll(brackRegex)][0]?.groups;

let matchArgs = (args) => {
    args = args ?? '';
    return args.length ? ([...args.matchAll(argsRegex)].map(a => a?.groups?.argv)) : [' '];
};

let searchRegex = (query) => {
    let tester = RegExp(query);
    let filtered = [...names.keys()].filter(tester.test.bind(tester)).slice(0, 11);
    return 'search output.... \ntemplates: *[text box count]*\n' + filtered.map(name => `**${name} [${names.get(name)[1]}]**`).join('\n');
}

let getFmt = (l, r) => 'valid templates: *[text box count]*\n' + [...names.keys()].slice(l, r).map(name => `**${name} [${names.get(name)[1]}]**`).join('\n');

let getImg = (name, args) => {
    return mkMeme(name.toLowerCase(), matchArgs(args))
        .then(url => [mkRndPrf(), { files: [url] }])
        .catch(err => console.log(err));
};

let fmtMsg = (cmd, name, args) => {
    switch (cmd) {
        case '!meme':
            console.log('meme request: ', name, args);

            return (name ? getImg(name, args ?? '') : NONAME);
        case '!preview':
            return (name ? getImg(name, '') : NONAME); // generate the meme as is

        case '!list':
            return [getFmt(0, 50)];
        case '!list2':
            return [getFmt(50, 100)];
        case '!help':
            return [helpStr];
        case '!lookup':
            return (name ? [searchRegex(name)] : NONAME)
        default:
            return ['invalid command, you donkey'];
    }
};

const handleMsg = async (msg) => {
    try {
        if (!msg.content.startsWith(prefix) || msg.author.bot) return;

        let m = matchCmd(msg);
        if (m === undefined) return;

        let { cmd, name, args } = m;

        if (name === undefined) {
            msg.channel.send('no meme specified??????')
        }
        let msgArgs = await fmtMsg(cmd, name, args);
        msg.channel.send.apply(msg.channel, msgArgs);


    } catch (err) {
        console.log(err);
        // msg.channel.send('unexpected error, big big sorry', err);
        return;
    }
}

module.exports = {
    handleMsg
}
