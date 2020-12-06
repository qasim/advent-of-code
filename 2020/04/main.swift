import Foundation

let input = try! String(contentsOfFile: "input.txt")
let passports = input
    .components(separatedBy: "\r\n\r\n")
    .map { section in
        section
            .components(separatedBy: "\r\n")
            .joined(separator: " ")
            .components(separatedBy: " ")
            .map { $0.components(separatedBy: ":") }
            .map { Field(id: $0[0], value: $0[1]) }
    }
    .map { Passport(fields: $0) }

print("Part 1: \(part1(passports))")
print("Part 2: \(part2(passports))")

func part1(_ passports: [Passport]) -> Int {
    passports
        .filter(\.isValid)
        .count
}

func part2(_ passports: [Passport]) -> Int {
    passports
        .filter(\.isValid)
        .filter { passport in
            if let birthYear = passport.value(of: "byr") {
                guard birthYear.count == 4 else {
                    return false
                }

                guard let birthYearInt = Int(birthYear) else {
                    return false
                }

                guard (1920...2002).contains(birthYearInt) else {
                    return false
                }
            }

            if let issueYear = passport.value(of: "iyr") {
                guard issueYear.count == 4 else {
                    return false
                }

                guard let issueYearInt = Int(issueYear) else {
                    return false
                }

                guard (2010...2020).contains(issueYearInt) else {
                    return false
                }
            }

            if let expirationYear = passport.value(of: "eyr") {
                guard expirationYear.count == 4 else {
                    return false
                }

                guard let expirationYearInt = Int(expirationYear) else {
                    return false
                }

                guard (2020...2030).contains(expirationYearInt) else {
                    return false
                }
            }

            if let height = passport.value(of: "hgt") {
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

            if let hairColor = passport.value(of: "hcl") {
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

            if let eyeColor = passport.value(of: "ecl") {
                guard ["amb", "blu", "brn", "gry", "grn", "hzl", "oth"].contains(eyeColor) else {
                    return false
                }
            }

            if let passportID = passport.value(of: "pid") {
                guard passportID.count == 9 else {
                    return false
                }

                guard Int(passportID) != nil else {
                    return false
                }
            }

            return true
        }
        .count
}

struct Passport {
    let fields: [Field]

    var isValid: Bool {
        Set(fields.map(\.id))
            .isSuperset(of: Set(["byr", "iyr", "eyr", "hgt", "hcl", "ecl", "pid"]))
    }

    func value(of fieldID: String) -> String? {
        fields.first(where: { $0.id == fieldID })?.value
    }
}

struct Field {
    let id: String
    let value: String
}
