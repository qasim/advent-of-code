with open('input.txt', 'r') as f:
    entries = f.readlines()

valid_passwords = []

for entry in entries:
    policy_range, character, password = entry.split(' ')
    policy_range = [int(x) for x in policy_range.split('-')]
    character = character[:1]
    password = password.strip()

    if policy_range[0] <= password.count(character) <= policy_range[1]:
        valid_passwords.append(password)

print(len(valid_passwords))