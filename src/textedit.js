let spongebobify = (s) => [...s.toLowerCase()].map(c => Math.random() < 0.5 ? c.toUpperCase() : c).join('');

module.exports.spongebobify = spongebobify