#include <iostream>
#include <sstream>

int main()
{
  std::string line;
  int16_t safe_count = 0;

  while (std::getline(std::cin, line))
  {
    std::istringstream line_stream(line);

    int16_t level, prev;
    line_stream >> prev;
    line_stream >> level;

    bool inc = prev < level;
    bool safe = true;

    do
    {
      if (prev == level || (prev < level) != inc || std::abs(prev - level) > 3)
      {
        safe = false;
        break;
      }

      prev = level;
    } while (line_stream >> level);

    if (safe)
      safe_count += 1;
  }

  std::cout << safe_count << std::endl;

  return 0;
}
