// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract AcademicTranscript {
    address private owner;     // Owner - Academichain
    string private rootUser;
    uint numOrganizations;

    struct Organization {
        uint regNo;
        string name;
        string email;
        string physicalAddress;
        address chainAddress;
        uint numAdmins;
        uint numStudents;
    }
    // Grader
    struct Admin {
        uint id;
        string name;
        string email;
        string physicalAddress;
        address chainAddress;
        string course;
    }

    struct Student {
        uint id;
        string name;
        string email;
        string physicalAddress;
        address chainAddress;
        string course;
        string class;
        uint numGrades;
        mapping(uint => Grade) grades;
    }

    struct Grade {
        string unitCode;
        string unitTitle;
        string year;
        string period;
        uint mark;
        uint GPA;
        address grader;
    }

    mapping(string => mapping(uint => Student)) private students;
    mapping(string => mapping(uint => Admin)) private admins;
    mapping(string => Organization) private organizations;

    event GradeUpdated(address indexed studentAddress, string courseCode, uint marks);
    event ReadAccessGranted(address indexed studentAddress, address indexed verifierAddress);
    event ReadAccessRevoked(address indexed studentAddress, address indexed verifierAddress);

    modifier onlyAdmin(string memory _orgName) {
        require(isAdmin[_orgName][msg.sender], "Only admins can perform this action");
        _;
    }

    modifier onlyStudent(string memory _orgName) {
        require(isStudent[_orgName][msg.sender], "Only students can perform this action");
        _;
    }

    modifier onlyMember(string memory _orgName) {
        require(isStudent[_orgName][msg.sender] || isAdmin[_orgName][msg.sender],  "Only university members can perform this action");
        _;
    }

    constructor() {
        owner = msg.sender; 
        rootUser = "AcademiChain";
        numOrganizations = 0;
        isOrganization[rootUser][owner] = true;

        Admin storage root = admins[rootUser][numOrganizations];
        root.chainAddress = owner;
        isAdmin[rootUser][owner] = true;
        numOrganizations++;
    }

// ======================== FUNCTIONS ==========================
    // ------------ CHECKERS ---------------
    mapping(string => mapping(address => bool)) public isStudent;
    mapping(string => mapping(address => bool)) public isAdmin;
    mapping(string => mapping(address => bool)) public isOrganization;
    // mapping(address => mapping(address => bool)) public readAccess;

    // ------------ ORGANIZATION ------------

    function addOrganization(uint _regNo, string memory _orgName, string memory _email, string memory _physicalAddress, address _chainAddress) onlyAdmin(rootUser) public {
        require(isOrganization["AcademiChain"][owner], "Contact Academichain");

        Organization storage newOrg = organizations[_orgName];
        // Default admin

        newOrg.regNo = _regNo;
        newOrg.name = _orgName;
        newOrg.email = _email;
        newOrg.physicalAddress = _physicalAddress;
        newOrg.chainAddress = _chainAddress;
        newOrg.numStudents = 0;
        newOrg.numAdmins = 0;
        isOrganization[_orgName][_chainAddress] = true;
        numOrganizations++;

        Admin storage rootAdmin = admins[_orgName][newOrg.numAdmins];
        rootAdmin.chainAddress = newOrg.chainAddress;
        isAdmin[_orgName][_chainAddress] = true;
        newOrg.numAdmins++;
    }

    function getOrganization(string memory _orgName) public view returns (
        uint regNo,
        string memory name,
        string memory email,
        string memory physicalAddress,
        address chainAddress,
        uint numStudents
    ) {
        Organization storage org = organizations[_orgName];
        return (
            org.regNo,
            org.name,
            org.email,
            org.physicalAddress,
            org.chainAddress,
            org.numStudents
        );
    }
}