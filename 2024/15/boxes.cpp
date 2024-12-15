#include <iostream>

int main()
{
  std::vector<std::string> warehouse;
  size_t w, h, x = std::string::npos, y = 0;
  std::string line;

  while (std::getline(std::cin, line) && line.length() > 0)
  {
    warehouse.push_back(line);

    if (x != std::string::npos)
      continue;

    x = line.find('@');

    if (x == std::string::npos)
      y++;
  }

  w = warehouse[0].size();
  h = warehouse.size();

  while (std::getline(std::cin, line))
  {
    for (char c : line)
    {
      std::ptrdiff_t dx = 0, dy = 0;

      switch (c)
      {
      case '^':
        dy = -1;
        break;
      case 'v':
        dy = 1;
        break;
      case '<':
        dx = -1;
        break;
      case '>':
        dx = 1;
        break;
      }

      size_t n = 1;
      while (warehouse[y + n * dy][x + n * dx] == 'O')
        n++;

      if (n > 1 && warehouse[y + n * dy][x + n * dx] == '.')
        std::swap(warehouse[y + n * dy][x + n * dx], warehouse[y + dy][x + dx]);

      if (warehouse[y + dy][x + dx] != '.')
        continue;

      std::swap(warehouse[y][x], warehouse[y + dy][x + dx]);
      x += dx;
      y += dy;
    }
  }

  uint64_t sum = 0;

  for (size_t j = 0; j < h; j++)
    for (size_t i = 0; i < w; i++)
      if (warehouse[j][i] == 'O')
        sum += 100 * j + i;

  std::cout << sum << std::endl;
}
