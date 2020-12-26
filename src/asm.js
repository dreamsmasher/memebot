/*
2 registers - R0, R1
stack - unlimited size (more or less)
push - push R0 onto the stack
pop - pop the top value into R0
swp - swap R0 and R1
add - add r0, r1, store in r0
sub 
mul
div

nah:
// jz - jmp to label in R0 if R1 == 0
// jnz - jmz to label in r0 if R1 != 0

trm ::= number
op ::= <push>|<pop>|<swp>|<add><trm><trm>|<sub><trm><trm>|<mul><trm><trm>|<div><trm><trm>
label ::= number

0:
    push 3
    push 4
    pop 
    swp 
    pop
    add 
    push

*/
    
let evalAsm = (ops) => {
    try {

    let r0 = 0;
    let r1 = 1;
    let st = []; 

    ops = ops.split(/\n|;/g).filter(s => s.length).map(s => s.trim());
        
    let funcs = new Map([
        ['add', (a, b) => a + b],
        ['sub', (a, b) => a - b],
        ['mul', (a, b) => a * b],
        ['div', (a, b) => ~~(a / b)],
    ]);

    for (let expr of ops) {
        let [op, arg] = expr.split(' ');
        switch (op) {
            case 'mov':
                r0 = Number(arg);
                break;
            case 'push':
                st.push(r0);
                break;
            case 'pop':
                r0 = st.pop();
                break;
            case 'swp':
                let tmp = r0;
                r0 = r1;
                r1 = tmp;
                break;
            default:
                r0 = funcs.get(op)(r0, r1);
                break;
        }
    }
    return r0;

    } catch (err) {
        return err;
    }
}

module.exports = {evalAsm};

// prog = `
//     mov 3
//     push 
//     mov 4
//     push
//     pop
//     swp
//     pop
//     add
//     push
//     mov 10
//     swp
//     pop
//     mul
// `

// console.log(evalAsm(prog));