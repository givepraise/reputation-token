### Table of Contents
- [ReputationToken](#reputationtoken)
  - [Functionality](#functionality)
    - [Initialization](#initialization)
    - [Burning Tokens](#burning-tokens)
    - [Minting Tokens](#minting-tokens)
    - [Setting Transferability](#setting-transferability)
  - [Methods](#methods)
    - [`initialize(string memory _name, string memory _symbol, uint8 _decimals, address _owner, bool _transferable, bool _burnable)`](#initializestring-memory-_name-string-memory-_symbol-uint8-_decimals-address-_owner-bool-_transferable-bool-_burnable)
    - [`burn(address _account, uint256 _amount)`](#burnaddress-_account-uint256-_amount)
    - [`mint(address _account, uint256 _amount)`](#mintaddress-_account-uint256-_amount)
    - [`mintMany(MintData[] memory _data)`](#mintmanymintdata-memory-_data)
    - [`setTransferable(bool _flag)`](#settransferablebool-_flag)
  - [Events](#events)
    - [`TransferableSet(bool _flag)`](#transferablesetbool-_flag)
  - [Thrown Errors](#thrown-errors)
- [ReputationTokenFactory](#reputationtokenfactory)
  - [Methods](#methods-1)
    - [`initialize(address _owner)`](#initializeaddress-_owner)
    - [`createToken(string memory _name, string memory _symbol, uint8 _decimals, bool _transferable, bool _burnable)`](#createtokenstring-memory-_name-string-memory-_symbol-uint8-_decimals-bool-_transferable-bool-_burnable)
    - [`updateTokenImplementation(address _tokenImplementation)`](#updatetokenimplementationaddress-_tokenimplementation)
  - [Events](#events-1)
    - [`event TokenCreated(address _token)`](#event-tokencreatedaddress-_token)
    - [`event TokenImplementationUpdated(address indexed tokenImplementation`](#event-tokenimplementationupdatedaddress-indexed-tokenimplementation)

# ReputationToken
This contract is a ERC20Votes token with additional functionality. The Owner can burn tokens, if burnable is true and mint tokens. The Owner can also set whether the token is transferable or not.


## Functionality
### Initialization
The `initialize` function is called after the deployment of the contract and sets up the basic properties of the token such as the name, symbol, decimals, owner, and whether the token is transferable and burnable. This function can only be called once and is protected by the initializer modifier.

### Burning Tokens
The `burn` function allows the owner of the contract to burn tokens from a specified account. This function can only be called when the burnable property is set to true. The function checks if the specified account has enough tokens to burn and if the address passed is not the zero address. If all checks pass, the _burn internal function is called to burn the specified amount of tokens.

### Minting Tokens
The `mint` function allows the owner of the contract to mint tokens to a specified account. This function calls the internal _mint function to mint the specified amount of tokens.

The `mintMany` function allows the owner of the contract to mint tokens to multiple accounts at once. It takes in an array of MintData structs, which contain the account and amount to mint to. The function then iterates through the array and calls the internal _mint function for each struct.

### Setting Transferability
The `setTransferable` function allows the owner of the contract to set whether the token is transferable or not. The function takes in a boolean flag and sets the transferable property accordingly. An event, TransferableSet, is emitted with the new flag value.


## Methods
### `initialize(string memory _name, string memory _symbol, uint8 _decimals, address _owner, bool _transferable, bool _burnable)`
Initializer for the ReputationToken contract.

- `_name`: The name of the token.
- `_symbol`: The symbol of the token.
- `_decimals`: The number of decimals of the token.
- `_owner`: The owner of the token.
- `_transferable`: Whether the token is transferable.
- `_burnable`: Whether the token is burnable.

### `burn(address _account, uint256 _amount)`
Burns tokens from the specified account. Can only be called by owner when burnable is set to true.

- `_account`: The account to burn tokens from.
- `_amount`: The amount of tokens to burn.

### `mint(address _account, uint256 _amount)`
Mints tokens to a specified account. Can only be called by owner.

- `_account`: The account to mint tokens to.
- `_amount`: The amount of tokens to mint.

### `mintMany(MintData[] memory _data)`
Mints tokens to multiple accounts. Can only be called by owner.
  ```
  struct MintData {
    address account;
    uint256 amount;
  }
  ```

- `_data`: The data to mint tokens to multiple accounts.

### `setTransferable(bool _flag)`
Sets whether the token is burnable or not.

`_flag`: Whether the token is burnable or not.

## Events
### `TransferableSet(bool _flag)`
Triggered when the transferable flag is set.

`_flag`: The new value of the transferable flag.


## Thrown Errors
`NotBurnable`: Thrown when the burn function is called when the burnable flag is set to false.
`NotEnoughTokens`: Thrown when the burn function is called with an amount greater than the balance of the specified account.
`ZeroAddress`: Thrown when the burn function is called with an address of 0.
`NotTransferable`: Thrown when the _transfer function is called and the transferable flag is set to false.


# ReputationTokenFactory
This contract is a factory for creating proxy instances of the ReputationToken contract. It allows anyone to deploy new instances of the ReputationToken contract.

## Methods

### `initialize(address _owner)`
Initializer for the ReputationTokenFactory contract.
- `_owner`: Owner of the factory contract.

### `createToken(string memory _name, string memory _symbol, uint8 _decimals, bool _transferable, bool _burnable)`
Allows anyone to create new instances of the ReputationToken contract. It takes in the following parameters:
- `_name`: The name of the token
- `_symbol`: The symbol of the token
- `_decimals`: The number of decimals of the token
- `_transferable`: A boolean that determines whether the token is transferable or not
- `_burnable`: A boolean that determines whether the token is burnable or not

### `updateTokenImplementation(address _tokenImplementation)`
Updates the implementation contract for future token creations.
- `_tokenImplementation`: Address of the new implementation.
## Events
### `event TokenCreated(address _token)`
Triggered when a new instance of the ReputationToken contract is deployed.

### `event TokenImplementationUpdated(address indexed tokenImplementation`
Triggered when the implementation is updated.