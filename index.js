const process = require('process');
const Discord = require('discord.js');
const client = new Discord.Client();
let TOKEN, PERMISSIONS;
const { handleMsg } = require('./src/commands');

if (process.env.DEV === 'true') {
  let { token, permissions } = require('./config/config').DISCORD_INFO;
  TOKEN = token;
  PERMISSIONS = permissions;
} else {
  TOKEN = process.env.DISCORD_TOKEN;
  PERMISSIONS = process.env.DISCORD_PERMS;
}

// const {DISCORD_INFO, ACCT_INFO} = require('./config/config.js');
// const {token, permissions, prefix} = DISCORD_INFO;
client.login(TOKEN);

client.once('ready', () => console.log('logged in'));

client.on('message', handleMsg);
