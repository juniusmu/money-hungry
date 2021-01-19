//
//  main.swift
//  money-hungry
//
//

import Foundation

import Foundation
let MAPWIDTH  = 50
let MAPHEIGHT = 20
var score: Int = 0
var userInput = ""

// Influence by: codereview.stackexchange.com/questions/182367/console-based-snake-game
var firstMove: Bool = true
var lastPressedButton: String = "s"
var date: Date = Date()

struct Coordinate: Equatable {
    let x: Int
    let y: Int

    static func ==(lhs: Coordinate, rhs: Coordinate) -> Bool {
        return lhs.x == rhs.x && lhs.y == rhs.y
    }
}

var food = Coordinate(x: 10, y: 10)

enum Direction: Int {
    case up
    case down
    case left
    case right
}


class Snake{
    var body = [Coordinate(x: 25, y: 5), Coordinate(x: 25, y: 4),Coordinate(x: 25, y: 3), Coordinate(x: 25, y: 2), Coordinate(x: 25, y: 1), Coordinate(x: 25, y: 0)]
    var direction = Direction.down
    func move(nextDirection: Direction){
        let newCoordinate: Coordinate?
        self.direction = nextDirection
        
        switch self.direction{
           case .up:
            newCoordinate = Coordinate(x: self.body[0].x, y: self.body[0].y - 1)
            break
           case .down:
            newCoordinate = Coordinate(x: self.body[0].x, y: self.body[0].y + 1)
           case .left:
            newCoordinate = Coordinate(x: self.body[0].x - 1, y: self.body[0].y)
           case .right:
            newCoordinate = Coordinate(x: self.body[0].x + 1, y: self.body[0].y)
        }
        self.body.insert(newCoordinate!, at: 0)
        self.body.removeLast()
    }
}

protocol Projectile{
    var currentCharacter: String {get set}
    var coordinate: Coordinate {get set}
}

protocol CircularMovement: Projectile{
    var direction: Direction {get}
    var coordinate: Coordinate {get set}
    var numStages: Int {get set}
    var phaseCharacters: [String] {get}
    var stage: Int {get set}
}

extension CircularMovement{
    mutating func move(){
        var xVal = 1
        if self.direction == .left{
            xVal = -1
        }
        let stageInLife = self.stage % self.numStages
        switch stageInLife{
            case 0:
                self.coordinate = Coordinate(x: self.coordinate.x + 2 * xVal, y: self.coordinate.y + 1)
                break
            case 1:
                self.coordinate = Coordinate(x: self.coordinate.x + 2 * xVal, y: self.coordinate.y - 1)
                break
            case 2:
                self.coordinate = Coordinate(x: self.coordinate.x - 1 * xVal, y: self.coordinate.y - 1)
                break
            case 3:
                self.coordinate = Coordinate(x: self.coordinate.x + 2 * xVal, y: self.coordinate.y + 1)
                break
            default:
                break
        }
        stage = stage + 1
        self.currentCharacter = self.phaseCharacters[stage % self.phaseCharacters.count]
    }
}

class ArrowProjectile: Projectile{
    var currentCharacter = "V"
    var coordinate: Coordinate
    init(startingCoord: Coordinate){
        coordinate = startingCoord
    }
    
    func move(){
        self.coordinate = Coordinate(x: self.coordinate.x, y: self.coordinate.y + 1)
    }
}

class SlashProjectile: Projectile, CircularMovement{
    var currentCharacter: String = "/"
    var coordinate: Coordinate
    var direction: Direction
    var numStages: Int = 4
    var stage: Int = 0
    var phaseCharacters: [String] = ["\\", "/"]
   
