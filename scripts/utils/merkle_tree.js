const crypto = require("crypto");

function dblSha256(valueBuffer) {
    return crypto.createHash("sha256").update(crypto.createHash("sha256").update(valueBuffer).digest()).digest();
}

function generateRoot(value, depth = Math.floor(24*Math.random())) {
    let position = 0;
    let root = Buffer.from([...value]);
    const proof = [];
    for(let i=0;i<depth;i++) {
        const sibling = crypto.randomBytes(32);
        proof.push(sibling);
        const leftOrRight = Math.floor(2*Math.random());
        root = dblSha256(Buffer.concat(leftOrRight==0 ? [
            root, sibling
        ] : [
            sibling, root
        ]));
        position += leftOrRight << i;
    }
    return [root.reverse().toString("hex"), proof.map(e => e.reverse().toString("hex")), position];
}

module.exports = {
    generateRoot
};
