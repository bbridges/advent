#include <iostream>
#include <iterator>
#include <regex>

int get_sum(std::string memory)
{
  std::regex r(R"(do\(\)|don't\(\)|mul\((\d+),(\d+)\))");
  std::sregex_iterator matches_begin(memory.begin(), memory.end(), r), matches_end;

  int sum = 0;
  bool mul_enabled = true;

  for (auto i = matches_begin; i != matches_end; i++)
  {
    std::smatch match = *i;
    std::string whole_match = match.str(0);

    if (whole_match.starts_with("do"))
      mul_enabled = whole_match[2] == '(';
    else if (mul_enabled)
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
