#include <iostream>
#include <iterator>
#include <sstream>

bool is_valid(int64_t target, std::vector<int64_t> numbers, size_t curr)
{
  int64_t n = numbers[curr];

  if (curr == 0)
    return target == n;

  return (target % n == 0 && is_valid(target / n, numbers, curr - 1))
         || (target - n > 0 && is_valid(target - n, numbers, curr - 1));
}

int main()
{
  int64_t sum = 0;
  std::string line;

  while (std::getline(std::cin, line))
  {
    std::istringstream line_stream(line);

    int64_t target;
    line_stream >> target;
    line_stream.get();

    std::vector<int64_t> numbers(
        (std::istream_iterator<int64_t>(line_stream)),
        std::istream_iterator<int64_t>());

    if (is_valid(target, numbers, numbers.size() - 1))
      sum += target;
  }

  std::cout << sum << std::endl;

  return 0;
}
