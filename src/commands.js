
const { mkMeme, names } = require('./imgflip');
const ro = require('./rodata');
const { parseRemind } = require('./remindme');
const { evalAsm } = require('./asm');


let matchCmd = (msg) => [...msg.content.matchAll(ro.brackRegex)][0]?.groups;

let matchArgs = (args) => {
  args = args ?? '';
  return args.length ? ([...args.matchAll(ro.argsRegex)].map(a => a?.groups?.argv)) : [' '];
};

let getFmt = (l, r) => 'valid templates: *[text box count]*\n' + [...names.keys()].slice(l, r).map(name => `**${name} [${names.get(name)[1]}]**`).join('\n');

let getImg = (name, args) => {
  return mkMeme(name.toLowerCase(), matchArgs(args))
    .then(url => [ro.mkRndPrf(), { files: [url] }])
    .catch(err => console.log(err));
};

let fmtMsg = (cmd, name, args) => {
  let res;
  switch (cmd) {
    case '!meme':
      console.log('meme request: ', name, args);

      res = (name ? getImg(name, args ?? '') : ro.NONAME);
      break;
    case '!preview':
      res = (name ? getImg(name, '') : ro.NONAME); // generate the meme as is
      break;
    case '!list':
      res = [getFmt(0, 50)];
      break;
    case '!list2':
      res = [getFmt(50, 100)];
      break;
    case '!help':
      res = [ro.helpStr];
      break;
    case '!lookup':
      res = (name ? [ro.searchRegex(name)] : ro.NONAME);
      break;
    case '!remindme':
      if (!(name || args)) {
        res = [''];
      } else {
        let len = parseRemind(name); // name: {time units} <reminder>
        res = new Promise(resv => setTimeout(() => resv([`reminder: **${matchArgs(args).join(' ')}**`]), len));
      }
      break;
    case '!asm':
      if (name) {
        res = ['' + evalAsm(name)];
      } else {
        res = [ro.asmHelp];
      }
      break;
    default:
      res = ['invalid command, you donkey'];
      break;
  }

  return Promise.resolve(res);
};

const handleMsg = (msg) => {
  if (!msg.content.startsWith(ro.prefix) || msg.author.bot) return;

  let m = matchCmd(msg);
  if (m === undefined) return;

  let { cmd, name, args } = m;

  if (name === undefined && cmd === '!meme') {
    msg.channel.send(ro.NONAME);
    return;
  }

  let del = msg => {
    let t = ro.deletables.get(cmd);  
    if (t === undefined) {
      return null;
    }
    return msg.delete({timeout: t});
  };

  fmtMsg(cmd, name, args, msg)
    .then(res => {
      if (res && res[0]?.length) {
        return msg.channel.send.apply(msg.channel, res);
      }
    })
    .then(del)
    .catch(err => console.log(err));

}
module.exports = {
  handleMsg
}