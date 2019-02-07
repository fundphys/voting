pragma solidity ^0.5.0;

contract Voting {

    address payable public _owner;
    bool public votingInProcess = false;
    string public question;

    event contractDeploy(address);
    event addNewPerson(address);
    event startVotingEvent(bool);
    event stopVotingEvent(bool);

    struct Person {
        address person_address;
    }

    mapping (address => bool) votingResults; 

    constructor() public {
        _owner = msg.sender;
        emit contractDeploy(_owner);     
    }

    Person[] public persons;

    function addPerson(address _person_address ) public {
        require(msg.sender == _owner);
        persons.push(Person(_person_address));
        emit addNewPerson(_person_address);
    }

    function checkPerson(address _person_address) public view returns(bool) {
        for(uint i = 0; i < persons.length; i++) {
            if( persons[i].person_address == _person_address)
                return true;
        }
        return false;
    }

    function setQuestion(string memory _question) public {
        require(msg.sender == _owner);
        question = _question;
    }

    function startVoting() public returns(bool) { 
        require(msg.sender == _owner);
        require(persons.length > 0);
        require(bytes(question).length > 0);
        votingInProcess = true;
        emit startVotingEvent(true);
    }

    function stopVoting() public { 
        require(msg.sender == _owner);
        votingInProcess = false;
        emit stopVotingEvent(true);
    }
 
    function vote(bool _person_vote) public {
        require(votingInProcess);
        require(checkPerson(msg.sender));
        votingResults[msg.sender] = _person_vote;
    }

    function deleteContract() public {
        require(msg.sender == _owner, "Only owner can distruct this contract");
        selfdestruct(_owner);
    }
}