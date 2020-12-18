const process = require('process');
const Imgflip = require('imgflip');
// const {DISCORD_INFO, ACCT_INFO} = require('./config/config.js');
// const {token, permissions, prefix} = DISCORD_INFO;
const Discord = require('discord.js');
const client = new Discord.Client();

const token = process.env.DISCORD_TOKEN;
const permissions = process.env.DISCORD_PERMS;
const prefix = '!';

const ACCT_INFO = {
  username: process.env.IMGFLIP_USERNAME, 
  password: process.env.IMGFLIP_PASSWORD,
};

const imgflip = new Imgflip.default(ACCT_INFO);

let mkMeme = (id, ...args) => {
  return imgflip.meme(id, {
    captions: args,
  });
};

let sendImg = (message, url) => {
  message.channel.send('meme', {
    files: [url],
  })  
};

let names = new Map();

let updateNames = () => {
  imgflip.memes()
    .then(resp => {
      resp.forEach(obj => {
        let {id, name} = obj;
        names.set(name.toLowerCase(), id);
      })
    }).catch(err => console.log('Error updating memes...'));
};

(async () => {
  await updateNames();
  setTimeout(86400000, updateNames);
})();

client.on('ready', () => {
  console.log('logged in.')
});

client.on('message', msg => {
  if (!msg.content.startsWith(prefix) || msg.author.bot) return;
  let args = msg.content.slice(prefix.length).trim().split(' ');
  let cmd = args.shift().toLowerCase();
  switch (cmd) {
    case 'meme':
      mkMeme.apply(args)
        .then(url => sendImg(msg, url))
        .catch(err => msg.send('Error in communicating with imgflip API'));
      break;
    case 'list':
      msg.send('valid templates:\n', names.keys().slice(0, 50).join('\n'));
      break;
    default:
      msg.send('invalid command, you donkey');
      break;
  }

})

