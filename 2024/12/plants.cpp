#include <iostream>
#include <iterator>
#include <set>

void get_plot_dim(std::vector<std::string> &garden,
                  std::set<std::tuple<size_t, size_t>> &visited,
                  size_t h,
                  size_t w,
                  size_t i,
                  size_t j,
                  uint64_t &area,
                  uint64_t &perim)
{
  if (visited.contains({i, j}))
    return;

  visited.insert({i, j});
  area++;

  char plant = garden[i][j];

  if (i == 0 || garden[i - 1][j] != plant)
    perim++;
  else
    get_plot_dim(garden, visited, h, w, i - 1, j, area, perim);

  if (i == h - 1 || garden[i + 1][j] != plant)
    perim++;
  else
    get_plot_dim(garden, visited, h, w, i + 1, j, area, perim);

  if (j == 0 || garden[i][j - 1] != plant)
    perim++;
  else
    get_plot_dim(garden, visited, h, w, i, j - 1, area, perim);

  if (j == w - 1 || garden[i][j + 1] != plant)
    perim++;
  else
    get_plot_dim(garden, visited, h, w, i, j + 1, area, perim);
}

int main()
{
  std::vector<std::string> garden((std::istream_iterator<std::string>(std::cin)),
                                  std::istream_iterator<std::string>());

  size_t h = garden.size(), w = garden[0].size();

  std::set<std::tuple<size_t, size_t>> visited;
  uint64_t price = 0;

  for (size_t i = 0; i < h; i++)
  {
    for (size_t j = 0; j < w; j++)
    {
      uint64_t area = 0, perim = 0;
      get_plot_dim(garden, visited, h, w, i, j, area, perim);

      if (area != 0)
        price += area * perim;
    }
  }

  std::cout << price << std::endl;
}
