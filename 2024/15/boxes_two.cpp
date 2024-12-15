#include <iostream>
#include <set>
#include <sstream>
#include <list>

int main()
{
  std::vector<std::string> warehouse;
  size_t w, h, x = 0, y = 0;
  std::string line;

  while (std::getline(std::cin, line) && line.length() > 0)
  {
    std::ostringstream os;

    for (size_t i = 0; i < line.length(); i++)
    {
      switch (line[i])
      {
      case '#':
        os << "##";
        break;
      case 'O':
        os << "[]";
        break;
      case '.':
        os << "..";
        break;
      case '@':
        x = i * 2;
        os << "@.";
        break;
      }
    }

    warehouse.push_back(os.str());

    if (x == 0)
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

      if (dx != 0)
      {
        size_t n = 1;
        while (warehouse[y][x + n * dx] == '[' || warehouse[y][x + n * dx] == ']')
          n++;

        if (warehouse[y][x + n * dx] != '.')
          continue;

        for (size_t i = n; i != 0; i--)
          std::swap(warehouse[y][x + i * dx], warehouse[y][x + (i - 1) * dx]);

        x += dx;
      }
      else
      {
        bool movable = true;
        size_t n = 1;
        std::list<std::set<size_t>> to_move = {{x}};

        while (movable)
        {
          std::set<size_t> next;

          for (size_t i : to_move.front())
          {
            if (warehouse[y + n * dy][i] == '#')
            {
              movable = false;
              break;
            }
            else if (warehouse[y + n * dy][i] == '[')
            {
              next.insert(i);
              next.insert(i + 1);
            }
            else if (warehouse[y + n * dy][i] == ']')
            {
              next.insert(i);
              next.insert(i - 1);
            }
          }

          if (next.size() == 0)
            break;

          to_move.push_front(next);
          n++;
        }

        if (!movable)
          continue;

        for (size_t j = n; j != 0; j--, to_move.pop_front())
          for (size_t i : to_move.front())
            std::swap(warehouse[y + j * dy][i], warehouse[y + (j - 1) * dy][i]);

        y += dy;
      }
    }
  }

  uint64_t sum = 0;

  for (size_t j = 0; j < h; j++)
    for (size_t i = 0; i < w; i++)
      if (warehouse[j][i] == '[')
        sum += 100 * j + i;

  std::cout << sum << std::endl;
}
