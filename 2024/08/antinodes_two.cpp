#include <iostream>
#include <map>
#include <set>

int main()
{
  std::map<char, std::vector<std::tuple<int, int>>> antennas;
  std::string line;

  int y = 0;

  while (std::getline(std::cin, line))
  {
    for (size_t x = 0; x < line.size(); x++)
    {
      char c = line[x];

      if (c == '.')
        continue;

      if (antennas.contains(c))
        antennas[c].push_back({x, y});
      else
        antennas[c] = {{x, y}};
    }

    y++;
  }

  int w = line.size(), h = y;

  std::set<std::tuple<int, int>> antinodes;

  for (auto &[c, positions] : antennas)
  {
    size_t count = positions.size();

    if (count == 1)
      continue;

    for (size_t i = 0; i < count; i++)
    {
      for (size_t j = i + 1; j < count; j++)
      {
        auto &[x_1, y_1] = positions[i];
        auto &[x_2, y_2] = positions[j];

        int dx = x_2 - x_1, dy = y_2 - y_1;

        for (int ax = x_1, ay = y_1; ax >= 0 && ax < w && ay >= 0 && ay < h; ax -= dx, ay -= dy)
          antinodes.insert({ax, ay});

        for (int ax = x_2, ay = y_2; ax >= 0 && ax < w && ay >= 0 && ay < h; ax += dx, ay += dy)
          antinodes.insert({ax, ay});
      }
    }
  }

  std::cout << antinodes.size() << std::endl;

  return 0;
}
