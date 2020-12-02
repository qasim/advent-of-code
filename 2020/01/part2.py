with open('input.txt', 'r') as f:
    entries = [int(entry) for entry in f.readlines()]

for x in entries:
    for y in entries:
        for z in entries:
            if x + y + z == 2020:
                print(x * y * z)
