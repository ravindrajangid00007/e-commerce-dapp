//SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.0;
pragma experimental ABIEncoderV2;

contract Products {
    uint256 public productCount;

    struct Product {
        uint256 pid;
        string name;
        uint256 price;
        uint256 stock;
        string imgHash;
        string desc;
        string category;
        address payable sellerAddress;
    }

    Product[] public products;

    mapping(address => uint256) public SellerProductCount;

    event ProductAdded(
        uint256 pid,
        string name,
        uint256 price,
        uint256 stock,
        string imgHash,
        string desc,
        string category,
        address payable sellerAddress
    );

    function getProduct(uint256 _pid) public view returns (Product memory) {
        return products[_pid - 1];
    }

    function decreaseStock(uint256 _pid, uint256 qnt) public {
        products[_pid - 1].stock = products[_pid - 1].stock - qnt;
    }

    function getPrice(uint256 _pid) public view returns (uint256) {
        return products[_pid - 1].price;
    }

    function getName(uint256 _pid) public view returns (string memory) {
        return products[_pid - 1].name;
    }

    function getSellerAddress(uint256 _pid)
        public
        view
        returns (address payable)
    {
        return products[_pid - 1].sellerAddress;
    }

    function getSellerProducts() public view returns (Product[] memory) {
        uint256 counter = SellerProductCount[msg.sender];
        uint256 flag = 0;
        Product[] memory ans = new Product[](counter);
        for (uint256 i = 0; i < products.length; i++) {
            if (products[i].sellerAddress == msg.sender) {
                ans[flag] = products[i];
                flag++;
                if (counter == flag) {
                    break;
                }
            }
        }
        return ans;
    }

    function getAllProducts() public view returns (Product[] memory) {
        return products;
    }

    function countProductsByCat(string memory cate)
        private
        view
        returns (uint256)
    {
        uint256 count = 0;
        for (uint256 i = 0; i < products.length; i++) {
            if (
                keccak256(bytes(products[i].category)) == keccak256(bytes(cate))
            ) {
                count++;
            }
        }
        return count;
    }

    function getProductsByCategory(string memory category)
        public
        view
        returns (Product[] memory)
    {
        uint256 noOfProds = countProductsByCat(category);
        uint256 counter = 0;
        Product[] memory prods = new Product[](noOfProds);
        for (uint256 i = 0; i < products.length; i++) {
            if (
                keccak256(bytes(products[i].category)) ==
                keccak256(bytes(category))
            ) {
                prods[counter] = products[i];
                counter++;
                if (counter == noOfProds) {
                    break;
                }
            }
        }
        return prods;
    }
}
