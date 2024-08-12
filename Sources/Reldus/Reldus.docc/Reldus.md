# ``Reldus``

A chess engine written and ran in Swift

## Overview

Reldus is a mighty chess engine written in Swift. It is a work in progress and is not yet complete. The goal of Reldus is to be a powerful chess engine that can be used in a variety of applications. It generates all the possible moves for a given position and then evaluates the best move based on a variety of factors. Of course, it filters out illegal moves and only considers the moves that are possible within the rules of chess.

It searches the best move within the ``Move`` array returned by ``MoveGenerator/generateMoves(for:color:)`` using a ``Search/alphabeta(board:depth:alpha:beta:maximizingPlayer:)`` algorythm.

## Topics

### The basics

- ``ChessBoard``
- <doc:bitboardsIntro>