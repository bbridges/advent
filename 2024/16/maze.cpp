#include <iostream>
#include <iterator>
#include <queue>
#include <set>

int main()
{
  std::istream_iterator<std::string> begin(std::cin), end;
  std::vector<std::string> maze(begin, end);

  size_t w = maze[0].size(), h = maze.size(), start_x, start_y, end_x, end_y;

  for (size_t j = 0; j < h; j++)
  {
    for (size_t i = 0; i < w; i++)
    {
      if (maze[j][i] == 'S')
      {
        start_x = i;
        start_y = j;
      }
      else if (maze[j][i] == 'E')
      {
        end_x = i;
        end_y = j;
      }
    }
  }

  using QueueEntry = std::tuple<size_t, size_t, uint8_t, uint64_t>;

  auto compare_cost = [](QueueEntry left, QueueEntry right)
  {
    return std::get<3>(left) >= std::get<3>(right);
  };

  std::priority_queue<QueueEntry, std::vector<QueueEntry>, decltype(compare_cost)> open(compare_cost);
  std::set<std::tuple<size_t, size_t, uint8_t>> closed;

  open.push({start_x, start_y, 1, 0});
  open.push({start_x, start_y, 0, 1000});
  open.push({start_x, start_y, 2, 1000});
  open.push({start_x, start_y, 3, 2000});

  auto pos = open.top();
  open.pop();

  while (std::get<0>(pos) != end_x || std::get<1>(pos) != end_y)
  {
    open.pop();
    auto &[x, y, dir, cost] = pos;

    if (!closed.contains({x, y, dir}))
    {
      closed.insert({x, y, dir});

      std::ptrdiff_t dx = (2 - dir) % 2, dy = (dir - 1) % 2;

      if (maze[y + dy][x + dx] != '#' && !closed.contains({x + dx, y + dy, dir}))
        open.push({x + dx, y + dy, dir, cost + 1});

      dir = (dir + 1) % 4;
      if (maze[y + (dir - 1) % 2][x + (2 - dir) % 2] != '#' && !closed.contains({x, y, dir}))
        open.push({x, y, dir, cost + 1000});

      dir = (dir + 2) % 4;
      if (maze[y + (dir - 1) % 2][x + (2 - dir) % 2] != '#' && !closed.contains({x, y, dir}))
        open.push({x, y, dir, cost + 1000});
    }

    pos = open.top();
  }

  std::cout << std::get<3>(pos) << std::endl;
}
