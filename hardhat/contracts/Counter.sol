// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.28;

/**
 * @title Counter
 * @author Your Name
 * @notice A production-ready counter smart contract with access control, events, and comprehensive validations
 * @dev This contract implements a counter that can be incremented and decremented with owner-only administrative functions
 */
contract Counter {
    /// @notice The current counter value
    uint public x;

    /// @notice The owner of the contract
    address public owner;

    /// @notice Emitted when the counter is incremented
    /// @param by The amount by which the counter was incremented
    /// @param newValue The new counter value after increment
    event Increment(uint indexed by, uint newValue);

    /// @notice Emitted when the counter is decremented
    /// @param by The amount by which the counter was decremented
    /// @param newValue The new counter value after decrement
    event Decrement(uint indexed by, uint newValue);

    /// @notice Emitted when data is stored by the owner
    /// @param data The data that was stored
    /// @param timestamp The block timestamp when data was stored
    event DataStored(string indexed data, uint256 timestamp);

    /// @notice Emitted when ownership is transferred
    /// @param previousOwner The address of the previous owner
    /// @param newOwner The address of the new owner
    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);

    /// @notice Emitted when the counter is reset by the owner
    /// @param previousValue The counter value before reset
    event CounterReset(uint previousValue);

    /// @notice Custom error for unauthorized access
    /// @param caller The address that attempted the unauthorized action
    error Unauthorized(address caller);

    /// @notice Custom error for invalid input
    /// @param reason The reason for the invalid input
    error InvalidInput(string reason);

    /**
     * @notice Modifier to restrict function access to the contract owner only
     * @dev Reverts with Unauthorized error if caller is not the owner
     */
    modifier onlyOwner() {
        if (msg.sender != owner) {
            revert Unauthorized(msg.sender);
        }
        _;
    }

    /**
     * @notice Constructor that initializes the contract with the deployer as owner
     * @dev Sets the initial counter value to 0 and assigns ownership to the deployer
     */
    constructor() {
        owner = msg.sender;
        emit OwnershipTransferred(address(0), msg.sender);
    }

    /**
     * @notice Increment the counter by 1
     * @dev Public function that anyone can call to increment the counter
     * @dev Emits Increment event with the new value
     */
    function inc() public {
        x++;
        emit Increment(1, x);
    }

    /**
     * @notice Decrement the counter by 1
     * @dev Public function that anyone can call to decrement the counter
     * @dev Reverts if counter would go below zero
     * @dev Emits Decrement event with the new value
     */
    function dec() public {
        require(x > 0, "Counter: cannot decrement below zero");
        x--;
        emit Decrement(1, x);
    }

    /**
     * @notice Increment the counter by a specified amount
     * @param by The amount to increment the counter by
     * @dev Public function that validates input and increments counter
     * @dev Reverts if increment amount is zero or would cause overflow
     * @dev Emits Increment event with the amount and new value
     */
    function incBy(uint by) public {
        require(by > 0, "Counter: increment amount must be greater than zero");
        require(x + by >= x, "Counter: increment would cause overflow");
        x += by;
        emit Increment(by, x);
    }

    /**
     * @notice Decrement the counter by a specified amount
     * @param by The amount to decrement the counter by
     * @dev Public function that validates input and decrements counter
     * @dev Reverts if decrement amount is zero or counter would go below zero
     * @dev Emits Decrement event with the amount and new value
     */
    function decBy(uint by) public {
        require(by > 0, "Counter: decrement amount must be greater than zero");
        require(x >= by, "Counter: cannot decrement below zero");
        x -= by;
        emit Decrement(by, x);
    }

    /**
     * @notice Store data (owner-only function)
     * @param data The data string to store
     * @dev Only the contract owner can call this function
     * @dev Validates that data is not empty
     * @dev Emits DataStored event with the data and timestamp
     */
    function storeData(string memory data) public onlyOwner {
        require(bytes(data).length > 0, "Counter: data cannot be empty");
        emit DataStored(data, block.timestamp);
    }

    /**
     * @notice Reset the counter to zero (owner-only function)
     * @dev Only the contract owner can call this function
     * @dev Emits CounterReset event with the previous value
     */
    function reset() public onlyOwner {
        uint previousValue = x;
        x = 0;
        emit CounterReset(previousValue);
    }

    /**
     * @notice Set the counter to a specific value (owner-only function)
     * @param newValue The new counter value to set
     * @dev Only the contract owner can call this function
     * @dev Emits Increment or Decrement event based on the change
     */
    function setValue(uint newValue) public onlyOwner {
        uint previousValue = x;
        if (newValue > previousValue) {
            uint difference = newValue - previousValue;
            x = newValue;
            emit Increment(difference, x);
        } else if (newValue < previousValue) {
            uint difference = previousValue - newValue;
            x = newValue;
            emit Decrement(difference, x);
        }
        // If newValue == previousValue, no change needed
    }

    /**
     * @notice Transfer ownership of the contract to a new address
     * @param newOwner The address of the new owner
     * @dev Only the current owner can call this function
     * @dev Validates that new owner is not the zero address
     * @dev Emits OwnershipTransferred event
     */
    function transferOwnership(address newOwner) public onlyOwner {
        require(newOwner != address(0), "Counter: new owner cannot be zero address");
        require(newOwner != owner, "Counter: new owner must be different from current owner");
        address previousOwner = owner;
        owner = newOwner;
        emit OwnershipTransferred(previousOwner, newOwner);
    }

    /**
     * @notice Get the current counter value
     * @return The current value of the counter
     * @dev This is a view function that doesn't modify state
     */
    function getValue() public view returns (uint) {
        return x;
    }

    /**
     * @notice Check if an address is the contract owner
     * @param account The address to check
     * @return True if the address is the owner, false otherwise
     * @dev This is a view function that doesn't modify state
     */
    function isOwner(address account) public view returns (bool) {
        return account == owner;
    }
}
