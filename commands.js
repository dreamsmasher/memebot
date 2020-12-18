
const { mkMeme, sendImg, names } = require('./imgflip');
const prefix = '!';

const handleMsg = (msg) => {
    if (!msg.content.startsWith(prefix) || msg.author.bot) return;
    let args = msg.content.slice(prefix.length).trim().split(' ');
    let cmd = args.shift().toLowerCase();

    switch (cmd) {
        case 'meme':
            console.log(args);
            mkMeme.apply(null, args)
                .then(url => sendImg(msg, url))
                .catch(err => msg.channel.send('Error making your meme: ', err));
            break;
        case 'list':
            msg.channel.send('valid templates:\n' + [...names.keys()].slice(0, 50).map(name => { let boxcount = names.name[1]; return `${name}, (${boxcount})` }).join('\n'));
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