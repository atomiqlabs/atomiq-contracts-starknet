const tests = [
	"main_chain",
	"main_chain_diff_adjustment",
	"fork_chain",
	"fork_chain_chainwork",
	"fork_chain_not_enough_length",
	"fork_chain_not_enough_chainwork",
	"block_invalid_pow",
	"block_invalid_nbits",
	"block_invalid_nbits_diff_adjustment",
	"block_invalid_prev_block",
	"block_invalid_median_timestamp",
	"block_invalid_future_timestamp"
];

for(let test of tests) {
    require("./tests/"+test);
    console.log("Populated data for "+test+" test!");
}
