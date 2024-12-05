#include <algorithm>
#include <iostream>
#include <set>
#include <sstream>

int main()
{
  std::set<std::tuple<int, int>> page_rules;
  auto compare_pages = [&](int a, int b)
  {
    return page_rules.contains({a, b});
  };

  std::string line;

  while (std::getline(std::cin, line) && line.size() > 0)
  {
    std::istringstream line_stream(line);

    int a, b;
    line_stream >> a;
    line_stream.get();
    line_stream >> b;

    page_rules.insert({a, b});
  }

  int sum = 0;

  while (std::getline(std::cin, line))
  {
    std::istringstream line_stream(line);

    std::vector<int> pages;
    std::string page_string;

    while (std::getline(line_stream, page_string, ','))
      pages.push_back(std::stoi(page_string));

    if (std::is_sorted(pages.begin(), pages.end(), compare_pages))
      sum += pages[pages.size() / 2];
  }

  std::cout << sum << std::endl;

  return 0;
}
