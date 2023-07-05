// SPDX-License-Identifier: GPL-3.0

pragma solidity ^0.8.0;

contract Academichain {

    uint internal studentsLength = 0;
    uint internal transcriptsLength = 0;
    uint internal gradesLength = 0;
    address grader = 0x5B38Da6a701c568545dCfcB03FcB875f56beddC4;
    address student = 0x5B38Da6a701c568545dCfcB03FcB875f56beddC4;
    // address grader = 0x2121cB84c07C03C86cab9142011233ea5c00ADd4;
    // address student = 0x6aa049aFe44e6791ac07E6820D0018ba1601660B;
    
    struct Student {
        string collegeName;
        uint studentId;
        string studentName;
        address studentAddress;
        string course;
        string class;
        mapping(uint => Transcript) transcripts;
        mapping(address => bool) sharedWith;
    }

    struct Transcript {
        Student learner;
        uint overallGrade;
        string uploadDate;
        mapping (uint => Grade) grades;
        address author;    // Grading Office's Address
    }
    struct Grade {
        uint studentId;
        string  unitCode;
        string  unitName;
        string  year;
        uint marks;
        uint GPA;
        address author;    // Grading Office's Address
    }

    mapping(uint => Student) internal students;

    modifier onlyEducator() {
        // Check if the sender is an authorized educator
        require(isEducator(msg.sender), "Only authorized educators can perform this action");
        _;
    }

    modifier onlyStudent() {
        // Check if the sender is a student
        require(isStudent(msg.sender), "Only students can perform this action");
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
    function addStudent(
        string memory _collegeName,
        uint _studentId,
        string memory _studentName,
        string memory _course,
        string memory _class
    ) public onlyStudent onlyEducator {
        transcriptsLength = 0;
        // students[studentsLength] = Student(collegeName, studentId, studentName, msg.sender, course, class);
        Student storage newStudent = students[studentsLength];
        newStudent.collegeName = _collegeName;
        newStudent.studentId = _studentId;
        newStudent.studentName = _studentName;
        newStudent.studentAddress = msg.sender;
        newStudent.course = _course;
        newStudent.class = _class;
        studentsLength++; 
    }

    function addGrade(
        uint _studentId,
        string memory  _unitCode,
        string memory  _unitName,
        string memory  _year,
        uint _marks,
        uint _GPA,
        address _author
        ) public onlyEducator {
            Student storage currentStudent = students[_studentId];
            Transcript storage currentTranscript = currentStudent.transcripts[transcriptsLength];
            Grade storage newGrade = currentTranscript.grades[gradesLength];
            newGrade.studentId = _studentId;
            newGrade.unitCode = _unitCode;
            newGrade.unitName = _unitName;
            newGrade.year = _year;
            newGrade.marks = _marks;
            newGrade.GPA = _GPA;
            newGrade.author = _author;
            gradesLength++;
    }
}
