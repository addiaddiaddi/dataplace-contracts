// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "../lib/openzeppelin-contracts/contracts/token/ERC20/IERC20.sol";
import "forge-std/console.sol";
import "../lib/openzeppelin-contracts/contracts/utils/math/Math.sol";

contract Marketplace {

    IERC20 public usdc;
    address public terraAddress;

    uint256 public disputePeriod = 100;
    constructor(address usdc_, address terraAddress_) {
        usdc = IERC20(usdc_);
        terraAddress = terraAddress_;
    }


    struct Order {
        uint8 v;
        bytes32 r;
        bytes32 s;
        bytes32 messageHash;

        uint256 price;
        string dataType;

        uint256[] encryptedData;
        uint256 buyerPublicKey;
        uint256 buyerN;
        uint256 status; // 0: open, 1: pending, 2: closed, 3: disputed

        uint256 creationTime;
        uint256 pendingTime;
        uint256 closedTime;

        address seller;
        address buyer;
    }

    Order[] public orders;

    function createOrder(string memory dataType_, uint256 price, uint256 buyerPublicKey, uint256 buyerN) external {
        usdc.transferFrom(msg.sender, address(this), price);
        uint256[] memory emptyArray;
        orders.push(Order(0, "", "", "", price, dataType_, emptyArray, buyerPublicKey, buyerN, 0, block.timestamp, 0, 0, address(0), msg.sender));
    } 

    function fulfillOrder(uint256 orderId, uint8 v_, bytes32 r_, bytes32 s_, bytes32 messageHash_, uint256[] memory encryptedData_) external {
        require(ecrecover(messageHash_, v_, r_, s_) == terraAddress, "signature must be from terra address");

        orders[orderId].v = v_;
        orders[orderId].r = r_;
        orders[orderId].s = s_;

        orders[orderId].messageHash = messageHash_;
        orders[orderId].encryptedData = encryptedData_;

        orders[orderId].status = 1;
        orders[orderId].pendingTime = block.timestamp;

        orders[orderId].seller = msg.sender;
    }

    function completeOrder(uint256 orderId) external {
        require(orders[orderId].status == 1, "order must be pending");
        require(orders[orderId].pendingTime + disputePeriod < block.timestamp, "dispute period must have passed");

        orders[orderId].status = 2;
        orders[orderId].closedTime = block.timestamp;
        usdc.transfer(orders[orderId].seller, orders[orderId].price);
    }

    function disputeOrder(uint256 orderId, uint256 prime1, uint256 prime2) external {
        require(orders[orderId].status == 1, "order must be pending");
        require(orders[orderId].pendingTime + disputePeriod > block.timestamp, "dispute period must not have passed");
        require(prime1 * prime2 == orders[orderId].buyerN, "prime1 * prime2 must equal buyerN");

        uint256 phi = (prime1 - 1) * (prime2 - 1);

        uint256 privateKey = multiplicative_inverse(orders[orderId].buyerPublicKey, phi);

        bytes memory unencryptedData = _decryptArray(orders[orderId].encryptedData, privateKey, orders[orderId].buyerN);
        
        require(keccak256(unencryptedData) != orders[orderId].messageHash, "hashes are equal. invalid dispute");

        orders[orderId].status = 3;
        orders[orderId].closedTime = block.timestamp;
        usdc.transfer(orders[orderId].buyer, orders[orderId].price);
    }

    function getUnencryptedPurchase(uint256 orderId, uint256 privateKey) external returns (bytes memory) {
        return _decryptArray(orders[orderId].encryptedData, privateKey, orders[orderId].buyerN);
    }

    // function disputeOrder(uint256 orderId, bytes privateKey) external {

    // }

    function getKeys() external returns (uint256,uint256,uint256) {
        return _getKeys();
    }

    function encrypt(uint256 message, uint256 publicKey, uint256 n) external returns (uint256) {
        return _encrypt(message, publicKey, n);
    }

    function _encrypt(uint256 message, uint256 publicKey, uint256 n) internal returns (uint256) {
        // (uint256 publicKey, uint256 privateKey, uint256 n) = _getKeys();

        uint256 e = publicKey;
        uint256 encryptedText = 1;

        // while (e != 0) {
        //     encryptedText *= message;
        //     encryptedText %= n; // maybe this goes outside of while loop
        //     e -= 1;
        // }

        
        // encryptedText = (message ** e) % n;
        // encryptedText = modularExponent(message, e, n);
        // revert();
        encryptedText = _recursiveExponent(message, e, n);
        // console.log("encrypted", message, "for", encryptedText);
        return encryptedText;

    }

    function encryptBytes(bytes memory message, uint256 publicKey, uint256 n) external returns (uint256[] memory) {
        return _encryptBytes(message, publicKey, n);
    }

    function _encryptBytes(bytes memory message, uint256 publicKey, uint256 n) internal returns (uint256[] memory) {
        uint256[] memory response = new uint256[](message.length);

        for (uint i; i < message.length; i++) {
            response[i] = _encrypt(uint8(message[i]), publicKey, n);
        }

        return response;
    }

    function decrypt(uint256 encryptedText, uint256 privateKey, uint256 n) external returns (uint256) {
        return _decrypt(encryptedText, privateKey, n);
    }

    function _decrypt(uint256 encryptedText, uint256 privateKey, uint256 n) internal returns (uint256) {
        // (uint256 publicKey, uint256 privateKey, uint256 n) = _getKeys();

        uint256 d = privateKey;
        uint256 decryptedText = 1;

        // while (d != 0) {
        //     decryptedText *= encryptedText;
        //     decryptedText %= n;
        //     d -= 1;
        // }

        // decryptedText = (encryptedText ** d) % n;
        // decryptedText = modularExponent(encryptedText, d, n);
        decryptedText = _recursiveExponent(encryptedText, d, n);
        // console.log("decrypted", encryptedText, " for ", decryptedText);
        return decryptedText;
    }

    function decryptArray(uint256[] memory encryptedText, uint256 privateKey, uint256 n) external returns (bytes memory) {
        return _decryptArray(encryptedText, privateKey, n);
    }
    function _decryptArray(uint256[] memory encryptedText, uint256 privateKey, uint256 n) internal returns (bytes memory) {
        bytes memory response = new bytes(encryptedText.length);

        for (uint i; i < encryptedText.length; i++) {
            response[i] = bytes1(uint8(_decrypt(encryptedText[i], privateKey, n)));
        }

        return response;
    }


   function gcd(uint256 a, uint256 b) public pure returns (uint256) {
        while (b != 0) {
            uint256 t = b;
            b = a % b;
            a = t;
        }
        return a;
    }

    function multiplicative_inverse(uint256 a_, uint256 m_) public pure returns (uint256) {
        int256 m0 = int256(m_);
        int256 x0 = 0;
        int256 x1 = 1;
        int256 a = int256(a_);
        int256 m = int256(m_);

        if (m == 1) return 0;

        // While a is greater than 1
        while (a > 1) {
            // q is quotient
            int256 q = a / m;
            int256 t = m;

            // m is remainder now, process same as Euclid's algorithm
            m = a % m;
            a = t;
            t = x0;
            x0 = x1 - int256(q) * x0;
            x1 = t;
        }

        // Make x1 positive
        if (x1 < 0) {
            x1 += m0;
        }

        return uint256(x1);
    }

    uint256 public randomNonce;

    function _getKeys() internal returns (uint256,uint256, uint256) {
        // uint256 prime1 = 63377;
        // uint256 prime2 = 61991;
        uint256 prime1 = 83;
        uint256 prime2 = 23;

        uint256 n = prime1 * prime2;
        uint256 phi = (prime1 - 1) * (prime2 - 1); // number of coprime numbers

        uint256 e = _randomNumber(1, phi);
        uint256 g = gcd(e,phi);
        while (g != 1) {
            e = _randomNumber(2, phi);
            require(e > 2 && e < phi, "e must be between 2 and phi");
            g = gcd(e,phi);
        }

        // console.log("e, phi inverse", e, phi);
        uint256 d = multiplicative_inverse(e, phi);
        // console.log("inverse", d);
        // console.log("keys", e, d, n);
        // revert("bonk");
        return (e, d, n);
    }

    function _randomNumber(uint256 min, uint256 max) internal returns (uint256) {
        randomNonce += 1;
        return uint256(keccak256(abi.encodePacked(block.timestamp, msg.sender, randomNonce))) % (max - min) + min;
    }

    function _recursiveExponent(uint256 a, uint256 b, uint256 c) internal returns (uint256) {
        // console.log("recursiveexponent",a,b,c);


        // console.log("Math.log10(a)", Math.log10(a));
        // console.log("b * Math.log10(a)", b * Math.log10(a));
        // console.log("Math.log10(type(uint).max)", Math.log10(type(uint).max));
        if (b * Math.log10(a, Math.Rounding.Ceil) <= 77) {
            // console.log("passing");
            return ((a**b) % c);
        } else {
            if (b % 2 == 1) {
                return (_recursiveExponent(a, b/2, c) * _recursiveExponent(a, b/2 + 1, c)) % c;
            } else {
                return (_recursiveExponent(a, b/2, c) ** 2) % c;

            }
        }   
    }

    function recursiveExponent(uint256 a ,uint256 b, uint256 c) external returns (uint256) {
        return _recursiveExponent(a,b,c);
    }

    function isTerraSignature(bytes memory data, uint8 v, bytes32 r, bytes32 s) external returns (bool) {
        return _isTerraSignature(data, v, r, s);
    }

    function _isTerraSignature(bytes memory data, uint8 v, bytes32 r, bytes32 s) internal returns (bool) {
        bytes32 messageHash = keccak256(data);
        address signer = ecrecover(messageHash, v, r, s);

        return signer == terraAddress;
    }

    


}
