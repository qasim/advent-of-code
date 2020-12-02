with open('input.txt', 'r') as f:
    entries = f.readlines()

valid_passwords = []

for entry in entries:
    policy_indices, character, password = entry.split(' ')
    policy_indices = [int(x) for x in policy_indices.split('-')]
    character = character[:1]
    password = password.strip()

    policy_characters = [password[policy_indices[0] - 1], password[policy_indices[1] - 1]]
    if policy_characters.count(character) == 1:
        valid_passwords.append(password)

print(len(valid_passwords))
