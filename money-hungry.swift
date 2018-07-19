import Foundation
var firstMove: Bool = true

// -- Constants -- //

//Optionals ✅
//varatic parameters
//nested functions
//closures
//extensions
//Emojis 🐶 (CMD + CTRL + SPACE)
// function return multiple values
//operator overloading
// math in string interpolation
//Underscore to ignore values
//Customizing argument labels
//Enumerations  ✅
//Protocols ✅
//Guard and Defer


//codereview.stackexchange.com/questions/182367/console-based-snake-game


let MAPWIDTH  = 50
let MAPHEIGHT = 20

// -- End Constants -- //

var lastPressedButton: String = "d"
var seconds: Int = 0
var minutes: Int = 0
var hours: Int = 0
var timeInSeconds: Int = 0
var date: Date = Date()

struct Coord: Equatable {
    let x: Int
    let y: Int

    static func ==(lhs: Coord, rhs: Coord) -> Bool {
        return lhs.x == rhs.x && lhs.y == rhs.y
    }
}

enum Direction: Int {
    case up
    case down
    case left
    case right
}

class Game {
    var snake = [ Coord(x: 0, y: 2), Coord(x: 0, y: 1), Coord(x: 0, y: 0)]
    var food = Coord(x: 10, y: 10)
    var direction = Direction.down
    var initialSnakeSize = 3
    var score: Int {
        return snake.count - initialSnakeSize
    }
    
    func move() {
        func calculateNextLocation() -> Coord {
            // This function calculates where the snake should move and makes sure that the next movement is not off the screen.  It does NOT check to see if a part has crossed or if it is touching food.

            if direction == .down && snake[0].y < MAPHEIGHT - 1 {
                return Coord(x: snake[0].x, y: snake[0].y + 1)
            }
            else if direction == .up && snake[0].y > 0 {
                return Coord(x: snake[0].x, y: snake[0].y - 1)
            }
            else if direction == .left && snake[0].x > 0 {
                return Coord(x: snake[0].x - 1, y: snake[0].y)
            }
            else if direction == .right && snake[0].x < MAPWIDTH - 1 {
                return Coord(x: snake[0].x + 1, y: snake[0].y)
            }
            else {
                displayDeathMessage("You crashed into the wall")
            }
        }

        let nextCoord = calculateNextLocation()

        if !snake.contains(nextCoord) { // does not remove last so the snake's size can grow by one
            if nextCoord == food {//delete last node if not touching food
                food = generateNewFoodCoords()
            }
            else { // to make the snake the same length
                snake.removeLast()
            }
            snake.insert(nextCoord, at: 0)
        }
        else {
            displayDeathMessage("Self Collision")
        }

    }
    

    func generateNewFoodCoords() -> Coord {
        return Coord(x: Int(arc4random_uniform(UInt32(MAPWIDTH))), y: Int(arc4random_uniform(UInt32(MAPHEIGHT))))
    }
    

    func moveUp() {
        if direction != .down {
            direction = .up
            move();
        }
        else {
            displayDeathMessage("Self Collision")
        }
    }
    

    func moveDown() {
        if direction != .up {
            direction = .down
            move();
        }
        else {
            displayDeathMessage("Self Collision")
        }
    }
    

    func moveLeft() {
        if direction != .right {
            direction = .left
            move();
        }
        else {
            displayDeathMessage("Self Collision")
        }
    }
    

    func moveRight() {
        if direction != .left {
            direction = .right
            move();
        }
        else {
            displayDeathMessage("Self Collision")
        }
    }
    

    func displayDeathMessage(_ message:String) -> Never {
        print("Death: \(message)")
        print("Score: \(score)")
        exit(1)
    }
    

    func drawMap() {
        func printLogo(){
            print(" _____                    _____                     ")
            print("|     |___ ___ ___ _ _   |  |  |_ _ ___ ___ ___ _ _ ")
            print("| | | | . |   | -_| | |  |     | | |   | . |  _| | |")
            print("|_|_|_|___|_|_|___|_  |  |__|__|___|_|_|_  |_| |_  |")
            print("                  |___|                |___|   |___|")
        }
        
        print(String(repeating: "\n", count: 22))
        printLogo()
        print("+" + String(repeating: "-", count: MAPWIDTH) + "+")
        for y in 0 ..< MAPHEIGHT {
            print("|", terminator:"")
            for x in 0 ..< MAPWIDTH {
                let coord = Coord(x: x, y: y)
                var hasPrinted = false
                
                if snake.contains(coord){
                    print("•", terminator:"")
                    hasPrinted = true
                }
                if !hasPrinted {
                    if food == coord {
                        print("¢", terminator:"")
                    }
                    else {
                        print(" ", terminator:"")
                    }
                }
            }
            print("|\n", terminator:"")
        }
        print("+" + String(repeating: "-", count: MAPWIDTH) + "+")
    }
    
}


func playGame() {
    let g = Game()
    g.drawMap()
    var l = ""
    while l != "q" {
        l = readLine() ?? ""
        let currentDate = Date()
        
        if firstMove{
            firstMove = false
            date = currentDate
        }
        if currentDate > Date(timeInterval:1, since: date){
            g.displayDeathMessage("You took to long")
            break
        }
        date = Date()
        print("this is l")
        if (l != ""){
            if l == "w" || l == "a" || l == "s" || l == "d" {
                lastPressedButton = l
            }
        }
        else{
            l = lastPressedButton
        }
        switch l{
            case "w":
                g.moveUp()
            case "a":
                g.moveLeft()
            case "s":
                g.moveDown()
            case "d":
                g.moveRight()
            default:
                break
        }
        g.drawMap()
    }
}

playGame()
