import Foundation
var firstMove: Bool = true
var tempSlashTrue = true

//Todo: make it so that the move function is more broad, so other objects can use it

// -- Constants -- //

//Optionals ✅
//varatic parameters
//nested functions ✅
//closures
//extensions
//Emojis 🐶 (CMD + CTRL + SPACE)
// function return multiple values
//operator overloading
// math in string interpolation ✅
//Underscore to ignore values ✅
//Customizing argument labels
//Enumerations  ✅
//Protocols ✅
//Guard and Defer


//codereview.stackexchange.com/questions/182367/console-based-snake-game


let MAPWIDTH  = 50
let MAPHEIGHT = 20
var score: Int = 0

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

var food = Coord(x: 10, y: 10)

enum Direction: Int {
    case up
    case down
    case left
    case right
}

class SlashProjectile{
    var currentChar = "\\"
    var coord: Coord
    
    var dir: Direction
    var numStages: Int = 4
    var stage: Int = 0
   
    init(startingCoord: Coord, direction: Direction){
        coord = startingCoord
        dir = direction
    }
    
    

    func move(){
        if self.dir == .left{
            print("going left")
            var stageInLife = self.stage % self.numStages
            switch stageInLife{
                case 0:
                    self.coord = Coord(x: self.coord.x - 2, y: self.coord.y + 1)
                    break
                case 1:
                    self.coord = Coord(x: self.coord.x - 2, y: self.coord.y - 1)
                    break
                case 2:
                    self.coord = Coord(x: self.coord.x + 1, y: self.coord.y - 1)
                    break
                case 3:
                    self.coord = Coord(x: self.coord.x - 2, y: self.coord.y + 1)
                    break
                default:
                    break
            }
            stage = stage + 1
            if self.currentChar == "\\"{
                self.currentChar = "/"
            }
            else{
                self.currentChar = "\\"
            }
        }
        else{
             print("going right")
            var stageInLife = self.stage % self.numStages
            switch stageInLife{
            case 0:
                self.coord = Coord(x: self.coord.x + 2, y: self.coord.y + 1)
                break
            case 1:
                self.coord = Coord(x: self.coord.x + 2, y: self.coord.y - 1)
                break
            case 2:
                self.coord = Coord(x: self.coord.x - 1, y: self.coord.y - 1)
                break
            case 3:
                self.coord = Coord(x: self.coord.x + 2, y: self.coord.y + 1)
                break
            default:
                break
            }
            stage = stage + 1
            if self.currentChar == "\\"{
                self.currentChar = "/"
            }
            else{
                self.currentChar = "\\"
            }
        }
        
    }
}

class Snake{
    var body = [Coord(x: 0, y: 5), Coord(x: 0, y: 4),Coord(x: 0, y: 3), Coord(x: 0, y: 2), Coord(x: 0, y: 1), Coord(x: 0, y: 0)]
    var direction = Direction.down
    var initialSnakeSize = 2
    var alive: Bool = true
    
    func move(nextDirection: Direction, deathDirection: Direction){
        if nextDirection == deathDirection{
//            displayDeathMessage("You got in your own way :(")
            alive = false
            print("Score: \(score)")
            exit(1)
        }
        let newCoord: Coord?
        self.direction = nextDirection
        
        if self.direction == .down && self.body[0].y < MAPHEIGHT - 1 {
            newCoord = Coord(x: self.body[0].x, y: self.body[0].y + 1)
        }
        else if direction == .up && self.body[0].y > 0 {
            newCoord = Coord(x: self.body[0].x, y: self.body[0].y - 1)
        }
        else if self.direction == .left && self.body[0].x > 0 {
            newCoord = Coord(x: self.body[0].x - 1, y: self.body[0].y)
        }
        else if self.direction == .right && self.body[0].x < MAPWIDTH - 1 {
            newCoord = Coord(x: self.body[0].x + 1, y: self.body[0].y)
        }
        else {
//            displayDeathMessage("You crashed into the wall")
            alive = false
            print("Score: \(score)")
            exit(1)
        }
        
        if !self.body.contains(newCoord!) {
            self.body.insert(newCoord!, at: 0)
        }
        else {
//            displayDeathMessage("Self Collision")
            alive = false
            print("Score: \(score)")
            exit(1)
        }
        
        
    }
}


