// SPDX-License-Identifier: GPL-3.0

pragma solidity 0.8.9;

import "./Owner.sol";

contract GarticPhone is Owner {
    
    enum Status {inProgress, Done, Won}
    Status state;
    
    string public result;
    string[] private words;

    mapping (address => bool) done;

    function getAllWords() public view onlyOwner returns (string[] memory) {
        return words;
    }
    
    function getLastWord() public view returns (string memory) {
        require(words.length > 1, "Le 2nd joueur ne connait pas le 1er mot");
        return words[words.length-1];
    }
    
    function getStatus() public view returns (Status) {
        return state;
    }
    
    function setWord(string memory _word) public {
        require(state == Status.inProgress, "Le jeu est termine");
        require(!done[msg.sender], "Vous avez deja joue");
        done[msg.sender] = true;
        words.push(_word);
        if(keccak256(bytes(words[0])) == keccak256(bytes(_word)) && (words.length > 2)) {
            result = _word;
            state = Status.Won;
        }
        if(words.length == 5 && state == Status.inProgress) {
            state = Status.Done;
        }
    }
}