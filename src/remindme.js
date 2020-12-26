let parseRemind = function (timeStr) {
  let timeRegex = /(?<len>[0-9]+) (?<unit>(sec|min|hour|day))s?/gi;
  let matched = [...timeStr.matchAll(timeRegex)][0]?.groups;
  if (matched === undefined) return;

  let lens = {
    sec: 1000,
    min: 60000,
    hour: 360000,
    day: 8640000,
  }

  //10 min || at 3:00

  //allow datetime format

  let len = (Number(matched.len ?? '0') * lens[matched.unit]) ?? 0;
  return len;


}

module.exports = {
  parseRemind
};