// SPDX-License-Identifier: GPL-3.0

pragma solidity 0.8.9;

import "./Owner.sol";

contract GarticPhone is Owner {
    
    enum Status {inProgress, Done, Won}
    Status state;
    
    string public result;
    string[] private words;

    mapping (address => bool) done;
    
    // Afficher le tableau de mots
    function getAllWords() public view onlyOwner returns (string[] memory) {
        return words;
    }
    
    // Afficher le dernier mot saisi
    function getLastWord() public view returns (string memory) {
        require(words.length > 1, "Le 2nd joueur ne connait pas le 1er mot");
        return words[words.length-1];
    }
    
    // Afficher le statut du jeu (0: en cours, 1: terminé, 2: gagné)
    function getStatus() public view returns (Status) {
        return state;
    }
    
    // Saisir un mot
    function setWord(string memory _word) public {
        require(state == Status.inProgress, "Le jeu est termine");
        require(!done[msg.sender], "Vous avez deja joue");
        require(bytes(_word).length > 2, "3 lettres minimum");
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