// SPDX-License-Identifier: MIT

pragma solidity >=0.7.0 <0.9.0;

interface IERC20Token {
  function transfer(address, uint256) external returns (bool);
  function approve(address, uint256) external returns (bool);
  function transferFrom(address, address, uint256) external returns (bool);
  function totalSupply() external view returns (uint256);
  function balanceOf(address) external view returns (uint256);
  function allowance(address, address) external view returns (uint256);

  event Transfer(address indexed from, address indexed to, uint256 value);
  event Approval(address indexed owner, address indexed spender, uint256 value);
}

contract Academichain {

    uint internal gradesLength = 0;
    address internal cUsdTokenAddress = 0x874069Fa1Eb16D44d622F2e0Ca25eeA172369bC1;

    struct Transcript {
        string memory studentName;
        string memory studentId;
        string memory collegeName;
        string memory course;
        string memory class;
        string memory uploadDate;
        uint CGPA;
        mapping (uint => Grade) storage grades;
        address internal author;    // University Address
    }

    struct Grade {
        string memory unitCode;
        string memory unitName;
        string memory year;
        uint marks;
        uint GPA;
        address internal author;    // University Address
    }

    function writeGrade(
        string memory _unitCode;
        string memory _unitName;
        string memory _year;
        uint _marks;
        uint _GPA;
    ) public {
        grades[gradesLength] = Grade(unitCode, unitName, year, marks, GPA, msg.sender);
        gradesLength++;
    }

    function readGrades() public view returns (
        string memory, 
        string memory, 
        string memory, 
        uint, 
        uint
        address payable,
    ) {
        return grades;
    }
    
    function buyProduct(uint _index) public payable  {
        require(
          IERC20Token(cUsdTokenAddress).transferFrom(
            msg.sender,
            products[_index].owner,
            products[_index].price
          ),
          "Transfer failed."
        );
        products[_index].sold++;
    }
    
    function getProductsLength() public view returns (uint) {
        return (productsLength);
    }
}