// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity ^0.8.21;

contract LudoGenarator {
    uint8 constant LUDO_SEEDS = 4;
    uint8 constant  PLAYERS = 4;
    uint8 constant  HOME_SIZE =  6
    uint8[BOARD_SIZE] public board;
    
    //mapping(uint8 => ) board
    struct Player {
        uint8[PIECES] pieces;
        bool isActive;
    }

    Player[PLAYERS] public players;
    uint8 public currentPlayer;
    uint256 private seed;

    event DiceRolled(uint8 player, uint8 result);
    event PieceMoved(uint8 player, uint8 piece, uint8 newPosition);

    constructor() {
        for (uint8 i = 0; i < PLAYERS; i++) {
            players[i].isActive = true;
            for (uint8 j = 0; j < PIECES; j++) {
                // Setting the default of the piece to 0
                players[i].pieces[j] = 0;
            }
        }
        currentPlayer = 0;
        seed = uint256(keccak256(abi.encodePacked(block.timestamp, block.difficulty)));
    }

    function rollDice() public returns (uint8) {
        require(players[currentPlayer].isActive, "Current player is not active");
        uint8 diceResult = uint8((uint256(keccak256(abi.encodePacked(seed, block.timestamp, block.difficulty))) % 6) + 1);
        seed = uint256(keccak256(abi.encodePacked(seed, diceResult)));
        emit DiceRolled(currentPlayer, diceResult);
        return diceResult;
    }

    function movePiece(uint8 pieceIndex, uint8 steps) public {
        require(players[currentPlayer].isActive, "Current player is not active");
        require(pieceIndex < PIECES, "Invalid piece index");
        uint8 currentPos = players[currentPlayer].pieces[pieceIndex];
        uint8 newPos = currentPos + steps;

        if (newPos >= BOARD_SIZE) {
            newPos = newPos - BOARD_SIZE;
        }

        players[currentPlayer].pieces[pieceIndex] = newPos;
        emit PieceMoved(currentPlayer, pieceIndex, newPos);
        nextPlayer();
    }
}