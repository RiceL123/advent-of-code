import re
            # rock       paper       scissors
dictionary = {'A': 'X', 'B': 'Y', 'C': 'Z', 
              'X': 1, 'Y': 2, 'Z': 3}

letter_to_num = {'A': 1, 'B': 2, 'C': 3}

# if you want to lose then (+ 1 % 3)
# if you want to win then (if index = 0 then then choose 3, else -1 to index)
# if you want to tie then keep the same
array = ['A', 'B', 'C']

letter_dict = {'X': 'A', 'Y': 'B', 'Z': 'C'}

            #lose      #draw     #win
point_dict = {'X': 'A', 'Y': '', 'Z': 'C'}

with open("day2.txt") as f:
    sum = 0
    for line in f:
        
        letters = line.split()
        #lose so - 1 % 3
        if letters[1] == 'X':
            for i in range(3):
                if array[i] == letters[0]:
                    letters[1] = dictionary[array[(i - 1) % 3]]
                    # print(f"{array[i]} -> lose -> {array[(i + 1) % 3]}: {letters[1]}")
        # draw
        elif letters[1] == 'Y':
            # print(f"{letters[0]} -> draw -> {letters[0]}: {dictionary[letters[0]]}")
            letters[1] = dictionary[letters[0]]
        # win + 1 % 3
        elif letters[1] == 'Z':
            for i in range(3):
                if array[i] == letters[0]:
                    letters[1] = dictionary[array[(i + 1) % 3]]
                    # print(f"{array[i]} -> Win -> {array[(i - 1) % 3]}: {letters[1]}")

        sum += dictionary[letters[1]]
        if (letter_dict[letters[1]] == letters[0]):
            sum += 3
        elif ((letter_to_num[letters[0]] % 3) - dictionary[letters[1]] == -1) :
            sum += 6
            
print(sum)
