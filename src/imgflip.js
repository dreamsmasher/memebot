const process = require('process');
const Imgflip = require('imgflip');

let ACCT_INFO;
if (process.env.DEV === 'true') {
    ACCT_INFO = require('../config/config').ACCT_INFO;
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
                let { id, name, box_count } = obj;
                names.set(name.toLowerCase(), [id, box_count]);
            });
            console.log("imgFlip db loaded.")
        }).catch(err => console.log('error updating memes...'));
};

var schedUpdate = async () => {
    try {
        await updateNames();
        console.log('names loaded');
        setTimeout(schedUpdate, 86400000);
    } catch (err) {
        console.log(err);
    }
};

schedUpdate();

let mkMeme = (name, args) => {
    let id = names.get(name)[0];
    return new Promise((res, rej) => {
        if (id === undefined) {
            rej("invalid name specified.")
        }
        res(imgflip.meme(id, {
            captions: args,
        }));
    })
};

module.exports = {
    mkMeme,
    names,
}