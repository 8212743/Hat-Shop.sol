// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract HatShop is ERC20, Ownable {

    mapping(uint256 => uint256) public HatPrices;
    mapping(address => uint256[]) public HatCollection;  

    constructor() ERC20("HatToken", "HAT") Ownable(msg.sender) {
        // Initial hat items
        HatPrices[1] = 200;   // Cowboy Hat
        HatPrices[2] = 150;   // Fedora
        HatPrices[3] = 180;   // Baseball Cap
        HatPrices[4] = 120;   // Beanie
    }

    function mint(address _to, uint256 _amount) public onlyOwner {
        _mint(_to, _amount);
    }

    function transferHat(address _to, uint256 _amount) public {
        require(balanceOf(msg.sender) >= _amount, "Transfer failed: Insufficient balance.");
        transfer(_to, _amount);
    }

    function showHatItems() external pure returns (string memory) {
    string memory items = "Hats on sale: ";
    for (uint256 i = 1; i <= 4; i++) {
        items = strConcat(items, uint2str(i), ") ", hatName(i));

    }
    return items;
}


    function redeemHat(uint256 _hat) public {
        require(HatPrices[_hat] > 0, "Redeem failed: Hat is not available.");
        require(balanceOf(msg.sender) >= HatPrices[_hat], "Redeem failed: Insufficient balance.");
        
        _transfer(msg.sender, owner(), HatPrices[_hat]);  
        HatCollection[msg.sender].push(_hat);  
    }
    
    function burn(uint256 _amount) public {
        require(balanceOf(msg.sender) >= _amount, "Burn failed: Insufficient balance.");
        _burn(msg.sender, _amount);
    }

    function getBalance() external view returns (uint256) {
        return balanceOf(msg.sender);
    }

    function getHatCollection(address _user) external view returns (uint256[] memory) {
        return HatCollection[_user];
    }

    function addHatItem(uint256 _hat, uint256 _price) external onlyOwner {
        require(_price > 0, "Add failed: Price must be greater than zero.");
        require(HatPrices[_hat] == 0, "Add failed: Hat already exists.");
        HatPrices[_hat] = _price;
    }

    function updateHatItem(uint256 _hat, uint256 _price) external onlyOwner {
        require(_price > 0, "Update failed: Price must be greater than zero.");
        require(HatPrices[_hat] > 0, "Update failed: Hat does not exist.");
        HatPrices[_hat] = _price;
    }

    function removeHatItem(uint256 _hat) external onlyOwner {
        require(HatPrices[_hat] > 0, "Remove failed: Hat does not exist.");
        delete HatPrices[_hat];
    }

    function hatName(uint256 _hat) internal pure returns (string memory) {
        if (_hat == 1) {
            return "Cowboy Hat";
        } else if (_hat == 2) {
            return "Fedora";
        } else if (_hat == 3) {
            return "Baseball Cap";
        } else if (_hat == 4) {
            return "Beanie";
        } else {
            revert("Invalid hat");
        }
    }

    function strConcat(string memory _a, string memory _b, string memory _c, string memory _d) internal pure returns (string memory) {
        return string(abi.encodePacked(_a, _b, _c, _d));
    }

    function uint2str(uint256 _i) internal pure returns (string memory) {
        if (_i == 0) {
            return "0";
        }
        uint256 j = _i;
        uint256 len;
        while (j != 0) {
            len++;
            j /= 10;
        }
        bytes memory bstr = new bytes(len);
        uint256 k = len;
        while (_i != 0) {
            k = k - 1;
            uint8 temp = (48 + uint8(_i - _i / 10 * 10));
            bytes1 b1 = bytes1(temp);
            bstr[k] = b1;
            _i /= 10;
        }
        return string(bstr);
    }
}
