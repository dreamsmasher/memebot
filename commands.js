
const { mkMeme, sendImg, names } = require('./imgflip');
const prefix = '!';
const helpStr = `
Commands:
    !meme [description] [top text] [bottom text] - make a meme
    !list - list top 50 memes
    !list2 - list top 50 - 100 memes

Syntax:
    !meme {meme name} <caption1> <caption2>...
    the braces are mandatory! (parser is just regex pls no bully)`;


// let inBracks = /(?<cmd>!(meme|list|help)) ?{(?<name>.*)} ?(<(?<args>.*)>)*/g;
let brackRegex = /(?<cmd>!(meme|list|help)) ?({(?<name>.*)})? ?((?<args><.*>)*)?/g;
let argsRegex = /(<(?<argv>[^<>]*)>)+/g;

let matchCmd = (msg) => [...msg.content.matchAll(brackRegex)][0]?.groups;
let matchArgs = (args) => [...args.matchAll(argsRegex)].map(a => a?.groups?.argv);

const handleMsg = (msg) => {
    try {
        if (!msg.content.startsWith(prefix) || msg.author.bot) return;
        let {cmd, name, args} = matchCmd(msg);

        switch (cmd) {
            case '!meme':
                console.log('meme request: ',name, args);
                if (name) {
                    mkMeme(name.toLowerCase(), matchArgs(args))
                        .then(url => sendImg(msg, url))
                        .catch(err => msg.channel.send('Error making your meme: ', err));
                } else {
                    msg.channel.send('error: no meme specified. Type `list` to see what\'s available.');
                }
                break;
            case '!list':
                msg.channel.send('valid templates:\n' + [...names.keys()].slice(0, 50).join('\n'));
                break;
            case '!list2':
                msg.channel.send('valid templates:\n' + [...names.keys()].slice(50, 101).join('\n'));
                break;
            case '!help':
                msg.channel.send(helpStr);
                break;
            default:
                msg.channel.send('invalid command, you donkey');
                break;
        }
    } catch (err) {
        msg.channel.send('unexpected error, sorry sorry');
    }
}

module.exports = {
    handleMsg
}
