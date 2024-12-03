#include <iostream>
#include <iterator>
#include <regex>

int get_sum(std::string memory)
{
  std::regex r(R"(mul\((\d+),(\d+)\))");
  std::sregex_iterator matches_begin(memory.begin(), memory.end(), r), matches_end;

  int sum = 0;

  for (auto i = matches_begin; i != matches_end; i++)
  {
    std::smatch match = *i;
    sum += std::stoi(match.str(1)) * std::stoi(match.str(2));
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
