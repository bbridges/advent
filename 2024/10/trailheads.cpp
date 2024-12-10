#include <iostream>
#include <map>
#include <set>

int main()
{
  std::vector<std::string> data;
  std::string line;

  while (std::getline(std::cin, line))
    data.push_back(line);

  size_t h = line.size(), w = data[0].size();

  using Loc = std::tuple<size_t, size_t>;
  std::map<Loc, std::set<Loc>> curr_levels, next_levels;

  auto add_peaks = [](std::map<Loc, std::set<Loc>> &levels, Loc loc, std::set<Loc> &peaks)
  {
    if (levels.contains(loc))
      levels[loc].insert(peaks.begin(), peaks.end());
    else
      levels[loc] = peaks;
  };

  for (size_t i = 0; i < h; i++)
    for (size_t j = 0; j < w; j++)
      if (data[i][j] == '9')
        curr_levels[{i, j}] = {{i, j}};

  for (char level = '9'; level > '0'; level--)
  {
    for (auto &[loc, peaks] : curr_levels)
    {
      auto &[i, j] = loc;

      if (i > 0 && data[i - 1][j] == level - 1)
        add_peaks(next_levels, {i - 1, j}, peaks);

      if (i < h - 1 && data[i + 1][j] == level - 1)
        add_peaks(next_levels, {i + 1, j}, peaks);

      if (j > 0 && data[i][j - 1] == level - 1)
        add_peaks(next_levels, {i, j - 1}, peaks);

      if (j < w - 1 && data[i][j + 1] == level - 1)
        add_peaks(next_levels, {i, j + 1}, peaks);
    }

    swap(curr_levels, next_levels);
    next_levels.clear();
  }

  int sum = 0;

  for (auto &[_, peaks] : curr_levels)
    sum += peaks.size();

  std::cout << sum << std::endl;

  return 0;
}
