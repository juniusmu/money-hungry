import Foundation
let MAPWIDTH  = 50
let MAPHEIGHT = 20
var score: Int = 0
var l = ""

// Influence by: codereview.stackexchange.com/questions/182367/console-based-snake-game
var firstMove: Bool = true
var lastPressedButton: String = "s"
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


class Snake{
    var body = [Coord(x: 25, y: 5), Coord(x: 25, y: 4),Coord(x: 25, y: 3), Coord(x: 25, y: 2), Coord(x: 25, y: 1), Coord(x: 25, y: 0)]
    var direction = Direction.down
    func move(nextDirection: Direction, deathDirection: Direction){
        let newCoord: Coord?
        self.direction = nextDirection
        
        // check if the snake is off the map
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
            gameOverMessage("You Hit A Wall")
            return
        }
        self.body.insert(newCoord!, at: 0)
        self.body.removeLast()
        // if !self.body.contains(newCoord!) {
        //     self.body.insert(newCoord!, at: 0)
        //     self.body.removeLast()
        // }
        // else {
        //     gameOverMessage("You Got In Your Own Way :(")
        //     return
        // }
    }
}

protocol Projectile{
    var currentChar: String {get set}
    var coord: Coord {get set}
}

protocol CircularMovement: Projectile{ 
    var dir: Direction {get}
    var coord: Coord {get set}
    var numStages: Int {get set}
    var phaseCharacters: [String] {get}
    var stage: Int {get set}
}

extension CircularMovement{
    mutating func move(){
        var xVal = 1
        if self.dir == .left{
            xVal = -1
        }
        let stageInLife = self.stage % self.numStages
        switch stageInLife{
            case 0:
                self.coord = Coord(x: self.coord.x + 2 * xVal, y: self.coord.y + 1)
                break
            case 1:
                self.coord = Coord(x: self.coord.x + 2 * xVal, y: self.coord.y - 1)
                break
            case 2:
                self.coord = Coord(x: self.coord.x - 1 * xVal, y: self.coord.y - 1)
                break
            case 3:
                self.coord = Coord(x: self.coord.x + 2 * xVal, y: self.coord.y + 1)
                break
            default:
                break
        }
        stage = stage + 1
        self.currentChar = self.phaseCharacters[stage % self.phaseCharacters.count]
    }
}

class ArrowProjectile: Projectile{
    var currentChar = "V"
    var coord: Coord
    init(startingCoord: Coord){
        coord = startingCoord
    }
    
    func move(){
        self.coord = Coord(x: self.coord.x, y: self.coord.y + 1)
    } 
}

class SlashProjectile: Projectile, CircularMovement{
    var currentChar: String = "/"
    var coord: Coord
    var dir: Direction
    var numStages: Int = 4
    var stage: Int = 0
    var phaseCharacters: [String] = ["\\", "/"]
   
    init(startingCoord: Coord, direction: Direction){
        coord = startingCoord
        dir = direction
    }
}

    
        
        
class Game {
    var snake = Snake()
    var firstLoad = true
    var slashProjectile1: SlashProjectile?
    var slashProjectile2: SlashProjectile?
    var slashProjectile3: SlashProjectile?
    
    var arrowProjectile1: ArrowProjectile?
    var arrowProjectile2: ArrowProjectile?
    var arrowProjectile3: ArrowProjectile? 

    func isGameOver(){
        func isSnakeOverlapping() -> Bool{
            for limb in snake.body{
                var limbsWithSameCoord = snake.body.filter{$0 == limb}
                if limbsWithSameCoord.count > 1{
                    return true
                }
            }
            return false
        }
        if isSnakeOverlapping(){
            gameOverMessage("You Got In Your Own Way :(")
        }
    }


    func generateNewFoodCoords() -> Coord {
        return Coord(x: Int(arc4random_uniform(UInt32(MAPWIDTH-15))) + 5, y: Int(arc4random_uniform(UInt32(MAPHEIGHT - 10 ))) + 5)
    }
    func isPlayerKilled() -> Bool {
        if let slashProjectile = slashProjectile1{
            if snake.body.contains(slashProjectile.coord){
                return true
            }
        }
        if let slashProjectile = slashProjectile2{
            if snake.body.contains(slashProjectile.coord){
                return true
            }
        }
        if let slashProjectile = slashProjectile3{
            if snake.body.contains(slashProjectile.coord){
                return true
            }
        }
        if let arrowProjectile = arrowProjectile1{
            if snake.body.contains(arrowProjectile.coord){
                return true
            }
        }
        if let arrowProjectile = arrowProjectile2{
            if snake.body.contains(arrowProjectile.coord){
                return true
            }
        }
        if let arrowProjectile = arrowProjectile3{
            if snake.body.contains(arrowProjectile.coord){
                return true
            }
        }
        return false
    }
    func deleteOffMapProjectiles(){
        if let slashProjectile = slashProjectile1{
            if slashProjectile.coord.x < 0 || slashProjectile.coord.x > MAPWIDTH{
                slashProjectile1 = nil
            }
        }
        if let slashProjectile = slashProjectile2{
            if slashProjectile.coord.x < 0 || slashProjectile.coord.x > MAPWIDTH{
                slashProjectile2 = nil
            }
        }
        if let slashProjectile = slashProjectile3{
            if slashProjectile.coord.x < 0 || slashProjectile.coord.x > MAPWIDTH{
                slashProjectile3 = nil
            }
        }
        if let arrowProjectile = arrowProjectile1{
            if arrowProjectile.coord.x < 0 || arrowProjectile.coord.y > MAPWIDTH{
                arrowProjectile1 = nil
            }
        }
        if let arrowProjectile = arrowProjectile2{
            if arrowProjectile.coord.x < 0 || arrowProjectile.coord.y > MAPWIDTH{
                arrowProjectile2 = nil
            }
        }
        if let arrowProjectile = arrowProjectile3{
            if arrowProjectile.coord.x < 0 || arrowProjectile.coord.y > MAPWIDTH{
                arrowProjectile3 = nil
            }
        } 
    }
    
