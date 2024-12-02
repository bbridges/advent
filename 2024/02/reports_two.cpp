#include <iostream>
#include <sstream>

bool is_safe(std::vector<int16_t> report, size_t skipped)
{
  int16_t prev = report[skipped == 0 ? 1 : 0], level = report[skipped <= 1 ? 2 : 1];

  if (prev == level || std::abs(prev - level) > 3)
    return false;

  bool inc = prev < level;

  for (size_t i = skipped <= 2 ? 3 : 2; i < report.size(); i++)
  {
    if (i == skipped)
      continue;

    prev = level;
    level = report[i];

    if (prev == level || (prev < level) != inc || std::abs(prev - level) > 3)
      return false;
  }

  return true;
}

int main()
{
  std::string line;
  int16_t safe_count = 0;

  while (std::getline(std::cin, line))
  {
    std::istringstream line_stream(line);
    std::vector<int16_t> report;

    int16_t number;
    while (line_stream >> number)
      report.push_back(number);

    for (size_t i = 0; i < report.size(); i++)
    {
      if (is_safe(report, i))
      {
        safe_count += 1;
        break;
      }
    }
  }

  std::cout << safe_count << std::endl;

  return 0;
}
