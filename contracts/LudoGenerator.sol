// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity ^0.8.21;

//WORK IN PROGREES....PRESSURE WAS TOO MUCH :(

contract LudoGenarator {
    uint8  LUDO_SEEDS = 4;
    uint8  PLAYERS = 4;
    uint8  HOME_SIZE =  6
    uint8 BOARD_SIZE public board;
    
    //mapping(uint8 => ) board
    struct Player {
        uint8[LUDO_SEEDS] pieces;
        bool isActive;
    }

    Player[PLAYERS] public players;
    uint8 public currentPlayer;
    uint256 private seed;

    event Rolled(uint8 player, uint8 result);
    event chipMoved(uint8 player, uint8 piece, uint8 newPosition);

    constructor() {
        for (uint8 i = 0; i < PLAYERS; i++) {
            players[i].isActive = true;
            for (uint8 j = 0; j < LUDO_SEEDS; j++) {

                // Setting the default of the piece to 0
                players[i].pieces[j] = 0;
            }
        }
    }

    function rollDice() public returns (uint8) {
        require(players[currentPlayer].isActive, "Current player is not active");
        //uint8 diceResult = uint8((uint256(keccak256(abi.encodePacked(seed, block.timestamp))) % 6) + 1);
        seed = uint256(keccak256(abi.encodePacked(seed, diceResult)));
        emit Rolled(currentPlayer, diceResult);
        return diceResult;
    }

    function movePiece(uint8 pieceIndex, uint8 steps) public {
        require(players[currentPlayer].isActive, "player is not available right now");
        require(pieceIndex < LUDO_SEEDS, "Invalid seed");
        uint8 currentPos = players[currentPlayer].pieces[pieceIndex];
        uint8 newPos = currentPos + steps;

        if (newPos >= BOARD_SIZE) {
            newPos = newPos - BOARD_SIZE;
        }

        players[currentPlayer].pieces[pieceIndex] = newPos;
        emit ChipMoved(currentPlayer, pieceIndex, newPos);
        nextPlayer();
    }
}