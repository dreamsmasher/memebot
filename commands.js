
const { mkMeme, sendImg } = require('./imgflip');

const handleMsg = (msg) => {
    if (!msg.content.startsWith(prefix) || msg.author.bot) return;
    let args = msg.content.slice(prefix.length).trim().split(' ');
    let cmd = args.shift().toLowerCase();

    switch (cmd) {
        case 'meme':
            mkMeme.apply(args)
                .then(url => sendImg(msg, url))
                .catch(err => msg.send('Error in communicating with imgflip API', err));
            break;
        case 'list':
            msg.send('valid templates:\n', names.keys().slice(0, 50).join('\n'));
            break;
        default:
            msg.send('invalid command, you donkey');
            break;
    }
}

module.exports = {
    handleMsg
}