class Game {
    func generateNewFoodCoords() -> Coord {
        return Coord(x: Int(arc4random_uniform(UInt32(MAPWIDTH))), y: Int(arc4random_uniform(UInt32(MAPHEIGHT))))
    }
    
    var snake = Snake()
    var firstLoad = true
    var slashProjectile1: SlashProjectile?
    var slashProjectile2: SlashProjectile?
    var slashProjectile3: SlashProjectile?
    
   
    

    
    func drawMap() {
        func printLogo(){
            print(" _____                    _____                     ")
            print("|     |___ ___ ___ _ _   |  |  |_ _ ___ ___ ___ _ _ ")
            print("| | | | . |   | -_| | |  |     | | |   | . |  _| | |")
            print("|_|_|_|___|_|_|___|_  |  |__|__|___|_|_|_  |_| |_  |")
            print("                  |___|                |___|   |___|")
        }
        
        if snake.body.contains(food){
            food = generateNewFoodCoords()
            score = score + 1
            
        }
        snake.body.removeLast()
        
        if let slashProjectile = slashProjectile1{
            if snake.body.contains(slashProjectile.coord){
                print("killed")
                print("Score: \(score)")
                exit(1)
            }
            if slashProjectile.coord.x < 0 || slashProjectile.coord.x > MAPWIDTH{
                slashProjectile1 = nil
            }
        }
        if let slashProjectile = slashProjectile2{
            if snake.body.contains(slashProjectile.coord){
                print("killed")
                print("Score: \(score)")
                exit(1)
            }
            if slashProjectile.coord.x < 0 || slashProjectile.coord.x > MAPWIDTH{
                slashProjectile2 = nil
            }
        }
        if let slashProjectile = slashProjectile3{
            if snake.body.contains(slashProjectile.coord){
                print("killed")
                print("Score: \(score)")
                exit(1)
            }
            if slashProjectile.coord.x < 0 || slashProjectile.coord.x > MAPWIDTH{
                slashProjectile3 = nil
            }
        }
        
        
        print(String(repeating: "\n", count: 22))
        if(firstLoad){
            printLogo()
            firstLoad = false
        }
        print("+" + String(repeating: "-", count: MAPWIDTH) + "+")
        for y in 0 ..< MAPHEIGHT {
            print("|", terminator:"")
            for x in 0 ..< MAPWIDTH {
                let coord = Coord(x: x, y: y)
                var hasPrinted = false
                var projectilePrinted = false
                var coinPrinted = false
                
                if snake.body.contains(coord){
                    print("•", terminator:"")
                    hasPrinted = true
                }
                if !hasPrinted {
                    if food == coord {
                        print("¢", terminator:"")
                        coinPrinted = true
                    }
                    if let projectile = slashProjectile1{
                        if coord == projectile.coord{
                            print(projectile.currentChar, terminator:"")
                            projectilePrinted = true

                        }
                        
                    }
                    if let projectile = slashProjectile2{
                        
                        if coord == projectile.coord{
                            print(projectile.currentChar, terminator:"")
                            projectilePrinted = true
                            
                        }
                        
                    }
                    if let projectile = slashProjectile3{
                        
                        if coord == projectile.coord{
                            print(projectile.currentChar, terminator:"")
                            projectilePrinted = true
                        }
                        
                    }
                    if coinPrinted == false && projectilePrinted == false {
                        print(" ", terminator:"")
                    }
                }
            }
            print("|\n", terminator:"")
        }
        print("+" + String(repeating: "-", count: MAPWIDTH) + "+")
        if let projectile = slashProjectile1{
            projectile.move()
        }
        if let projectile = slashProjectile2{
            projectile.move()
        }
        if let projectile = slashProjectile3{
            projectile.move()
        }
    }
    
    
}


