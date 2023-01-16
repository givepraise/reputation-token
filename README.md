# Reputation Token and Token Factory
The TokenFactory contract has one non-restricted function `create` to create new ReputationToken contracts. 
To create a new token you have to pass the following parameter:
```
string memory _name,    // The name of the token
string memory _symbol,  // The symbol of the token
uint8 _decimals,        // The number of decimals of the token
address _owner,         // The owner of the token
bool _transferable      // Whether the token is transferable
bool _burnable          // Whether the token is burnable
```
The ReputationToken itself is based on OpenZeppelins ERC20Vote extension. The constructor takes the same parameters described above. Beside the general token functions, mint, checkpoints, delegation and permit are also transfer and burn locks implemented.
The transfer lock can be enabled and disabled by the owner at any time. The burn lock is set in constructor and can't be changed afterwards.

# Installation
To install all dependencies, please run:
```
npm install
```

# Test
You can run all test cases with the following comment:
```
npm test
```