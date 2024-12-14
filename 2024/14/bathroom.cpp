#include <iostream>

int main()
{
  uint64_t quad_counts[4] = {0, 0, 0, 0};
  const int64_t seconds = 100, width = 101, height = 103;

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

    px += vx * seconds;
    px %= width;
    py += vy * seconds;
    py %= height;

    if (px < 0)
      px += width;
    if (py < 0)
      py += height;

    if (py < height / 2)
    {
      if (px < width / 2)
        quad_counts[0]++;
      else if (px > width / 2)
        quad_counts[1]++;
    }
    else if (py > height / 2)
    {
      if (px < width / 2)
        quad_counts[2]++;
      else if (px > width / 2)
        quad_counts[3]++;
    }
  }

  std::cout << quad_counts[0] * quad_counts[1] * quad_counts[2] * quad_counts[3] << std::endl;
}
