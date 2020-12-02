with open('input.txt', 'r') as f:
    entries = [int(entry) for entry in f.readlines()]

for x in entries:
    for y in entries:
        if x + y == 2020:
            print(x * y)
