#include <iostream>
#include <regex>

std::tuple<int64_t, int64_t> read_pair(std::string &line)
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

    x += 10'000'000'000'000;
    y += 10'000'000'000'000;

    if ((x * a_y - y * a_x) % (b_x * a_y - b_y * a_x) != 0)
      continue;

    auto b = (x * a_y - y * a_x) / (b_x * a_y - b_y * a_x);

    if (b < 0 || b > x / b_x)
      continue;

    auto a = (x - b * b_x) / a_x;

    sum += 3 * a + b;
  }

  std::cout << sum << std::endl;
}
