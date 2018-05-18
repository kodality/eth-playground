// Allows us to use ES6 in our migrations and tests.
require('babel-register');

let host = 8545;
if (process.env.ETH_HOST) {
    host = process.env.ETH_HOST;
}

module.exports = {
    networks: {
        development: {
            host: host,
            port: 8545,
            network_id: '*', // Match any network id
            gas: 9000000000, // should be lower than gasLimit in genesis config
            from: '0x8432885e624a8d15c9774cbada102c08957887ca'
        }
    }
};
