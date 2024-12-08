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

    for (size_t i = 0; i < count; i++)
    {
      for (size_t j = i + 1; j < count; j++)
      {
        auto &[x_1, y_1] = positions[i];
        auto &[x_2, y_2] = positions[j];

        int ax_1 = x_1 - (x_2 - x_1), ay_1 = y_1 - (y_2 - y_1);
        int ax_2 = x_2 - (x_1 - x_2), ay_2 = y_2 - (y_1 - y_2);

        if (ax_1 >= 0 && ax_1 < w && ay_1 >= 0 && ay_1 < h)
          antinodes.insert({ax_1, ay_1});

        if (ax_2 >= 0 && ax_2 < w && ay_2 >= 0 && ay_2 < h)
          antinodes.insert({ax_2, ay_2});
      }
    }
  }

  std::cout << antinodes.size() << std::endl;

  return 0;
}
