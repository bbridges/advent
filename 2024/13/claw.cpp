#include <iostream>
#include <regex>

std::tuple<uint64_t, uint64_t> read_pair(std::string &line)
{
  const std::regex pair_r(".+: X.(\\d+), Y.(\\d+)");

  std::smatch match;
  std::regex_match(line, match, pair_r);

  return {std::stoi(match.str(1)), std::stoi(match.str(2))};
}

int main()
{
  uint64_t sum = 0;
  std::string line;

  while (std::getline(std::cin, line))
  {
    auto [a_x, a_y] = read_pair(line);
    std::getline(std::cin, line);
    auto [b_x, b_y] = read_pair(line);
    std::getline(std::cin, line);
    auto [x, y] = read_pair(line);
    std::getline(std::cin, line);

    uint64_t min_tokens = __UINT64_MAX__;

    for (uint64_t a = 0; a <= 100; a++)
    {
      if (3 * a > min_tokens)
        break;

      for (uint64_t b = 0; b <= 100; b++)
      {
        uint64_t tokens = 3 * a + b;

        if (tokens > min_tokens)
          break;

        if (a * a_x + b * b_x == x && a * a_y + b * b_y == y)
          min_tokens = tokens;
      }
    }

    if (min_tokens != __UINT64_MAX__)
      sum += min_tokens;
  }

  std::cout << sum << std::endl;
}
