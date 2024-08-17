// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.7.0 <0.9.0;

contract ProjectKeychain0 {

    /////////////////////////////
    // CONSTANTS AND VARIABLES //
    /////////////////////////////
    string constant private _name = "Project Keychain 0";
    address public immutable i_architect;

    struct KeychainHolder {
        uint256 joiningTimestamp;
        uint256 keyChainCount;
        address holderAddress;  // the key holder
        bytes holderUsername;
    }
    struct Keychain {
        uint256 keychainSerialId; 
        uint256 creationTimestamp;
        address holderAddress;
        bytes keyIdentifier;
        bytes keySecret;
    }

    mapping (address => mapping(uint256 => Keychain)) private addressToKeychain;
    mapping (address => KeychainHolder) private addressToKeychainHolder;


    event NewKeychainHolder (address indexed _holderAddress, string indexed _holderUsername);
    event NewKeychain (address indexed _holderAddress);
    event KeychainUpdated (address indexed _holderAddress);

    
    modifier callerIsHolder (address _holderAddress) {
        require(_holderAddress == msg.sender, "Caller is not the keychain holder address!");
        _;
    }

    modifier holderExists (address _holderAddress) {
        require(addressToKeychainHolder[_holderAddress].joiningTimestamp > 0 &&
                addressToKeychainHolder[_holderAddress].holderAddress != address(0),
                "Holder address does not exist!");
        _;
    }

        modifier holderDoesNotExist (address _holderAddress) {
        require(addressToKeychainHolder[_holderAddress].joiningTimestamp == 0 &&
                addressToKeychainHolder[_holderAddress].holderAddress == address(0),
                "Holder with this address already exists!");
        _;
    }

    constructor(address _architect) {
            require(_architect != address(0), "Architect cannot be zero address");
            require(_architect == msg.sender, "Architect must send the init tx");
            // require(bytes32(keccak256(abi.encodePacked(_architect, msg.sender))).length == 64, "Architect and signer must share a 64 byte hash");
            
            i_architect = _architect; 
    }

    function createNewKeychainHolder (address _holderAddress, bytes memory _holderUsernameBytes) external callerIsHolder(_holderAddress) holderDoesNotExist(_holderAddress) {
        KeychainHolder memory newHolder = KeychainHolder({
                joiningTimestamp: block.timestamp,
                keyChainCount: 0,
                holderAddress: _holderAddress,
                holderUsername: _holderUsernameBytes
        });
        addressToKeychainHolder[_holderAddress] = newHolder;
        emit NewKeychainHolder(_holderAddress, string(_holderUsernameBytes));
    }

    function createNewKeychain (address _holderAddress, bytes memory _keyIdentifier, bytes memory _keySecret) external callerIsHolder(_holderAddress) holderExists(_holderAddress) {
        uint256 newKeyChainSerialId = addressToKeychainHolder[_holderAddress].keyChainCount;
        Keychain memory newKeychain = Keychain({
            keychainSerialId: newKeyChainSerialId,
            creationTimestamp: block.timestamp,
            holderAddress: _holderAddress,
            keyIdentifier: _keyIdentifier,
            keySecret: _keySecret
        });
        addressToKeychain[_holderAddress][newKeyChainSerialId] = newKeychain;
        addressToKeychainHolder[_holderAddress].keyChainCount += 1;
        emit NewKeychain(_holderAddress);
    }

    function updateKeychainSecret (address _holderAddress, uint256 _newKeyChainSerialId, bytes memory _keySecret) external callerIsHolder(_holderAddress) holderExists(_holderAddress) {
        // uint256 newKeyChainSerialId = addressToKeychainHolder[_holderAddress].keyChainCount;
        // Keychain memory newKeychain = Keychain({
        //     keychainSerialId: newKeyChainSerialId,
        //     creationTimestamp: block.timestamp,
        //     holderAddress: _holderAddress,
        //     keyIdentifier: _keyIdentifier,
        //     keySecret: _keySecret
        // });
        addressToKeychain[_holderAddress][_newKeyChainSerialId].keySecret = _keySecret;
        // addressToKeychainHolder[_holderAddress].keyChainCount += 1;
        emit KeychainUpdated(_holderAddress);
    }

    function test(string memory input) public pure returns(bytes memory) {
        return bytes(input);
    }

    function getKeychainHolderDetails (address _holderAddress) public view returns (KeychainHolder memory) {
        require(_holderAddress != address(0), "Holder address cannot be zero address");
        return addressToKeychainHolder[_holderAddress];
    }

    function getAllKeychainsByHolder (address _holderAddress) public view callerIsHolder(_holderAddress) returns (Keychain[] memory) {
        require(_holderAddress != address(0), "Holder address cannot be zero address");
        uint256 keyChainCount = addressToKeychainHolder[_holderAddress].keyChainCount;
        require(keyChainCount > 0, "Holder does not have any keychains");
        Keychain[] memory keychains = new Keychain[](keyChainCount);
        for (uint256 i = 0; i < keyChainCount; i++) {
            keychains[i] = addressToKeychain[_holderAddress][i];
        }
        return keychains;
    }

    function getKeychainDetailsById (address _holderAddress, uint256 keychainSerialId) public view callerIsHolder(_holderAddress) returns (Keychain memory) {
        require(_holderAddress != address(0), "Holder address cannot be zero address");
        return addressToKeychain[_holderAddress][keychainSerialId];
    }

}s