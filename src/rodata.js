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
        , 'uwu'
        , 'owo'
        , '[object Object]'
        , 'undefined'
        , 'await meme;'
        , 'fast n furious'
        , 'nnneeeeooooom'
        ];
let mkRndPrf = () => prefices[~~(Math.random()) * prefices.length];

const helpStr = `
Commands:
<<<<<<< HEAD
    \`$meme {template} <caption 1> <caption 2>...\` - make a meme
    \`$preview {template}\` - check out a template without any text
    \`$list\` - list top 50 memes
    \`$list2\` - list top 50 - 100 memes
    \`$lookup {query} \` - search for a meme template (js regex supported)
    \`$help\` - print this help message 
    \`$remindme {length (secs|mins|hours|days)} <reminder>\` - remind the channel about something
    \`$asm {prog}\` - evaluate a simple stack machine program. enter $asm without any arguments to see the syntax.
    \`$about\` - credits and contact info for bugs
    
=======
    \`!meme {template} <caption 1> <caption 2>...\` - make a meme
    \`!preview {template}\` - check out a template without any text
    \`!list\` - list top 50 memes
    \`!list2\` - list top 50 - 100 memes
    \`!lookup {query} \` - search for a meme template (js regex supported)
    \`!help\` - print this help message
    \`!remindme {length (secs|mins|hours|days)} <reminder>\` - remind the channel about something
    \`asm {prog}\` - evaluate a simple stack machine program. enter !asm without any arguments to see the syntax.
     
    the punctuation is literal!
>>>>>>> 52153a85c24f94c904211c65f352dcdcef9466bd
    preview/list/lookups are ephemeral - they'll delete themselves after a minute
`

const about = `
memebot is a discord bot written in \`node.js\`, using the \`discord\` and \`imgflip\` apis

https://github.com/dreamsmasher/memebot
https://nliu.net
https://www.3hz.io
`

const asmHelp = `
the https://nliu.net ™ stack machine consists of 2 registers: R0, R1, and a stack.

assembly syntax consists of line/semicolon separated statements, of the form
    \`op ::= mov <int> | <cmd>\`
    where \`cmd ::= push | pop | swp | add | mul | sub | div\`

the operations are as follows:
    \`mov [int]\` - move a constant value into R0
    \`push\` - push R0 onto the stack
    \`pop\` - pop the top value of the stack into R0
    \`swp\` - swap R0 and R1
    \`add\` - add R0 and R1, storing in R0
    \`sub\` - sub R1 from R0, storing in R0
    \`mul\` - mul R0 and R1, storing in R0
    \`div\` - div R0 by R1, storing in R0

example: 
\`\`\`$asm {
    mov 3;
    push;
    mov 5;
    push;
    mov 7;
    swp;
    pop;
    mul;
    swp;
    pop;
    add;
}\`\`\`
will evaluate to \`38\`.
`
const NONAME = ['error: no meme specified. Type `list` to see what\'s available.'];

const prefix = '$'

const brackRegex = /(?<cmd>\$(meme|list[2-9]?|preview|help|lookup|remindme|asm|about)) ?({(?<name>.*)})? ?((?<args><.*>)*)?/g;
const argsRegex = /(<(?<argv>[^<>]*)>)+/g;

let searchRegex = (query) => {
    let tester = RegExp(query);
    let filtered = [...names.keys()].filter(tester.test.bind(tester)).slice(0, 11);
    return 'search output.... \ntemplates: *[text box count]*\n' + filtered.map(name => `**${name} [${names.get(name)[1]}]**`).join('\n');
}

const deletables = new Map(
    [ ['$preview', 10000]
    , ['$lookup', 60000]
    , ['$list', 60000]
    , ['$list2', 60000]
    , ['$about', 60000]
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
    asmHelp,
    about,
}
