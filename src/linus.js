const axios = require('axios');
const process = require('process');

class CircBuf {
    constructor(n) {
        this._arr = new Array(n);
        this._h = 0;
        this._t = 0;
        this._len = n;
        this._size = 0;
    }
    
    enque(x) {
        this._arr[this._h++] = x;
        this._h %= this._len;
        ++this._size;
        return;
    }
    
    deque() {
        let x = this._arr[this._t++];
        this._t %= this._len;
        --this._size;
        return x;
    }
    
    size() {
        return this._size;
    }
}

let getAPIUrls = () => {
    return process.env.LINUS_API?.split(',')?.map(s => `http://api.${s}`);
}

const apis = getAPIUrls();

console.log(apis);
             
const rants = new CircBuf(64);


let getRant = 
module.exports = {

}