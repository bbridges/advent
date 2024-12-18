#include <iostream>
#include <set>

int step_count(std::vector<std::vector<bool>> &space)
{
  int w = space.size(), h = space[0].size(), steps = 0;
  std::set<std::tuple<int, int>> visited = {}, prev = {}, curr = {{0, 0}};

  auto explore = [&](int x, int y)
  {
    if (x < 0 || x >= w || y < 0 || y >= h || !space[x][y] || visited.contains({x, y}))
      return;

    curr.insert({x, y});
  };

  while (true)
  {
    std::swap(curr, prev);
    curr.clear();

    for (auto [x, y] : prev)
    {
      if (x == w - 1 && y == h - 1)
        return steps;

      visited.insert({x, y});

      explore(x + 1, y);
      explore(x - 1, y);
      explore(x, y + 1);
      explore(x, y - 1);
    }

    steps++;
  }
}

int main()
{
  const int w = 71, h = 71, bytes = 1024;

  std::vector<std::vector<bool>> space(w, std::vector<bool>(h, true));

  for (int i = 0; i < bytes; i++)
  {
    int x, y;

    std::cin >> x;
    std::cin.get();
    std::cin >> y;

    space[x][y] = false;
  }

  std::cout << step_count(space) << std::endl;
}
