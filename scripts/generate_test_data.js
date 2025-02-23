const fs = require("fs");

try {fs.mkdirSync("../packages/btc_txid_claim_handler/tests/data")} catch(e) {}
require("./tests/btc_txid_claim_handler");
console.log("Generated test data for: btc_txid_claim_handler");

try {fs.mkdirSync("../packages/btc_output_claim_handler/tests/data")} catch(e) {}
require("./tests/btc_output_claim_handler");
console.log("Generated test data for: btc_output_claim_handler");

try {fs.mkdirSync("../packages/btc_nonced_output_claim_handler/tests/data")} catch(e) {}
require("./tests/btc_nonced_output_claim_handler");
console.log("Generated test data for: btc_nonced_output_claim_handler");

try {fs.mkdirSync("../packages/timelock_refund_handler/tests/data")} catch(e) {}
require("./tests/timelock_refund_handler");
console.log("Generated test data for: timelock_refund_handler");

try {fs.mkdirSync("../packages/hashlock_claim_handler/tests/data")} catch(e) {}
require("./tests/hashlock_claim_handler");
console.log("Generated test data for: hashlock_claim_handler");

try {fs.mkdirSync("../packages/btc_relay/tests/data")} catch(e) {}
require("./tests/btc_relay");
console.log("Generated test data for: btc_relay");
