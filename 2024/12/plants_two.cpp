#include <iostream>
#include <iterator>
#include <set>

void get_fences(std::vector<std::string> &garden,
                size_t h,
                size_t w,
                std::vector<std::vector<std::set<uint64_t>>> &fences)
{
  uint64_t fence_id = 0;
  char prev;

  auto check_fence = [&](size_t i, size_t j, std::ptrdiff_t di, std::ptrdiff_t dj)
  {
    char plant = garden[i][j];

    if (plant != prev)
      fence_id++;

    bool in_bounds = (i + di) >= 0 && (i + di) < h && (j + dj) >= 0 && (j + dj) < w;

    if (!in_bounds || garden[i + di][j + dj] != plant)
      fences[i][j].insert(fence_id);
    else
      fence_id++;

    prev = plant;
  };

  for (size_t i = 0; i < h; i++)
  {
    prev = 0;
    for (size_t j = 0; j < w; j++)
      check_fence(i, j, -1, 0);

    prev = 0;
    for (size_t j = 0; j < w; j++)
      check_fence(i, j, 1, 0);
  }

  for (size_t j = 0; j < w; j++)
  {
    prev = 0;
    for (size_t i = 0; i < h; i++)
      check_fence(i, j, 0, -1);

    prev = 0;
    for (size_t i = 0; i < h; i++)
      check_fence(i, j, 0, 1);
  }
}

void get_plot_dim(std::vector<std::string> &garden,
                  std::vector<std::vector<std::set<uint64_t>>> &fences,
                  std::set<std::tuple<size_t, size_t>> &visited,
                  size_t h,
                  size_t w,
                  size_t i,
                  size_t j,
                  uint64_t &area,
                  std::set<uint64_t> &sides)
{
  if (visited.contains({i, j}))
    return;

  visited.insert({i, j});
  sides.insert(fences[i][j].begin(), fences[i][j].end());
  area++;

  char plant = garden[i][j];

  if (i > 0 && garden[i - 1][j] == plant)
    get_plot_dim(garden, fences, visited, h, w, i - 1, j, area, sides);

  if (i < h - 1 && garden[i + 1][j] == plant)
    get_plot_dim(garden, fences, visited, h, w, i + 1, j, area, sides);

  if (j > 0 && garden[i][j - 1] == plant)
    get_plot_dim(garden, fences, visited, h, w, i, j - 1, area, sides);

  if (j < w - 1 && garden[i][j + 1] == plant)
    get_plot_dim(garden, fences, visited, h, w, i, j + 1, area, sides);
}

int main()
{
  std::vector<std::string> garden((std::istream_iterator<std::string>(std::cin)),
                                  std::istream_iterator<std::string>());

  size_t h = garden.size(), w = garden[0].size();

  std::vector<std::vector<std::set<uint64_t>>>
      fences(h, std::vector<std::set<uint64_t>>(w, std::set<uint64_t>()));
  get_fences(garden, h, w, fences);

  std::set<std::tuple<size_t, size_t>> visited;
  uint64_t price = 0;

  for (size_t i = 0; i < h; i++)
  {
    for (size_t j = 0; j < w; j++)
    {
      uint64_t area = 0;
      std::set<uint64_t> sides;
      get_plot_dim(garden, fences, visited, h, w, i, j, area, sides);

      if (area != 0)
        price += area * sides.size();
    }
  }

  std::cout << price << std::endl;
}
