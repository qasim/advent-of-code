#!/usr/bin/env python3

def fuel_required(mass: int) -> int:
  return (mass // 3) - 2

def main():
  with open('input.txt', 'r') as input_file:
    total_fuel = 0
    for line in input_file:
      mass = int(line.strip())
      total_fuel += fuel_required(mass)
    print(total_fuel)

if __name__ == "__main__":
  main()
