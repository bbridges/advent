#include <iostream>

enum Dir
{
  Up,
  Right,
  Down,
  Left
};

int position_count(std::vector<std::string> input)
{
  int w = input[0].size(), h = input.size();

  int x, y;
  Dir dir = Up;

  for (x = 0; x < h; x++)
    if ((y = input[x].find('^')) != std::string::npos)
      break;

  while (x >= 0 && x < h && y >= 0 && y < w)
  {
    input[x][y] = 'X';

    switch (dir)
    {
    case Up:
      if (x > 0 && input[x - 1][y] == '#')
        dir = Right;
      else
        x--;
      break;
    case Right:
      if (y < w - 1 && input[x][y + 1] == '#')
        dir = Down;
      else
        y++;
      break;
    case Down:
      if (x < h - 1 && input[x + 1][y] == '#')
        dir = Left;
      else
        x++;
      break;
    case Left:
      if (y > 0 && input[x][y - 1] == '#')
        dir = Up;
      else
        y--;
      break;
    }
  }

  int count = 0;

  for (size_t i = 0; i < h; i++)
    for (size_t j = 0; j < w; j++)
      if (input[i][j] == 'X')
        count++;

  return count;
}

int main()
{
  std::vector<std::string> input;
  std::string line;

  while (std::getline(std::cin, line))
    input.push_back(line);

  std::cout << position_count(input) << std::endl;

  return 0;
}
