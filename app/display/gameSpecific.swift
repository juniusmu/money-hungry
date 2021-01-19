//
//  gameSpecific.swift
//  money-hungry
//
//  Created by Junius Murphy on 1/18/21.
//

import Foundation

func gameOverMessage(message: String, score: Int){
    print("Game Over: \(message)")
    print("Score: \(score)")
    exit(1)
}
