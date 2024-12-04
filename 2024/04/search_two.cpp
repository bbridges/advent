#include <iostream>

int xmas_count(std::vector<std::string> input)
{
  int count = 0;
  size_t w = input[0].size(), h = input.size();

  for (size_t i = 1; i < h - 1; i++)
  {
    for (size_t j = 1; j < w - 1; j++)
    {
      if (input[i][j] == 'A'
          && (input[i - 1][j - 1] + input[i + 1][j + 1] == 'M' + 'S')
          && (input[i - 1][j + 1] + input[i + 1][j - 1] == 'M' + 'S'))
      {
        count++;
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
