
const { mkMeme, sendImg, names } = require('./imgflip');
const prefix = '!';

let inQuotes = /(?<cmd>!(meme|list|help)?)(?<name> "[A-Za-z ]+")(?<args>(( "(?:[^"\\]|\\.)+"))*)/gi;
let matchArgs = (s) => {
    s = s.trim();
    let res = [];
    let p = 1;
    let acc = '';
    while ( p < s.length) {
        if (s[p] === '"') {
            res.push(acc);
            acc = '';
        } else {
            acc += s[p];
        }
        p++;
    }
    return res;
}

// let s = `!meme "american chopper argument" "what is this" "who are you"`
// console.log(inQuotes.exec(s));
const handleMsg = (msg) => {
    if (!msg.content.startsWith(prefix) || msg.author.bot) return;
    // let args = msg.content.slice(prefix.length).trim().split(' ');
    // let cmd = args.shift().toLowerCase();
    console.log([...msg.content.matchAll(inQuotes)]);
    return;
    cmd = cmd.slice(1).toLowerCase();
    switch (cmd) {
        case 'meme':
            console.log('NAME:', name, 'ARGS', args);
            mkMeme(name, args)
                .then(url => sendImg(msg, url))
                .catch(err => msg.channel.send('Error making your meme: ', err));
            break;
        case 'list':
            msg.channel.send('valid templates:\n' + [...names.keys()].slice(0, 50).join('\n'));
            break;
        case 'help':
            let helpStr = `
                Commands:
                    meme [description] [top text] [bottom text] - make a meme
                    list - list top 50 memes
            `
            msg.channel.send(helpStr);
        default:
            msg.channel.send('invalid command, you donkey');
            break;
    }
}

module.exports = {
    handleMsg
}