import re

file = "day05.txt"

# initializing the list of lists (which will act as a list of stacks)
listoflists = []
with open(file) as f:
    firstline = f.readline().strip('\n')

numoflists = int(len(firstline) / 4) + 1
for i in range(numoflists):
    listoflists.append([])

# open the file and parsing the info
with open(file) as f:
    init = True
    for line in f:
        # initializing the list of lists/ list of stacks
        if init == True:
            if (line[0:3] == ' 1 '):
                # for i in range(numoflists):
                    # print(listoflists[i])
                init = False
            else:
                i = int(0)
                while (line[i] != '\n'):
                    stack = (i - 1) % 4
                    if stack == 0 and line[i] != '' and line[i] != ' ':
                        listoflists[int((i - 1) / 4)].append(line[i])
                    i+=1
        # init is complete time to move the boxes around
        else:
            result = re.match(r"move ([0-9]+) from ([0-9]+) to ([0-9]+)", line)
            if (result != None):
                ### part 1 ###
                # for i in range(int(result.group(1))):
                #     listoflists[int(result.group(3)) - 1].insert(0, listoflists[int(result.group(2)) - 1].pop(0))

                ### part 2 ###
                i = int(result.group(1)) - 1
                while i >= 0:
                    listoflists[int(result.group(3)) - 1].insert(0, listoflists[int(result.group(2)) - 1].pop(i))
                    i-=1

    for i in range(numoflists):
        print(listoflists[i][0], end='')
    print('')
