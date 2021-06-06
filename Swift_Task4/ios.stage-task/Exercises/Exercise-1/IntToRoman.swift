import Foundation

public extension Int {
    
    var roman: String? {
        var input = self;
        if (input < 1 || 3999 < input){
            return nil
        }
        
        var result = ""
        let romanMap = [1000:"M", 900:"CM", 500:"D", 400:"CD",
                        100:"C", 90:"XC", 50:"L", 40:"XL",
                        10:"X", 9:"IX", 5:"V", 4:"IV", 1:"I",].sorted(by: { $0.key > $1.key })
        while input > 0{
            let first = romanMap.first(where: {input >= $0.key})
            result.append(first!.value)
            input -= first!.key
        }
        return result
    }
}
