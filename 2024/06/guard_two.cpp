#include <iostream>
#include <set>

enum Dir
{
  Up,
  Right,
  Down,
  Left
};

class Guard
{
private:
  int x, y, w, h;
  Dir dir;
  std::vector<std::string> &input;
  std::set<std::tuple<int, int, Dir>> visited;

public:
  Guard(std::vector<std::string> &input) : input(input)
  {
    w = input[0].size();
    h = input.size();

    for (x = 0; x < h; x++)
      if ((y = input[x].find('^')) != std::string::npos)
        break;

    dir = Up;
  }

  void move()
  {
    visited.insert({x, y, dir});

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

  bool inside()
  {
    return x >= 0 && x < h && y >= 0 && y < w;
  }

  bool in_loop()
  {
    return visited.contains({x, y, dir});
  }

  std::tuple<int, int> get_pos()
  {
    return {x, y};
  }

  Dir get_dir()
  {
    return dir;
  }
};

bool is_guard_in_loop(std::vector<std::string> &input)
{
  Guard guard(input);

  while (guard.inside())
  {
    guard.move();

    if (guard.in_loop())
      return true;
  }

  return false;
}

int position_count(std::vector<std::string> &input)
{
  std::set<std::tuple<int, int>> obstacles;
  Guard guard(input);

  while (guard.inside())
  {
    Dir prev_dir = guard.get_dir();
    guard.move();

    if (guard.get_dir() == prev_dir)
      obstacles.insert(guard.get_pos());
  }

  int count = 0;

  for (auto &[x, y] : obstacles)
  {
    if (input[x][y] == '^')
      continue;

    input[x][y] = '#';

    if (is_guard_in_loop(input))
      count++;

    input[x][y] = '.';
  }

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
