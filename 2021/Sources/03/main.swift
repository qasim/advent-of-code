import Foundation
import Utility

// MARK: - Parsing

let binaryNumbers = mainInput
    .split(separator: "\n")
    .map(String.init)

let binaryLength = binaryNumbers.first?.count ?? 0

// MARK: - Main

print("Part 1: \(part1() ?? "nil")")
print("Part 2: \(part2() ?? "nil")")

// MARK: - Parts

func part1() -> Any? {
    var binaryGammaRate = ""
    var binaryEpsilonRate = ""
    
    for position in 0..<binaryLength {
        var numberOf0Bits = 0
        var numberOf1Bits = 0
        
        for binaryNumber in binaryNumbers {
            switch binaryNumber[position] {
            case "0": numberOf0Bits += 1
            case "1": numberOf1Bits += 1
            default: continue
            }
        }
        
        if numberOf0Bits > numberOf1Bits {
            binaryGammaRate.append("0")
            binaryEpsilonRate.append("1")
        } else {
            binaryGammaRate.append("1")
            binaryEpsilonRate.append("0")
        }
    }
    
    let gammaRate = Int(binaryGammaRate, radix: 2)!
    let epsilonRate = Int(binaryEpsilonRate, radix: 2)!
    
    return gammaRate * epsilonRate
}

func part2() -> Any? {
    func binaryRating(
        bitCriteria: (_ numberOf0Bits: Int, _ numberOf1Bits: Int) -> Bool
    ) -> String {
        var filteredBinaryNumbers = binaryNumbers
        var position = 0

        while filteredBinaryNumbers.count > 1 {
            var numberOf0Bits = 0
            var numberOf1Bits = 0

            for binaryNumber in filteredBinaryNumbers {
                switch binaryNumber[position] {
                case "0": numberOf0Bits += 1
                case "1": numberOf1Bits += 1
                default: continue
                }
            }

            filteredBinaryNumbers = filteredBinaryNumbers.filter { binaryNumber in
                binaryNumber[position] == (bitCriteria(numberOf0Bits, numberOf1Bits) ? "0" : "1")
            }
            position += 1
        }

        return filteredBinaryNumbers.last!
    }
    
    let oxygenGeneratorRating = Int(binaryRating(bitCriteria: >), radix: 2)!
    let co2ScrubberRating = Int(binaryRating(bitCriteria: <=), radix: 2)!

    return oxygenGeneratorRating * co2ScrubberRating
}