    init(startingCoordinate: Coordinate, direction: Direction){
        self.coordinate = startingCoordinate
        self.direction = direction
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
                let limbsWithSameCoordinate = snake.body.filter{$0 == limb}
                if limbsWithSameCoordinate.count > 1{
                    return true
                }
            }
            return false
        }
        func isSnakeOutOfBounds() -> Bool{
            let snakeHead = snake.body[0]
            if(snakeHead.y > MAPHEIGHT - 1 || snakeHead.y < 0 ||
            snakeHead.x > MAPWIDTH - 1 || snakeHead.x < 0){
                return true
            }
            return false
        }
        func isSnakeHitWithProjectile() -> Bool{
            return false
        }
        if isSnakeOverlapping(){
            gameOverMessage(message: "You Got In Your Own Way :(", score: score)
        }
        if isSnakeOutOfBounds(){
            gameOverMessage(message: "You hit a wall", score: score)
        }
        if isPlayerKilled() {
            gameOverMessage(message: "Killed", score: score)
            return
        }

    }


    func generateNewFoodCoords() -> Coordinate {
        return Coordinate(x: Int(arc4random_uniform(UInt32(MAPWIDTH-15))) + 5, y: Int(arc4random_uniform(UInt32(MAPHEIGHT - 10 ))) + 5)
    }
    func isProjectileAttackingSnake(projectile: Projectile) -> Bool{
        return snake.body.contains(projectile.coordinate)
    }
    func isPlayerKilled() -> Bool {
        var projectiles = [Projectile?]()
        projectiles.append(slashProjectile1)
        projectiles.append(slashProjectile2)
        projectiles.append(slashProjectile3)
        projectiles.append(arrowProjectile1)
        projectiles.append(arrowProjectile2)
        projectiles.append(arrowProjectile3)

        for projectile in projectiles{
            if let projectile = projectile{
                if(isProjectileAttackingSnake(projectile: projectile)){
                    return true
                }
            }
        }
        return false
    }
    func deleteOffMapProjectiles(){
        if let slashProjectile = slashProjectile1{
            if slashProjectile.coordinate.x < 0 || slashProjectile.coordinate.x > MAPWIDTH{
                slashProjectile1 = nil
            }
        }
        if let slashProjectile = slashProjectile2{
            if slashProjectile.coordinate.x < 0 || slashProjectile.coordinate.x > MAPWIDTH{
                slashProjectile2 = nil
            }
        }
        if let slashProjectile = slashProjectile3{
            if slashProjectile.coordinate.x < 0 || slashProjectile.coordinate.x > MAPWIDTH{
                slashProjectile3 = nil
            }
        }
        if let arrowProjectile = arrowProjectile1{
            if arrowProjectile.coordinate.x < 0 || arrowProjectile.coordinate.y > MAPWIDTH{
                arrowProjectile1 = nil
            }
        }
        if let arrowProjectile = arrowProjectile2{
            if arrowProjectile.coordinate.x < 0 || arrowProjectile.coordinate.y > MAPWIDTH{
                arrowProjectile2 = nil
            }
        }
        if let arrowProjectile = arrowProjectile3{
            if arrowProjectile.coordinate.x < 0 || arrowProjectile.coordinate.y > MAPWIDTH{
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
        if let projectile = arrowProjectile1{
            projectile.move()
        }
        if let projectile = arrowProjectile2{
            projectile.move()
        }
        if let projectile = arrowProjectile3{
            projectile.move()
        }
    }

    func drawMap(){
        if snake.body.contains(food){
            food = generateNewFoodCoords()
            score = score + 1
            
        }
        
        deleteOffMapProjectiles()
        
        print(String(repeating: "\n", count: 22))
        isGameOver()
        if(firstLoad){
            displayGameLogo()
            firstLoad = false
        }
        print("+" + String(repeating: "-", count: MAPWIDTH) + "+")
        for y in 0 ..< MAPHEIGHT {
            print("|", terminator:"")
            for x in 0 ..< MAPWIDTH {
                let coord = Coordinate(x: x, y: y)
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
                        if coord == projectile.coordinate{
                            print(projectile.currentCharacter, terminator:"")
                            projectilePrinted = true

                        }
                        
                    }
                    if let projectile = slashProjectile2{
                        
                        if coord == projectile.coordinate{
                            print(projectile.currentCharacter, terminator:"")
                            projectilePrinted = true
                            
                        }
                        
                    }
                    if let projectile = slashProjectile3{
                        
                        if coord == projectile.coordinate{
                            print(projectile.currentCharacter, terminator:"")
                            projectilePrinted = true
                        }
                        
                    }
                    if let projectile = arrowProjectile1{
                        if coord == projectile.coordinate{
                            print(projectile.currentCharacter, terminator:"")
                            projectilePrinted = true
                        }
                    }
                    if let projectile = arrowProjectile2{
                        if coord == projectile.coordinate{
                            print(projectile.currentCharacter, terminator:"")
                            projectilePrinted = true
                        }
                    }
                    if let projectile = arrowProjectile3{
                        if coord == projectile.coordinate{
                            print(projectile.currentCharacter, terminator:"")
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
        updateProjectilePosition()
    }
}

func startGame() {
    userInput = readLine() ?? ""
    let game = Game()
    game.drawMap()

    while userInput != "q" {
        userInput = readLine() ?? ""
        let weaponDeterminer = Int(arc4random_uniform(UInt32(5)))
        
        switch weaponDeterminer{ //randomly chooses which projectile to shoot out
            case 0:
                if(game.slashProjectile1 == nil){
                    let sideDeterminer = Int(arc4random_uniform(UInt32(2)))
                    if(sideDeterminer == 0){
                        game.slashProjectile1 = SlashProjectile(startingCoordinate: Coordinate(x: 0, y: Int(arc4random_uniform(UInt32(20)))) , direction: .right)
                    }
                    else{
                        game.slashProjectile1 = SlashProjectile(startingCoordinate: Coordinate(x: 49, y: Int(arc4random_uniform(UInt32(20)))) , direction: .left)
                    }
                }
            
            case 1:
                if(game.slashProjectile2 == nil){
                    let sideDeterminer = Int(arc4random_uniform(UInt32(2)))
                    if(sideDeterminer == 0){
                        game.slashProjectile2 = SlashProjectile(startingCoordinate: Coordinate(x: 0, y: Int(arc4random_uniform(UInt32(20)))) , direction: .right)
                    }
                    else{
                        game.slashProjectile2 = SlashProjectile(startingCoordinate: Coordinate(x: 49, y: Int(arc4random_uniform(UInt32(20)))) , direction: .left)
                    }
                }
            case 2:
                if(game.slashProjectile3 == nil){
                    let sideDeterminer = Int(arc4random_uniform(UInt32(2)))
                    if(sideDeterminer == 0){
                        game.slashProjectile3 = SlashProjectile(startingCoordinate: Coordinate(x: 0, y: Int(arc4random_uniform(UInt32(20)))) , direction: .right)
                    }
                    else{
                        game.slashProjectile3 = SlashProjectile(startingCoordinate: Coordinate(x: 49, y: Int(arc4random_uniform(UInt32(20)))) , direction: .left)
                    }
                }
            case 3:
                if(game.arrowProjectile1 == nil ){
                    game.arrowProjectile1 = ArrowProjectile(startingCoord: Coordinate(x: Int(arc4random_uniform(UInt32(49))), y: 0))
                }
            case 4:
                if(game.arrowProjectile2 == nil ){
                    game.arrowProjectile2 = ArrowProjectile(startingCoord: Coordinate(x: Int(arc4random_uniform(UInt32(49))), y: 0))
                }
            case 5:
                if(game.arrowProjectile3 == nil ){
                    game.arrowProjectile3 = ArrowProjectile(startingCoord: Coordinate(x: Int(arc4random_uniform(UInt32(49))), y: 0))
                }
            default:
                break
        }
        
        
        let currentDate = Date()
        
        if firstMove{
            firstMove = false
            date = currentDate
        }
       if currentDate > Date(timeInterval:1, since: date){
        gameOverMessage(message: "Took Too Long To Make A Decision", score: score)
           break
       }
        date = Date()
        if (userInput != ""){
            if userInput == "w" || userInput == "a" || userInput == "s" || userInput == "d" {
                lastPressedButton = userInput
            }
            else{
                userInput = lastPressedButton
            }
        }
        else{
            userInput = lastPressedButton
        }
        switch userInput{
            case "w":
                game.snake.move(nextDirection: .up)
            case "a":
                game.snake.move(nextDirection: .left)
            case "s":
                game.snake.move(nextDirection: .down)
            case "d":
                game.snake.move(nextDirection: .right)
            default:
                break
        }
        game.drawMap()
    }
}

displayGameInstructions()
startGame()
