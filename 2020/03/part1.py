with open('input.txt', 'r') as f:
    map = [list(entry.strip()) for entry in f.readlines()]

def trees_encountered(slope_x: int, slope_y: int) -> int:
    total = 0

    current_x = 0
    current_y = 0

    while current_y < len(map):
        space = map[current_y][current_x]

        if space == '#':
            total += 1

        current_x += slope_x
        if current_x >= len(map[current_y]):
            current_x -= len(map[current_y])

        current_y += slope_y

    return total

print(trees_encountered(3, 1))