    func updateProjectilePosition(){
        if var projectile = slashProjectile1{
            projectile.move()
        }
        if var projectile = slashProjectile2{
            projectile.move()
        }
        if var projectile = slashProjectile3{
            projectile.move()
        }
        if var projectile = arrowProjectile1{
            projectile.move()
        }
        if var projectile = arrowProjectile2{
            projectile.move()
        }
        if var projectile = arrowProjectile3{
            projectile.move()
        }
    }

    func drawMap(){
        
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
        
        deleteOffMapProjectiles()
        
        print(String(repeating: "\n", count: 22))
        isGameOver()
        if(firstLoad){
            printLogo()
            firstLoad = false
        }
        print("+" + String(repeating: "-", count: MAPWIDTH) + "+")
        for y in 0 ..< MAPHEIGHT {
            print("|", terminator:"")
            for x in 0 ..< MAPWIDTH {
                let coord = Coord(x: x, y: y)
                var projectilePrinted = false
                var coinPrinted = false
                var snakeBodyPartIsThere = false

                if snake.body.contains(coord){
                    snakeBodyPartIsThere = true
                }
                if !snakeBodyPartIsThere {
                    if food == coord {
                        print("¢", terminator:"")
                        coinPrinted = true
                    }
                }
                if !coinPrinted {
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
                    if let projectile = arrowProjectile1{
                        if coord == projectile.coord{
                            print(projectile.currentChar, terminator:"")
                            projectilePrinted = true
                        }
                    }
                    if let projectile = arrowProjectile2{
                        if coord == projectile.coord{
                            print(projectile.currentChar, terminator:"")
                            projectilePrinted = true
                        }
                    }
                    if let projectile = arrowProjectile3{
                        if coord == projectile.coord{
                            print(projectile.currentChar, terminator:"")
                            projectilePrinted = true
                        }
                    }
                }
                if(!projectilePrinted && snakeBodyPartIsThere){
                    print("•", terminator:"")
                }
                if !coinPrinted && !projectilePrinted && !snakeBodyPartIsThere {
                    print(" ", terminator:"")
                }
            }
            print("|\n", terminator:"")
        }
        
        print("+" + String(repeating: "-", count: MAPWIDTH) + "+")
        print("Score: \(score)")
        if isPlayerKilled() {
            gameOverMessage("Killed")
            return
        }
        updateProjectilePosition()
    }  
}


func playGame() { 
    let g = Game()
    g.drawMap()

    while l != "q" {
        l = readLine() ?? ""
        let weaponDeterminer = Int(arc4random_uniform(UInt32(5)))
        
        switch weaponDeterminer{ //randomly chooses which projectile to shoot out
            case 0:
                if(g.slashProjectile1 == nil){
                    let sideDeterminer = Int(arc4random_uniform(UInt32(2)))
                    if(sideDeterminer == 0){
                        g.slashProjectile1 = SlashProjectile(startingCoord: Coord(x: 0, y: Int(arc4random_uniform(UInt32(20)))) , direction: .right)
                    }
                    else{
                        g.slashProjectile1 = SlashProjectile(startingCoord: Coord(x: 49, y: Int(arc4random_uniform(UInt32(20)))) , direction: .left)
                    }
                }
            
            case 1:
                if(g.slashProjectile2 == nil){
                    let sideDeterminer = Int(arc4random_uniform(UInt32(2)))
                    if(sideDeterminer == 0){
                        g.slashProjectile2 = SlashProjectile(startingCoord: Coord(x: 0, y: Int(arc4random_uniform(UInt32(20)))) , direction: .right)
                    }
                    else{
                        g.slashProjectile2 = SlashProjectile(startingCoord: Coord(x: 49, y: Int(arc4random_uniform(UInt32(20)))) , direction: .left)
                    }
                }
            case 2:
                if(g.slashProjectile3 == nil){
                    let sideDeterminer = Int(arc4random_uniform(UInt32(2)))
                    if(sideDeterminer == 0){
                        g.slashProjectile3 = SlashProjectile(startingCoord: Coord(x: 0, y: Int(arc4random_uniform(UInt32(20)))) , direction: .right)
                    }
                    else{
                        g.slashProjectile3 = SlashProjectile(startingCoord: Coord(x: 49, y: Int(arc4random_uniform(UInt32(20)))) , direction: .left)
                    }
                }
            case 3:
                if(g.arrowProjectile1 == nil ){
                    g.arrowProjectile1 = ArrowProjectile(startingCoord: Coord(x: Int(arc4random_uniform(UInt32(49))), y: 0))
                }
            case 4:
                if(g.arrowProjectile2 == nil ){
                    g.arrowProjectile2 = ArrowProjectile(startingCoord: Coord(x: Int(arc4random_uniform(UInt32(49))), y: 0))
                }
            case 5:
                if(g.arrowProjectile3 == nil ){
                    g.arrowProjectile3 = ArrowProjectile(startingCoord: Coord(x: Int(arc4random_uniform(UInt32(49))), y: 0))
                }
            default:
                break
        }
        
        
        let currentDate = Date()
        
        if firstMove{
            firstMove = false
            date = currentDate
        }
        // uncomment when i want the timer turned back on
    //    if currentDate > Date(timeInterval:1, since: date){
    //        gameOverMessage("Took Too Long To Make A Decision")
    //        break
    //    }
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

func gameOverMessage(_ message: String){
    print("Game Over: \(message)")
    print("Score: \(score)")
    l = "q"
}
playGame()