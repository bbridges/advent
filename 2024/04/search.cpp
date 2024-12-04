#include <iostream>

int xmas_count(std::vector<std::string> input)
{
  int count = 0;
  size_t w = input[0].size(), h = input.size();

  const std::tuple<int, int> dirs[8] = {
    {1, 1}, {1, 0}, {1, -1}, {0, 1}, {0, -1}, {-1, 1}, {-1, 0}, {-1, -1}
  };

  for (size_t i = 0; i < h; i++)
  {
    for (size_t j = 0; j < w; j++)
    {
      if (input[i][j] == 'X')
      {
        for (auto &[m, n] : dirs)
        {
          if (i + 3 * m >= 0 && i + 3 * m < h && j + 3 * n >= 0 && j + 3 * n < w
              && input[i + m][j + n] == 'M'
              && input[i + 2 * m][j + 2 * n] == 'A'
              && input[i + 3 * m][j + 3 * n] == 'S')
          {
            count++;
          }
        }
      }
    }
  }

  return count;
}

int main()
{
  std::vector<std::string> input;
  std::string line;

  while (std::getline(std::cin, line))
    input.push_back(line);

  std::cout << xmas_count(input) << std::endl;

  return 0;
}
