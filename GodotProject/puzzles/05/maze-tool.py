from sys import stdin

maze = []
i = 0

def setChar(i, j, c):
    if i < len(maze) and j < len(maze[i]):
        maze[i][j] = c

        
def getChar(i, j):
    if i >= 0 and j >= 0 and i < len(maze) and j < len(maze[i]):
        return tmaze[i][j]
    return None

def next0(i, j, dx, dy):
    return getChar(i + dy, j + dx) == '0'

def wasZero(i, j, dx, dy):
    return getChar(i - dy, j - dx) == '0'

def convert0ToLines(size, dx, dy, c):
    for j in range(size):
        was0 = wasZero(i, j, dx, dy)
        are0 = getChar(i, j) == '0'
        if next0(i, j, dx, dy):
            if was0 and are0:
                setChar(i, j, '#')
            elif are0:
                setChar(i, j, c)
            else:
                setChar(i, j, getChar(i, j))
        else:
            if was0 and are0:
                setChar(i, j, 'x')
            else:
                setChar(i, j, getChar(i, j))
    

for line in stdin:
    maze.append(list(line))


maze_h = len(maze)
maze_w = len(maze[0])
    
tmaze = [list(x) for x in maze]
for i in range(maze_h):
    convert0ToLines(maze_w, 0, 1, 'v')
tmaze = [list(x) for x in maze]
for i in range(maze_h):
    convert0ToLines(maze_w, 1, 0, '>')


print("".join(["".join(line) for line in maze]), end='')
