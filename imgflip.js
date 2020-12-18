const process = require('process');
const Imgflip = require('imgflip');

let ACCT_INFO;
if (process.env.DEV === 'true') {
    ACCT_INFO = require('./config/config').ACCT_INFO;
} else {
    ACCT_INFO = {
        username: process.env.IMGFLIP_USERNAME,
        password: process.env.IMGFLIP_PASSWORD,
    };
}

const imgflip = new Imgflip.default(ACCT_INFO);

let names = new Map();

let updateNames = async () => {
    return imgflip.memes()
        .then(resp => {
            resp.forEach(obj => {
                let { id, name } = obj;
                names.set(name.toLowerCase(), id);
            });
            console.log("imgFlip db loaded.")

        }).catch(err => console.log('Error updating memes...'));
        
};

(async () => {
    try {
        await updateNames();
        console.log('names loaded');
        setTimeout(updateNames, 86400000);
    } catch (err) {
        console.log(err);
    }
})();



let mkMeme = (name, ...args) => {
    let id = names.get(name);
    return new Promise((res, rej) => {
        if (id === undefined) {
            rej("Invalid name specified.")
        }
        res(imgflip.meme(id, {
            captions: args,
        }));
    })
};

let sendImg = (message, url) => {
    message.channel.send('meme', {
        files: [url],
    })
};

module.exports = {
    mkMeme,
    sendImg,
    names,
}