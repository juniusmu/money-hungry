//
//  static.swift
//  money-hungry
//
//  Created by Junius Murphy on 1/18/21.
//

import Foundation

func displayGameLogo(){
    print(" _____                    _____                     ")
    print("|     |___ ___ ___ _ _   |  |  |_ _ ___ ___ ___ _ _ ")
    print("| | | | . |   | -_| | |  |     | | |   | . |  _| | |")
    print("|_|_|_|___|_|_|___|_  |  |__|__|___|_|_|_  |_| |_  |")
    print("                  |___|                |___|   |___|")
}

func displayGameInstructions(){
    print(String(repeating: "\n", count: 100))
    print("This is a game where you are a snake.")
    print("Your goal is to avoid all of the obstacles.")
    print("And rack up as much money as you can.")
    print(" 'W' 'A' 'S' 'D' are the direction keys.")
    print("Once you type in your direction, press the enter key to execute it")
    print("If you take to long to move, you will die.")
    print("press ENTER to start game.")
}
