#!/usr/bin/env python3

def fuel_required(mass: int) -> int:
  return (mass // 3) - 2

def fuel_required_including_fuel(mass: int) -> int:
  total_fuel = 0
  fuel = fuel_required(mass)
  while fuel > 0:
    total_fuel += fuel
    fuel = fuel_required(fuel)
  return total_fuel

def main():
  with open('input.txt', 'r') as input_file:
    total_fuel = 0
    for line in input_file:
      mass = int(line.strip())
      total_fuel += fuel_required_including_fuel(mass)
    print(total_fuel)

if __name__ == "__main__":
  main()