func displayDeathMessage(_ message:String) -> Never {
    print("Death: \(message)")
//    print("Score: \(score)")
    exit(1)
}

func playGame() {
    
    let g = Game()
    g.drawMap()
    var l = ""
    while l != "q" {
        l = readLine() ?? ""
        
        var weaponDeterminer = Int(arc4random_uniform(UInt32(20)))
        
        switch weaponDeterminer{ //randomly chooses which projectile to shoot out
            case 0:
                print("case 0")
                if(g.slashProjectile1 == nil){
                    var sideDeterminer = Int(arc4random_uniform(UInt32(2)))
                    if(sideDeterminer == 0){
                        g.slashProjectile1 = SlashProjectile(startingCoord: Coord(x: 0, y: Int(arc4random_uniform(UInt32(20)))) , direction: .right)
                    }
                    else{
                        g.slashProjectile1 = SlashProjectile(startingCoord: Coord(x: 49, y: Int(arc4random_uniform(UInt32(20)))) , direction: .left)
                    }
                }
            
            case 1:
                print("case 1")
                if(g.slashProjectile2 == nil){
                    var sideDeterminer = Int(arc4random_uniform(UInt32(2)))
                    if(sideDeterminer == 0){
                        g.slashProjectile2 = SlashProjectile(startingCoord: Coord(x: 0, y: Int(arc4random_uniform(UInt32(20)))) , direction: .right)
                    }
                    else{
                        g.slashProjectile2 = SlashProjectile(startingCoord: Coord(x: 49, y: Int(arc4random_uniform(UInt32(20)))) , direction: .left)
                    }
                }
            
            case 2:
                print("case 2")
                if(g.slashProjectile3 == nil){
                    var sideDeterminer = Int(arc4random_uniform(UInt32(2)))
                    if(sideDeterminer == 0){
                        g.slashProjectile3 = SlashProjectile(startingCoord: Coord(x: 0, y: Int(arc4random_uniform(UInt32(20)))) , direction: .right)
                    }
                    else{
                        g.slashProjectile3 = SlashProjectile(startingCoord: Coord(x: 49, y: Int(arc4random_uniform(UInt32(20)))) , direction: .left)
                    }
                }
            default:
                break
        }
        
        let currentDate = Date()
//        if(tempSlashTrue){
//            var sideDeterminer = Int(arc4random_uniform(UInt32(2)))
//            if(sideDeterminer == 0){
//                g.slashProjectile = SlashProjectile(startingCoord: Coord(x: 0, y: Int(arc4random_uniform(UInt32(20)))) , direction: .right)
//            }
//            else{
//                g.slashProjectile = SlashProjectile(startingCoord: Coord(x: 49, y: Int(arc4random_uniform(UInt32(20)))) , direction: .left)
//            }
//
//            tempSlashTrue = false
//        }
        
        if firstMove{
            firstMove = false
            date = currentDate
        }
        //        TODO: Uncomment this chunk of code later. kills player if she's taking to long
        
//        if currentDate > Date(timeInterval:1, since: date){
//            g.snake.alive = false
//            exit(1)
////            g.snake.displayDeathMessage("You took to long")
//            break
//        }
        date = Date()
        if (l != ""){
            if l == "w" || l == "a" || l == "s" || l == "d" {
                lastPressedButton = l
            }
            else{
                l = lastPressedButton
            }
        }
        else{
            l = lastPressedButton
        }
        switch l{
            case "w":
                g.snake.move(nextDirection: .up, deathDirection: .down)
            case "a":
                g.snake.move(nextDirection: .left, deathDirection: .right)
            case "s":
                g.snake.move(nextDirection: .down, deathDirection: .up)
            case "d":
                g.snake.move(nextDirection: .right, deathDirection: .left)
            default:
                break
        }
        g.drawMap()
    }
}

playGame()
