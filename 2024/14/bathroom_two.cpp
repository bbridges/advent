#include <algorithm>
#include <iostream>

int main()
{
  const int64_t width = 101, height = 103;
  std::vector<std::vector<int64_t>> input;

  while (!std::cin.eof())
  {
    int64_t px, py, vx, vy;

    std::cin.get();
    std::cin.get();
    std::cin >> px;
    std::cin.get();
    std::cin >> py;
    std::cin.get();
    std::cin.get();
    std::cin.get();
    std::cin >> vx;
    std::cin.get();
    std::cin >> vy;
    std::cin.get();

    input.push_back({px, py, vx, vy});
  }

  for (int seconds = 0; seconds < 10000; seconds++)
  {
    std::vector<std::string> bathroom;

    for (int i = 0; i < height; i++)
      bathroom.push_back(std::string(width, ' '));

    for (auto robot : input)
    {
      int64_t px = robot[0], py = robot[1], vx = robot[2], vy = robot[3];

      px += vx * seconds;
      px %= width;
      py += vy * seconds;
      py %= height;

      if (px < 0)
        px += width;
      if (py < 0)
        py += height;

      bathroom[py][px] = 'X';
    }

    if (!std::any_of(bathroom.begin(),
                     bathroom.end(),
                     [](std::string s)
                     { return s.contains("XXXXXXXXXX"); }))
      continue;

    for (auto row : bathroom)
      std::cout << row << std::endl;

    std::cout << seconds << std::endl;
    break;
  }
}
