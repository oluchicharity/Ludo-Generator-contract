// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity ^0.8.21;

contract LudoGenerator {
    uint8 constant LUDO_SEEDS = 4;  
    uint8 constant PLAYERS = 4;    
    uint8 constant BOARD_SIZE = 52;

    struct Player {
        uint8[LUDO_SEEDS] pieces;  

        bool isActive;            
    }

    Player[PLAYERS] public players;

    uint8 public currentPlayer; 

    uint256 private seed;          

    event Rolled(uint8 player, uint8 result);  

    event ChipMoved(uint8 player, uint8 piece, uint8 newPosition); 

    // Setting up the game with all players being active
    constructor() {
        for (uint8 i = 0; i < PLAYERS; i++) {

            players[i].isActive = true;

            for (uint8 j = 0; j < LUDO_SEEDS; j++) {

                players[i].pieces[j] = 0;  
            }
        }
    }

    // Function for rolling a dice 1 to 6
    function rollingDice() public returns (uint8) {
        require(players[currentPlayer].isActive, "Current player is not active rn");

        // Generateing a random dice roll from numbers 1 to 6
        uint8 diceResult = uint8((uint256(keccak256(abi.encodePacked(seed, block.timestamp))) % 6) + 1);

        seed = uint256(keccak256(abi.encodePacked(seed, diceResult)));
        
        emit Rolled(currentPlayer, diceResult);

        return diceResult;
    }

    // Function to move a chip by a number of steps taken
    function movePiece(uint8 pieceIndex, uint8 steps) public {

        require(players[currentPlayer].isActive, "Player is not available right now");

        require(pieceIndex < LUDO_SEEDS, "Invalid piece index");

        // Getting the current position of the piece and calculate the new position
        uint8 currentPos = players[currentPlayer].pieces[pieceIndex];

        uint8 newPos = currentPos + steps;

        // If the piece goes past the board, loop it back to the beginning
        if (newPos >= BOARD_SIZE) {

            newPos = newPos - BOARD_SIZE;
        }

        // Update the position of the chip and announce the move
        players[currentPlayer].pieces[pieceIndex] = newPos;

        emit ChipMoved(currentPlayer, pieceIndex, newPos);
        
        // Move to the next player's turn 
        nextPlayer();
    }

    // Helper function to go to the next player's turn
    // function nextPlayer() private {

    //     currentPlayer = (currentPlayer + 1) % PLAYERS;
    // }
}
