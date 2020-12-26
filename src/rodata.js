const { names } = require('./imgflip');
const prefices = 
        ['meme'
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
let mkRndPrf = () => prefices[~~(Math.random()) * prefices.length];

const helpStr = `
Commands:
    \`!meme {template} <caption 1> <caption 2>...\` - make a meme
    \`!preview {template}\` - check out a template without any text
    \`!list\` - list top 50 memes
    \`!list2\` - list top 50 - 100 memes
    \`!lookup {query} \` - search for a meme template (js regex supported)
    \`!help\` - print this help message 
    \`!remindme {length (secs|mins|hours|days)} <reminder>\` - remind the channel about something
    
    preview/list/lookups are ephemeral - they'll delete themselves after a minute
`

const NONAME = ['error: no meme specified. Type `list` to see what\'s available.'];

const prefix = '!';

const brackRegex = /(?<cmd>!(meme|list[2-9]?|preview|help|lookup|remindme)) ?({(?<name>.*)})? ?((?<args><.*>)*)?/g;
const argsRegex = /(<(?<argv>[^<>]*)>)+/g;

let searchRegex = (query) => {
    let tester = RegExp(query);
    let filtered = [...names.keys()].filter(tester.test.bind(tester)).slice(0, 11);
    return 'search output.... \ntemplates: *[text box count]*\n' + filtered.map(name => `**${name} [${names.get(name)[1]}]**`).join('\n');
}

const deletables = new Map(
    [ ['!preview', 10000]
    , ['!lookup', 60000]
    , ['!list', 60000]
    , ['!list2', 60000]
    ]
);

module.exports = {
    mkRndPrf,
    helpStr,
    NONAME,
    prefix,
    brackRegex,
    argsRegex,
    searchRegex,
    deletables,
}