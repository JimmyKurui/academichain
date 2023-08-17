// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract Constants {
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
}