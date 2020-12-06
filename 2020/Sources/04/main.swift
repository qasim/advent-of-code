import Foundation

// MARK: - Main

let passports = mainInput
    .components(separatedBy: "\n\n")
    .map { section in
        section
            .components(separatedBy: "\n")
            .joined(separator: " ")
            .components(separatedBy: " ")
            .map { $0.components(separatedBy: ":") }
            .map { Field(id: $0[0], value: $0[1]) }
    }
    .map { Passport(fields: $0) }

print("Part 1: \(part1() ?? "nil")")
print("Part 2: \(part2() ?? "nil")")

// MARK: - Parts

func part1() -> Any? {
    passports
        .filter(\.containsRequiredFields)
        .count
}

func part2() -> Any? {
    passports
        .filter(\.isValid)
        .count
}

// MARK: - Types

struct Passport {
    let fields: [Field]

    var containsRequiredFields: Bool {
        Set(fields.map(\.id))
            .isSuperset(of: Set(["byr", "iyr", "eyr", "hgt", "hcl", "ecl", "pid"]))
    }

    var isValid: Bool {
        guard containsRequiredFields else {
            return false
        }

        // byr
        if let birthYear = value(of: "byr") {
            guard let birthYearInt = Int(birthYear) else {
                return false
            }

            guard (1920...2002).contains(birthYearInt) else {
                return false
            }
        }

        // iyr
        if let issueYear = value(of: "iyr") {
            guard let issueYearInt = Int(issueYear) else {
                return false
            }

            guard (2010...2020).contains(issueYearInt) else {
                return false
            }
        }

        // eyr
        if let expirationYear = value(of: "eyr") {
            guard let expirationYearInt = Int(expirationYear) else {
                return false
            }

            guard (2020...2030).contains(expirationYearInt) else {
                return false
            }
        }

        // hgt
        if let height = value(of: "hgt") {
            guard
                let heightValue = height.split(whereSeparator: \.isLetter).first,
                let heightInt = Int(heightValue)
            else {
                return false
            }

            switch height.suffix(2) {
            case "cm":
                if !(150...193).contains(heightInt) {
                    return false
                }

            case "in":
                if !(59...76).contains(heightInt) {
                    return false
                }

            default:
                return false
            }
        }

        // hcl
        if let hairColor = value(of: "hcl") {
            guard hairColor.count == 7 else {
                return false
            }

            guard hairColor.starts(with: "#") else {
                return false
            }

            guard hairColor.suffix(6).allSatisfy({ character in
                ["a", "b", "c", "d", "e", "f", "0", "1", "2", "3", "4", "5", "6", "7", "8", "9"].contains(character)
            }) else {
                return false
            }
        }

        // ecl
        if let eyeColor = value(of: "ecl") {
            guard ["amb", "blu", "brn", "gry", "grn", "hzl", "oth"].contains(eyeColor) else {
                return false
            }
        }

        // pid
        if let passportID = value(of: "pid") {
            guard passportID.count == 9 else {
                return false
            }

            guard Int(passportID) != nil else {
                return false
            }
        }

        return true
    }

    func value(of fieldID: String) -> String? {
        fields.first(where: { $0.id == fieldID })?.value
    }
}

struct Field {
    let id: String
    let value: String
}
