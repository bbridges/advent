#include <iostream>
#include <set>

bool end_reachable(std::vector<std::vector<bool>> &space)
{
  int w = space.size(), h = space[0].size();
  std::set<std::tuple<int, int>> visited = {}, prev = {}, curr = {{0, 0}};

  auto explore = [&](int x, int y)
  {
    if (x < 0 || x >= w || y < 0 || y >= h || !space[x][y] || visited.contains({x, y}))
      return;

    curr.insert({x, y});
  };

  while (!curr.empty())
  {
    std::swap(curr, prev);
    curr.clear();

    for (auto [x, y] : prev)
    {
      if (x == w - 1 && y == h - 1)
        return true;

      visited.insert({x, y});

      explore(x + 1, y);
      explore(x - 1, y);
      explore(x, y + 1);
      explore(x, y - 1);
    }
  }

  return false;
}

int main()
{
  const int w = 71, h = 71;

  std::vector<std::vector<bool>> space(w, std::vector<bool>(h, true));

  while (true)
  {
    int x, y;

    std::cin >> x;
    std::cin.get();
    std::cin >> y;

    space[x][y] = false;

    if (!end_reachable(space))
    {
      std::cout << x << "," << y << std::endl;
      return 0;
    }
  }
}
