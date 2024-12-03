#include <iostream>
#include <iterator>
#include <regex>

int get_sum(std::string memory)
{
  std::regex r("(do)\\(\\)|(don't)\\(\\)|mul\\((\\d+),(\\d+)\\)");
  std::sregex_iterator matches_begin(memory.begin(), memory.end(), r), matches_end;

  int sum = 0;
  bool mul_enabled = true;

  for (auto i = matches_begin; i != matches_end; i++)
  {
    std::smatch match = *i;

    if (match.str(1) == "do")
      mul_enabled = true;
    else if (match.str(2) == "don't")
      mul_enabled = false;
    else if (mul_enabled)
      sum += std::stoi(match.str(3)) * std::stoi(match.str(4));
  }

  return sum;
}

int main()
{
  std::istreambuf_iterator<char> begin(std::cin), end;
  std::string memory(begin, end);

  std::cout << get_sum(memory) << std::endl;

  return 0;
}
