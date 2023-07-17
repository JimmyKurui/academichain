// SPDX-License-Identifier: GPL-3.0

pragma solidity ^0.8.0;

contract Academichain {

    uint internal studentsLength = 0;
    address grader = 0x5B38Da6a701c568545dCfcB03FcB875f56beddC4;
    address student = 0x4B20993Bc481177ec7E8f571ceCaE8A9e22C02db;
    // address = admin
    // address grader = 0x2121cB84c07C03C86cab9142011233ea5c00ADd4;
    // address student = 0x6aa049aFe44e6791ac07E6820D0018ba1601660B;
    
    struct Student {
        uint studentId;
        string studentName;
        string email;
        string physicalAddress;
        address chainAddress;
        string course;
        string class;
        Transcript transcript;
        mapping(address => bool) sharedWith;
    }

    struct Organization {
        uint regNo;
        string organizationName;
        string email;
        address chainAddress;
        string physicalAddress;        
    }

    struct Transcript {
        uint totalCredits;
        uint creditsEarned;
        uint averageMark;
        uint averageGrade;
        string uploadDate;
        uint gradesLength;
        mapping (uint => Grade) grades;
        address author;    // Grading Office's Address
    }
    struct Grade {
        string unitCode;
        string unitTitle;
        string year;
        string period;
        uint mark;
        uint GPA;
        address author;    // Grading Office's Address
    }

    mapping(uint => Student) internal students;

    modifier onlyEducator() {
        require(isEducator(msg.sender), "Only authorized educators can perform this action");
        _;
    }

    modifier onlyStudent() {
        require(isStudent(msg.sender), "Only students can perform this action");
        _;
    }

    modifier onlyMember() {
        require(isStudent(msg.sender) || isEducator(msg.sender), "Only students can perform this action");
        _;
    }

    // Check if the account is an authorized educator
    function isEducator(address account) public view returns (bool) {
        if (account==grader) {return true; } else {return false; }
    }
    // Check if the account is a student
    function isStudent(address account) public view returns (bool) {
        if (account==student) {return true; } else {return false; }
    }
    
// ======================== FUNCTIONS ==========================

    // Student
     function addStudent(
        string memory _studentName,
        string memory _email,
        string memory _physicalAddress,
        string memory _course,
        string memory _class
    ) public onlyMember {
        // students[studentsLength] = Student(_studentId, _studentName, _email, msg.sender, _physicalAddress, _course, _class, (Transcript storage newTranscript) );
        Student storage newStudent = students[studentsLength];
        newStudent.studentId = studentsLength;
        newStudent.studentName = _studentName;
        newStudent.email = _email;
        newStudent.physicalAddress = _physicalAddress;
        newStudent.chainAddress = msg.sender;
        newStudent.course = _course;
        newStudent.class = _class;
        studentsLength++; 
    }

    function getStudent(uint _studentId) public view onlyMember returns (
        uint,
        string memory,
        string memory,
        string memory,
        address,
        string memory,
        string memory
    ) {
        // students[studentsLength] = Student(_studentId, _studentName, _email, msg.sender, _physicalAddress, _course, _class, (Transcript storage newTranscript) );
        Student storage newStudent = students[_studentId];
        return (
            newStudent.studentId,
            newStudent.studentName,
            newStudent.email,
            newStudent.physicalAddress,
            newStudent.chainAddress,
            newStudent.course,
            newStudent.class
        );
    }
    
    // Grade
    function setGrade(
        uint _gradeIndex,
        uint _studentId,
        string memory _unitCode,
        string memory _unitTitle,
        string memory _year,
        string memory _period,
        uint _mark,
        uint _GPA,
        address _author
    ) public onlyEducator {
        Transcript storage transcript = students[_studentId].transcript;
        Grade storage newGrade = transcript.grades[transcript.gradeLength];

        // Check if the grade index is within the existing grades range
        require(_gradeIndex < transcript.gradesLength, "Invalid grade index");

        newGrade.unitCode = _unitCode;
        newGrade.unitTitle = _unitTitle;
        newGrade.year = _year;
        newGrade.period = _period;
        newGrade.mark = _mark;
        newGrade.GPA = _GPA;
        newGrade.author = _author;
    }

    function getGrade(
        uint _studentId,
        uint _gradeIndex
    ) public view onlyMember returns (
        string memory,
        string memory,
        string memory,
        string memory,
        uint,
        uint,
        address
    ) {
        Transcript storage transcript = students[_studentId].transcript;
        Grade storage grade = transcript.grades[_gradeIndex];

        if(grade == transcript.grades[transcript.grade])
        return (
            grade.unitCode,
            grade.unitTitle,
            grade.year,
            grade.period,
            grade.mark,
            grade.GPA,
            grade.author
        );
    }

}
